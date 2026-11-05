// Az „English Tutor” app exportjából Englishbox mentésfájlt készít, amit a
// Settings → Import backup menüponttal lehet betölteni.
//
// Futtatás (a projekt gyökeréből):
//   dart run tool/convert_english_tutor.dart
//   dart run tool/convert_english_tutor.dart <bemenet.json> <kimenet.json>
//
// FIGYELEM: az Englishbox importja a teljes dobozt lecseréli (elemek, haladás,
// XP, beállítások) – ez a fájl csak az átalakított szavakat tartalmazza.

import 'dart:convert';
import 'dart:io';

const _source = 'English Tutor';
const _tag = 'english-tutor';

/// Igekötők/elöljárók – ha a „to” utáni ige után csak ezek jönnek, phrasal verb.
const _particles = {
  'about', 'across', 'after', 'along', 'around', 'away', 'back', 'by', 'down', 'for', //
  'forward', 'in', 'into', 'off', 'on', 'out', 'over', 'through', 'to', 'up', 'with',
};

void main(List<String> args) {
  final input = args.isNotEmpty ? args[0] : 'import_data/english_tutor_export.json';
  final output = args.length > 1 ? args[1] : 'import_data/englishbox_import.json';

  final entries = (jsonDecode(File(input).readAsStringSync()) as List).cast<Map<String, dynamic>>();
  final now = DateTime.now();
  final nowSec = _seconds(now);
  final today = DateTime(now.year, now.month, now.day);

  final items = <Map<String, Object?>>[];
  final links = <Map<String, Object?>>[];
  final itemTags = <Map<String, Object?>>[];
  final reviewStates = <Map<String, Object?>>[];
  final stats = <String, int>{};
  void count(String key) => stats[key] = (stats[key] ?? 0) + 1;

  var nextId = 1;
  int addItem({
    required String type,
    required String english,
    String hungarian = '',
    String? notes,
    String? partOfSpeech,
    String? phraseKind,
    String? ipa,
    required int dueAt,
    int repetitions = 0,
    int intervalDays = 0,
  }) {
    final id = nextId++;
    items.add({
      'id': id,
      'type': type,
      'english': english,
      'hungarian': hungarian,
      'notes': notes,
      'part_of_speech': partOfSpeech,
      'phrase_kind': phraseKind,
      'ipa': ipa,
      'level': null,
      'source': _source,
      'rule_category': null,
      'formula': '[]',
      'trap_note': null,
      'is_favorite': 0,
      'created_at': nowSec,
      'updated_at': nowSec,
    });
    reviewStates.add({
      'item_id': id,
      'due_at': dueAt,
      'ease': 2.5,
      'interval_days': intervalDays,
      'repetitions': repetitions,
      'lapses': 0,
      'last_reviewed_at': null,
    });
    itemTags.add({'item_id': id, 'tag_id': 1});
    count(type);
    return id;
  }

  for (final (index, e) in entries.indexed) {
    final rawEnglish = _clean(e['english'] as String? ?? '');
    if (rawEnglish.isEmpty) {
      count('skipped (empty)');
      continue;
    }
    final hungarian = _clean(e['hungarian'] as String? ?? '');
    final grammarNote = (e['grammarNote'] as String? ?? '').trim();
    final phonetic = (e['phonetic'] as String? ?? '').trim();
    final known = e['isKnown'] == true;
    final examples = _parseExamples(e['exampleSentences'] as String? ?? '');

    final hasTo = rawEnglish.toLowerCase().startsWith('to ');
    final type = _guessType(rawEnglish);
    // Szavaknál és kifejezéseknél a „to” elhagyható: „to take on” → „take on”.
    final english = type != 'sentence' && hasTo ? rawEnglish.substring(3).trim() : rawEnglish;

    // Amit már tudtál: „Getting there” szint, és szétszórva jön elő a következő héten.
    final dueAt = known
        ? _seconds(DateTime(today.year, today.month, today.day + 1 + index % 7))
        : nowSec;

    var notes = grammarNote.isEmpty ? null : grammarNote;
    if (type == 'sentence' && examples.isNotEmpty) {
      // Mondathoz nem tartozhat példamondat → a megjegyzésbe kerülnek.
      final lines = examples.map((x) => x.hu.isEmpty ? x.en : '${x.en} – ${x.hu}').join('\n');
      notes = [?notes, 'Examples:\n$lines'].join('\n\n');
    }

    final id = addItem(
      type: type,
      english: english,
      hungarian: hungarian,
      notes: notes,
      partOfSpeech: type == 'word' ? _partOfSpeech(hasTo, grammarNote) : null,
      phraseKind: type == 'phrase' ? _phraseKind(english, hasTo, grammarNote) : null,
      ipa: phonetic.isEmpty ? null : phonetic,
      dueAt: dueAt,
      repetitions: known ? 2 : 0,
      intervalDays: known ? 7 : 0,
    );
    if (known) count('already known');

    if (type == 'sentence') continue;
    for (final (position, example) in examples.indexed) {
      // A példamondatok fokozatosan jönnek, a következő két hétben szétszórva –
      // így az első körök a szavakról szólnak.
      final exampleId = addItem(
        type: 'sentence',
        english: example.en,
        hungarian: example.hu,
        dueAt: _seconds(DateTime(today.year, today.month, today.day + 1 + nextId % 14)),
      );
      count('example sentences');
      links.add({
        'parent_id': id,
        'child_id': exampleId,
        'role': 'example',
        'position': position,
      });
    }
  }

  final backup = {
    'format': 'englishbox-backup',
    'schemaVersion': 2,
    'exportedAt': now.toUtc().toIso8601String(),
    'tables': {
      'items': items,
      'item_links': links,
      'tags': [
        {'id': 1, 'name': _tag},
      ],
      'item_tags': itemTags,
      'review_states': reviewStates,
    },
  };
  File(output).writeAsStringSync(const JsonEncoder.withIndent(' ').convert(backup));

  stdout.writeln('Read ${entries.length} entries from $input');
  stdout.writeln('Wrote ${items.length} items to $output');
  for (final MapEntry(:key, :value) in stats.entries) {
    stdout.writeln('  $key: $value');
  }
}

