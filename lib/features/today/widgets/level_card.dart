import 'package:flutter/material.dart';

import '../../../app/format.dart';
import '../../../app/theme.dart';
import '../../../domain/levels.dart';

/// Szint, cím és XP-sáv a következő szintig.
class LevelCard extends StatelessWidget {
  const LevelCard({super.key, required this.level});

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 12,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 2,
                  children: [
                    Text(
                      'LEVEL ${level.level}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                        color: AppColors.textMuted,
                      ),
                    ),
                    Text(
                      level.title,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              Text(
                '${thousands(level.xpInLevel)} / ${thousands(level.xpForNext)} XP',
                style: const TextStyle(fontSize: 14, color: AppColors.textMuted),
              ),
            ],
          ),
          ProgressBar(value: level.progress, height: 14),
          Text.rich(
            TextSpan(
              style: const TextStyle(fontSize: 13, color: AppColors.textMuted),
              children: [
                TextSpan(text: '${thousands(level.xpToGo)} XP to '),
                TextSpan(
                  text: level.nextTitle,
                  style: const TextStyle(color: AppColors.text, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Lekerekített, animált haladásjelző sáv.
class ProgressBar extends StatelessWidget {
  const ProgressBar({
    super.key,
    required this.value,
    this.height = 8,
    this.color = AppColors.accent,
  });

  /// 0–1
  final double value;
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: Container(
        height: height,
        color: AppColors.border,
        alignment: Alignment.centerLeft,
        // Mint egy CSS `transition: width` – az érték változásakor csúszik.
        child: TweenAnimationBuilder<double>(
          tween: Tween(end: value.clamp(0, 1)),
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOutCubic,
          builder: (context, fraction, _) => FractionallySizedBox(
            widthFactor: fraction,
            heightFactor: 1,
            child: DecoratedBox(
              decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(999)),
            ),
          ),
        ),
      ),
    );
  }
}
