import 'package:flutter/material.dart';

import '../../../app/theme.dart';
import '../../../domain/days.dart';
import 'progress_card.dart';

/// Az elmúlt 12 hét aktivitása – mint a GitHub „contribution” naptára.
/// Oszlop = hét (hétfőtől vasárnapig), cella = nap, a szín erőssége = aznapi XP.
class ActivityHeatmap extends StatefulWidget {
  const ActivityHeatmap({super.key, required this.xpPerDay, required this.today});

  /// [dayNumber] → XP
  final Map<int, int> xpPerDay;
  final DateTime today;

  @override
  State<ActivityHeatmap> createState() => _ActivityHeatmapState();
}

class _ActivityHeatmapState extends State<ActivityHeatmap> {
  static const _weeks = 12;
  static const _gap = 3.0;

  /// Lépcsők: 0 XP, 1–19, 20–49, 50–99, 100+ – sötéttől a lime-ig.
  static const _steps = [
    AppColors.border,
    Color(0xFF485C34),
    Color(0xFF6C8C41),
    Color(0xFF94C24E),
    AppColors.accent,
  ];
  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec', //
  ];

  DateTime? _selected;

  static int _level(int xp) => switch (xp) {
    <= 0 => 0,
    < 20 => 1,
    < 50 => 2,
    < 100 => 3,
    _ => 4,
  };

  @override
  Widget build(BuildContext context) {
    final t = widget.today;
    // Az utolsó oszlop az aktuális hét; az első oszlop 11 héttel korábbi hétfő.
    final thisMonday = DateTime(t.year, t.month, t.day - (t.weekday - 1));
    final firstMonday = DateTime(
      thisMonday.year,
      thisMonday.month,
      thisMonday.day - 7 * (_weeks - 1),
    );
    final todayNumber = dayNumber(t);

    var activeDays = 0;
    for (var i = 0; i < _weeks * 7; i++) {
      final day = DateTime(firstMonday.year, firstMonday.month, firstMonday.day + i);
      if ((widget.xpPerDay[dayNumber(day)] ?? 0) > 0) activeDays++;
    }

    final selected = _selected;
    final caption = selected == null
        ? 'Tap a day to see its XP'
        : '${_months[selected.month - 1]} ${selected.day} · '
              '${widget.xpPerDay[dayNumber(selected)] ?? 0} XP';

    return ProgressCard(
      title: 'Activity',
      trailing: activeDays == 1 ? '1 active day' : '$activeDays active days',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 10,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final cell = (constraints.maxWidth - _gap * (_weeks - 1)) / _weeks;
              return Row(
                spacing: _gap,
                children: [
                  for (var w = 0; w < _weeks; w++)
                    Column(
                      spacing: _gap,
                      children: [
                        for (var d = 0; d < 7; d++)
                          _cell(
                            DateTime(
                              firstMonday.year,
                              firstMonday.month,
                              firstMonday.day + w * 7 + d,
                            ),
                            cell,
                            todayNumber,
                          ),
                      ],
                    ),
                ],
              );
            },
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  caption,
                  style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                ),
              ),
              const Text('Less', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
              const SizedBox(width: 6),
              for (final color in _steps)
                Container(
                  width: 10,
                  height: 10,
                  margin: const EdgeInsets.only(right: 3),
                  decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)),
                ),
              const SizedBox(width: 3),
              const Text('More', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _cell(DateTime day, double size, int todayNumber) {
    final number = dayNumber(day);
    // Jövőbeli napok (az aktuális hét hátralévő része) üresen maradnak.
    if (number > todayNumber) return SizedBox.square(dimension: size);
    final xp = widget.xpPerDay[number] ?? 0;
    final isSelected = _selected != null && dayNumber(_selected!) == number;
    return GestureDetector(
      onTap: () => setState(() => _selected = isSelected ? null : day),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: _steps[_level(xp)],
          borderRadius: BorderRadius.circular(3),
          border: isSelected || number == todayNumber
              ? Border.all(color: AppColors.text, width: isSelected ? 2 : 1)
              : null,
        ),
      ),
    );
  }
}
