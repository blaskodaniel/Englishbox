import 'dart:math' as math;

import '../../data/db.dart';
import '../../data/repositories/review_repository.dart';
import '../../domain/enums.dart';
import '../../domain/mastery.dart';
import '../../domain/review_text.dart';
import '../../domain/srs.dart';
import '../../domain/xp.dart';
import 'review_providers.dart';

/// Egy kártya a körben: melyik elem, milyen feladattal, melyik irányban.
class ReviewCard {
  const ReviewCard({
    required this.item,
    required this.task,
    required this.srs,
    this.toEnglish = false,
    this.tiles = const [],
    this.example,
    this.isRetry = false,
  });

  final Item item;
  final ReviewTask task;

  /// Az ütemezés a kártya feltételekor.
  final SrsState srs;

  /// `true` → a kérdés magyar, a válasz angol (HU → EN).
  final bool toEnglish;

  /// Mondatépítésnél a szócsempék (a válasz szavai + csalik, keverve).
  final List<String> tiles;

  /// Szókártyánál az első példamondat (a hátoldalon).
  final Item? example;

  /// Egy elfelejtett kártya ismétlése a kör végén – ezért már nem jár XP.
  final bool isRetry;

  String get prompt => toEnglish ? item.hungarian : item.english;
  String get answer => toEnglish ? item.english : item.hungarian;

  ReviewCard copyWith({ReviewTask? task, SrsState? srs, bool? isRetry}) => ReviewCard(
    item: item,
    task: task ?? this.task,
    srs: srs ?? this.srs,
    toEnglish: toEnglish,
    tiles: tiles,
    example: example,
    isRetry: isRetry ?? this.isRetry,
  );
}

/// Egy válasz eredménye – a visszajelző panelhez.
class AnswerOutcome {
  const AnswerOutcome({
    required this.grade,
    required this.next,
    required this.xp,
    required this.before,
    required this.after,
  });

  final ReviewGrade grade;

  /// Az új ütemezés – ezt mentjük az adatbázisba.
  final SrsState next;
  final int xp;
  final Mastery before;
  final Mastery after;

  bool get movedUp => after.index > before.index;
}

/// Elemenkénti összesítés a körről (a „Session complete” képernyőhöz).
class ItemResult {
  ItemResult(this.item, this.firstMastery, this.firstGrade);

  final Item item;
  final Mastery firstMastery;
  final ReviewGrade firstGrade;
  late Mastery lastMastery;
  bool forgotten = false;

  bool get movedUp => lastMastery.index > firstMastery.index;
}

/// Egy ismétlési kör állapota – tiszta Dart, mint egy `useReducer` reducer +
/// állapot egyben. A képernyő hívja az [answer] / [advance] metódusokat,
/// aztán `setState`-tel újrarajzol.
class ReviewSession {
  ReviewSession(List<ReviewCard> cards) : _queue = [...cards];

  final List<ReviewCard> _queue;
  final DateTime startedAt = DateTime.now();
  final Map<int, ItemResult> _results = {};
  int _index = 0;
  int xp = 0;

  ReviewCard? get current => _index < _queue.length ? _queue[_index] : null;
  bool get isDone => current == null;
  int get position => _index;
  int get total => _queue.length;
  double get progress => total == 0 ? 1 : _index / total;

  /// Értékeli az aktuális kártyát. A léptetés külön ([advance]), hogy a
  /// visszajelző panel közben még az aktuális kártyát mutathassa.
  AnswerOutcome answer(ReviewGrade grade, DateTime now) {
    final card = current!;
    final next = Srs.schedule(card.srs, grade, now);
    final gained = card.isRetry ? 0 : XpRules.forReview(grade);
    xp += gained;

    final result = _results.putIfAbsent(
      card.item.id,
      () => ItemResult(card.item, card.srs.mastery, grade),
    );
    result.lastMastery = next.mastery;
    if (grade == ReviewGrade.forgot) {
      result.forgotten = true;
      // Az elfelejtett kártya a kör végén még egyszer előjön.
      if (!card.isRetry) _queue.add(card.copyWith(srs: next, isRetry: true));
    }

    return AnswerOutcome(
      grade: grade,
      next: next,
      xp: gained,
      before: card.srs.mastery,
      after: next.mastery,
    );
  }

