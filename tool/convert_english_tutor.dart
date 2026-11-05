// Az „English Tutor” app exportjából Englishbox mentésfájlt készít, amit a
// Settings → Import backup menüponttal lehet betölteni.
//
// A tool/grammar_rules.json nyelvtani szabályai is bekerülnek (példamondatokkal,
// hibás példákkal), „grammar” címkével.
//
// Futtatás (a projekt gyökeréből):
//   dart run tool/convert_english_tutor.dart
//   dart run tool/convert_english_tutor.dart <bemenet.json> <kimenet.json> [<szabályok.json>]
//
// FIGYELEM: az Englishbox importja a teljes dobozt lecseréli (elemek, haladás,
// XP, beállítások) – ez a fájl csak az átalakított szavakat tartalmazza.

import 'dart:convert';
import 'dart:io';

const _source = 'English Tutor';
const _tag = 'english-tutor';
const _tagId = 1;
const _grammarTag = 'grammar';
const _grammarTagId = 2;

/// Igekötők/elöljárók – ha a „to” utáni ige után csak ezek jönnek, phrasal verb.
const _particles = {
  'about', 'across', 'after', 'along', 'around', 'away', 'back', 'by', 'down', 'for', //
  'forward', 'in', 'into', 'off', 'on', 'out', 'over', 'through', 'to', 'up', 'with',
};

