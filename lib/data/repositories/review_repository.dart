import 'package:drift/drift.dart';

import '../../domain/enums.dart';
import '../../domain/srs.dart';
import '../db.dart';

/// A Review fül „Focus” szűrője: csak egy szint és/vagy egy címke elemei.
/// Az [excludedTypes] és a [sentenceCards] a beállításokból jön: a kizárt
/// típusok nem jönnek elő (pl. a nyelvtan kikapcsolva), a [sentenceCards]
/// pedig azt mondja meg, hogy a mondatok szókártyaként is előjöjjenek-e.
class ReviewFocus {
  const ReviewFocus({
    this.level,
    this.tagId,
    this.tagName,
    this.excludedTypes = const {},
    this.sentenceCards = false,
  });

  final CefrLevel? level;
  final int? tagId;
  final String? tagName;
  final Set<ItemType> excludedTypes;
  final bool sentenceCards;

  bool get isEmpty => level == null && tagId == null;

  ReviewFocus withCardSettings({
    required Set<ItemType> excludedTypes,
    required bool sentenceCards,
  }) => ReviewFocus(
    level: level,
    tagId: tagId,
    tagName: tagName,
    excludedTypes: excludedTypes,
    sentenceCards: sentenceCards,
  );
}

/// Egy esedékes elem az ütemezésével.
class DueEntry {
  const DueEntry(this.item, this.review);

  final Item item;
  final ReviewState review;

  SrsState get srs => srsOf(review);

  /// Mondat magyar fordítással → mondatépítés / szabad fordítás.
  bool get isTranslatable => item.type == ItemType.sentence && item.hungarian.trim().isNotEmpty;
}

/// Az esedékes elemek (legrégebben esedékes elöl) + mikor jön a következő.
class DueSummary {
  const DueSummary({this.entries = const [], this.nextDue, this.sentenceCards = false});

  final List<DueEntry> entries;

  /// Ha most semmi sem esedékes: a legközelebbi esedékesség (ha van elem).
  final DateTime? nextDue;

  /// A fordítással rendelkező mondatok is jöjjenek-e szókártyaként.
  final bool sentenceCards;

  int get total => entries.length;

  int count(ItemType type) => entries.where((e) => e.item.type == type).length;

  /// Szókártyával ismételhető: szó, kifejezés, szabály, fordítás nélküli mondat
  /// – és ha a beállítás engedi, minden mondat.
  List<DueEntry> get cardEntries =>
      entries.where((e) => sentenceCards || !e.isTranslatable).toList();

  /// Mondatépítéssel / fordítással ismételhető mondatok.
  List<DueEntry> get sentenceEntries => entries.where((e) => e.isTranslatable).toList();
}

SrsState srsOf(ReviewState r) => SrsState(
  dueAt: r.dueAt,
  ease: r.ease,
  intervalDays: r.intervalDays,
  repetitions: r.repetitions,
  lapses: r.lapses,
);

/// Ismétlés: esedékes elemek, csaliszavak, válaszok mentése.
class ReviewRepository {
  ReviewRepository(this._db);

  final AppDatabase _db;

  /// Az esedékes elemek élőben. Minden változáskor újra lekérdezünk, mindig a
  /// *mostani* időponttal – így az épp most hozzáadott elem is azonnal megjelenik.
  Stream<DueSummary> watchDue(ReviewFocus focus) async* {
    yield await loadDue(focus);
    final changes = _db.tableUpdates(
      TableUpdateQuery.onAllTables([_db.items, _db.reviewStates, _db.itemTags]),
    );
    await for (final _ in changes) {
      yield await loadDue(focus);
    }
  }

