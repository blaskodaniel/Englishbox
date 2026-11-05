import 'package:flutter/material.dart';

import '../../../app/theme.dart';
import '../../../domain/mastery.dart';
import 'progress_card.dart';

/// Sorrendi (szekvenciális) skála: egy szín, sötéttől világosig – minél jobban
/// tudod, annál élénkebb lime. A „New” semleges szürke.
const masteryColors = {
  Mastery.newItem: Color(0xFF3A4256),
  Mastery.learning: Color(0xFF58713A),
  Mastery.gettingThere: Color(0xFF80A747),
  Mastery.familiar: Color(0xFF98C84F),
  Mastery.mastered: AppColors.accent,
};

/// Hány elem van az egyes tudásszinteken: egy szakaszolt sáv + jelmagyarázat.
class MasteryCard extends StatelessWidget {
  const MasteryCard({super.key, required this.counts});

  final Map<Mastery, int> counts;

  @override
  Widget build(BuildContext context) {
    final total = counts.values.fold(0, (a, b) => a + b);
    final present = [
      for (final m in Mastery.values)
        if ((counts[m] ?? 0) > 0) m,
    ];

    return ProgressCard(
      title: 'Mastery',
      trailing: total == 1 ? '1 item' : '$total items',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 14,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: SizedBox(
              height: 14,
              child: total == 0
                  ? const ColoredBox(color: AppColors.border)
                  // A szakaszok között 2 px rés, hogy a szomszédos színek elváljanak.
                  : Row(
                      spacing: 2,
                      children: [
                        for (final m in present)
                          Expanded(
                            flex: counts[m]!,
                            child: ColoredBox(color: masteryColors[m]!),
                          ),
                      ],
                    ),
            ),
          ),
          // Jelmagyarázat: szín + név + szám – a szín sosem egyedül hordozza a jelentést.
          Wrap(
            spacing: 14,
            runSpacing: 8,
            children: [
              for (final m in Mastery.values)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 6,
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: masteryColors[m],
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    Text(m.label, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                    Text(
                      '${counts[m] ?? 0}',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}
