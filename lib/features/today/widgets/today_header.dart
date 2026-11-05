import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/format.dart';
import '../../../app/theme.dart';
import '../../../data/providers.dart';
import '../../../widgets/stat_pill.dart';

/// Avatar (→ Settings), köszönés, streak és összes XP.
class TodayHeader extends ConsumerWidget {
  const TodayHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = ref.watch(settingsProvider).value?.username.trim() ?? '';
    final streak = ref.watch(streakProvider);
    final totalXp = ref.watch(totalXpProvider).value ?? 0;

    return Row(
      spacing: 12,
      children: [
        Tooltip(
          message: 'Settings',
          child: Material(
            color: AppColors.accent,
            borderRadius: BorderRadius.circular(14),
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () => context.push('/settings'),
              child: SizedBox.square(
                dimension: 44,
                child: Center(
                  child: name.isEmpty
                      ? const Icon(Icons.person_rounded, color: AppColors.onAccent)
                      : Text(
                          name.characters.first.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: AppColors.onAccent,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 2,
            children: [
              Text(
                greeting(DateTime.now()),
                style: const TextStyle(fontSize: 13, color: AppColors.textMuted),
              ),
              Text(
                name.isEmpty ? 'Welcome!' : name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
        StatPill(
          icon: Icons.local_fire_department_rounded,
          value: '${streak.current}',
          tooltip: streak.activeToday
              ? '${streak.current}-day streak'
              : 'Learn something today to keep your streak',
          color: AppColors.streak,
          background: AppColors.streakBg,
          // Ha ma még nem tanultál, a láng halványabb – emlékeztetőnek.
          dimmed: !streak.activeToday,
        ),
        if (ref.watch(gameModeProvider))
          StatPill(
            icon: Icons.bolt_rounded,
            value: thousands(totalXp),
            tooltip: 'Total XP',
            color: AppColors.accent,
            background: AppColors.accentBg,
          ),
      ],
    );
  }
}
