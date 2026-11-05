import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/labels.dart';
import '../../app/theme.dart';
import '../../domain/enums.dart';
import '../../widgets/chunky_button.dart';
import 'library_filter.dart';
import 'widgets/filter_sheet.dart';
import 'widgets/item_row.dart';

class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen> {
  late final _search = TextEditingController(text: ref.read(libraryFilterProvider).search);

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filter = ref.watch(libraryFilterProvider);
    final notifier = ref.read(libraryFilterProvider.notifier);
    // Ha kívülről (pl. a Today csempéiről) törlik a keresést, a mező is ürüljön.
    ref.listen(libraryFilterProvider.select((f) => f.search), (_, search) {
      if (_search.text != search) _search.text = search;
    });
    final itemsAsync = ref.watch(libraryItemsProvider);
    // Frissítés közben az előző lista marad látható (nincs villogás gépelés közben).
    final entries = itemsAsync.value;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              sliver: SliverList.list(
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Library',
                          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () => context.push('/tags'),
                        icon: const Icon(Icons.sell_outlined, size: 16),
                        label: const Text('Collections'),
                        style: TextButton.styleFrom(
                          backgroundColor: AppColors.surface,
                          foregroundColor: AppColors.accent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadii.chip),
                          ),
                          textStyle: const TextStyle(
                            fontFamily: 'Lexend',
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _search,
                    onChanged: notifier.setSearch,
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      hintText: 'Search words, meanings, tags…',
                      prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textMuted),
                      suffixIcon: filter.search.isEmpty
                          ? null
                          : IconButton(
                              tooltip: 'Clear search',
                              icon: const Icon(Icons.close_rounded),
                              onPressed: () {
                                _search.clear();
                                notifier.setSearch('');
                              },
                            ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  _TypeChips(selected: filter.type, onSelected: notifier.setType),
                  const SizedBox(height: 10),
                  _FilterSummary(filter: filter, onTap: () => showLibraryFilterSheet(context)),
                  const SizedBox(height: 8),
                ],
              ),
            ),
            if (entries == null)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: itemsAsync.hasError
                      ? Text('Something went wrong: ${itemsAsync.error}')
                      : const CircularProgressIndicator(),
                ),
              )
            else if (entries.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: filter.isEmpty
                    ? const _EmptyBox()
                    : _NoMatches(
                        onClear: () {
                          _search.clear();
                          notifier.reset();
                        },
                      ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                sliver: SliverList.separated(
                  itemCount: entries.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final entry = entries[index];
                    return ItemRow(
                      entry: entry,
                      onTap: () => context.push('/item/${entry.item.id}'),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _TypeChips extends StatelessWidget {
  const _TypeChips({required this.selected, required this.onSelected});

  final ItemType? selected;
  final ValueChanged<ItemType?> onSelected;

  static const _labels = {
    ItemType.word: 'Words',
    ItemType.phrase: 'Phrases',
    ItemType.rule: 'Grammar',
    ItemType.sentence: 'Sentences',
  };

  @override
  Widget build(BuildContext context) {
    Widget chip(String label, ItemType? type, Color color) {
      final isSelected = selected == type;
      return Semantics(
        selected: isSelected,
        button: true,
        child: GestureDetector(
          onTap: () => onSelected(type),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            height: 36,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected ? color : Colors.transparent,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: isSelected ? color : AppColors.borderStrong, width: 2),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                color: isSelected ? AppColors.background : color,
              ),
            ),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        spacing: 8,
        children: [
          chip('All', null, AppColors.text),
          for (final type in ItemType.values) chip(_labels[type]!, type, type.color),
        ],
      ),
    );
  }
}

class _FilterSummary extends StatelessWidget {
  const _FilterSummary({required this.filter, required this.onTap});

  final LibraryFilter filter;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final parts = [
      if (filter.collectionName != null) filter.collectionName!,
      filter.level?.label ?? 'All levels',
      if (filter.tagName != null) '#${filter.tagName}',
      if (filter.favoritesOnly) '★',
    ];
    final color = filter.hasExtraFilters ? AppColors.accent : AppColors.textMuted;

    return Row(
      children: [
        const Expanded(
          child: Text('Recently added', style: TextStyle(fontSize: 13, color: AppColors.textMuted)),
        ),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
            child: Row(
              spacing: 6,
              children: [
                Text(parts.join(' · '), style: TextStyle(fontSize: 13, color: color)),
                Icon(Icons.filter_list_rounded, size: 16, color: color),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _EmptyBox extends StatelessWidget {
  const _EmptyBox();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 12,
        children: [
          const Icon(Icons.inventory_2_outlined, size: 48, color: AppColors.textMuted),
          const Text(
            'Your box is empty',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const Text(
            'Catch your first word, phrase or sentence.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textMuted),
          ),
          const SizedBox(height: 8),
          ChunkyButton(
            label: 'Add your first item',
            icon: Icons.add_rounded,
            onPressed: () => context.push('/add'),
          ),
        ],
      ),
    );
  }
}

class _NoMatches extends StatelessWidget {
  const _NoMatches({required this.onClear});

  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 8,
      children: [
        const Text('Nothing matches', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        TextButton(onPressed: onClear, child: const Text('Clear search and filters')),
      ],
    );
  }
}
