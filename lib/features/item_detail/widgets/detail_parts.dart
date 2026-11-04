import 'package:flutter/material.dart';

import '../../../app/format.dart';
import '../../../app/labels.dart';
import '../../../app/theme.dart';
import '../../../data/db.dart';
import '../../../widgets/highlighted_text.dart';

/// Nagybetűs szürke szakaszcím: „EXAMPLES · 2”.
class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        letterSpacing: 1,
        color: AppColors.textMuted,
      ),
    );
  }
}

/// Egy szakasz: cím + tartalom.
class DetailSection extends StatelessWidget {
  const DetailSection({super.key, required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 10,
      children: [SectionTitle(title), ...children],
    );
  }
}

/// Példamondat-kártya kiemelt szóval; koppintásra a mondat részletei nyílnak.
class ExampleCard extends StatelessWidget {
  const ExampleCard({
    super.key,
    required this.sentence,
    required this.highlight,
    required this.color,
    required this.onTap,
  });

  final Item sentence;
  final String highlight;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _CardButton(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 4,
        children: [
          HighlightedText(
            sentence.english,
            highlight: highlight,
            color: color,
            style: const TextStyle(fontSize: 15, height: 1.45),
          ),
          if (sentence.hungarian.isNotEmpty)
            Text(
              sentence.hungarian,
              style: const TextStyle(fontSize: 13, color: AppColors.textMuted),
            ),
        ],
      ),
    );
  }
}

/// Kapcsolt elem (nyelvtan, „Used in”) színes háttérrel és nyíllal.
class LinkedItemCard extends StatelessWidget {
  const LinkedItemCard({super.key, required this.item, required this.onTap});

  final Item item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final subtitle = itemSubtitle(item);
    return Material(
      color: item.type.background,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            spacing: 12,
            children: [
              Icon(Icons.link_rounded, size: 20, color: item.type.color),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 2,
                  children: [
                    Text(
                      item.english,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                    if (subtitle.isNotEmpty)
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 13, color: AppColors.textMuted),
                      ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
            ],
          ),
        ),
      ),
    );
  }
}

/// Lekerekített, keretes kártya, ami koppintható.
class _CardButton extends StatelessWidget {
  const _CardButton({required this.child, required this.onTap});

  final Widget child;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: SizedBox(width: double.infinity, child: child),
        ),
      ),
    );
  }
}

/// Lábléc: „#feelings · #lesson” balra, „From: lesson, Oct 28” jobbra.
class DetailFooter extends StatelessWidget {
  const DetailFooter({super.key, required this.item, required this.tags});

  final Item item;
  final List<Tag> tags;

  @override
  Widget build(BuildContext context) {
    final date = shortDate(item.createdAt);
    final origin = item.source == null ? 'Added $date' : 'From: ${item.source}, $date';
    return DefaultTextStyle.merge(
      style: const TextStyle(fontSize: 13, color: AppColors.textMuted),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [
          Expanded(child: Text(tags.map((t) => '#${t.name}').join(' · '))),
          Text(origin, textAlign: TextAlign.end),
        ],
      ),
    );
  }
}

/// Többsoros jegyzet megjelenítése: a „•”, „-” vagy „*” kezdetű sorok
/// számozott pontok lesznek (mint a terv „Use it when” listája), a többi bekezdés.
class NotesText extends StatelessWidget {
  const NotesText(this.notes, {super.key, this.accent = AppColors.rule});

  final String notes;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final lines = notes.split('\n').map((l) => l.trim()).where((l) => l.isNotEmpty);
    var number = 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 8,
      children: [
        for (final line in lines)
          if (RegExp(r'^[•\-*]\s*').hasMatch(line))
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                Text(
                  '${++number}',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: accent),
                ),
                Expanded(
                  child: Text(
                    line.replaceFirst(RegExp(r'^[•\-*]\s*'), ''),
                    style: const TextStyle(fontSize: 15, height: 1.45),
                  ),
                ),
              ],
            )
          else
            Text(line, style: const TextStyle(fontSize: 15, height: 1.45)),
      ],
    );
  }
}
