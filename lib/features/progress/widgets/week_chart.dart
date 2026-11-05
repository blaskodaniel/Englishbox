import 'package:flutter/material.dart';

import '../../../app/theme.dart';
import '../../../domain/days.dart';
import 'progress_card.dart';

/// „Items added this week” – oszlopdiagram az elmúlt 7 napról, a mai nap lime.
///
/// Egy oszlopra koppintva fölötte megjelenik a napi szám (mobilon ez a „hover”).
/// Alapból csak a mai nap száma látszik – nem írunk számot minden oszlopra.
class WeekChart extends StatefulWidget {
  const WeekChart({super.key, required this.addedPerDay, required this.today});

  /// [dayNumber] → darab
  final Map<int, int> addedPerDay;
  final DateTime today;

  @override
  State<WeekChart> createState() => _WeekChartState();
}

class _WeekChartState extends State<WeekChart> {
  static const _barArea = 96.0;
  static const _labels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
  static const _weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  /// A kiválasztott oszlop (0–6), alapból a mai (6).
  int _selected = 6;

  @override
  Widget build(BuildContext context) {
    final t = widget.today;
    final days = [for (var i = 6; i >= 0; i--) DateTime(t.year, t.month, t.day - i)];
    final counts = [for (final d in days) widget.addedPerDay[dayNumber(d)] ?? 0];
    final total = counts.fold(0, (a, b) => a + b);
    final max = counts.fold(1, (a, b) => b > a ? b : a);

    return ProgressCard(
      title: 'Items added this week',
      trailing: '$total total',
      child: Semantics(
        label: [for (var i = 0; i < 7; i++) '${_weekdays[days[i].weekday - 1]}: ${counts[i]}']
            .join(', '),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          spacing: 8,
          children: [
            for (var i = 0; i < 7; i++)
              Expanded(
                child: _Bar(
                  count: counts[i],
                  fraction: counts[i] / max,
                  label: _labels[days[i].weekday - 1],
                  isToday: i == 6,
                  showValue: i == _selected,
                  barArea: _barArea,
                  onTap: () => setState(() => _selected = i),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({
    required this.count,
    required this.fraction,
    required this.label,
    required this.isToday,
    required this.showValue,
    required this.barArea,
    required this.onTap,
  });

  final int count;
  final double fraction;
  final String label;
  final bool isToday;
  final bool showValue;
  final double barArea;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // Nulla esetén egy vékony „csonk” jelzi, hogy van adat, csak 0.
    final height = count == 0 ? 4.0 : (barArea * fraction).clamp(8.0, barArea);
    return GestureDetector(
      behavior: HitTestBehavior.opaque, // az egész oszlop-sáv koppintható
      onTap: onTap,
      child: Column(
        spacing: 6,
        children: [
          SizedBox(
            height: barArea + 20,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              spacing: 4,
              children: [
                if (showValue)
                  Text('$count', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                TweenAnimationBuilder<double>(
                  tween: Tween(end: height),
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOutCubic,
                  builder: (context, h, _) => Container(
                    height: h,
                    decoration: BoxDecoration(
                      color: count == 0
                          ? AppColors.border
                          : isToday
                          ? AppColors.accent
                          : const Color(0xFF3A4256),
                      // Csak a felső, „adat” vég lekerekített; az alap egyenes.
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
              color: isToday ? AppColors.text : AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