int _seconds(DateTime t) => t.millisecondsSinceEpoch ~/ 1000;

/// Felesleges szóközök ki, „okos” aposztróf helyett sima.
String _clean(String s) => s.replaceAll('’', "'").replaceAll(RegExp(r'\s+'), ' ').trim();

/// Hasonló az app gyorsrögzítéséhez, a „honour / honor” típusú változatokat
/// egy szónak véve: .!? zárja (de nem „...”) vagy 7+ szó → mondat,
/// 2+ szó → kifejezés, különben szó.
String _guessType(String english) {
  var text = english;
  if (text.toLowerCase().startsWith('to ')) text = text.substring(3);
  final firstVariant = text.split(' / ').first;
  final words = firstVariant.split(' ').where((w) => w.isNotEmpty).length;
  final trimmed = text.trim();
  // „It seems (that)...”, „As for…” – befejezetlen mondatkezdés, az kifejezés.
  final unfinished = trimmed.endsWith('...') || trimmed.endsWith('…');
  final endsLikeSentence = !unfinished && RegExp(r'[.!?]$').hasMatch(trimmed);
  if ((endsLikeSentence && words >= 2) || words >= 7) return 'sentence';
  if (words >= 2) return 'phrase';
  return 'word';
}

String? _partOfSpeech(bool hasTo, String note) {
  if (hasTo) return 'verb';
  final n = note.toLowerCase();
  if (n.contains('melléknév')) return 'adjective';
  if (n.contains('határozószó')) return 'adverb';
  if (n.contains('főnév')) return 'noun';
  if (RegExp(r'(^|[\s,(])ige([\s,.)]|$)').hasMatch(n)) return 'verb';
  return null;
}

String? _phraseKind(String english, bool hasTo, String note) {
  final n = note.toLowerCase();
  if (n.contains('idióma') || n.contains('idiom')) return 'idiom';
  if (n.contains('phrasal')) return 'phrasalVerb';
  final words = english.toLowerCase().split(' ');
  if (hasTo && words.length >= 2 && words.skip(1).every(_particles.contains)) {
    return 'phrasalVerb';
  }
  return null;
}

/// „I decided to take on the challenge. - Úgy döntöttem, …” soronként,
/// a „ - ” / „ – ” jel előtt angol, utána magyar.
List<({String en, String hu})> _parseExamples(String raw) {
  final result = <({String en, String hu})>[];
  for (final line in raw.split('\n')) {
    final text = _clean(line);
    if (text.isEmpty) continue;
    final match = RegExp(r'\s[-–—]\s').firstMatch(text);
    if (match == null) {
      result.add((en: text, hu: ''));
    } else {
      result.add((
        en: text.substring(0, match.start).trim(),
        hu: text.substring(match.end).trim(),
      ));
    }
  }
  return result.where((x) => x.en.isNotEmpty).toList();
}