void main(List<String> args) {
  final input = args.isNotEmpty ? args[0] : 'import_data/english_tutor_export.json';
  final output = args.length > 1 ? args[1] : 'import_data/englishbox_import.json';
  final rulesInput = args.length > 2 ? args[2] : 'tool/grammar_rules.json';
  final fixesInput = args.length > 3 ? args[3] : 'tool/english_tutor_fixes.json';

  final entries = (jsonDecode(File(input).readAsStringSync()) as List).cast<Map<String, dynamic>>();
  final now = DateTime.now();
  final nowSec = _seconds(now);
  final today = DateTime(now.year, now.month, now.day);

  final items = <Map<String, Object?>>[];
  final links = <Map<String, Object?>>[];
  final itemTags = <Map<String, Object?>>[];
  final reviewStates = <Map<String, Object?>>[];
  final ruleMistakes = <Map<String, Object?>>[];
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
    String? level,
    String? source = _source,
    String? ruleCategory,
    String formula = '[]',
    String? trapNote,
    int tagId = _tagId,
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
      'level': level,
      'source': source,
      'rule_category': ruleCategory,
      'formula': formula,
      'trap_note': trapNote,
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
    itemTags.add({'item_id': id, 'tag_id': tagId});
    count(type);
    return id;
  }

  // Kézi javítások (elírások, szintek, hiányzó fordítások) – az eredeti angol
  // szöveg / példasor a kulcs, mert az exportban az id-k nem egyediek.
  final fixesFile = File(fixesInput);
  final fixes = fixesFile.existsSync()
      ? jsonDecode(fixesFile.readAsStringSync()) as Map<String, dynamic>
      : const <String, dynamic>{};
  final entryFixes = {
    for (final MapEntry(:key, :value) in (fixes['entries'] as Map? ?? const {}).entries)
      _clean(key as String): (value as Map).cast<String, String>(),
  };
  final exampleFixes = {
    for (final MapEntry(:key, :value) in (fixes['examples'] as Map? ?? const {}).entries)
      _clean(key as String): (value as Map).cast<String, String>(),
  };
  final usedEntryFixes = <String>{};
  final usedExampleFixes = <String>{};
  final missingLevel = <String>[];

  for (final (index, e) in entries.indexed) {
    final originalEnglish = _clean(e['english'] as String? ?? '');
    if (originalEnglish.isEmpty) {
      count('skipped (empty)');
      continue;
    }
    final fix = entryFixes[originalEnglish] ?? const {};
    if (fix.isNotEmpty) usedEntryFixes.add(originalEnglish);
    final rawEnglish = fix['english'] ?? originalEnglish;
    final hungarian = fix['hungarian'] ?? _clean(e['hungarian'] as String? ?? '');
    final grammarNote = (e['grammarNote'] as String? ?? '').trim();
    final phonetic = fix['phonetic'] ?? (e['phonetic'] as String? ?? '').trim();
    final level = fix['level'];
    if (level == null) missingLevel.add(originalEnglish);
    final known = e['isKnown'] == true;
    final examples = [
      for (final example in _parseExamples(e['exampleSentences'] as String? ?? ''))
        if (exampleFixes[example.raw] case final f?)
          (en: f['en'] ?? example.en, hu: f['hu'] ?? example.hu, raw: example.raw)
        else
          example,
    ];
    usedExampleFixes.addAll(examples.map((x) => x.raw).where(exampleFixes.containsKey));

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
      level: level,
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
        level: level, // a példamondat a szava szintjét kapja
        dueAt: _seconds(DateTime(today.year, today.month, today.day + 1 + nextId % 14)),
      );
      count('example sentences');
      if (example.hu.isEmpty) count('example sentences without Hungarian');
      links.add({
        'parent_id': id,
        'child_id': exampleId,
        'role': 'example',
        'position': position,
      });
    }
  }

  // ------------------------------------------------- nyelvtani szabályok
  final rulesFile = File(rulesInput);
  final rules = rulesFile.existsSync()
      ? (jsonDecode(rulesFile.readAsStringSync()) as List).cast<Map<String, dynamic>>()
      : const <Map<String, dynamic>>[];

  for (final (index, rule) in rules.indexed) {
    final level = rule['level'] as String?;
    final id = addItem(
      type: 'rule',
      english: rule['name'] as String,
      notes: rule['notes'] as String?,
      level: level,
      source: null,
      ruleCategory: rule['category'] as String?,
      formula: jsonEncode([
        for (final block in (rule['formula'] as List? ?? const []).cast<String>())
          // „[If]” → kulcsszó (kiemelt), a többi sima „hely” blokk.
          block.startsWith('[') && block.endsWith(']')
              ? {'text': block.substring(1, block.length - 1), 'kw': true}
              : {'text': block, 'kw': false},
      ]),
      trapNote: rule['trap'] as String?,
      tagId: _grammarTagId,
      // Egy hét alatt szétszórva jönnek elő, nem egyszerre mind.
      dueAt: _seconds(DateTime(today.year, today.month, today.day + index % 7)),
    );

    final examples = (rule['examples'] as List? ?? const []).cast<List>();
    for (final (position, example) in examples.indexed) {
      final exampleId = addItem(
        type: 'sentence',
        english: example[0] as String,
        hungarian: example.length > 1 ? example[1] as String : '',
        level: level,
        source: null,
        tagId: _grammarTagId,
        dueAt: _seconds(DateTime(today.year, today.month, today.day + 1 + nextId % 14)),
      );
      count('grammar examples');
      links.add({'parent_id': id, 'child_id': exampleId, 'role': 'example', 'position': position});
    }

    final mistakes = (rule['mistakes'] as List? ?? const []).cast<List>();
    for (final (position, mistake) in mistakes.indexed) {
      ruleMistakes.add({
        'id': ruleMistakes.length + 1,
        'rule_id': id,
        'wrong': mistake[0] as String,
        'explanation': mistake.length > 1 ? mistake[1] as String : null,
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
      'rule_mistakes': ruleMistakes,
      'tags': [
        {'id': _tagId, 'name': _tag},
        if (rules.isNotEmpty) {'id': _grammarTagId, 'name': _grammarTag},
      ],
      'item_tags': itemTags,
      'review_states': reviewStates,
    },
  };
  File(output).writeAsStringSync(const JsonEncoder.withIndent(' ').convert(backup));

  stdout.writeln('Read ${entries.length} entries from $input');
  stdout.writeln('Read ${rules.length} grammar rules from $rulesInput');
  stdout.writeln('Wrote ${items.length} items to $output');
  for (final MapEntry(:key, :value) in stats.entries) {
    stdout.writeln('  $key: $value');
  }

  // Ellenőrzés: elgépelt kulcs a javítófájlban, vagy szint nélküli elem.
  void warn(String title, Iterable<String> list) {
    if (list.isEmpty) return;
    stdout.writeln('WARNING – $title (${list.length}):');
    for (final x in list) {
      stdout.writeln('  • $x');
    }
  }

  warn('entry fixes that matched nothing', entryFixes.keys.where((k) => !usedEntryFixes.contains(k)));
  warn(
    'example fixes that matched nothing',
    exampleFixes.keys.where((k) => !usedExampleFixes.contains(k)),
  );
  warn('entries without level', missingLevel);
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

typedef _Example = ({String en, String hu, String raw});

/// „I decided to take on the challenge. - Úgy döntöttem, …” soronként,
/// a „ - ” / „ – ” jel előtt angol, utána magyar. A `raw` a tisztított eredeti
/// sor – ez a kulcs a javításokhoz.
List<_Example> _parseExamples(String raw) {
  final result = <_Example>[];
  for (final line in raw.split('\n')) {
    final text = _clean(line);
    if (text.isEmpty) continue;
    final match = RegExp(r'\s[-–—]\s').firstMatch(text);
    if (match == null) {
      result.add((en: text, hu: '', raw: text));
    } else {
      result.add((
        en: text.substring(0, match.start).trim(),
        hu: text.substring(match.end).trim(),
        raw: text,
      ));
    }
  }
  return result.where((x) => x.en.isNotEmpty).toList();
}
