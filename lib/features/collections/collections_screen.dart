import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../data/models.dart';
import '../../data/providers.dart';
import '../../domain/enums.dart';
import '../../widgets/screen_header.dart';
import '../library/library_filter.dart';
import 'collection_sheet.dart';
import 'collection_style.dart';

/// „Collections” – saját gyűjtemények, elemszám szintenként és a címkék.
/// Bármelyikre koppintva a Library nyílik meg, arra szűrve.
class CollectionsScreen extends ConsumerWidget {
  const CollectionsScreen({super.key});

  /// A Library fülre vált a megadott szűrővel (a korábbi szűrőket törli).
  void _openLibrary(
    BuildContext context,
    WidgetRef ref,
    void Function(LibraryFilterNotifier filter) apply,
  ) {
    final filter = ref.read(libraryFilterProvider.notifier)..reset();
    apply(filter);
    context.go('/library');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collections = ref.watch(collectionsProvider).value;
    final levels = ref.watch(levelCountsProvider).value;
    final tags = ref.watch(tagsWithCountsProvider).value;
    final myLevel = ref.watch(settingsProvider).value?.levelNow;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            ScreenHeader(
              title: '',
              leadingIcon: Icons.arrow_back_rounded,
              leadingLabel: 'Back',
              onLeading: () => context.pop(),
              trailing: SquareIconButton(
                icon: Icons.add_rounded,
                tooltip: 'New collection',
                color: AppColors.accent,
                onPressed: () => showCollectionSheet(context),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
                children: [
                  const Text(
                    'Collections',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 16),
                  if (collections == null)
                    const SizedBox(height: 80)
                  else if (collections.isEmpty)
                    _EmptyCollections(onCreate: () => showCollectionSheet(context))
                  else
                    Column(
                      spacing: 10,
                      children: [
                        for (final summary in collections)
                          _CollectionCard(
                            summary: summary,
                            onTap: () => _openLibrary(
                              context,
                              ref,
                              (f) =>
                                  f.setCollection(summary.collection.id, summary.collection.name),
                            ),
                            onEdit: () =>
                                showCollectionSheet(context, existing: summary.collection),
                          ),
                      ],
                    ),
                  const SizedBox(height: 24),
                  const _SectionTitle('By level'),
                  const SizedBox(height: 10),
                  if (levels != null)
                    _LevelChart(
                      counts: levels,
                      highlight: myLevel,
                      onTap: (level) => _openLibrary(context, ref, (f) => f.setLevel(level)),
                    ),
                  const SizedBox(height: 24),
                  _SectionTitle('Tags', trailing: tags == null ? null : '${tags.length}'),
                  const SizedBox(height: 10),
                  if (tags != null && tags.isEmpty)
                    const Text(
                      'No tags yet. Add some when you save a word.',
                      style: TextStyle(fontSize: 14, color: AppColors.textMuted),
                    )
                  else if (tags != null)
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final t in tags)
                          _TagChip(
                            name: t.tag.name,
                            count: t.count,
                            onTap: () =>
                                _openLibrary(context, ref, (f) => f.setTag(t.tag.id, t.tag.name)),
                          ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title, {this.trailing});

  final String title;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        ),
        if (trailing != null)
          Text(trailing!, style: const TextStyle(fontSize: 13, color: AppColors.textMuted)),
      ],
    );
  }
}

/// Egy gyűjtemény: ikon, név, elemszám és a „mastered” arány sávja.
/// Koppintás → Library; hosszú nyomás vagy a ⋯ gomb → szerkesztés.
class _CollectionCard extends StatelessWidget {
  const _CollectionCard({required this.summary, required this.onTap, required this.onEdit});

  final CollectionSummary summary;
  final VoidCallback onTap;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final collection = summary.collection;
    final percent = (summary.masteredFraction * 100).round();
    return Material(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadii.card),
        side: const BorderSide(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        onLongPress: onEdit,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 8, 14),
          child: Row(
            spacing: 14,
            children: [
              CollectionBadge(icon: collection.icon, color: collection.colorValue),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 6,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            collection.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                          ),
                        ),
                        Text(
                          '${summary.total}',
                          style: const TextStyle(fontSize: 13, color: AppColors.textMuted),
                        ),
                      ],
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: summary.masteredFraction,
                        minHeight: 8,
                        backgroundColor: AppColors.border,
                        color: AppColors.accent,
                      ),
                    ),
                    Text(
                      summary.total == 0
                          ? 'Empty – add items from their page'
                          : '$percent% mastered',
                      style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Edit collection',
                onPressed: onEdit,
                icon: const Icon(Icons.more_vert_rounded, color: AppColors.textMuted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyCollections extends StatelessWidget {
  const _EmptyCollections({required this.onCreate});

  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onCreate,
      borderRadius: BorderRadius.circular(AppRadii.card),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadii.card),
          border: Border.all(color: AppColors.dashed, width: 2),
        ),
        child: const Row(
          spacing: 14,
          children: [
            Icon(Icons.create_new_folder_outlined, size: 28, color: AppColors.accent),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4,
                children: [
                  Text(
                    'Create your first collection',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    'Group items your way – e.g. „Work English” or „Series & films”.',
                    style: TextStyle(fontSize: 13, height: 1.4, color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Oszlopdiagram A1–C2: a saját szinted lime, a többi semleges szürke.
/// Koppintásra a Library az adott szintre szűrve nyílik.
class _LevelChart extends StatelessWidget {
  const _LevelChart({required this.counts, required this.highlight, required this.onTap});

  final Map<CefrLevel, int> counts;
  final CefrLevel? highlight;
  final ValueChanged<CefrLevel> onTap;

  static const _barArea = 60.0;

  @override
  Widget build(BuildContext context) {
    final max = counts.values.fold(1, (a, b) => b > a ? b : a);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      spacing: 8,
      children: [
        for (final level in CefrLevel.values)
          Expanded(
            child: Semantics(
              button: true,
              label: '${level.label}: ${counts[level] ?? 0} items',
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onTap(level),
                child: _bar(level, counts[level] ?? 0, max),
              ),
            ),
          ),
      ],
    );
  }

  Widget _bar(CefrLevel level, int count, int max) {
    final mine = level == highlight;
    final height = count == 0 ? 4.0 : (_barArea * count / max).clamp(8.0, _barArea);
    return Column(
      spacing: 6,
      children: [
        Text(
          '$count',
          style: TextStyle(
            fontSize: 11,
            fontWeight: mine ? FontWeight.w700 : FontWeight.w400,
            color: mine ? AppColors.accent : AppColors.textSoft,
          ),
        ),
        SizedBox(
          height: _barArea,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: height,
              decoration: BoxDecoration(
                color: count == 0
                    ? AppColors.border
                    : mine
                    ? AppColors.accent
                    : const Color(0xFF3A4256),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        Text(
          level.label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: mine ? AppColors.text : AppColors.textSoft,
          ),
        ),
      ],
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({required this.name, required this.count, required this.onTap});

  final String name;
  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceAlt,
      borderRadius: BorderRadius.circular(AppRadii.chip),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadii.chip),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 8,
            children: [
              Text('#$name', style: const TextStyle(fontSize: 14)),
              Text('$count', style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
            ],
          ),
        ),
      ),
    );
  }
}
