import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app/labels.dart';
import '../app/theme.dart';
import '../data/db.dart';
import '../data/models.dart';
import '../data/providers.dart';
import '../domain/enums.dart';
import 'chunky_button.dart';

/// Elemválasztó alsó lap kereséssel: a dobozban lévő elemek közül lehet
/// egyet vagy többet kijelölni. A kijelölt elemekkel tér vissza (`null`, ha
/// bezárták).
///
/// - [types]: csak ezek a típusok jelennek meg (pl. csak mondatok).
/// - [excludeIds]: ezek nem jelennek meg (pl. maga az elem, vagy ami már hozzá van adva).
Future<List<Item>?> showItemPickerSheet(
  BuildContext context, {
  required String title,
  required Set<ItemType> types,
  Set<int> excludeIds = const {},
  String confirmLabel = 'Add',
}) {
  return showModalBottomSheet<List<Item>>(
    context: context,
    backgroundColor: AppColors.surface,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => _ItemPickerSheet(
      title: title,
      types: types,
      excludeIds: excludeIds,
      confirmLabel: confirmLabel,
    ),
  );
}

/// A keresés eredménye – a kulcs a keresett szöveg és (ha egy van) a típus.
/// `autoDispose`: a lap bezárásakor a lekérdezés is leáll.
final _pickerItemsProvider = StreamProvider.autoDispose
    .family<List<ItemListEntry>, ({ItemType? type, String search})>(
      (ref, key) =>
          ref.watch(itemsRepositoryProvider).watchItems(type: key.type, search: key.search),
    );

class _ItemPickerSheet extends ConsumerStatefulWidget {
  const _ItemPickerSheet({
    required this.title,
    required this.types,
    required this.excludeIds,
    required this.confirmLabel,
  });

  final String title;
  final Set<ItemType> types;
  final Set<int> excludeIds;
  final String confirmLabel;

  @override
  ConsumerState<_ItemPickerSheet> createState() => _ItemPickerSheetState();
}

class _ItemPickerSheetState extends ConsumerState<_ItemPickerSheet> {
  String _search = '';

  /// A kijelöltek, a kijelölés sorrendjében (a Map megőrzi a beszúrási sorrendet).
  final Map<int, Item> _selected = {};

  void _toggle(Item item) => setState(() {
    if (_selected.remove(item.id) == null) _selected[item.id] = item;
  });

  @override
  Widget build(BuildContext context) {
    final key = (type: widget.types.length == 1 ? widget.types.first : null, search: _search);
    final entries = ref.watch(_pickerItemsProvider(key)).value;
    final visible = entries
        ?.where((e) => widget.types.contains(e.item.type) && !widget.excludeIds.contains(e.item.id))
        .toList();
    final keyboard = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: keyboard),
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.75,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 12,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                  TextField(
                    onChanged: (value) => setState(() => _search = value),
                    textInputAction: TextInputAction.search,
                    decoration: const InputDecoration(
                      hintText: 'Search your box…',
                      prefixIcon: Icon(Icons.search_rounded, color: AppColors.textMuted),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: switch (visible) {
                null => const Center(child: CircularProgressIndicator()),
                [] => Center(
                  child: Text(
                    _search.trim().isEmpty ? 'Nothing to pick yet' : 'Nothing matches',
                    style: const TextStyle(color: AppColors.textMuted),
                  ),
                ),
                final list => ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final item = list[index].item;
                    return _PickTile(
                      item: item,
                      selected: _selected.containsKey(item.id),
                      onTap: () => _toggle(item),
                    );
                  },
                ),
              },
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                child: ChunkyButton(
                  label: _selected.isEmpty
                      ? widget.confirmLabel
                      : '${widget.confirmLabel} (${_selected.length})',
                  onPressed: _selected.isEmpty
                      ? null
                      : () => Navigator.of(context).pop(_selected.values.toList()),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PickTile extends StatelessWidget {
  const _PickTile({required this.item, required this.selected, required this.onTap});

  final Item item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final subtitle = itemSubtitle(item);
    return CheckboxListTile(
      value: selected,
      onChanged: (_) => onTap(),
      activeColor: AppColors.accent,
      checkColor: AppColors.onAccent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      secondary: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(color: item.type.color, shape: BoxShape.circle),
      ),
      title: Text(
        item.english,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),
      subtitle: subtitle.isEmpty
          ? null
          : Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13, color: AppColors.textMuted),
            ),
    );
  }
}
