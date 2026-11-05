import 'package:drift/drift.dart';

import '../../domain/enums.dart';
import '../db.dart';
import '../models.dart';

/// Gyűjtemények (pl. „Lesson notes”, „Work English”) és a szintenkénti összesítés
/// – a Collections képernyőhöz.
class CollectionsRepository {
  CollectionsRepository(this._db);

  final AppDatabase _db;

  // ---------------------------------------------------------------- olvasás

  /// Gyűjtemények elemszámmal és a „Mastered” elemek számával, létrehozás
  /// szerinti sorrendben.
  ///
  /// A „mastered” feltétel ugyanaz, mint a `Mastery.from`-ban: legalább egy
  /// sikeres ismétlés és legalább 21 napos intervallum.
  Stream<List<CollectionSummary>> watchCollections() {
    return _db
        .customSelect(
          'SELECT c.*, COUNT(ci.item_id) AS total, '
          'COALESCE(SUM(CASE WHEN rs.repetitions > 0 AND rs.interval_days >= 21 '
          'THEN 1 ELSE 0 END), 0) AS mastered '
          'FROM collections c '
          'LEFT JOIN collection_items ci ON ci.collection_id = c.id '
          'LEFT JOIN review_states rs ON rs.item_id = ci.item_id '
          'GROUP BY c.id '
          'ORDER BY c.created_at, c.id',
          readsFrom: {_db.collections, _db.collectionItems, _db.reviewStates},
        )
        .watch()
        .map(
          (rows) => [
            for (final row in rows)
              CollectionSummary(
                _db.collections.map(row.data),
                total: row.read<int>('total'),
                mastered: row.read<int>('mastered'),
              ),
          ],
        );
  }

  /// Elemszám CEFR-szintenként (a szint nélküli elemek nem számítanak bele).
  Stream<Map<CefrLevel, int>> watchLevelCounts() {
    final count = _db.items.id.count();
    final query = _db.selectOnly(_db.items)
      ..addColumns([_db.items.level, count])
      ..where(_db.items.level.isNotNull())
      ..groupBy([_db.items.level]);

    return query.watch().map((rows) {
      final counts = {for (final level in CefrLevel.values) level: 0};
      for (final row in rows) {
        final level = CefrLevel.values.byName(row.read(_db.items.level)!);
        counts[level] = row.read(count) ?? 0;
      }
      return counts;
    });
  }

  /// Mely gyűjteményekben van benne az elem.
  Stream<Set<int>> watchCollectionIdsOf(int itemId) {
    final query = _db.select(_db.collectionItems)..where((c) => c.itemId.equals(itemId));
    return query.watch().map((rows) => {for (final row in rows) row.collectionId});
  }

  // ------------------------------------------------------------------ írás

  /// Új gyűjtemény; visszaadja az azonosítóját.
  Future<int> create({required String name, required String icon, required int color}) {
    return _db
        .into(_db.collections)
        .insert(
          CollectionsCompanion.insert(name: name.trim(), icon: Value(icon), color: Value(color)),
        );
  }

  Future<void> update(int id, {required String name, required String icon, required int color}) {
    return (_db.update(_db.collections)..where((c) => c.id.equals(id))).write(
      CollectionsCompanion(name: Value(name.trim()), icon: Value(icon), color: Value(color)),
    );
  }

  /// Törli a gyűjteményt. Az elemek a dobozban maradnak, csak a hozzárendelés
  /// tűnik el (kaszkád).
  Future<void> delete(int id) => (_db.delete(_db.collections)..where((c) => c.id.equals(id))).go();

  /// Elem be/ki egy gyűjteménybe.
  Future<void> setMembership(int collectionId, int itemId, {required bool member}) async {
    if (member) {
      await _db
          .into(_db.collectionItems)
          .insert(
            CollectionItemsCompanion.insert(collectionId: collectionId, itemId: itemId),
            mode: InsertMode.insertOrIgnore,
          );
    } else {
      await (_db.delete(
        _db.collectionItems,
      )..where((c) => c.collectionId.equals(collectionId) & c.itemId.equals(itemId))).go();
    }
  }
}
