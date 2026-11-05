import 'package:flutter/material.dart';

import '../../../app/theme.dart';
import '../../today/widgets/level_card.dart';

/// A kör fejléce: bezárás, haladás, a körben szerzett XP.
class SessionHeader extends StatelessWidget {
  const SessionHeader({super.key, required this.progress, required this.xp, required this.onClose});

  final double progress;

  /// `null` → nem látszik (játék mód kikapcsolva).
  final int? xp;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        spacing: 14,
        children: [
          Tooltip(
            message: 'End session',
            child: Material(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: onClose,
                child: const SizedBox.square(
                  dimension: 44,
                  child: Icon(Icons.close_rounded, size: 22),
                ),
              ),
            ),
          ),
          Expanded(child: ProgressBar(value: progress, height: 14)),
          if (xp != null)
            Row(
              spacing: 4,
              children: [
                const Icon(Icons.bolt_rounded, size: 18, color: AppColors.accent),
                Text(
                  '$xp',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.accent,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

/// A feladat felirata (pl. „WORD CARDS · EN → HU”) és a számláló („2 / 10”).
class TaskLabel extends StatelessWidget {
  const TaskLabel({super.key, required this.label, required this.color, this.trailing});

  final String label;
  final Color color;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
              color: color,
            ),
          ),
        ),
        ?trailing,
      ],
    );
  }
}

/// Kérdés-buborék: „HU” / „EN” jelvény + a mondat.
class PromptBubble extends StatelessWidget {
  const PromptBubble({
    super.key,
    required this.code,
    required this.text,
    required this.color,
    required this.background,
  });

  final String code;
  final String text;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        Container(
          width: 52,
          height: 52,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(16)),
          child: Text(
            code,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: color),
          ),
        ),
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border.all(color: AppColors.border),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Text(
              text,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, height: 1.4),
            ),
          ),
        ),
      ],
    );
  }
}
