import 'package:flutter/material.dart';

import '../../../app/theme.dart';
import '../../../domain/srs.dart';

/// Egy önértékelő gomb felirata, pl. „Hard” / „in 2 days”.
class GradeOption {
  const GradeOption(this.grade, this.label, [this.sublabel]);

  final ReviewGrade grade;
  final String label;
  final String? sublabel;
}

/// Három egymás melletti „3D” gomb: piros (Forgot), narancs (Hard), lime (Knew it).
class GradeButtons extends StatelessWidget {
  const GradeButtons({super.key, required this.options, required this.onGrade});

  final List<GradeOption> options;
  final ValueChanged<ReviewGrade> onGrade;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10,
      children: [
        for (final option in options)
          Expanded(
            child: _GradeButton(option: option, onPressed: () => onGrade(option.grade)),
          ),
      ],
    );
  }
}

class _GradeButton extends StatefulWidget {
  const _GradeButton({required this.option, required this.onPressed});

  final GradeOption option;
  final VoidCallback onPressed;

  @override
  State<_GradeButton> createState() => _GradeButtonState();
}

class _GradeButtonState extends State<_GradeButton> {
  static const _depth = 4.0;
  bool _pressed = false;

  // (háttér, felirat, árnyék, alcím)
  (Color, Color, Color, Color) get _colors => switch (widget.option.grade) {
    ReviewGrade.forgot => (
      AppColors.wrongBg,
      AppColors.wrong,
      const Color(0xFF1C0D0B),
      AppColors.wrongText,
    ),
    ReviewGrade.hard => (
      AppColors.ruleBg,
      AppColors.streak,
      const Color(0xFF120C06),
      const Color(0xFFE2D6C4),
    ),
    ReviewGrade.good => (
      AppColors.accent,
      AppColors.onAccent,
      AppColors.accentShadow,
      AppColors.onAccent,
    ),
  };

  @override
  Widget build(BuildContext context) {
    final (background, foreground, shadow, sub) = _colors;
    final sink = _pressed ? _depth : 0.0;
    final height = widget.option.sublabel == null ? 56.0 : 64.0;

    return Semantics(
      button: true,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        onTap: widget.onPressed,
        child: SizedBox(
          height: height + _depth,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 80),
            margin: EdgeInsets.only(top: sink, bottom: _depth - sink),
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [BoxShadow(color: shadow, offset: Offset(0, _depth - sink))],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 2,
              children: [
                Text(
                  widget.option.label,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: foreground),
                ),
                if (widget.option.sublabel != null)
                  Text(
                    widget.option.sublabel!,
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: sub),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
