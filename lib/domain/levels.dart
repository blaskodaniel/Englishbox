/// Szintek az összes XP alapján.
///
/// Az n. szintről az (n+1).-re lépéshez `100 + 150 × (n − 1)` XP kell:
/// 1→2: 100, 2→3: 250 … 7→8: 1000 (ahogy a tervben: „Level 7 · 640 / 1000 XP”).
class LevelInfo {
  const LevelInfo({required this.level, required this.xpInLevel, required this.xpForNext});

  factory LevelInfo.fromTotalXp(int totalXp) {
    var level = 1;
    var remaining = totalXp < 0 ? 0 : totalXp;
    while (remaining >= xpToAdvance(level)) {
      remaining -= xpToAdvance(level);
      level++;
    }
    return LevelInfo(level: level, xpInLevel: remaining, xpForNext: xpToAdvance(level));
  }

  final int level;

  /// Mennyi XP gyűlt össze a mostani szinten belül.
  final int xpInLevel;

  /// Mennyi XP kell a következő szinthez (a szinten belül).
  final int xpForNext;

  int get xpToGo => xpForNext - xpInLevel;
  double get progress => xpInLevel / xpForNext;

  String get title => titleOf(level);
  String get nextTitle => titleOf(level + 1);

  static int xpToAdvance(int level) => 100 + 150 * (level - 1);

  static const _titles = [
    'Newcomer',
    'First Words',
    'Note Taker',
    'Box Builder',
    'Sentence Starter',
    'Pattern Spotter',
    'Word Collector',
    'Phrase Hunter',
    'Grammar Tamer',
    'Story Teller',
    'Fluent Explorer',
    'Englishbox Master',
  ];

  /// A 12. szint fölött a cím már nem változik.
  static String titleOf(int level) => _titles[(level - 1).clamp(0, _titles.length - 1)];
}
