import 'package:drift/drift.dart';

import '../../domain/drafts.dart';
import '../../domain/enums.dart';
import '../../domain/search.dart';
import '../db.dart';
import '../models.dart';

/// Elemek olvasása és írása. A képernyők csak ezen keresztül érik el az adatbázist.
class ItemsRepository {
  ItemsRepository(this._db);

  final AppDatabase _db;

  // ---------------------------------------------------------------- olvasás

  /// Library lista, legújabb elöl.
  ///
  /// A típus/szint/címke/kedvenc szűrést SQL végzi; a szöveges keresést Dartban
  /// csináljuk ékezet-összevonással ([foldForSearch]), és a címkékben is keres.
  Stream<List<ItemListEntry>> watchItems({
    ItemType? type,
    CefrLevel? level,
    int? tagId,
    int? collectionId,
    bool favoritesOnly = false,
    String search = '',
  }) {
    final query = _db.select(_db.items).join([
      leftOuterJoin(_db.reviewStates, _db.reviewStates.itemId.equalsExp(_db.items.id)),
    ]);

    if (type != null) query.where(_db.items.type.equalsValue(type));
    if (level != null) query.where(_db.items.level.equalsValue(level));
    if (favoritesOnly) query.where(_db.items.isFavorite.equals(true));
    if (tagId != null) {
      final tagged = _db.selectOnly(_db.itemTags)
        ..addColumns([_db.itemTags.itemId])
        ..where(_db.itemTags.itemId.equalsExp(_db.items.id) & _db.itemTags.tagId.equals(tagId));
      query.where(existsQuery(tagged));
    }
    if (collectionId != null) {
      final inCollection = _db.selectOnly(_db.collectionItems)
        ..addColumns([_db.collectionItems.itemId])
        ..where(
          _db.collectionItems.itemId.equalsExp(_db.items.id) &
              _db.collectionItems.collectionId.equals(collectionId),
        );
      query.where(existsQuery(inCollection));
    }
    query.orderBy([OrderingTerm.desc(_db.items.createdAt), OrderingTerm.desc(_db.items.id)]);

    var term = foldForSearch(search.trim());
    while (term.startsWith('#')) {
      term = term.substring(1);
    }

    return query.watch().asyncMap((rows) async {
      final items = [for (final row in rows) row.readTable(_db.items)];
      final tagsByItem = await _tagNamesFor(items.map((i) => i.id));
      final entries = [
        for (final (index, row) in rows.indexed)
          ItemListEntry(
            item: items[index],
            review: row.readTableOrNull(_db.reviewStates),
            tags: tagsByItem[items[index].id] ?? const [],
          ),
      ];
      if (term.isEmpty) return entries;
      return entries.where((e) => _matches(e, term)).toList();
    });
  }

  bool _matches(ItemListEntry entry, String term) => [
    entry.item.english,
    entry.item.hungarian,
    entry.item.notes ?? '',
    ...entry.tags,
  ].any((field) => foldForSearch(field).contains(term));

  Future<Map<int, List<String>>> _tagNamesFor(Iterable<int> itemIds) async {
    final ids = itemIds.toList();
    if (ids.isEmpty) return const {};
    final query =
        _db.select(_db.itemTags).join([
            innerJoin(_db.tags, _db.tags.id.equalsExp(_db.itemTags.tagId)),
          ])
          ..where(_db.itemTags.itemId.isIn(ids))
          ..orderBy([OrderingTerm.asc(_db.tags.name)]);
    final result = <int, List<String>>{};
    for (final row in await query.get()) {
      final itemId = row.readTable(_db.itemTags).itemId;
      (result[itemId] ??= []).add(row.readTable(_db.tags).name);
    }
    return result;
  }

  /// Elemszám típusonként – a Today „Your box” rácsához.
  Stream<Map<ItemType, int>> watchCountsByType() {
    final count = _db.items.id.count();
    final query = _db.selectOnly(_db.items)
      ..addColumns([_db.items.type, count])
      ..groupBy([_db.items.type]);

    return query.watch().map((rows) {
      final counts = {for (final type in ItemType.values) type: 0};
      for (final row in rows) {
        final type = ItemType.values.byName(row.read(_db.items.type)!);
        counts[type] = row.read(count) ?? 0;
      }
      return counts;
    });
  }

