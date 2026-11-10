import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/badges.dart';
import '../domain/days.dart';
import '../domain/enums.dart';
import '../domain/levels.dart';
import '../domain/mastery.dart';
import '../domain/quests.dart';
import '../domain/streak.dart';
import 'backup_service.dart';
import 'db.dart';
import 'models.dart';
import 'repositories/activity_repository.dart';
import 'repositories/collections_repository.dart';
import 'repositories/items_repository.dart';
import 'repositories/review_repository.dart';
import 'repositories/settings_repository.dart';
import 'repositories/tags_repository.dart';
import 'repositories/xp_repository.dart';

/// Az egyetlen adatbázis-példány. Tesztben felülírható:
/// `ProviderScope(overrides: [databaseProvider.overrideWithValue(...)])`.
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

// Repositoryk
final itemsRepositoryProvider = Provider((ref) => ItemsRepository(ref.watch(databaseProvider)));
final tagsRepositoryProvider = Provider((ref) => TagsRepository(ref.watch(databaseProvider)));
final settingsRepositoryProvider = Provider(
  (ref) => SettingsRepository(ref.watch(databaseProvider)),
);
final xpRepositoryProvider = Provider((ref) => XpRepository(ref.watch(databaseProvider)));
final reviewRepositoryProvider = Provider((ref) => ReviewRepository(ref.watch(databaseProvider)));
final backupServiceProvider = Provider((ref) => BackupService(ref.watch(databaseProvider)));

// Élő lekérdezések – a képernyők ezeket figyelik (`ref.watch`).
final itemCountsProvider = StreamProvider<Map<ItemType, int>>(
  (ref) => ref.watch(itemsRepositoryProvider).watchCountsByType(),
);

final itemDetailProvider = StreamProvider.family<ItemDetail?, int>(
  (ref, id) => ref.watch(itemsRepositoryProvider).watchItemDetail(id),
);

/// Hány elem van „To check” jelöléssel.
final needsCheckCountProvider = StreamProvider<int>(
  (ref) => ref.watch(itemsRepositoryProvider).watchNeedsCheckCount(),
);

final tagsWithCountsProvider = StreamProvider<List<TagWithCount>>(
  (ref) => ref.watch(tagsRepositoryProvider).watchTagsWithCounts(),
);

final collectionsRepositoryProvider = Provider(
  (ref) => CollectionsRepository(ref.watch(databaseProvider)),
);

final collectionsProvider = StreamProvider<List<CollectionSummary>>(
  (ref) => ref.watch(collectionsRepositoryProvider).watchCollections(),
);

final levelCountsProvider = StreamProvider<Map<CefrLevel, int>>(
  (ref) => ref.watch(collectionsRepositoryProvider).watchLevelCounts(),
);

/// Egy elem gyűjteményei (azonosítók) – az elemrészlet gombjához.
final itemCollectionIdsProvider = StreamProvider.family<Set<int>, int>(
  (ref, itemId) => ref.watch(collectionsRepositoryProvider).watchCollectionIdsOf(itemId),
);

final settingsProvider = StreamProvider<Settings>(
  (ref) => ref.watch(settingsRepositoryProvider).watch(),
);

final totalXpProvider = StreamProvider<int>((ref) => ref.watch(xpRepositoryProvider).watchTotal());

// ------------------------------------------------- tevékenység, gamifikáció

final activityRepositoryProvider = Provider(
  (ref) => ActivityRepository(ref.watch(databaseProvider)),
);

/// A „mai nap” (helyi éjfél). Ha az app éjfél után kerül újra előtérbe,
/// a Today képernyő frissíti – és vele minden, ami tőle függ.
class CurrentDayNotifier extends Notifier<DateTime> {
  @override
  DateTime build() => startOfDay(DateTime.now());

  void refresh() {
    final today = startOfDay(DateTime.now());
    if (today != state) state = today;
  }
}

final currentDayProvider = NotifierProvider<CurrentDayNotifier, DateTime>(CurrentDayNotifier.new);

final todayActivityProvider = StreamProvider<TodayActivity>((ref) {
  final day = ref.watch(currentDayProvider);
  return ref.watch(activityRepositoryProvider).watchDay(day);
});

final boxStatsProvider = StreamProvider<BoxStats>(
  (ref) => ref.watch(activityRepositoryProvider).watchBoxStats(),
);

final activeDaysProvider = StreamProvider<Set<int>>(
  (ref) => ref.watch(activityRepositoryProvider).watchActiveDays(),
);

