import 'package:flutter/material.dart';

import '../app/theme.dart';
import '../domain/enums.dart';
import 'field_label.dart';

/// A1–C2 választó. A kiválasztott szintre újra koppintva törli a választást.
class LevelPicker extends StatelessWidget {
  const LevelPicker({
    super.key,
    required this.value,
    required this.onChanged,
    this.label = 'English level',
  });

  final CefrLevel? value;
  final ValueChanged<CefrLevel?> onChanged;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 6,
      children: [
        Row(
          children: [
            Expanded(child: FieldLabel(label)),
            if (value != null)
              Text(
                '${value!.label} · ${value!.title}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.accent,
                ),
              ),
          ],
        ),
        Row(
          spacing: 6,
          children: [
            for (final level in CefrLevel.values)
              Expanded(
                child: _LevelButton(
                  level: level,
                  selected: level == value,
                  onTap: () => onChanged(level == value ? null : level),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _LevelButton extends StatelessWidget {
  const _LevelButton({required this.level, required this.selected, required this.onTap});

  final CefrLevel level;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      selected: selected,
      button: true,
      label: '${level.label} ${level.title}',
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? AppColors.accent : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? AppColors.accent : AppColors.borderStrong,
              width: 2,
            ),
            boxShadow: [
              if (selected) const BoxShadow(color: AppColors.accentShadow, offset: Offset(0, 3)),
            ],
          ),
          child: Text(
            level.label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: selected ? AppColors.onAccent : AppColors.textSoft,
            ),
          ),
        ),
      ),
    );
  }
}
