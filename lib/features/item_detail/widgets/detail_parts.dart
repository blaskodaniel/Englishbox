import 'package:flutter/material.dart';

import '../../../app/format.dart';
import '../../../app/labels.dart';
import '../../../app/theme.dart';
import '../../../data/db.dart';
import '../../../domain/note_markup.dart';
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

/// Többsoros jegyzet megjelenítése a formázással együtt (`**félkövér**`,
/// `_dőlt_`, `==kiemelt==`). A „•”, „-” vagy „*” kezdetű sorok felsorolás-
/// pontok: [numbered] esetén számozva (mint a terv „Use it when” listája),
/// különben színes „•” jellel. A többi sor bekezdés.
class NotesText extends StatelessWidget {
  const NotesText(this.notes, {super.key, this.accent = AppColors.rule, this.numbered = true});

  final String notes;
  final Color accent;
  final bool numbered;

  static const _style = TextStyle(fontSize: 15, height: 1.45);

  @override
  Widget build(BuildContext context) {
    final lines = notes.split('\n').map((l) => l.trim()).where((l) => l.isNotEmpty);
    var number = 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 8,
      children: [
        for (final line in lines)
          if (bulletPattern.hasMatch(line))
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                Text(
                  numbered ? '${++number}' : '•',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: accent),
                ),
                Expanded(child: _rich(line.replaceFirst(bulletPattern, ''))),
              ],
            )
          else
            _rich(line),
      ],
    );
  }

  /// Egy sor formázott darabokból – mint több egymás melletti `<span>`.
  Widget _rich(String line) => Text.rich(
    TextSpan(
      children: [
        for (final span in parseNoteInline(line))
          TextSpan(
            text: span.text,
            style: TextStyle(
              fontWeight: span.styles.contains(NoteStyle.bold) ? FontWeight.w700 : null,
              fontStyle: span.styles.contains(NoteStyle.italic) ? FontStyle.italic : null,
              color: span.styles.contains(NoteStyle.highlight) ? accent : null,
              backgroundColor: span.styles.contains(NoteStyle.highlight)
                  ? accent.withValues(alpha: 0.16)
                  : null,
            ),
          ),
      ],
    ),
    style: _style,
  );
}
