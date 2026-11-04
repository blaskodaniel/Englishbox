import 'enums.dart';

/// XP-szabályok a terv alapján.
abstract final class XpRules {
  /// Minden példamondat (szabálynál a hibás példa is) ennyit ér.
  static const perExample = 5;

  /// Saját példa hozzáadása az elemrészleten.
  static const ownExample = 10;

  /// Alap XP egy új elemért, a példák nélkül.
  static int baseForNewItem(ItemType type) => switch (type) {
        ItemType.word => 5,
        ItemType.phrase => 15,
        ItemType.rule => 25,
        ItemType.sentence => 20,
      };

  /// Egy új elem mentéséért járó XP összesen.
  /// (Terv: szó 2 példával +15, kifejezés 2 példával +25,
  /// szabály 3 példával +40, mondat +20.)
  static int forNewItem(ItemType type, {int exampleCount = 0}) =>
      baseForNewItem(type) +
      (type == ItemType.sentence ? 0 : perExample * exampleCount);
}
