import 'dart:math' as math;

/// Szöveges segédek az ismétlési feladatokhoz: szócsempék, összehasonlítás, diff.

/// „Could you walk me through it?” → [Could, you, walk, me, through, it?]
/// Az írásjelek a szóhoz tapadva maradnak – a csempéken is így látszanak.
List<String> tokenize(String sentence) =>
    sentence.trim().split(RegExp(r'\s+')).where((t) => t.isNotEmpty).toList();

/// Összehasonlításhoz: kisbetű, írásjelek nélkül, egyforma aposztróf.
/// „Process?” → „process”, „I’ve” → „i've”
String normalizeToken(String token) => token
    .toLowerCase()
    .replaceAll(RegExp('[‘’`´]'), "'")
    .replaceAll(RegExp(r"""[.,!?;:"“”„()\[\]…–—]"""), '')
    .replaceAll(RegExp(r"^'+|'+$"), '');

List<String> normalizedWords(String text) =>
    tokenize(text).map(normalizeToken).where((t) => t.isNotEmpty).toList();

/// Egyezik-e a két mondat kis-/nagybetűtől és írásjelektől eltekintve.
bool sameSentence(String a, String b) {
  final x = normalizedWords(a);
  final y = normalizedWords(b);
  if (x.length != y.length) return false;
  for (var i = 0; i < x.length; i++) {
    if (x[i] != y[i]) return false;
  }
  return true;
}

/// A mondatépítő csempéi: a mondat szavai + néhány „csali” szó más mondatokból,
/// összekeverve.
List<String> buildTiles(
  String sentence, {
  required Iterable<String> distractorPool,
  required math.Random random,
  int distractors = 3,
}) {
  final tokens = tokenize(sentence);
  final used = tokens.map(normalizeToken).toSet();
  final candidates = <String>{};
  for (final token in distractorPool) {
    final norm = normalizeToken(token);
    // Csak „tiszta” szavak, amelyek nincsenek benne a mondatban.
    if (norm.length < 2 || used.contains(norm) || norm != token.toLowerCase()) continue;
    candidates.add(token);
  }
  final extra = candidates.toList()..shuffle(random);
  return [...tokens, ...extra.take(distractors)]..shuffle(random);
}

/// Egy szó a diff eredményében.
class DiffToken {
  const DiffToken(this.text, {required this.matched});

  final String text;

  /// `false` → ez a szó a másik szövegben nincs meg (kiemeljük).
  final bool matched;
}

/// Szószintű diff két mondat között (leghosszabb közös részsorozat, LCS – mint a
/// `git diff`, csak szavakra).
///
/// Visszaadja a mentett fordítás szavait (amit kihagytál, az `matched: false`)
/// és a te válaszod szavait (ami fölösleges vagy eltér, az `matched: false`).
({List<DiffToken> expected, List<DiffToken> answer}) diffWords(String expected, String answer) {
  final a = tokenize(expected);
  final b = tokenize(answer);
  final na = a.map(normalizeToken).toList();
  final nb = b.map(normalizeToken).toList();

  // lcs[i][j] = a[i..] és b[j..] leghosszabb közös részsorozatának hossza.
  final lcs = List.generate(a.length + 1, (_) => List.filled(b.length + 1, 0));
  for (var i = a.length - 1; i >= 0; i--) {
    for (var j = b.length - 1; j >= 0; j--) {
      lcs[i][j] = na[i] == nb[j] ? lcs[i + 1][j + 1] + 1 : math.max(lcs[i + 1][j], lcs[i][j + 1]);
    }
  }

  final matchedA = List.filled(a.length, false);
  final matchedB = List.filled(b.length, false);
  var i = 0, j = 0;
  while (i < a.length && j < b.length) {
    if (na[i] == nb[j]) {
      matchedA[i] = matchedB[j] = true;
      i++;
      j++;
    } else if (lcs[i + 1][j] >= lcs[i][j + 1]) {
      i++;
    } else {
      j++;
    }
  }

  return (
    expected: [for (var k = 0; k < a.length; k++) DiffToken(a[k], matched: matchedA[k])],
    answer: [for (var k = 0; k < b.length; k++) DiffToken(b[k], matched: matchedB[k])],
  );
}
