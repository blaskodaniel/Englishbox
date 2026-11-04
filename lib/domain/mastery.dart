/// Az elemrészleten és a Library listában látható 4 fokozatú tudásszint.
enum Mastery {
  newItem('New'),
  learning('Learning'),
  gettingThere('Getting there'),
  familiar('Familiar'),
  mastered('Mastered');

  const Mastery(this.label);

  final String label;

  /// Hány sáv világít a 4-ből.
  int get bars => index;

  /// Az ismétlési állapotból (sikeres ismétlések, aktuális intervallum) számol.
  static Mastery from({required int repetitions, required int intervalDays}) {
    if (repetitions == 0) return Mastery.newItem;
    if (intervalDays < 3) return Mastery.learning;
    if (intervalDays < 10) return Mastery.gettingThere;
    if (intervalDays < 21) return Mastery.familiar;
    return Mastery.mastered;
  }
}
