import 'package:flutter/material.dart';

import '../../../app/labels.dart';
import '../../../app/theme.dart';
import '../../../widgets/chunky_button.dart';
import '../review_session.dart';

/// „Session complete!” – XP, pontosság, streak, kik léptek szintet.
class SessionDone extends StatelessWidget {
  const SessionDone({
    super.key,
    required this.session,
    required this.streak,
    required this.remaining,
    required this.onContinue,
    required this.onMore,
    this.showXp = true,
  });

  /// Játék mód nélkül az XP-csempe nem látszik.
  final bool showXp;

  final ReviewSession session;
  final int streak;

  /// Ennyi esedékes elem maradt még ebben a módban.
  final int remaining;
  final VoidCallback onContinue;
  final VoidCallback onMore;

  @override
  Widget build(BuildContext context) {
    final count = session.reviewedCount;
    final minutes = (session.elapsed.inSeconds / 60).round().clamp(1, 999);
    final movedUp = session.movedUp;
    final forgotten = session.forgottenCount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 40, 20, 16),
            child: Column(
              spacing: 20,
              children: [
                Container(
                  width: 112,
                  height: 112,
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(36),
                    boxShadow: const [
                      BoxShadow(color: AppColors.accentShadow, offset: Offset(0, 8)),
                    ],
                  ),
                  child: const Icon(
                    Icons.emoji_events_outlined,
                    size: 56,
                    color: AppColors.onAccent,
                  ),
                ),
                Column(
                  spacing: 6,
                  children: [
                    const Text(
                      'Session complete!',
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
                    ),
                    Text(
                      '${count == 1 ? '1 item' : '$count items'} reviewed in $minutes min',
                      style: const TextStyle(fontSize: 15, color: AppColors.textMuted),
                    ),
                  ],
                ),
                Row(
                  spacing: 10,
                  children: [
                    if (showXp)
                      _Stat(
                        value: '+${session.xp}',
                        label: 'XP',
                        color: AppColors.accent,
                        background: AppColors.accentBg,
                      ),
                    _Stat(
                      value: '${(session.accuracy * 100).round()}%',
                      label: 'accuracy',
                      color: AppColors.word,
                      background: AppColors.wordBg,
                    ),
                    _Stat(
                      value: '$streak',
                      label: 'day streak',
                      color: AppColors.streak,
                      background: AppColors.streakBg,
                    ),
                  ],
                ),
                if (movedUp.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: 10,
                    children: [
                      const Text(
                        'Moved up',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                      for (final result in movedUp.take(6)) _MovedUpRow(result: result),
                    ],
                  ),
                if (forgotten > 0)
                  Text(
                    forgotten == 1
                        ? '1 tricky item will come back soon'
                        : '$forgotten tricky items will come back soon',
                    style: const TextStyle(fontSize: 13, color: AppColors.textMuted),
                  ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 10,
            children: [
              ChunkyButton(label: 'Continue', onPressed: onContinue),
              if (remaining > 0)
                OutlinedButton(
                  onPressed: onMore,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.text,
                    minimumSize: const Size.fromHeight(48),
                    side: const BorderSide(color: AppColors.borderStrong, width: 2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    textStyle: const TextStyle(
                      fontFamily: 'Lexend',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  child: Text('Review $remaining more'),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({
    required this.value,
    required this.label,
    required this.color,
    required this.background,
  });

  final String value;
  final String label;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
        decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(18)),
        child: Column(
          spacing: 4,
          children: [
            Text(
              value,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: color),
            ),
            Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSoft)),
          ],
        ),
      ),
    );
  }
}

class _MovedUpRow extends StatelessWidget {
  const _MovedUpRow({required this.result});

  final ItemResult result;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        spacing: 12,
        children: [
          Container(
            width: 6,
            height: 32,
            decoration: BoxDecoration(
              color: result.item.type.color,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          Expanded(
            child: Text(
              result.item.english,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
            ),
          ),
          Text(
            '${result.firstMastery.label} →',
            style: const TextStyle(fontSize: 13, color: AppColors.textMuted),
          ),
          Text(
            result.lastMastery.label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.accent,
            ),
          ),
        ],
      ),
    );
  }
}
