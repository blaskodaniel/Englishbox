import 'package:flutter/material.dart';

import '../../../app/format.dart';
import '../../../app/theme.dart';
import '../../../domain/badges.dart';
import '../../today/widgets/level_card.dart';

/// Kitűzőnként ikon és színpár (szín, háttér).
(IconData, Color, Color) _style(BadgeKind kind) => switch (kind) {
  BadgeKind.words => (Icons.auto_stories_outlined, AppColors.word, AppColors.wordBg),
  BadgeKind.phrases => (Icons.chat_bubble_outline_rounded, AppColors.phrase, AppColors.phraseBg),
  BadgeKind.rules => (Icons.account_tree_outlined, AppColors.rule, AppColors.ruleBg),
  BadgeKind.sentences => (Icons.notes_rounded, AppColors.sentence, AppColors.sentenceBg),
  BadgeKind.streak => (Icons.local_fire_department_rounded, AppColors.streak, AppColors.streakBg),
  BadgeKind.review => (Icons.style_outlined, AppColors.word, AppColors.wordBg),
  BadgeKind.mastered => (Icons.workspace_premium_outlined, AppColors.accent, AppColors.accentBg),
  BadgeKind.level => (Icons.military_tech_outlined, AppColors.phrase, AppColors.phraseBg),
};

/// „Badges · 4 / 12” – 4 oszlopos rács, a megszerzettek elöl.
class BadgesGrid extends StatelessWidget {
  const BadgesGrid({super.key, required this.badges});

  final List<BadgeProgress> badges;

  @override
  Widget build(BuildContext context) {
    final earned = badges.where((b) => b.earned).length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 10,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text('Badges', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            ),
            Text(
              '$earned / ${badges.length}',
              style: const TextStyle(fontSize: 13, color: AppColors.textMuted),
            ),
          ],
        ),
        GridView.count(
          crossAxisCount: 4,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 14,
          crossAxisSpacing: 10,
          childAspectRatio: 0.72,
          children: [
            for (final b in badges) _BadgeTile(progress: b, onTap: () => _showDetails(context, b)),
          ],
        ),
      ],
    );
  }

  void _showDetails(BuildContext context, BadgeProgress b) {
    final (icon, color, background) = _style(b.badge.kind);
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 12,
            children: [
              _Medal(
                icon: b.earned ? icon : Icons.lock_outline_rounded,
                color: b.earned ? color : AppColors.textMuted,
                background: b.earned ? background : AppColors.surfaceAlt,
                size: 80,
              ),
              Text(
                b.badge.title,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
              ),
              Text(
                b.badge.description,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15, color: AppColors.textSoft),
              ),
              const SizedBox(height: 4),
              if (b.earned)
                const Text(
                  'Unlocked!',
                  style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.accent),
                )
              else ...[
                ProgressBar(value: b.fraction, height: 10),
                Text(
                  '${thousands(b.current)} / ${thousands(b.badge.target)}',
                  style: const TextStyle(fontSize: 13, color: AppColors.textMuted),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _BadgeTile extends StatelessWidget {
  const _BadgeTile({required this.progress, required this.onTap});

  final BadgeProgress progress;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final (icon, color, background) = _style(progress.badge.kind);
    final earned = progress.earned;
    return Semantics(
      button: true,
      label: '${progress.badge.title}, ${earned ? 'unlocked' : 'locked'}',
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          spacing: 6,
          children: [
            Opacity(
              opacity: earned ? 1 : 0.55,
              child: _Medal(
                icon: earned ? icon : Icons.lock_outline_rounded,
                color: earned ? color : AppColors.textMuted,
                background: earned ? background : AppColors.surfaceAlt,
                size: 60,
              ),
            ),
            Text(
              progress.badge.title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                height: 1.2,
                color: earned ? AppColors.textSoft : AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Medal extends StatelessWidget {
  const _Medal({
    required this.icon,
    required this.color,
    required this.background,
    required this.size,
  });

  final IconData icon;
  final Color color;
  final Color background;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(size / 3),
        boxShadow: [
          BoxShadow(color: Color.lerp(background, Colors.black, 0.45)!, offset: const Offset(0, 4)),
        ],
      ),
      child: Icon(icon, size: size * 0.43, color: color),
    );
  }
}