/// Szint az összes XP-ből. Betöltés közben az 1. szint 0 XP-vel.
final levelProvider = Provider<LevelInfo>(
  (ref) => LevelInfo.fromTotalXp(ref.watch(totalXpProvider).value ?? 0),
);

/// Streak az aktív napokból és a „streak freeze” beállításból.
final streakProvider = Provider<StreakInfo>((ref) {
  final days = ref.watch(activeDaysProvider).value ?? const <int>{};
  final freeze = ref.watch(settingsProvider).value?.streakFreeze ?? false;
  final today = dayNumber(ref.watch(currentDayProvider));
  return computeStreak(days, today, freeze: freeze);
});

/// Mi kell az emlékeztetők ütemezéséhez. Rekord → érték szerint hasonlít, így
/// a figyelő csak akkor fut le, ha tényleg változott valami.
final reminderPlanProvider = Provider<({bool enabled, int minutes, bool practisedToday})?>((ref) {
  final settings = ref.watch(settingsProvider).value;
  if (settings == null || !ref.watch(activeDaysProvider).hasValue) return null;
  return (
    enabled: settings.reminderEnabled,
    minutes: settings.reminderMinutes,
    practisedToday: ref.watch(streakProvider).activeToday,
  );
});

/// Játék mód: ha ki van kapcsolva, nem látszik XP, szint és küldetés.
/// (Az XP a háttérben továbbra is gyűlik – visszakapcsoláskor minden megvan.)
final gameModeProvider = Provider<bool>(
  (ref) => ref.watch(settingsProvider).value?.gameMode ?? true,
);

/// A beállításokban ki-be kapcsolható szókártya-típusok.
///
/// A mondat különleges: ha be van kapcsolva, a fordítással rendelkező mondatok
/// is előjönnek szókártyaként (a mondatépítés és a fordítás mellett). Ha ki van
/// kapcsolva, a mondatok akkor sem maradnak ki az ismétlésből – csak a saját
/// feladataikban jönnek elő.
const selectableCardTypes = [ItemType.word, ItemType.phrase, ItemType.rule, ItemType.sentence];

/// Alapértelmezés (és a régi beállítás): mondatok nélkül.
const defaultCardTypes = {ItemType.word, ItemType.phrase, ItemType.rule};

/// „word,phrase,rule” → {word, phrase, rule}. Ismeretlen nevet kihagy; ha
/// semmi sem marad, az alapértelmezést adja vissza (üres kör ne lehessen).
Set<ItemType> parseCardTypes(String raw) {
  final byName = ItemType.values.asNameMap();
  final types = {
    for (final name in raw.split(','))
      if (byName[name.trim()] case final type? when selectableCardTypes.contains(type)) type,
  };
  return types.isEmpty ? defaultCardTypes : types;
}

String formatCardTypes(Set<ItemType> types) => [
  for (final t in selectableCardTypes)
    if (types.contains(t)) t.name,
].join(',');

/// Mely típusok jönnek szókártyaként (betöltés közben mind).
final cardTypesProvider = Provider<Set<ItemType>>((ref) {
  final raw = ref.watch(settingsProvider).value?.cardTypes;
  return raw == null ? defaultCardTypes : parseCardTypes(raw);
});

final progressStatsProvider = StreamProvider<ProgressStats>(
  (ref) => ref.watch(activityRepositoryProvider).watchProgress(),
);

/// A kitűzők állása – `null`, amíg az adatok betöltenek.
final badgesProvider = Provider<List<BadgeProgress>?>((ref) {
  final stats = ref.watch(progressStatsProvider).value;
  if (stats == null) return null;
  return badgeProgress(
    BadgeStats(
      items: stats.totalItems,
      words: stats.count(ItemType.word),
      sentences: stats.count(ItemType.sentence),
      idioms: stats.idioms,
      rules: stats.count(ItemType.rule),
      bestStreak: ref.watch(streakProvider).best,
      reviews: stats.totalReviews,
      mastered: stats.mastery[Mastery.mastered] ?? 0,
      level: ref.watch(levelProvider).level,
    ),
  );
});

/// A mai küldetések – `null`, amíg az adatok betöltenek.
final dailyQuestsProvider = Provider<List<QuestProgress>?>((ref) {
  final settings = ref.watch(settingsProvider).value;
  final today = ref.watch(todayActivityProvider).value;
  final stats = ref.watch(boxStatsProvider).value;
  if (settings == null || today == null || stats == null) return null;
  return buildDailyQuests(
    dailyGoal: settings.dailyGoal,
    sessionLength: settings.sessionLength,
    dueCount: stats.due,
    today: today,
  );
});
