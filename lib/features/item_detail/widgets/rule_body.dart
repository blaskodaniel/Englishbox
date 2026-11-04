import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme.dart';
import '../../../data/models.dart';
import 'detail_parts.dart';

/// Nyelvtani szabály részletei a terv „Grammar” képernyője szerint.
class RuleBody extends StatelessWidget {
  const RuleBody({super.key, required this.detail});

  final ItemDetail detail;

  @override
  Widget build(BuildContext context) {
    final item = detail.item;
    final notes = item.notes;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 18,
      children: [
        _RuleHero(detail: detail),
        if (notes != null && notes.isNotEmpty)
          DetailSection(title: 'Use it when', children: [NotesText(notes)]),
        if (detail.examples.isNotEmpty || detail.mistakes.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 8,
            children: [
              for (final example in detail.examples)
                _VerdictCard(
                  correct: true,
                  text: example.english,
                  note: example.hungarian,
                  onTap: () => context.push('/item/${example.id}'),
                ),
              for (final mistake in detail.mistakes)
                _VerdictCard(correct: false, text: mistake.wrong, note: mistake.explanation),
            ],
          ),
        if (item.trapNote != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.dashed, width: 2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 6,
              children: [
                const Text(
                  'Hungarian trap',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.rule),
                ),
                Text(
                  item.trapNote!,
                  style: const TextStyle(fontSize: 14, height: 1.5, color: AppColors.textSoft),
                ),
              ],
            ),
          ),
        DetailSection(
          title: 'In your box',
          children: [
            Row(
              spacing: 8,
              children: [
                _StatTile(
                  value: detail.examples.length,
                  label: 'example sentences',
                  color: AppColors.sentence,
                ),
                _StatTile(
                  value: detail.linkedFrom.length,
                  label: 'linked items',
                  color: AppColors.phrase,
                ),
              ],
            ),
          ],
        ),
        if (detail.linkedFrom.isNotEmpty)
          DetailSection(
            title: 'Linked items',
            children: [
              for (final linked in detail.linkedFrom)
                LinkedItemCard(item: linked, onTap: () => context.push('/item/${linked.id}')),
            ],
          ),
        DetailFooter(item: item, tags: detail.tags),
      ],
    );
  }
}

class _RuleHero extends StatelessWidget {
  const _RuleHero({required this.detail});

  final ItemDetail detail;

  @override
  Widget build(BuildContext context) {
    final item = detail.item;
    final chip = [
      'Grammar',
      if (item.ruleCategory != null) item.ruleCategory!,
    ].join(' · ');

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.ruleBg,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 14,
        children: [
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              _Chip(text: chip.toUpperCase(), filled: true),
              if (item.level != null) _Chip(text: 'Level ${item.level!.label}'),
            ],
          ),
          Text(
            item.english,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, height: 1.15),
          ),
          if (item.formula.isNotEmpty)
            Wrap(
              spacing: 6,
              runSpacing: 6,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                for (final (index, block) in item.formula.indexed) ...[
                  if (index > 0) const Text('+', style: TextStyle(color: AppColors.textMuted)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: block.isKeyword ? AppColors.rule : AppColors.ruleSlot,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      block.text,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: block.isKeyword ? FontWeight.w700 : FontWeight.w600,
                        color: block.isKeyword ? AppColors.onRule : AppColors.text,
                      ),
                    ),
                  ),
                ],
              ],
            ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.text, this.filled = false});

  final String text;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: filled ? AppColors.rule : null,
        borderRadius: BorderRadius.circular(8),
        border: filled ? null : Border.all(color: AppColors.rule, width: 1.5),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.6,
          color: filled ? AppColors.onRule : AppColors.text,
        ),
      ),
    );
  }
}

class _VerdictCard extends StatelessWidget {
  const _VerdictCard({required this.correct, required this.text, this.note, this.onTap});

  final bool correct;
  final String text;
  final String? note;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: correct ? AppColors.sentenceBg : AppColors.wrongBg,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              Icon(
                correct ? Icons.check_rounded : Icons.close_rounded,
                size: 20,
                color: correct ? AppColors.sentence : AppColors.wrong,
                semanticLabel: correct ? 'Correct' : 'Wrong',
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4,
                  children: [
                    Text(
                      text,
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.45,
                        color: correct ? AppColors.text : AppColors.wrongText,
                      ),
                    ),
                    if (note != null && note!.isNotEmpty)
                      Text(note!, style: const TextStyle(fontSize: 13, color: AppColors.textMuted)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.value, required this.label, required this.color});

  final int value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 2,
          children: [
            Text('$value', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: color)),
            Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textMuted)),
          ],
        ),
      ),
    );
  }
}
