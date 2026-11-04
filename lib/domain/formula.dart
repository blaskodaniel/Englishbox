/// Egy nyelvtani képlet egy blokkja, pl. `If` (kulcsszó) vagy `past simple` (hely).
class FormulaBlock {
  const FormulaBlock(this.text, {this.isKeyword = false});

  factory FormulaBlock.fromJson(Map<String, dynamic> json) =>
      FormulaBlock(json['text'] as String, isKeyword: json['kw'] as bool? ?? false);

  final String text;

  /// Kulcsszó (pl. „If”, „would”) – kiemelt színnel jelenik meg.
  final bool isKeyword;

  Map<String, dynamic> toJson() => {'text': text, 'kw': isKeyword};

  @override
  bool operator ==(Object other) =>
      other is FormulaBlock && other.text == text && other.isKeyword == isKeyword;

  @override
  int get hashCode => Object.hash(text, isKeyword);

  @override
  String toString() => isKeyword ? '[$text]' : text;
}
