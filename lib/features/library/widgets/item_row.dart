import 'package:flutter/material.dart';

import '../../../app/labels.dart';
import '../../../app/theme.dart';
import '../../../data/models.dart';
import '../../../domain/enums.dart';
import '../../../domain/mastery.dart';
import '../../../widgets/mastery_bars.dart';

/// Egy elem a Library listában: színes típuscsík, cím, fajta, szint, jelentés, tudásszint.
class ItemRow extends StatelessWidget {
  const ItemRow({super.key, required this.entry, required this.onTap});

  final ItemListEntry entry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final item = entry.item;
    final isSentence = item.type == ItemType.sentence;
    final subtitle = itemSubtitle(item);

    return Material(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: IntrinsicHeight(
            child: Row(
              spacing: 12,
              children: [
                Container(
                  width: 6,
                  decoration: BoxDecoration(
                    color: item.type.color,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 3,
                    children: [
                      if (isSentence)
                        Text(
                          item.english,
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                        )
                      else
                        _TitleLine(entry: entry),
                      if (subtitle.isNotEmpty)
                        Text(
                          subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 14, color: AppColors.textMuted),
                        ),
                    ],
                  ),
                ),
                Center(
                  child: entry.mastery == Mastery.mastered
                      ? const _MasteredPill()
                      : MasteryBars(mastery: entry.mastery),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TitleLine extends StatelessWidget {
  const _TitleLine({required this.entry});

  final ItemListEntry entry;

  @override
  Widget build(BuildContext context) {
    final item = entry.item;
    return Wrap(
      spacing: 8,
      runSpacing: 2,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(item.english, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
        if (item.type != ItemType.rule)
          Text(
            itemKindLabel(item).toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
              color: item.type.color,
            ),
          ),
        if (item.level != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: const Color(0xFF3A4256), width: 1.5),
            ),
            child: Text(
              item.level!.label,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.textSoft,
              ),
            ),
          ),
        if (item.isFavorite) const Icon(Icons.star_rounded, size: 16, color: AppColors.streak),
      ],
    );
  }
}

class _MasteredPill extends StatelessWidget {
  const _MasteredPill();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: AppColors.accentBg, borderRadius: BorderRadius.circular(8)),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 4,
        children: [
          Icon(Icons.check_rounded, size: 14, color: AppColors.accent),
          Text(
            'Mastered',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.accent),
          ),
        ],
      ),
    );
  }
}
