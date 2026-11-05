import 'package:flutter/material.dart';

import '../app/theme.dart';

/// Egymás melletti szegmensek, egy választható – mint egy `<select>` gombokként.
class SegmentedPicker<T> extends StatelessWidget {
  const SegmentedPicker({
    super.key,
    required this.options,
    required this.value,
    required this.onChanged,
  });

  /// (érték, felirat) párok.
  final List<(T, String)> options;
  final T value;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.input,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderStrong, width: 2),
      ),
      child: Row(
        children: [
          for (final (option, label) in options)
            Expanded(
              child: Semantics(
                button: true,
                selected: option == value,
                child: GestureDetector(
                  onTap: () => onChanged(option),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 120),
                    height: 36,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: option == value ? AppColors.borderStrong : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: option == value ? FontWeight.w700 : FontWeight.w500,
                        color: option == value ? AppColors.text : AppColors.textSoft,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
