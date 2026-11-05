import 'package:drift/drift.dart';

import '../../domain/days.dart';
import '../../domain/enums.dart';
import '../../domain/mastery.dart';
import '../../domain/quests.dart';
import '../db.dart';

/// A doboz összesítői a Today „Your box” rácsához.
class BoxStats {
  const BoxStats({this.countsByType = const {}, this.mastered = 0, this.tags = 0, this.due = 0});

  final Map<ItemType, int> countsByType;
  final int mastered;
  final int tags;

  /// Most esedékes ismétlések.
  final int due;

  int count(ItemType type) => countsByType[type] ?? 0;
}

/// A Progress fül adatai.
class ProgressStats {
  const ProgressStats({
    this.addedPerDay = const {},
    this.xpPerDay = const {},
    this.mastery = const {},
    this.countsByType = const {},
    this.idioms = 0,
    this.totalReviews = 0,
  });

  /// Napi új elemek ([dayNumber] → darab), az elmúlt 7 napra.
  final Map<int, int> addedPerDay;

  /// Napi XP ([dayNumber] → XP), az elmúlt 12 hétre – az aktivitás-naptárhoz.
  final Map<int, int> xpPerDay;

  /// Hány elem van az egyes tudásszinteken.
  final Map<Mastery, int> mastery;

  final Map<ItemType, int> countsByType;
  final int idioms;
  final int totalReviews;

  int get totalItems => mastery.values.fold(0, (a, b) => a + b);
  int count(ItemType type) => countsByType[type] ?? 0;
}

/// Tevékenység és statisztika: aktív napok (streak), mai küldetések, összesítők.
class ActivityRepository {
  ActivityRepository(this._db);

  final AppDatabase _db;

  /// Azok a napok ([dayNumber]), amelyeken XP-t szereztél.
  Stream<Set<int>> watchActiveDays() {
    final query = _db.selectOnly(_db.xpEvents)..addColumns([_db.xpEvents.createdAt]);
    return query.watch().map(
      (rows) => {for (final row in rows) dayNumber(row.read(_db.xpEvents.createdAt)!)},
    );
  }

  /// A [day] napi tevékenység, élőben frissülve.
  Stream<TodayActivity> watchDay(DateTime day) async* {
    yield await _dayActivity(day);
    final changes = _db.tableUpdates(
      TableUpdateQuery.onAllTables([_db.xpEvents, _db.reviewLogs, _db.questClaims]),
    );
    await for (final _ in changes) {
      yield await _dayActivity(day);
    }
  }

  Future<TodayActivity> _dayActivity(DateTime day) async {
    final from = startOfDay(day);
    final to = from.add(const Duration(days: 1));

    Future<int> countXp(XpReason reason) async {
      final count = _db.xpEvents.id.count();
      final query = _db.selectOnly(_db.xpEvents)
        ..addColumns([count])
        ..where(
          _db.xpEvents.reason.equalsValue(reason) &
              _db.xpEvents.createdAt.isBetweenValues(from, to),
        );
      return (await query.getSingle()).read(count) ?? 0;
    }

    final reviewed = _db.reviewLogs.itemId.count(distinct: true);
    final reviewedQuery = _db.selectOnly(_db.reviewLogs)
      ..addColumns([reviewed])
      ..where(_db.reviewLogs.reviewedAt.isBetweenValues(from, to));

    final claims = await (_db.select(
      _db.questClaims,
    )..where((c) => c.day.equals(dayKey(day)))).get();

    return TodayActivity(
      itemsAdded: await countXp(XpReason.addItem),
      ownExamples: await countXp(XpReason.addExample),
      reviewed: (await reviewedQuery.getSingle()).read(reviewed) ?? 0,
      claimed: {for (final claim in claims) claim.quest},
    );
  }

  /// A „Your box” rács számai, élőben frissülve.
  Stream<BoxStats> watchBoxStats() async* {
    yield await _boxStats();
    final changes = _db.tableUpdates(
      TableUpdateQuery.onAllTables([_db.items, _db.reviewStates, _db.tags, _db.itemTags]),
    );
    await for (final _ in changes) {
      yield await _boxStats();
    }
  }

