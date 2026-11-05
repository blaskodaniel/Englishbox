import 'dart:math' as math;

import 'days.dart';
import 'mastery.dart';

/// Az önértékelés három gombja: Forgot / Hard / Knew it
/// (fordításnál Wrong / Almost / Correct).
enum ReviewGrade { forgot, hard, good }

/// Egy elem ismétlési ütemezése – a `ReviewStates` sor tiszta Dart másolata.
class SrsState {
  const SrsState({
    required this.dueAt,
    this.ease = 2.5,
    this.intervalDays = 0,
    this.repetitions = 0,
    this.lapses = 0,
  });

  final DateTime dueAt;

  /// Mennyivel szorzódik az intervallum egy sikeres ismétlés után.
  final double ease;
  final int intervalDays;

  /// Egymás utáni sikeres ismétlések.
  final int repetitions;

  /// Hányszor felejtetted el.
  final int lapses;

  Mastery get mastery => Mastery.from(repetitions: repetitions, intervalDays: intervalDays);
}

/// SM-2 jellegű ütemező (mint az Anki egyszerűsített változata).
///
/// - **Forgot**: vissza az elejére, még ma újra előjön; a „könnyűség” csökken.
/// - **Hard**: az intervallum csak kicsit nő (×1.2), a könnyűség kicsit csökken.
/// - **Knew it**: 1 → 3 nap, utána az intervallum × könnyűség (2.5 → 8 → 20 → 50…).
///
/// Az új esedékesség mindig a cél nap **elején** van, így ha este ismételsz,
/// a „holnap” reggeltől már esedékes.
abstract final class Srs {
  static const minEase = 1.3;

  static SrsState schedule(SrsState s, ReviewGrade grade, DateTime now) {
    switch (grade) {
      case ReviewGrade.forgot:
        return SrsState(
          dueAt: now,
          ease: math.max(minEase, s.ease - 0.2),
          intervalDays: 0,
          repetitions: 0,
          lapses: s.lapses + 1,
        );
      case ReviewGrade.hard:
      case ReviewGrade.good:
        final interval = nextInterval(s, grade);
        final ease = grade == ReviewGrade.hard ? math.max(minEase, s.ease - 0.15) : s.ease;
        final today = startOfDay(now);
        return SrsState(
          // DateTime(év, hó, nap + n) – a hónapváltást és az óraátállítást is kezeli.
          dueAt: DateTime(today.year, today.month, today.day + interval),
          ease: ease,
          intervalDays: interval,
          repetitions: s.repetitions + 1,
          lapses: s.lapses,
        );
    }
  }

  /// Hány nap múlva jön újra, ha ezt a gombot nyomod (0 = még ma).
  static int nextInterval(SrsState s, ReviewGrade grade) {
    switch (grade) {
      case ReviewGrade.forgot:
        return 0;
      case ReviewGrade.hard:
        if (s.repetitions == 0) return 1;
        return math.max(s.intervalDays + 1, (s.intervalDays * 1.2).round());
      case ReviewGrade.good:
        if (s.repetitions == 0) return 1;
        if (s.repetitions == 1) return math.max(3, s.intervalDays + 1);
        return math.max(s.intervalDays + 1, (s.intervalDays * s.ease).round());
    }
  }

  /// A gombok alatti kis felirat: „again today”, „tomorrow”, „in 6 days”.
  static String intervalLabel(int days) => switch (days) {
    0 => 'again today',
    1 => 'tomorrow',
    _ => 'in $days days',
  };
}
