import 'package:flutter/material.dart';

import '../app/theme.dart';
import '../domain/mastery.dart';

/// 4 sávos tudásszint-jelző. [vertical]: keskeny álló sávok (lista),
/// egyébként széles fekvő sávok (elemrészlet).
class MasteryBars extends StatelessWidget {
  const MasteryBars({
    super.key,
    required this.mastery,
    this.vertical = true,
    this.emptyColor = AppColors.borderStrong,
  });

  final Mastery mastery;
  final bool vertical;
  final Color emptyColor;

  @override
  Widget build(BuildContext context) {
    Widget bar(int index) {
      final color = index < mastery.bars ? AppColors.accent : emptyColor;
      return vertical
          ? Container(
              width: 6,
              height: 18,
              decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3)),
            )
          : Expanded(
              child: Container(
                height: 8,
                decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
              ),
            );
    }

    return Semantics(
      label: 'Mastery ${mastery.bars} of 4, ${mastery.label}',
      excludeSemantics: true,
      child: Row(
        mainAxisSize: vertical ? MainAxisSize.min : MainAxisSize.max,
        spacing: vertical ? 3 : 4,
        children: [for (var i = 0; i < 4; i++) bar(i)],
      ),
    );
  }
}