  Future<ItemDetail?> getItemDetail(int id) async {
    final item = await _getItem(id);
    if (item == null) return null;

    final review = await (_db.select(
      _db.reviewStates,
    )..where((r) => r.itemId.equals(id))).getSingleOrNull();

    final tagsQuery =
        _db.select(_db.tags).join([
            innerJoin(_db.itemTags, _db.itemTags.tagId.equalsExp(_db.tags.id)),
          ])
          ..where(_db.itemTags.itemId.equals(id))
          ..orderBy([OrderingTerm.asc(_db.tags.name)]);

    final mistakes =
        await (_db.select(_db.ruleMistakes)
              ..where((m) => m.ruleId.equals(id))
              ..orderBy([(m) => OrderingTerm.asc(m.position)]))
            .get();

    return ItemDetail(
      item: item,
      review: review,
      examples: await _children(id, LinkRole.example),
      linkedGrammar: await _children(id, LinkRole.grammar),
      similar: await _children(id, LinkRole.similar),
      tags: [for (final row in await tagsQuery.get()) row.readTable(_db.tags)],
      mistakes: mistakes,
      exampleOf: await _parents(id, LinkRole.example),
      linkedFrom: await _parents(id, LinkRole.grammar),
    );
  }

  /// Az elemrészlet élő változata: újratölt, ha bármelyik érintett tábla változik.
  Stream<ItemDetail?> watchItemDetail(int id) async* {
    yield await getItemDetail(id);
    final changes = _db.tableUpdates(
      TableUpdateQuery.onAllTables([
        _db.items,
        _db.itemLinks,
        _db.itemTags,
        _db.tags,
        _db.ruleMistakes,
        _db.reviewStates,
      ]),
    );
    await for (final _ in changes) {
      yield await getItemDetail(id);
    }
  }

  Future<Item?> _getItem(int id) =>
      (_db.select(_db.items)..where((i) => i.id.equals(id))).getSingleOrNull();

  /// Elemek, amelyekre a [parentId] mutat (pl. a szó példamondatai).
  Future<List<Item>> _children(int parentId, LinkRole role) async {
    final query =
        _db.select(_db.itemLinks).join([
            innerJoin(_db.items, _db.items.id.equalsExp(_db.itemLinks.childId)),
          ])
          ..where(_db.itemLinks.parentId.equals(parentId) & _db.itemLinks.role.equalsValue(role))
          ..orderBy([OrderingTerm.asc(_db.itemLinks.position)]);
    return [for (final row in await query.get()) row.readTable(_db.items)];
  }

  /// Elemek, amelyek a [childId]-ra mutatnak (pl. mely szavak példája egy mondat).
  Future<List<Item>> _parents(int childId, LinkRole role) async {
    final query =
        _db.select(_db.itemLinks).join([
            innerJoin(_db.items, _db.items.id.equalsExp(_db.itemLinks.parentId)),
          ])
          ..where(_db.itemLinks.childId.equals(childId) & _db.itemLinks.role.equalsValue(role))
          ..orderBy([OrderingTerm.asc(_db.items.english)]);
    return [for (final row in await query.get()) row.readTable(_db.items)];
  }

  // ------------------------------------------------------------------ írás

  /// Új elem mentése egy tranzakcióban: maga az elem, ismétlési állapot,
  /// címkék, példamondatok (külön mondat elemként) és hibás példák.
  /// Visszaadja az új elem azonosítóját.
  Future<int> createItem(NewItem draft) {
    return _db.transaction(() async {
      final id = await _db
          .into(_db.items)
          .insert(
            ItemsCompanion.insert(
              type: draft.type,
              english: draft.english.trim(),
              hungarian: Value(draft.hungarian.trim()),
              notes: Value(_blankToNull(draft.notes)),
              partOfSpeech: Value(draft.partOfSpeech),
              phraseKind: Value(draft.phraseKind),
              ipa: Value(_blankToNull(draft.ipa)),
              level: Value(draft.level),
              source: Value(_blankToNull(draft.source)),
              ruleCategory: Value(_blankToNull(draft.ruleCategory)),
              formula: Value(draft.formula),
              trapNote: Value(_blankToNull(draft.trapNote)),
            ),
          );
      await _startReview(id);
      await _attachTags(id, draft.tags);

      if (draft.type != ItemType.sentence) {
        for (final (index, example) in draft.examples.indexed) {
          final existingId = example.existingId;
          if (existingId != null) {
            // „From my box”: a meglévő mondatot csak összekapcsoljuk.
            await _upsertLink(id, existingId, LinkRole.example, index);
          } else {
            await _insertExample(
              parentId: id,
              example: example,
              position: index,
              level: draft.level,
              source: draft.source,
              tags: draft.tags,
            );
          }
        }
        await _replaceSimilar(id, draft.similarIds);
      }

      if (draft.type == ItemType.rule) {
        for (final (index, mistake) in draft.mistakes.indexed) {
          await _db
              .into(_db.ruleMistakes)
              .insert(
                RuleMistakesCompanion.insert(
                  ruleId: id,
                  wrong: mistake.wrong.trim(),
                  explanation: Value(_blankToNull(mistake.explanation)),
                  position: Value(index),
                ),
              );
        }
      }

      return id;
    });
  }

