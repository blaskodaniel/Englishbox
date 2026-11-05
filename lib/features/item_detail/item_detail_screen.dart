import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/labels.dart';
import '../../app/theme.dart';
import '../../data/models.dart';
import '../../data/providers.dart';
import '../../domain/enums.dart';
import '../../domain/xp.dart';
import '../../services/speech_service.dart';
import '../../widgets/chunky_button.dart';
import '../../widgets/screen_header.dart';
import 'add_example_dialog.dart';
import 'widgets/detail_parts.dart';
import 'widgets/item_hero.dart';
import 'widgets/rule_body.dart';

/// Elemrészlet. A tartalom élő: ha pl. új példát adsz hozzá, magától frissül.
class ItemDetailScreen extends ConsumerWidget {
  const ItemDetailScreen({super.key, required this.itemId});

  final int itemId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(itemDetailProvider(itemId));
    final detail = detailAsync.value;

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
              trailing: detail == null ? null : _HeaderActions(detail: detail),
            ),
            Expanded(
              child: switch (detail) {
                null when detailAsync.isLoading => const Center(child: CircularProgressIndicator()),
                null => const _Missing(),
                final detail => SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                  child: detail.item.type == ItemType.rule
                      ? RuleBody(detail: detail)
                      : _ItemBody(detail: detail),
                ),
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: detail == null || detail.item.type == ItemType.sentence
          ? null
          : _AddExampleBar(detail: detail),
    );
  }
}

/// Szó, kifejezés vagy mondat részletei a terv „Word” képernyője szerint.
class _ItemBody extends ConsumerWidget {
  const _ItemBody({required this.detail});

  final ItemDetail detail;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final item = detail.item;
    final notes = item.notes;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 18,
      children: [
        ItemHero(
          detail: detail,
          onSpeak: () => ref.read(speechServiceProvider).speak(item.english),
        ),
        if (notes != null && notes.isNotEmpty)
          DetailSection(
            title: 'Notes',
            children: [NotesText(notes, accent: item.type.color, numbered: false)],
          ),
        if (detail.examples.isNotEmpty)
          DetailSection(
            title: 'Examples · ${detail.examples.length}',
            children: [
              for (final example in detail.examples)
                ExampleCard(
                  sentence: example,
                  highlight: item.english,
                  color: item.type.color,
                  onTap: () => context.push('/item/${example.id}'),
                ),
            ],
          ),
        if (detail.exampleOf.isNotEmpty)
          DetailSection(
            title: 'Example of',
            children: [
              for (final parent in detail.exampleOf)
                LinkedItemCard(item: parent, onTap: () => context.push('/item/${parent.id}')),
            ],
          ),
        if (detail.similar.isNotEmpty)
          DetailSection(
            title: 'Similar',
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final similar in detail.similar)
                    ActionChip(
                      label: Text(similar.english),
                      onPressed: () => context.push('/item/${similar.id}'),
                      backgroundColor: AppColors.surfaceAlt,
                      side: BorderSide.none,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadii.chip),
                      ),
                    ),
                ],
              ),
            ],
          ),
        if (detail.linkedGrammar.isNotEmpty)
          DetailSection(
            title: 'Linked grammar',
            children: [
              for (final rule in detail.linkedGrammar)
                LinkedItemCard(item: rule, onTap: () => context.push('/item/${rule.id}')),
            ],
          ),
        DetailFooter(item: item, tags: detail.tags),
      ],
    );
  }
}

class _HeaderActions extends ConsumerWidget {
  const _HeaderActions({required this.detail});

  final ItemDetail detail;

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final item = detail.item;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete „${item.english}”?'),
        content: Text(
          item.type == ItemType.sentence
              ? 'This sentence will be removed from your box.'
              : 'Its example sentences stay in your box as sentences.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.wrong),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    // A repositoryt még a navigáció előtt elkérjük, mert utána a widget már nem él.
    final repository = ref.read(itemsRepositoryProvider);
    context.pop();
    await repository.deleteItem(item.id);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final item = detail.item;
    return Row(
      spacing: 8,
      children: [
        SquareIconButton(
          icon: item.isFavorite ? Icons.star_rounded : Icons.star_outline_rounded,
          tooltip: item.isFavorite ? 'Remove from favourites' : 'Add to favourites',
          color: AppColors.streak,
          onPressed: () => ref.read(itemsRepositoryProvider).toggleFavorite(item.id),
        ),
        SquareIconButton(
          icon: Icons.edit_outlined,
          tooltip: 'Edit',
          onPressed: () => context.push('/item/${item.id}/edit'),
        ),
        SquareIconButton(
          icon: Icons.delete_outline_rounded,
          tooltip: 'Delete',
          onPressed: () => _confirmDelete(context, ref),
        ),
      ],
    );
  }
}

class _AddExampleBar extends ConsumerWidget {
  const _AddExampleBar({required this.detail});

  final ItemDetail detail;

  Future<void> _addExample(BuildContext context, WidgetRef ref) async {
    final item = detail.item;
    final example = await showAddExampleDialog(context, term: item.english);
    if (example == null) return;

    final sentenceId = await ref.read(itemsRepositoryProvider).addExample(item.id, example);
    await ref
        .read(xpRepositoryProvider)
        .award(XpRules.ownExample, XpReason.addExample, itemId: sentenceId);
    if (context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Example added · +${XpRules.ownExample} XP')));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isRule = detail.item.type == ItemType.rule;
    return Container(
      padding: EdgeInsets.fromLTRB(20, 12, 20, 12 + MediaQuery.paddingOf(context).bottom),
      child: ChunkyButton(
        label: isRule ? 'Collect an example' : 'Add your own example',
        badge: '+${XpRules.ownExample} XP',
        onPressed: () => _addExample(context, ref),
      ),
    );
  }
}

class _Missing extends StatelessWidget {
  const _Missing();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'This item is no longer in your box.',
        style: TextStyle(color: AppColors.textMuted),
      ),
    );
  }
}
