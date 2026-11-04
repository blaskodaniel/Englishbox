/// Kereséshez egységesített szöveg: kisbetűs, ékezetek nélkül.
/// Így a „vonakodo” is megtalálja a „Vonakodó”-t.
String foldForSearch(String input) {
  final lower = input.toLowerCase();
  final buffer = StringBuffer();
  for (final rune in lower.runes) {
    final char = String.fromCharCode(rune);
    buffer.write(_accents[char] ?? char);
  }
  return buffer.toString();
}

const _accents = {
  'á': 'a',
  'é': 'e',
  'í': 'i',
  'ó': 'o',
  'ö': 'o',
  'ő': 'o',
  'ú': 'u',
  'ü': 'u',
  'ű': 'u',
};