  Future<BoxStats> _boxStats() async {
    final count = _db.items.id.count();
    final byType = _db.selectOnly(_db.items)
      ..addColumns([_db.items.type, count])
      ..groupBy([_db.items.type]);
    final counts = <ItemType, int>{
      for (final row in await byType.get())
        ItemType.values.byName(row.read(_db.items.type)!): row.read(count) ?? 0,
    };

    // „Mastered” = legalább 21 napos ismétlési intervallum (lásd Mastery.from).
    final reviewCount = _db.reviewStates.itemId.count();
    final mastered = _db.selectOnly(_db.reviewStates)
      ..addColumns([reviewCount])
      ..where(
        _db.reviewStates.repetitions.isBiggerThanValue(0) &
            _db.reviewStates.intervalDays.isBiggerOrEqualValue(21),
      );
    final due = _db.selectOnly(_db.reviewStates)
      ..addColumns([reviewCount])
      ..where(_db.reviewStates.dueAt.isSmallerOrEqualValue(DateTime.now()));

    // Csak a használt címkék számítanak.
    final tagCount = _db.itemTags.tagId.count(distinct: true);
    final tags = _db.selectOnly(_db.itemTags)..addColumns([tagCount]);

    return BoxStats(
      countsByType: counts,
      mastered: (await mastered.getSingle()).read(reviewCount) ?? 0,
      due: (await due.getSingle()).read(reviewCount) ?? 0,
      tags: (await tags.getSingle()).read(tagCount) ?? 0,
    );
  }

  /// A Progress fül adatai, élőben.
  Stream<ProgressStats> watchProgress() async* {
    yield await _progress();
    final changes = _db.tableUpdates(
      TableUpdateQuery.onAllTables([_db.items, _db.reviewStates, _db.reviewLogs, _db.xpEvents]),
    );
    await for (final _ in changes) {
      yield await _progress();
    }
  }

  Future<ProgressStats> _progress() async {
    final today = startOfDay(DateTime.now());
    final weekStart = DateTime(today.year, today.month, today.day - 6);
    final heatmapStart = DateTime(today.year, today.month, today.day - 7 * 12);

    // Napi bontás Dartban: kevés sor, és így a helyi idő szerinti napot számoljuk.
    final added = <int, int>{};
    final addedQuery = _db.selectOnly(_db.items)
      ..addColumns([_db.items.createdAt])
      ..where(_db.items.createdAt.isBiggerOrEqualValue(weekStart));
    for (final row in await addedQuery.get()) {
      final day = dayNumber(row.read(_db.items.createdAt)!);
      added[day] = (added[day] ?? 0) + 1;
    }

    final xp = <int, int>{};
    final xpQuery = _db.selectOnly(_db.xpEvents)
      ..addColumns([_db.xpEvents.createdAt, _db.xpEvents.amount])
      ..where(_db.xpEvents.createdAt.isBiggerOrEqualValue(heatmapStart));
    for (final row in await xpQuery.get()) {
      final day = dayNumber(row.read(_db.xpEvents.createdAt)!);
      xp[day] = (xp[day] ?? 0) + row.read(_db.xpEvents.amount)!;
    }

    final mastery = {for (final m in Mastery.values) m: 0};
    final statesQuery = _db.selectOnly(_db.reviewStates)
      ..addColumns([_db.reviewStates.repetitions, _db.reviewStates.intervalDays]);
    for (final row in await statesQuery.get()) {
      final m = Mastery.from(
        repetitions: row.read(_db.reviewStates.repetitions)!,
        intervalDays: row.read(_db.reviewStates.intervalDays)!,
      );
      mastery[m] = mastery[m]! + 1;
    }

    final count = _db.items.id.count();
    final byType = _db.selectOnly(_db.items)
      ..addColumns([_db.items.type, count])
      ..groupBy([_db.items.type]);
    final idioms = _db.selectOnly(_db.items)
      ..addColumns([count])
      ..where(_db.items.phraseKind.equalsValue(PhraseKind.idiom));
    final reviewCount = _db.reviewLogs.id.count();
    final reviews = _db.selectOnly(_db.reviewLogs)..addColumns([reviewCount]);

    return ProgressStats(
      addedPerDay: added,
      xpPerDay: xp,
      mastery: mastery,
      countsByType: {
        for (final row in await byType.get())
          ItemType.values.byName(row.read(_db.items.type)!): row.read(count) ?? 0,
      },
      idioms: (await idioms.getSingle()).read(count) ?? 0,
      totalReviews: (await reviews.getSingle()).read(reviewCount) ?? 0,
    );
  }

  /// Küldetésjutalom felvétele. Ha ma már felvették, nem történik semmi.
  /// Visszaadja, hogy most sikerült-e.
  Future<bool> claimQuest(Quest quest, DateTime day, int reward) {
    return _db.transaction(() async {
      final key = dayKey(day);
      final existing = await (_db.select(
        _db.questClaims,
      )..where((c) => c.day.equals(key) & c.quest.equalsValue(quest))).getSingleOrNull();
      if (existing != null) return false;

      await _db.into(_db.questClaims).insert(QuestClaimsCompanion.insert(day: key, quest: quest));
      await _db
          .into(_db.xpEvents)
          .insert(XpEventsCompanion.insert(amount: reward, reason: XpReason.quest));
      return true;
    });
  }
}
