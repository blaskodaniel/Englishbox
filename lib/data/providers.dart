import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/enums.dart';
import 'db.dart';
import 'models.dart';
import 'repositories/items_repository.dart';
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
final itemsRepositoryProvider =
    Provider((ref) => ItemsRepository(ref.watch(databaseProvider)));
final tagsRepositoryProvider =
    Provider((ref) => TagsRepository(ref.watch(databaseProvider)));
final settingsRepositoryProvider =
    Provider((ref) => SettingsRepository(ref.watch(databaseProvider)));
final xpRepositoryProvider =
    Provider((ref) => XpRepository(ref.watch(databaseProvider)));

// Élő lekérdezések – a képernyők ezeket figyelik (`ref.watch`).
final itemCountsProvider = StreamProvider<Map<ItemType, int>>(
  (ref) => ref.watch(itemsRepositoryProvider).watchCountsByType(),
);

final itemDetailProvider = StreamProvider.family<ItemDetail?, int>(
  (ref, id) => ref.watch(itemsRepositoryProvider).watchItemDetail(id),
);

final tagsWithCountsProvider = StreamProvider<List<TagWithCount>>(
  (ref) => ref.watch(tagsRepositoryProvider).watchTagsWithCounts(),
);

final settingsProvider = StreamProvider<Settings>(
  (ref) => ref.watch(settingsRepositoryProvider).watch(),
);

final totalXpProvider = StreamProvider<int>(
  (ref) => ref.watch(xpRepositoryProvider).watchTotal(),
);
