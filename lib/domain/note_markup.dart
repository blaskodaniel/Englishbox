/// Jegyzetek egyszerű formázása – a szöveg sima szövegként kerül az
/// adatbázisba, a formázást jelölők adják (mint egy mini-Markdown):
///
///   **félkövér**   _dőlt_   ==kiemelt==   „• ” a sor elején → felsorolás
library;

enum NoteStyle { bold, italic, highlight }

/// Egy egyformán formázott szövegdarab.
class NoteSpan {
  const NoteSpan(this.text, this.styles);

  final String text;
  final Set<NoteStyle> styles;
}

const bulletPrefix = '• ';

/// A dőlt `_` csak szóhatáron számít, hogy a `look_up`-féle szövegek ne
/// váltsanak dőltre.
final _inline = RegExp(r'\*\*(.+?)\*\*|==(.+?)==|(?<!\w)_(?!\s)(.+?)(?<!\s)_(?!\w)');

/// Felsorolásjel a sor elején: „•” (szóköz nélkül is), vagy „-” / „*” + szóköz.
/// (A `**félkövér**` sor így nem számít felsorolásnak.)
final bulletPattern = RegExp(r'^(•\s*|[-*]\s+)');

/// Egy sor szétbontása formázott darabokra. Egymásba ágyazva is működik:
/// `**nagyon _fontos_**`.
List<NoteSpan> parseNoteInline(String text, [Set<NoteStyle> styles = const {}]) {
  final spans = <NoteSpan>[];
  var position = 0;
  for (final match in _inline.allMatches(text)) {
    if (match.start > position) spans.add(NoteSpan(text.substring(position, match.start), styles));
    final (inner, style) = match[1] != null
        ? (match[1]!, NoteStyle.bold)
        : match[2] != null
        ? (match[2]!, NoteStyle.highlight)
        : (match[3]!, NoteStyle.italic);
    spans.addAll(parseNoteInline(inner, {...styles, style}));
    position = match.end;
  }
  if (position < text.length) spans.add(NoteSpan(text.substring(position), styles));
  return spans;
}

/// A jelölők nélküli szöveg – pl. listák egysoros alcíméhez.
String stripNoteMarkup(String text) =>
    parseNoteInline(text.replaceFirst(bulletPattern, '')).map((s) => s.text).join();