  /// Meglévő elem mentése a szerkesztő képernyőről, egy tranzakcióban.
  ///
  /// - A típus nem változik (a [draft] típusát figyelmen kívül hagyjuk).
  /// - Példák: a megtartottak (`existingId != null`) a megadott sorrendbe
  ///   kerülnek, az újak mondat elemként jönnek létre, a kivettek kapcsolata
  ///   megszűnik – maga a mondat a dobozban marad.
  /// - Címkék és hibás példák: lecseréljük az űrlapon szereplőkre.
  ///
  /// Visszaadja az újonnan létrehozott példamondatok számát (az XP-hez).
  Future<int> updateItem(int id, NewItem draft) {
    return _db.transaction(() async {
      final current = await _getItem(id);
      if (current == null) throw StateError('Item $id not found');

      await (_db.update(_db.items)..where((i) => i.id.equals(id))).write(
        ItemsCompanion(
          english: Value(draft.english.trim()),
          hungarian: Value(draft.hungarian.trim()),
          notes: Value(_blankToNull(draft.notes)),
          partOfSpeech: Value(draft.partOfSpeech),
          phraseKind: Value(draft.phraseKind),
          ipa: Value(_blankToNull(draft.ipa)),
          level: Value(draft.level),
          source: Value(_blankToNull(draft.source)),
          ruleCategory: Value(_blankToNull(draft.ruleCategory)),
          formula: Value(draft.formula),
          trapNote: Value(_blankToNull(draft.trapNote)),
          updatedAt: Value(DateTime.now()),
        ),
      );

      // Címkék: mindet levesszük, majd az űrlapon lévőket újra felrakjuk.
      await (_db.delete(_db.itemTags)..where((t) => t.itemId.equals(id))).go();
      await _attachTags(id, draft.tags);

      var created = 0;
      if (current.type != ItemType.sentence) {
        final keptIds = {
          for (final e in draft.examples)
            if (e.existingId != null) e.existingId!,
        };
        // A kivett példák kapcsolatának törlése.
        await (_db.delete(_db.itemLinks)..where(
              (l) =>
                  l.parentId.equals(id) &
                  l.role.equalsValue(LinkRole.example) &
                  l.childId.isNotIn(keptIds),
            ))
            .go();

        for (final (index, example) in draft.examples.indexed) {
          final existingId = example.existingId;
          if (existingId != null) {
            // Megtartott példa (új sorrend), vagy most a dobozból választott.
            await _upsertLink(id, existingId, LinkRole.example, index);
          } else {
            await _insertExample(
              parentId: id,
              example: example,
              position: index,
              level: draft.level,
              source: draft.source,
              tags: draft.tags,
            );
            created++;
          }
        }
        await _replaceSimilar(id, draft.similarIds);
      }

      if (current.type == ItemType.rule) {
        await (_db.delete(_db.ruleMistakes)..where((m) => m.ruleId.equals(id))).go();
        for (final (index, mistake) in draft.mistakes.indexed) {
          await _db
              .into(_db.ruleMistakes)
              .insert(
                RuleMistakesCompanion.insert(
                  ruleId: id,
                  wrong: mistake.wrong.trim(),
                  explanation: Value(_blankToNull(mistake.explanation)),
                  position: Value(index),
                ),
              );
        }
      }

      return created;
    });
  }

  /// Új példamondat egy meglévő elemhez („Add your own example”).
  /// A mondat megkapja a szülő szintjét, forrását és címkéit.
  /// Visszaadja az új mondat azonosítóját.
  Future<int> addExample(int parentId, NewExample example) {
    return _db.transaction(() async {
      final parent = await _getItem(parentId);
      if (parent == null) throw StateError('Item $parentId not found');

      final maxPosition = _db.itemLinks.position.max();
      final positionQuery = _db.selectOnly(_db.itemLinks)
        ..addColumns([maxPosition])
        ..where(
          _db.itemLinks.parentId.equals(parentId) &
              _db.itemLinks.role.equalsValue(LinkRole.example),
        );
      final last = await positionQuery.map((r) => r.read(maxPosition)).getSingle();

      final tagNames = (await _tagNamesFor([parentId]))[parentId] ?? const [];
      return _insertExample(
        parentId: parentId,
        example: example,
        position: (last ?? -1) + 1,
        level: parent.level,
        source: parent.source,
        tags: tagNames,
      );
    });
  }

