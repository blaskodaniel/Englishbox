/// Kitűzők. Nem tároljuk őket: mindig az aktuális adatokból számoljuk, hogy
/// hol tartasz (mint egy „derived state” – nincs mit szinkronban tartani).
enum BadgeKind { words, phrases, rules, sentences, streak, review, mastered, level }

/// Mit tudunk rólad, amiből a kitűzők számolnak.
class BadgeStats {
  const BadgeStats({
    this.items = 0,
    this.words = 0,
    this.sentences = 0,
    this.idioms = 0,
    this.rules = 0,
    this.bestStreak = 0,
    this.reviews = 0,
    this.mastered = 0,
    this.level = 1,
  });

  final int items;
  final int words;
  final int sentences;
  final int idioms;
  final int rules;
  final int bestStreak;
  final int reviews;
  final int mastered;
  final int level;
}

class Badge {
  const Badge({
    required this.title,
    required this.description,
    required this.kind,
    required this.target,
    required this.value,
  });

  final String title;
  final String description;
  final BadgeKind kind;
  final int target;
  final int Function(BadgeStats) value;
}

/// Egy kitűző állása.
class BadgeProgress {
  const BadgeProgress(this.badge, this.current);

  final Badge badge;
  final int current;

  bool get earned => current >= badge.target;
  double get fraction => (current / badge.target).clamp(0, 1).toDouble();
}

/// A 12 kitűző, nagyjából a megszerzés várható sorrendjében.
final List<Badge> badges = [
  Badge(
    title: 'First catch',
    description: 'Add your first item to the box.',
    kind: BadgeKind.words,
    target: 1,
    value: (s) => s.items,
  ),
  Badge(
    title: '7-day fire',
    description: 'Keep a 7-day streak.',
    kind: BadgeKind.streak,
    target: 7,
    value: (s) => s.bestStreak,
  ),
  Badge(
    title: 'Card shark',
    description: 'Answer 100 review cards.',
    kind: BadgeKind.review,
    target: 100,
    value: (s) => s.reviews,
  ),
  Badge(
    title: 'Idiom fan',
    description: 'Collect 10 idioms.',
    kind: BadgeKind.phrases,
    target: 10,
    value: (s) => s.idioms,
  ),
  Badge(
    title: 'Grammar tamer',
    description: 'Save 10 grammar rules.',
    kind: BadgeKind.rules,
    target: 10,
    value: (s) => s.rules,
  ),
  Badge(
    title: 'First ten',
    description: 'Master 10 items (21+ day interval).',
    kind: BadgeKind.mastered,
    target: 10,
    value: (s) => s.mastered,
  ),
  Badge(
    title: '50 sentences',
    description: 'Have 50 sentences in your box.',
    kind: BadgeKind.sentences,
    target: 50,
    value: (s) => s.sentences,
  ),
  Badge(
    title: '100 words',
    description: 'Have 100 words in your box.',
    kind: BadgeKind.words,
    target: 100,
    value: (s) => s.words,
  ),
  Badge(
    title: 'Level 10',
    description: 'Reach level 10.',
    kind: BadgeKind.level,
    target: 10,
    value: (s) => s.level,
  ),
  Badge(
    title: '30-day fire',
    description: 'Keep a 30-day streak.',
    kind: BadgeKind.streak,
    target: 30,
    value: (s) => s.bestStreak,
  ),
  Badge(
    title: 'Review machine',
    description: 'Answer 1,000 review cards.',
    kind: BadgeKind.review,
    target: 1000,
    value: (s) => s.reviews,
  ),
  Badge(
    title: 'Centurion',
    description: 'Master 100 items.',
    kind: BadgeKind.mastered,
    target: 100,
    value: (s) => s.mastered,
  ),
];

/// Az összes kitűző állása: a megszerzettek elöl, a többi a lista sorrendjében.
List<BadgeProgress> badgeProgress(BadgeStats stats) {
  final all = [for (final b in badges) BadgeProgress(b, b.value(stats))];
  return [...all.where((b) => b.earned), ...all.where((b) => !b.earned)];
}
