import 'package:flutter/material.dart';

import '../../../app/labels.dart';
import '../../../app/theme.dart';
import '../../../data/models.dart';
import '../../../domain/enums.dart';
import '../../../widgets/mastery_bars.dart';

/// A szó/kifejezés/mondat színes fejkártyája: fajta, szint, nagy cím,
/// kiejtés gomb, magyar jelentés és tudásszint.
class ItemHero extends StatelessWidget {
  const ItemHero({super.key, required this.detail, required this.onSpeak});

  final ItemDetail detail;
  final VoidCallback onSpeak;

  @override
  Widget build(BuildContext context) {
    final item = detail.item;
    final type = item.type;
    final isSentence = type == ItemType.sentence;
    final darkOnType = Color.lerp(type.color, Colors.black, 0.85)!;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: type.background,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 12,
        children: [
          Row(
            spacing: 6,
            children: [
              _Badge(
                text: itemKindLabel(item).toUpperCase(),
                background: type.color,
                foreground: darkOnType,
              ),
              if (item.level != null)
                _Badge(text: item.level!.label, borderColor: type.color),
            ],
          ),
          Row(
            spacing: 12,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4,
                  children: [
                    Text(
                      item.english,
                      style: TextStyle(
                        fontSize: isSentence ? 22 : 36,
                        fontWeight: isSentence ? FontWeight.w700 : FontWeight.w800,
                        height: isSentence ? 1.35 : 1.1,
                      ),
                    ),
                    if (item.ipa != null)
                      Text(
                        item.ipa!,
                        style: const TextStyle(fontSize: 15, color: AppColors.textSoft),
                      ),
                  ],
                ),
              ),
              _SpeakButton(color: type.color, foreground: darkOnType, onPressed: onSpeak),
            ],
          ),
          if (item.hungarian.isNotEmpty)
            Text(
              item.hungarian,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
            ),
          Row(
            spacing: 10,
            children: [
              Expanded(
                child: MasteryBars(
                  mastery: detail.mastery,
                  vertical: false,
                  emptyColor: Color.lerp(type.background, Colors.white, 0.12)!,
                ),
              ),
              Text(
                detail.mastery.label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.accent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({
    required this.text,
    this.background,
    this.foreground = AppColors.text,
    this.borderColor,
  });

  final String text;
  final Color? background;
  final Color foreground;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(8),
        border: borderColor == null ? null : Border.all(color: borderColor!, width: 1.5),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.6,
          color: foreground,
        ),
      ),
    );
  }
}

class _SpeakButton extends StatelessWidget {
  const _SpeakButton({required this.color, required this.foreground, required this.onPressed});

  final Color color;
  final Color foreground;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Play pronunciation',
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(color: Color.lerp(color, Colors.black, 0.4)!, offset: const Offset(0, 4)),
            ],
          ),
          child: Icon(Icons.volume_up_rounded, size: 26, color: foreground),
        ),
      ),
    );
  }
}