  void advance() {
    if (_index < _queue.length) _index++;
  }

  /// Az aktuális kártya más feladattal (pl. „Use keyboard” → szabad fordítás).
  void switchTask(ReviewTask task) => _queue[_index] = _queue[_index].copyWith(task: task);

  // ------------------------------------------------------------ összesítés

  int get reviewedCount => _results.length;

  /// Első próbálkozásra tudott elemek aránya.
  double get accuracy => _results.isEmpty
      ? 0
      : _results.values.where((r) => r.firstGrade != ReviewGrade.forgot).length / _results.length;

  List<ItemResult> get movedUp => _results.values.where((r) => r.movedUp).toList();

  int get forgottenCount => _results.values.where((r) => r.forgotten).length;

  Duration get elapsed => DateTime.now().difference(startedAt);
}

// ------------------------------------------------------------- kör összeállítása

/// A módnak megfelelő esedékes elemek, legfeljebb [limit] darab.
List<DueEntry> selectEntries(DueSummary due, ReviewMode mode, int limit) {
  final entries = switch (mode) {
    ReviewMode.mix => due.entries,
    ReviewMode.cards => due.cardEntries,
    ReviewMode.build || ReviewMode.translate => due.sentenceEntries,
  };
  return entries.take(limit).toList();
}

/// Becsült idő percben: kártya ~20 mp, mondat ~40 mp.
int estimateMinutes(Iterable<DueEntry> entries) {
  final seconds = entries.fold<int>(0, (sum, e) => sum + (e.isTranslatable ? 40 : 20));
  return math.max(1, (seconds / 60).ceil());
}

/// A kiválasztott elemekből kártyák, keverve.
List<ReviewCard> buildCards(
  List<DueEntry> entries, {
  required ReviewMode mode,
  required AnswerMode answerMode,
  required Map<int, Item> examples,
  required List<String> englishPool,
  required List<String> hungarianPool,
  math.Random? random,
}) {
  final rnd = random ?? math.Random();
  List<String> words(List<String> sentences) => [for (final s in sentences) ...tokenize(s)];
  final enWords = words(englishPool);
  final huWords = words(hungarianPool);

  ReviewCard sentenceCard(DueEntry e, ReviewTask task) {
    if (task == ReviewTask.freeTranslation) {
      return ReviewCard(item: e.item, task: task, srs: e.srs, toEnglish: true);
    }
    // Mondatépítés: többnyire magyarról angolra, néha fordítva.
    final toEnglish = rnd.nextDouble() < 0.7;
    final target = toEnglish ? e.item.english : e.item.hungarian;
    return ReviewCard(
      item: e.item,
      task: task,
      srs: e.srs,
      toEnglish: toEnglish,
      tiles: buildTiles(target, distractorPool: toEnglish ? enWords : huWords, random: rnd),
    );
  }

  bool fitsBank(DueEntry e) {
    final n = math.max(tokenize(e.item.english).length, tokenize(e.item.hungarian).length);
    return n >= 2 && n <= 14;
  }

  ReviewTask sentenceTask(DueEntry e) {
    final build = fitsBank(e) ? ReviewTask.buildSentence : ReviewTask.freeTranslation;
    return switch (mode) {
      ReviewMode.build => build,
      ReviewMode.translate => ReviewTask.freeTranslation,
      _ => switch (answerMode) {
        AnswerMode.wordBank => build,
        AnswerMode.keyboard => ReviewTask.freeTranslation,
        AnswerMode.mix => rnd.nextBool() ? build : ReviewTask.freeTranslation,
      },
    };
  }

  final cards = [
    for (final e in entries)
      if (e.isTranslatable)
        sentenceCard(e, sentenceTask(e))
      else
        ReviewCard(
          item: e.item,
          task: ReviewTask.wordCard,
          srs: e.srs,
          // Szavak/kifejezések néha fordítva: magyarból kell felidézni az angolt.
          toEnglish:
              e.item.hungarian.trim().isNotEmpty &&
              (e.item.type == ItemType.word || e.item.type == ItemType.phrase) &&
              rnd.nextDouble() < 0.3,
          example: examples[e.item.id],
        ),
  ];
  return cards..shuffle(rnd);
}
