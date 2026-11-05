import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models.dart';
import '../../data/providers.dart';
import '../../domain/enums.dart';

/// A Library szűrői. Nem csak a Library állíthatja: pl. a Today „Words” csempéje
/// vagy a Collections egy címkéje is beállíthatja, mielőtt a Libraryre navigál.
class LibraryFilter {
  const LibraryFilter({
    this.type,
    this.level,
    this.tagId,
    this.tagName,
    this.collectionId,
    this.collectionName,
    this.favoritesOnly = false,
    this.search = '',
  });

  final ItemType? type;
  final CefrLevel? level;
  final int? tagId;
  final String? tagName;
  final int? collectionId;
  final String? collectionName;
  final bool favoritesOnly;
  final String search;

  /// Van-e a típuson és a keresésen kívül aktív szűrő (a szűrőgomb jelzéséhez).
  bool get hasExtraFilters =>
      level != null || tagId != null || collectionId != null || favoritesOnly;

  bool get isEmpty => type == null && !hasExtraFilters && search.trim().isEmpty;
}

/// Mint egy kis Redux/Zustand store: az állapot + a módosító műveletek.
class LibraryFilterNotifier extends Notifier<LibraryFilter> {
  @override
  LibraryFilter build() => const LibraryFilter();

  LibraryFilter _copy({
    ItemType? Function()? type,
    CefrLevel? Function()? level,
    (int, String)? Function()? tag,
    (int, String)? Function()? collection,
    bool? favoritesOnly,
    String? search,
  }) {
    final s = state;
    final newTag = tag != null ? tag() : (s.tagId == null ? null : (s.tagId!, s.tagName ?? ''));
    final newCollection = collection != null
        ? collection()
        : (s.collectionId == null ? null : (s.collectionId!, s.collectionName ?? ''));
    return LibraryFilter(
      type: type != null ? type() : s.type,
      level: level != null ? level() : s.level,
      tagId: newTag?.$1,
      tagName: newTag?.$2,
      collectionId: newCollection?.$1,
      collectionName: newCollection?.$2,
      favoritesOnly: favoritesOnly ?? s.favoritesOnly,
      search: search ?? s.search,
    );
  }

  void setType(ItemType? type) => state = _copy(type: () => type);

  void setLevel(CefrLevel? level) => state = _copy(level: () => level);

  void setTag(int? id, String? name) =>
      state = _copy(tag: () => id == null ? null : (id, name ?? ''));

  void setCollection(int? id, String? name) =>
      state = _copy(collection: () => id == null ? null : (id, name ?? ''));

  void setFavoritesOnly(bool value) => state = _copy(favoritesOnly: value);

  void setSearch(String search) => state = _copy(search: search);

  void clearExtraFilters() => state = LibraryFilter(type: state.type, search: state.search);

  void reset() => state = const LibraryFilter();
}

final libraryFilterProvider = NotifierProvider<LibraryFilterNotifier, LibraryFilter>(
  LibraryFilterNotifier.new,
);

/// A szűrt lista – automatikusan újraszámol, ha a szűrő vagy az adat változik.
final libraryItemsProvider = StreamProvider<List<ItemListEntry>>((ref) {
  final filter = ref.watch(libraryFilterProvider);
  return ref
      .watch(itemsRepositoryProvider)
      .watchItems(
        type: filter.type,
        level: filter.level,
        tagId: filter.tagId,
        collectionId: filter.collectionId,
        favoritesOnly: filter.favoritesOnly,
        search: filter.search,
      );
});
