import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme.dart';
import '../../../data/providers.dart';
import '../../../domain/enums.dart';
import '../../../widgets/field_label.dart';
import '../../../widgets/select_chip.dart';
import '../library_filter.dart';

Future<void> showLibraryFilterSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: AppColors.surface,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => const _FilterSheet(),
  );
}

/// Szint, címke és kedvencek szűrő. Minden koppintás azonnal érvényesül.
class _FilterSheet extends ConsumerWidget {
  const _FilterSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(libraryFilterProvider);
    final notifier = ref.read(libraryFilterProvider.notifier);
    final tags = ref.watch(tagsWithCountsProvider).value ?? const [];
    final collections = ref.watch(collectionsProvider).value ?? const [];

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 18,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Filter',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                ),
                if (filter.hasExtraFilters)
                  TextButton(onPressed: notifier.clearExtraFilters, child: const Text('Clear')),
              ],
            ),
            _section('Level', [
              for (final level in CefrLevel.values)
                SelectChip(
                  label: level.label,
                  selected: filter.level == level,
                  onTap: () => notifier.setLevel(filter.level == level ? null : level),
                ),
            ]),
            if (collections.isNotEmpty)
              _section('Collection', [
                for (final c in collections)
                  SelectChip(
                    label: '${c.collection.name} · ${c.total}',
                    selected: filter.collectionId == c.collection.id,
                    onTap: () => filter.collectionId == c.collection.id
                        ? notifier.setCollection(null, null)
                        : notifier.setCollection(c.collection.id, c.collection.name),
                  ),
              ]),
            _section(
              'Tag',
              tags.isEmpty
                  ? [const Text('No tags yet', style: TextStyle(color: AppColors.textMuted))]
                  : [
                      for (final t in tags)
                        SelectChip(
                          label: '#${t.tag.name} · ${t.count}',
                          selected: filter.tagId == t.tag.id,
                          onTap: () => filter.tagId == t.tag.id
                              ? notifier.setTag(null, null)
                              : notifier.setTag(t.tag.id, t.tag.name),
                        ),
                    ],
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Favourites only'),
              value: filter.favoritesOnly,
              onChanged: notifier.setFavoritesOnly,
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('To check only'),
              subtitle: const Text('Items you marked to look up later'),
              value: filter.needsCheckOnly,
              onChanged: notifier.setNeedsCheckOnly,
            ),
          ],
        ),
      ),
    );
  }

  Widget _section(String title, List<Widget> chips) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: 8,
    children: [
      FieldLabel(title),
      Wrap(spacing: 8, runSpacing: 8, children: chips),
    ],
  );
}
