import 'enums.dart';

/// A gyorsrögzítő mezőbe írt szövegből kitalálja, milyen elem lehet:
/// egy szó → word, 2–4 szó → phrase, hosszabb vagy írásjellel zárul → sentence.
/// Az Add képernyőn persze át lehet állítani.
ItemType guessItemType(String text) {
  final trimmed = text.trim();
  if (trimmed.isEmpty) return ItemType.word;

  final words = trimmed.split(RegExp(r'\s+')).length;
  final endsLikeSentence = RegExp(r'[.!?…]$').hasMatch(trimmed);

  if (words >= 5 || (words >= 2 && endsLikeSentence)) return ItemType.sentence;
  if (words >= 2) return ItemType.phrase;
  return ItemType.word;
}
