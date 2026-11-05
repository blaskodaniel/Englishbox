/// Streak: hány egymást követő napon tanultál (szereztél XP-t).
class StreakInfo {
  const StreakInfo({required this.current, required this.best, required this.activeToday});

  static const empty = StreakInfo(current: 0, best: 0, activeToday: false);

  /// A mostani sorozat hossza. Ha ma még nem tanultál, de tegnap igen,
  /// a sorozat még él (ma még megmentheted).
  final int current;

  /// A valaha volt leghosszabb sorozat.
  final int best;
  final bool activeToday;
}

/// Kiszámolja a streaket az aktív napokból ([dayNumber] értékek).
///
/// [freeze] = „streak freeze”: hetente egy kihagyott nap nem szakítja meg a
/// sorozatot (de a kihagyott nap nem is számít bele a hosszába).
StreakInfo computeStreak(Set<int> activeDays, int today, {bool freeze = false}) {
  if (activeDays.isEmpty) return StreakInfo.empty;
  final days = activeDays.where((d) => d <= today).toList()..sort();
  if (days.isEmpty) return StreakInfo.empty;

  var best = 0;
  var run = 0;
  int? previous;
  int? lastFreeze;

  bool canFreezeAt(int day) => freeze && (lastFreeze == null || day - lastFreeze >= 7);

  for (final day in days) {
    final gap = previous == null ? null : day - previous;
    if (gap == 1) {
      run++;
    } else if (gap == 2 && canFreezeAt(day - 1)) {
      run++;
      lastFreeze = day - 1;
    } else {
      run = 1;
      lastFreeze = null;
    }
    if (run > best) best = run;
    previous = day;
  }

  // Él-e még a sorozat: az utolsó aktív nap ma vagy tegnap volt – freeze-zel
  // tegnapelőtt is lehet (a tegnapi kihagyást a freeze fedi).
  final last = days.last;
  final alive = today - last <= 1 || (today - last == 2 && canFreezeAt(today - 1));

  return StreakInfo(current: alive ? run : 0, best: best, activeToday: last == today);
}