  Future<DueSummary> loadDue(ReviewFocus focus) async {
    final now = DateTime.now();
    final due = _joined(focus)
      ..where(_db.reviewStates.dueAt.isSmallerOrEqualValue(now))
      ..orderBy([OrderingTerm.asc(_db.reviewStates.dueAt), OrderingTerm.asc(_db.items.id)]);
    final entries = [
      for (final row in await due.get())
        DueEntry(row.readTable(_db.items), row.readTable(_db.reviewStates)),
    ];
    if (entries.isNotEmpty) {
      return DueSummary(entries: entries, sentenceCards: focus.sentenceCards);
    }

    final next = _joined(focus)
      ..orderBy([OrderingTerm.asc(_db.reviewStates.dueAt)])
      ..limit(1);
    final row = await next.getSingleOrNull();
    return DueSummary(
      nextDue: row?.readTable(_db.reviewStates).dueAt,
      sentenceCards: focus.sentenceCards,
    );
  }

  JoinedSelectStatement<HasResultSet, dynamic> _joined(ReviewFocus focus) {
    final query = _db.select(_db.items).join([
      innerJoin(_db.reviewStates, _db.reviewStates.itemId.equalsExp(_db.items.id)),
    ]);
    if (focus.level != null) query.where(_db.items.level.equalsValue(focus.level));
    if (focus.excludedTypes.isNotEmpty) {
      query.where(_db.items.type.isNotIn([for (final t in focus.excludedTypes) t.name]));
    }
    if (focus.tagId != null) {
      final tagged = _db.selectOnly(_db.itemTags)
        ..addColumns([_db.itemTags.itemId])
        ..where(
          _db.itemTags.itemId.equalsExp(_db.items.id) & _db.itemTags.tagId.equals(focus.tagId!),
        );
      query.where(existsQuery(tagged));
    }
    return query;
  }

  /// Elemenként az első példamondat (a szókártya hátoldalára).
  Future<Map<int, Item>> firstExamples(Iterable<int> parentIds) async {
    final ids = parentIds.toList();
    if (ids.isEmpty) return const {};
    final query =
        _db.select(_db.itemLinks).join([
            innerJoin(_db.items, _db.items.id.equalsExp(_db.itemLinks.childId)),
          ])
          ..where(
            _db.itemLinks.parentId.isIn(ids) & _db.itemLinks.role.equalsValue(LinkRole.example),
          )
          ..orderBy([OrderingTerm.asc(_db.itemLinks.position)]);
    final result = <int, Item>{};
    for (final row in await query.get()) {
      result.putIfAbsent(row.readTable(_db.itemLinks).parentId, () => row.readTable(_db.items));
    }
    return result;
  }

  /// Véletlen mondatok a dobozból – ezek szavaiból lesznek a „csali” csempék.
  Future<({List<String> english, List<String> hungarian})> sentencePool({int limit = 40}) async {
    final rows = await _db
        .customSelect(
          "SELECT english, hungarian FROM items WHERE type = 'sentence' ORDER BY RANDOM() LIMIT ?",
          variables: [Variable.withInt(limit)],
          readsFrom: {_db.items},
        )
        .get();
    return (
      english: [for (final r in rows) r.read<String>('english')],
      hungarian: [for (final r in rows) r.read<String>('hungarian')],
    );
  }

  /// Egy válasz mentése egy tranzakcióban: új ütemezés, napló, XP.
  Future<void> recordAnswer({
    required int itemId,
    required ReviewTask task,
    required ReviewGrade grade,
    required SrsState next,
    required int xp,
  }) {
    return _db.transaction(() async {
      final now = DateTime.now();
      await (_db.update(_db.reviewStates)..where((r) => r.itemId.equals(itemId))).write(
        ReviewStatesCompanion(
          dueAt: Value(next.dueAt),
          ease: Value(next.ease),
          intervalDays: Value(next.intervalDays),
          repetitions: Value(next.repetitions),
          lapses: Value(next.lapses),
          lastReviewedAt: Value(now),
        ),
      );
      await _db
          .into(_db.reviewLogs)
          .insert(
            ReviewLogsCompanion.insert(
              itemId: itemId,
              task: task,
              correct: grade != ReviewGrade.forgot,
              reviewedAt: Value(now),
            ),
          );
      if (xp > 0) {
        await _db
            .into(_db.xpEvents)
            .insert(
              XpEventsCompanion.insert(amount: xp, reason: XpReason.review, itemId: Value(itemId)),
            );
      }
    });
  }
}