  /// Két meglévő elem összekapcsolása (pl. szó → nyelvtani szabály).
  Future<void> link(int parentId, int childId, LinkRole role) async {
    await _db
        .into(_db.itemLinks)
        .insert(
          ItemLinksCompanion.insert(parentId: parentId, childId: childId, role: role),
          mode: InsertMode.insertOrIgnore,
        );
  }

  Future<void> toggleFavorite(int id) async {
    await _db.customUpdate(
      'UPDATE items SET is_favorite = NOT is_favorite WHERE id = ?',
      variables: [Variable.withInt(id)],
      updates: {_db.items},
    );
  }

  /// Törli az elemet. A hozzá tartozó kapcsolatok, címke-hozzárendelések és
  /// ismétlési adatok kaszkádolva törlődnek; a példamondatok megmaradnak.
  Future<void> deleteItem(int id) async {
    await (_db.delete(_db.items)..where((i) => i.id.equals(id))).go();
  }

  // ------------------------------------------------------------ segédek

  /// Kapcsolat beszúrása, vagy ha már van, a sorrend frissítése
  /// (SQL „upsert”: INSERT … ON CONFLICT DO UPDATE).
  Future<void> _upsertLink(int parentId, int childId, LinkRole role, int position) async {
    await _db
        .into(_db.itemLinks)
        .insertOnConflictUpdate(
          ItemLinksCompanion.insert(
            parentId: parentId,
            childId: childId,
            role: role,
            position: Value(position),
          ),
        );
  }

  /// A „similar” kapcsolatok cseréje az űrlapon lévőkre. A kapcsolat kölcsönös:
  /// mindkét irányban eltároljuk, így a másik elem oldalán is megjelenik.
  Future<void> _replaceSimilar(int id, List<int> similarIds) async {
    await (_db.delete(_db.itemLinks)..where(
          (l) =>
              l.role.equalsValue(LinkRole.similar) & (l.parentId.equals(id) | l.childId.equals(id)),
        ))
        .go();
    for (final (index, otherId) in similarIds.where((o) => o != id).toSet().indexed) {
      await _upsertLink(id, otherId, LinkRole.similar, index);
      await _upsertLink(otherId, id, LinkRole.similar, 0);
    }
  }

  Future<int> _insertExample({
    required int parentId,
    required NewExample example,
    required int position,
    required CefrLevel? level,
    required String? source,
    required List<String> tags,
  }) async {
    final sentenceId = await _db
        .into(_db.items)
        .insert(
          ItemsCompanion.insert(
            type: ItemType.sentence,
            english: example.english.trim(),
            hungarian: Value(example.hungarian?.trim() ?? ''),
            level: Value(level),
            source: Value(_blankToNull(source)),
          ),
        );
    await _startReview(sentenceId);
    await _attachTags(sentenceId, tags);
    await _db
        .into(_db.itemLinks)
        .insert(
          ItemLinksCompanion.insert(
            parentId: parentId,
            childId: sentenceId,
            role: LinkRole.example,
            position: Value(position),
          ),
        );
    return sentenceId;
  }

  Future<void> _startReview(int itemId) async {
    await _db
        .into(_db.reviewStates)
        .insert(ReviewStatesCompanion.insert(itemId: Value(itemId), dueAt: DateTime.now()));
  }

  Future<void> _attachTags(int itemId, List<String> names) async {
    for (final name in names.map(normalizeTag).where((n) => n.isNotEmpty).toSet()) {
      final existing = await (_db.select(
        _db.tags,
      )..where((t) => t.name.equals(name))).getSingleOrNull();
      final tagId =
          existing?.id ?? await _db.into(_db.tags).insert(TagsCompanion.insert(name: name));
      await _db
          .into(_db.itemTags)
          .insert(
            ItemTagsCompanion.insert(itemId: itemId, tagId: tagId),
            mode: InsertMode.insertOrIgnore,
          );
    }
  }
}

/// „#Work ” → „work”
String normalizeTag(String raw) {
  var name = raw.trim().toLowerCase();
  while (name.startsWith('#')) {
    name = name.substring(1);
  }
  return name.trim();
}

String? _blankToNull(String? value) {
  final trimmed = value?.trim();
  return (trimmed == null || trimmed.isEmpty) ? null : trimmed;
}
