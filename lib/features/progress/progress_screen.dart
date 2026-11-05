import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/format.dart';
import '../../app/theme.dart';
import '../../data/providers.dart';
import '../../domain/days.dart';
import '../../domain/levels.dart';
import '../../domain/mastery.dart';
import '../../widgets/screen_header.dart';
import '../today/widgets/level_card.dart';
import 'widgets/activity_heatmap.dart';
import 'widgets/badges_grid.dart';
import 'widgets/mastery_card.dart';
import 'widgets/week_chart.dart';

/// A Progress fül: szint, streak, heti grafikon, tudásszintek, aktivitás, kitűzők.
class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(progressStatsProvider).value;
    final streak = ref.watch(streakProvider);
    final level = ref.watch(levelProvider);
    final badges = ref.watch(badgesProvider);
    final gameMode = ref.watch(gameModeProvider);
    final today = ref.watch(currentDayProvider);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Progress',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
                  ),
                ),
                SquareIconButton(
                  icon: Icons.settings_outlined,
                  tooltip: 'Settings',
                  onPressed: () => context.push('/settings'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (stats == null)
              const SizedBox(height: 300, child: Center(child: CircularProgressIndicator()))
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 16,
                children: [
                  if (gameMode) _LevelHero(level: level),
                  Row(
                    spacing: 10,
                    children: [
                      _StatTile(
                        icon: Icons.local_fire_department_rounded,
                        value: streak.current,
                        label: 'day streak',
                        color: AppColors.streak,
                        background: AppColors.streakBg,
                        labelColor: const Color(0xFFE2D6C4),
                      ),
                      _StatTile(
                        icon: Icons.emoji_events_outlined,
                        value: streak.best,
                        label: 'best streak',
                        color: AppColors.textSoft,
                        background: AppColors.surfaceAlt,
                        labelColor: AppColors.textMuted,
                      ),
                      _StatTile(
                        icon: Icons.check_rounded,
                        value: stats.mastery[Mastery.mastered] ?? 0,
                        label: 'mastered',
                        color: AppColors.accent,
                        background: AppColors.accentBg,
                        labelColor: const Color(0xFFD2E5B8),
                      ),
                    ],
                  ),
                  WeekChart(addedPerDay: stats.addedPerDay, today: today),
                  MasteryCard(counts: stats.mastery),
                  ActivityHeatmap(xpPerDay: stats.xpPerDay, today: startOfDay(today)),
                  if (gameMode && badges != null) BadgesGrid(badges: badges),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

/// Nagy „LVL 7” kocka + cím + sáv.
class _LevelHero extends StatelessWidget {
  const _LevelHero({required this.level});

  final LevelInfo level;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.panel),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        spacing: 16,
        children: [
          Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(24),
              boxShadow: const [BoxShadow(color: AppColors.accentShadow, offset: Offset(0, 5))],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'LVL',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                    color: AppColors.onAccent,
                  ),
                ),
                Text(
                  '${level.level}',
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    height: 1,
                    color: AppColors.onAccent,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 8,
              children: [
                Text(
                  level.title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                ProgressBar(value: level.progress, height: 10),
                Text(
                  '${thousands(level.xpInLevel)} / ${thousands(level.xpForNext)} XP',
                  style: const TextStyle(fontSize: 13, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
    required this.background,
    required this.labelColor,
  });

  final IconData icon;
  final int value;
  final String label;
  final Color color;
  final Color background;
  final Color labelColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(18)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 4,
          children: [
            Icon(icon, size: 20, color: color),
            Text(
              thousands(value),
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
            ),
            Text(label, style: TextStyle(fontSize: 12, color: labelColor)),
          ],
        ),
      ),
    );
  }
}
