/// A doboz négy elemtípusa.
enum ItemType { word, phrase, rule, sentence }

/// Szófaj – csak szavaknál.
enum PartOfSpeech { noun, verb, adjective, adverb }

/// Kifejezés fajtája – csak kifejezéseknél.
enum PhraseKind { idiom, phrasalVerb, collocation }

/// Közös európai referenciakeret (CEFR) szintjei.
enum CefrLevel {
  a1('Beginner'),
  a2('Elementary'),
  b1('Intermediate'),
  b2('Upper intermediate'),
  c1('Advanced'),
  c2('Proficient');

  const CefrLevel(this.title);

  final String title;

  /// „B2”
  String get label => name.toUpperCase();
}

/// Két elem kapcsolata (szülő → gyerek).
enum LinkRole {
  /// A gyerek egy példamondat a szülőhöz.
  example,

  /// A gyerek egy nyelvtani szabály, amelyhez a szülő kapcsolódik.
  grammar,

  /// A gyerek egy hasonló jelentésű elem.
  similar,
}

/// Ismétlési feladattípusok.
enum ReviewTask { wordCard, buildSentence, freeTranslation }

/// Miért kapott XP-t a felhasználó.
enum XpReason { addItem, addExample, review, quest, badge }

/// Napi küldetések.
enum Quest { addItems, reviewItems, ownExample }

/// Fordítási feladatoknál a válaszadás módja.
enum AnswerMode { wordBank, keyboard, mix }

enum Accent { british, american }

enum SpeechSpeed { slow, normal, fast }
