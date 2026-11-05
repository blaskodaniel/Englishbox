import 'package:flutter/material.dart';

import '../../../app/theme.dart';
import '../../../domain/enums.dart';
import '../../../domain/quests.dart';
import 'level_card.dart';

/// Egy napi küldetés: ikon, cím, haladás és jutalom (vagy „Claim” gomb).
class QuestCard extends StatelessWidget {
  const QuestCard({super.key, required this.quest, required this.onTap, required this.onClaim});

  final QuestProgress quest;
  final VoidCallback onTap;
  final VoidCallback onClaim;

  (IconData, Color, Color) get _style => switch (quest.quest) {
    Quest.addItems => (Icons.add_rounded, AppColors.word, AppColors.wordBg),
    Quest.reviewItems => (Icons.style_rounded, AppColors.rule, AppColors.ruleBg),
    Quest.ownExample => (Icons.edit_note_rounded, AppColors.sentence, AppColors.sentenceBg),
  };

  @override
  Widget build(BuildContext context) {
    final (icon, color, background) = _style;
    final done = quest.claimed;

    return Opacity(
      opacity: quest.isAvailable ? 1 : 0.55,
      child: Material(
        color: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.card),
          side: BorderSide(color: quest.canClaim ? AppColors.accent : AppColors.border),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              spacing: 14,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: background,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(done ? Icons.check_rounded : icon, color: color, size: 22),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: 8,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              quest.title,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: done ? AppColors.textMuted : AppColors.text,
                                decoration: done ? TextDecoration.lineThrough : null,
                                decorationColor: AppColors.textMuted,
                              ),
                            ),
                          ),
                          if (quest.isAvailable)
                            Text(
                              '${quest.progress}/${quest.target}',
                              style: const TextStyle(fontSize: 14, color: AppColors.textMuted),
                            ),
                        ],
                      ),
                      // Kevés lépésnél szegmensek (mint a tervben az 5-ös), soknál sáv.
                      if (quest.target > 0 && quest.target <= 6)
                        _Segments(filled: quest.progress, total: quest.target, color: color)
                      else
                        ProgressBar(value: quest.fraction, color: color),
                    ],
                  ),
                ),
                _RewardBadge(quest: quest, onClaim: onClaim),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Segments extends StatelessWidget {
  const _Segments({required this.filled, required this.total, required this.color});

  final int filled;
  final int total;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 4,
      children: [
        for (var i = 0; i < total; i++)
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: 8,
              decoration: BoxDecoration(
                color: i < filled ? color : AppColors.border,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
      ],
    );
  }
}

class _RewardBadge extends StatelessWidget {
  const _RewardBadge({required this.quest, required this.onClaim});

  final QuestProgress quest;
  final VoidCallback onClaim;

  @override
  Widget build(BuildContext context) {
    if (quest.claimed) {
      return const Text(
        'Done',
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textMuted),
      );
    }

    if (quest.canClaim) {
      return FilledButton(
        onPressed: onClaim,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: AppColors.onAccent,
          minimumSize: const Size(0, 34),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          textStyle: const TextStyle(
            fontFamily: 'Lexend',
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
        child: Text('Claim +${quest.reward}'),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: AppColors.accentBg, borderRadius: BorderRadius.circular(8)),
      child: Text(
        '+${quest.reward} XP',
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.accent),
      ),
    );
  }
}
