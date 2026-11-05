import '../domain/mastery.dart';
import 'db.dart';

/// Egy sor a Library listában: az elem, az ismétlési állapota és a címkéi.
class ItemListEntry {
  const ItemListEntry({required this.item, this.review, this.tags = const []});

  final Item item;
  final ReviewState? review;

  /// Címkenevek `#` nélkül.
  final List<String> tags;

  Mastery get mastery => masteryOf(review);
}

/// Minden, ami az elemrészlet-képernyőhöz kell.
class ItemDetail {
  const ItemDetail({
    required this.item,
    this.review,
    this.examples = const [],
    this.linkedGrammar = const [],
    this.similar = const [],
    this.tags = const [],
    this.mistakes = const [],
    this.exampleOf = const [],
    this.linkedFrom = const [],
  });

  final Item item;
  final ReviewState? review;

  /// Példamondatok (mondat elemek).
  final List<Item> examples;

  /// Kapcsolt nyelvtani szabályok.
  final List<Item> linkedGrammar;
  final List<Item> similar;
  final List<Tag> tags;

  /// Hibás példák – csak szabályoknál.
  final List<RuleMistake> mistakes;

  /// Mondatnál: mely szavak/kifejezések példája.
  final List<Item> exampleOf;

  /// Szabálynál: mely elemek kapcsolódnak hozzá.
  final List<Item> linkedFrom;

  Mastery get mastery => masteryOf(review);
}

class TagWithCount {
  const TagWithCount(this.tag, this.count);

  final Tag tag;
  final int count;
}

/// Egy gyűjtemény a Collections listához: elemszám és hány „Mastered” közülük.
class CollectionSummary {
  const CollectionSummary(this.collection, {required this.total, required this.mastered});

  final Collection collection;
  final int total;
  final int mastered;

  double get masteredFraction => total == 0 ? 0 : mastered / total;
}

Mastery masteryOf(ReviewState? review) => review == null
    ? Mastery.newItem
    : Mastery.from(repetitions: review.repetitions, intervalDays: review.intervalDays);
