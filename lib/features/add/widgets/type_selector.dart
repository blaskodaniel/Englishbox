import 'package:flutter/material.dart';

import '../../../app/labels.dart';
import '../../../app/theme.dart';
import '../../../domain/enums.dart';

/// A négy elemtípus közti váltó az Add képernyő tetején.
class TypeSelector extends StatelessWidget {
  const TypeSelector({super.key, required this.value, required this.onChanged});

  final ItemType value;
  final ValueChanged<ItemType> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 6,
      children: [
        for (final type in ItemType.values)
          Expanded(
            child: _TypeTile(
              type: type,
              selected: type == value,
              onTap: () => onChanged(type),
            ),
          ),
      ],
    );
  }
}

class _TypeTile extends StatelessWidget {
  const _TypeTile({required this.type, required this.selected, required this.onTap});

  final ItemType type;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      selected: selected,
      button: true,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          height: 56,
          decoration: BoxDecoration(
            color: selected ? type.background : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? type.color : AppColors.borderStrong,
              width: 2,
            ),
            boxShadow: [
              if (selected) BoxShadow(color: type.color, offset: const Offset(0, 3)),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 6,
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(color: type.color, shape: BoxShape.circle),
              ),
              Text(
                type.label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: selected ? type.color : AppColors.textSoft,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
