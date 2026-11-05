import 'package:flutter/material.dart';

/// Kerek „pirula” ikonnal és számmal – streak, XP.
class StatPill extends StatelessWidget {
  const StatPill({
    super.key,
    required this.icon,
    required this.value,
    required this.tooltip,
    required this.color,
    required this.background,
    this.dimmed = false,
  });

  final IconData icon;
  final String value;
  final String tooltip;
  final Color color;
  final Color background;
  final bool dimmed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(999)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 6,
          children: [
            Icon(icon, size: 18, color: dimmed ? color.withValues(alpha: 0.45) : color),
            Text(
              value,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: color),
            ),
          ],
        ),
      ),
    );
  }
}
