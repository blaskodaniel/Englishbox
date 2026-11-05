import 'enums.dart';
import 'formula.dart';

/// Egy példamondat az Add/Edit képernyőről.
class NewExample {
  const NewExample(this.english, {this.hungarian, this.existingId});

  final String english;
  final String? hungarian;

  /// Egy már a dobozban lévő mondat elem azonosítója (szerkesztéskor a meglévő
  /// példa, vagy a „From my box” gombbal választott mondat). Ilyenkor csak
  /// összekapcsoljuk; ha `null`, a mentés új mondatot hoz létre.
  final int? existingId;
}

/// Egy hibás példa egy nyelvtani szabályhoz (pl. „If I would have…”).
class NewMistake {
  const NewMistake(this.wrong, {this.explanation});

  final String wrong;
  final String? explanation;
}

/// Minden, ami egy elem mentéséhez kell – az Add/Edit képernyő ezt állítja össze.
class NewItem {
  const NewItem({
    required this.type,
    required this.english,
    this.hungarian = '',
    this.notes,
    this.partOfSpeech,
    this.phraseKind,
    this.ipa,
    this.level,
    this.source,
    this.ruleCategory,
    this.formula = const [],
    this.trapNote,
    this.tags = const [],
    this.examples = const [],
    this.mistakes = const [],
    this.similarIds = const [],
  });

  final ItemType type;

  /// Szó, kifejezés, szabály neve vagy maga a mondat.
  final String english;

  /// Magyar jelentés / fordítás.
  final String hungarian;

  /// Hosszabb magyarázat (kifejezés jelentése, szabály leírása).
  final String? notes;

  final PartOfSpeech? partOfSpeech;
  final PhraseKind? phraseKind;
  final String? ipa;
  final CefrLevel? level;
  final String? source;
  final String? ruleCategory;
  final List<FormulaBlock> formula;
  final String? trapNote;

  /// Címkenevek, `#` nélkül vagy azzal.
  final List<String> tags;

  /// Helyes példák – mondat elemként is elmentődnek.
  final List<NewExample> examples;

  /// Hibás példák – csak szabályoknál.
  final List<NewMistake> mistakes;

  /// Hasonló szavak/kifejezések – a kapcsolat mindkét irányban létrejön.
  final List<int> similarIds;
}
