import 'package:flutter/material.dart';

import '../../../app/format.dart';
import '../../../app/labels.dart';
import '../../../app/theme.dart';
import '../../../data/repositories/activity_repository.dart';
import '../../../domain/enums.dart';

/// „Your box”: elemszám típusonként + mastered + címkék, 3 oszlopban.
class BoxGrid extends StatelessWidget {
  const BoxGrid({
    super.key,
    required this.stats,
    required this.onType,
    required this.onMastered,
    required this.onTags,
  });

  final BoxStats stats;
  final ValueChanged<ItemType> onType;
  final VoidCallback onMastered;
  final VoidCallback onTags;

  static const _typeTitles = {
    ItemType.word: 'Words',
    ItemType.phrase: 'Phrases',
    ItemType.rule: 'Grammar',
    ItemType.sentence: 'Sentences',
  };

  @override
  Widget build(BuildContext context) {
    final tiles = [
      for (final type in ItemType.values)
        _Tile(
          value: stats.count(type),
          label: _typeTitles[type]!,
          color: type.color,
          background: type.background,
          onTap: () => onType(type),
        ),
      _Tile(
        value: stats.mastered,
        label: 'Mastered',
        color: AppColors.accent,
        background: AppColors.accentBg,
        onTap: onMastered,
      ),
      _Tile(
        value: stats.tags,
        label: 'Tags',
        color: AppColors.text,
        background: AppColors.surfaceAlt,
        labelColor: AppColors.textMuted,
        onTap: onTags,
      ),
    ];

    // 3 oszlopos rács – mint `grid-template-columns: repeat(3, 1fr)`.
    return Column(
      spacing: 10,
      children: [
        for (var row = 0; row < tiles.length; row += 3)
          Row(
            spacing: 10,
            children: [for (final tile in tiles.skip(row).take(3)) Expanded(child: tile)],
          ),
      ],
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({
    required this.value,
    required this.label,
    required this.color,
    required this.background,
    required this.onTap,
    this.labelColor = AppColors.textSoft,
  });

  final int value;
  final String label;
  final Color color;
  final Color background;
  final Color labelColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 4,
            children: [
              Text(
                thousands(value),
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: color),
              ),
              Text(label, style: TextStyle(fontSize: 13, color: labelColor)),
            ],
          ),
        ),
      ),
    );
  }
}
