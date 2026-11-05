/// Egy példamondat az Add/Edit űrlapon, mentés előtt.
class ExampleDraft {
  const ExampleDraft({required this.english, this.second, this.isCorrect = true, this.sentenceId});

  final String english;

  /// Helyes példánál a magyar fordítás, hibásnál a magyarázat.
  final String? second;

  /// Csak nyelvtani szabályoknál lehet `false` (✗ Wrong).
  final bool isCorrect;

  /// Szerkesztéskor: a már elmentett példamondat (mondat elem) azonosítója.
  /// Új példánál `null`.
  final int? sentenceId;

  /// Mentéskor új mondat elem jön létre belőle (ezért jár XP).
  bool get createsSentence => isCorrect && sentenceId == null;

  ExampleDraft copyWith({bool? isCorrect}) => ExampleDraft(
    english: english,
    second: second,
    isCorrect: isCorrect ?? this.isCorrect,
    sentenceId: sentenceId,
  );
}
