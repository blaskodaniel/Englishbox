import 'package:drift/drift.dart';

import '../db.dart';
import '../models.dart';

class TagsRepository {
  TagsRepository(this._db);

  final AppDatabase _db;

  /// Címkék elemszámmal, a leggyakoribb elöl – a Collections képernyőhöz.
  Stream<List<TagWithCount>> watchTagsWithCounts() {
    final count = _db.itemTags.itemId.count();
    final query =
        _db.select(_db.tags).join([
            leftOuterJoin(_db.itemTags, _db.itemTags.tagId.equalsExp(_db.tags.id)),
          ])
          ..addColumns([count])
          ..groupBy([_db.tags.id])
          ..orderBy([OrderingTerm.desc(count), OrderingTerm.asc(_db.tags.name)]);

    return query.watch().map(
      (rows) => [
        for (final row in rows) TagWithCount(row.readTable(_db.tags), row.read(count) ?? 0),
      ],
    );
  }
}
