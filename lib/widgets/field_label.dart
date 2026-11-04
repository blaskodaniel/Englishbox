import 'package:flutter/material.dart';

import '../app/theme.dart';

/// Kis szürke mezőfelirat a beviteli mezők fölött.
class FieldLabel extends StatelessWidget {
  const FieldLabel(this.text, {super.key, this.trailing});

  final String text;

  /// Opcionális elem a sor jobb szélén (pl. „+5 XP each”).
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final label = Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.textMuted,
      ),
    );
    if (trailing == null) return label;
    return Row(children: [Expanded(child: label), trailing!]);
  }
}
