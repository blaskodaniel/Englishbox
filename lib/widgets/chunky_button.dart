import 'package:flutter/material.dart';

import '../app/theme.dart';

/// A terv „3D” gombja: alatta sötétebb árnyék, megnyomáskor lesüllyed.
class ChunkyButton extends StatefulWidget {
  const ChunkyButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.badge,
    this.icon,
    this.color = AppColors.accent,
    this.shadowColor = AppColors.accentShadow,
    this.foreground = AppColors.onAccent,
    this.height = 56,
  });

  final String label;

  /// `null` → letiltott gomb.
  final VoidCallback? onPressed;

  /// Kis címke a felirat mellett, pl. „+15 XP”.
  final String? badge;
  final IconData? icon;
  final Color color;
  final Color shadowColor;
  final Color foreground;
  final double height;

  @override
  State<ChunkyButton> createState() => _ChunkyButtonState();
}

class _ChunkyButtonState extends State<ChunkyButton> {
  static const _depth = 4.0;
  bool _pressed = false;

  bool get _enabled => widget.onPressed != null;

  void _setPressed(bool value) {
    if (_enabled && _pressed != value) setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final background = _enabled ? widget.color : AppColors.borderStrong;
    final foreground = _enabled ? widget.foreground : AppColors.textMuted;
    final sink = _pressed ? _depth : 0.0;

    return Semantics(
      button: true,
      enabled: _enabled,
      child: GestureDetector(
        onTapDown: (_) => _setPressed(true),
        onTapUp: (_) => _setPressed(false),
        onTapCancel: () => _setPressed(false),
        onTap: widget.onPressed,
        child: SizedBox(
          height: widget.height + _depth,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 80),
            margin: EdgeInsets.only(top: sink, bottom: _depth - sink),
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                if (_enabled)
                  BoxShadow(color: widget.shadowColor, offset: Offset(0, _depth - sink)),
              ],
            ),
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.icon != null) ...[
                  Icon(widget.icon, size: 20, color: foreground),
                  const SizedBox(width: 10),
                ],
                // Keskeny képernyőn / nagy betűmérettel a felirat rövidül, nem lóg ki.
                Flexible(
                  child: Text(
                    widget.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: foreground),
                  ),
                ),
                if (widget.badge != null) ...[
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: _enabled ? widget.foreground : AppColors.surfaceAlt,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      widget.badge!,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: _enabled ? widget.color : AppColors.textMuted,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
