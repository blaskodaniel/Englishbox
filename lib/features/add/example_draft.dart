/// Egy példamondat az Add űrlapon, mentés előtt.
class ExampleDraft {
  const ExampleDraft({required this.english, this.second, this.isCorrect = true});

  final String english;

  /// Helyes példánál a magyar fordítás, hibásnál a magyarázat.
  final String? second;

  /// Csak nyelvtani szabályoknál lehet `false` (✗ Wrong).
  final bool isCorrect;

  ExampleDraft copyWith({bool? isCorrect}) => ExampleDraft(
        english: english,
        second: second,
        isCorrect: isCorrect ?? this.isCorrect,
      );
}
