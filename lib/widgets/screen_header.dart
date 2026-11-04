import 'package:flutter/material.dart';

import '../app/theme.dart';

/// Teljes képernyős oldalak fejléce: bal oldalon négyzetes gomb (bezárás/vissza),
/// középen cím, jobbra opcionális műveletek.
class ScreenHeader extends StatelessWidget {
  const ScreenHeader({
    super.key,
    required this.title,
    required this.onLeading,
    this.leadingIcon = Icons.close_rounded,
    this.leadingLabel = 'Close',
    this.trailing,
  });

  final String title;
  final VoidCallback onLeading;
  final IconData leadingIcon;
  final String leadingLabel;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      child: Row(
        children: [
          SquareIconButton(icon: leadingIcon, tooltip: leadingLabel, onPressed: onLeading),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
          ),
          trailing ?? const SizedBox(width: 44),
        ],
      ),
    );
  }
}

/// 44×44-es lekerekített ikon gomb sötét háttérrel.
class SquareIconButton extends StatelessWidget {
  const SquareIconButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.color = AppColors.text,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 44,
      child: IconButton(
        tooltip: tooltip,
        onPressed: onPressed,
        icon: Icon(icon, size: 22, color: color),
        style: IconButton.styleFrom(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }
}
