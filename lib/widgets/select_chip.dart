import 'package:flutter/material.dart';

import '../app/theme.dart';

/// Kiválasztható chip (szófaj, kifejezésfajta…). Kiválasztva a megadott színnel keretezett.
class SelectChip extends StatelessWidget {
  const SelectChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.color = AppColors.accent,
    this.selectedBackground = AppColors.accentBg,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color color;
  final Color selectedBackground;

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadii.chip),
      side: BorderSide(color: selected ? color : AppColors.borderStrong, width: 2),
    );
    return Semantics(
      selected: selected,
      button: true,
      child: Material(
        color: selected ? selectedBackground : Colors.transparent,
        shape: shape,
        child: InkWell(
          customBorder: shape,
          onTap: onTap,
          child: Container(
            height: 36,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            alignment: Alignment.center,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                color: selected ? color : AppColors.textSoft,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
