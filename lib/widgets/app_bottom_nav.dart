import 'package:flutter/material.dart';

import '../app/theme.dart';

/// Alsó navigációs sáv a terv szerint: 4 fül + kiemelt középső „+” gomb.
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
    required this.onAdd,
  });

  final int currentIndex;
  final ValueChanged<int> onTabSelected;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Container(
      height: 84 + bottomInset,
      padding: EdgeInsets.fromLTRB(12, 8, 12, 16 + bottomInset),
      decoration: const BoxDecoration(
        color: AppColors.navBar,
        border: Border(top: BorderSide(color: AppColors.navBorder)),
      ),
      child: Row(
        children: [
          _NavTab(
            icon: Icons.home_rounded,
            label: 'Today',
            selected: currentIndex == 0,
            onTap: () => onTabSelected(0),
          ),
          _NavTab(
            icon: Icons.auto_stories_rounded,
            label: 'Library',
            selected: currentIndex == 1,
            onTap: () => onTabSelected(1),
          ),
          Expanded(
            child: Center(child: _AddButton(onPressed: onAdd)),
          ),
          _NavTab(
            icon: Icons.style_rounded,
            label: 'Review',
            selected: currentIndex == 2,
            onTap: () => onTabSelected(2),
          ),
          _NavTab(
            icon: Icons.emoji_events_rounded,
            label: 'Progress',
            selected: currentIndex == 3,
            onTap: () => onTabSelected(3),
          ),
        ],
      ),
    );
  }
}

class _NavTab extends StatelessWidget {
  const _NavTab({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.accent : AppColors.textMuted;
    return Expanded(
      child: Semantics(
        selected: selected,
        button: true,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadii.button),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 24, color: color),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  const _AddButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, -14),
      child: Semantics(
        button: true,
        label: 'Add item',
        child: GestureDetector(
          onTap: onPressed,
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [BoxShadow(color: AppColors.accentShadow, offset: Offset(0, 4))],
            ),
            child: const Icon(Icons.add_rounded, size: 30, color: AppColors.onAccent),
          ),
        ),
      ),
    );
  }
}
