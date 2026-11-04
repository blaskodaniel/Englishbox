import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:englishbox/data/db.dart';
import 'package:englishbox/data/repositories/items_repository.dart';
import 'package:englishbox/data/repositories/settings_repository.dart';
import 'package:englishbox/data/repositories/tags_repository.dart';
import 'package:englishbox/domain/drafts.dart';
import 'package:englishbox/domain/enums.dart';
import 'package:englishbox/domain/formula.dart';
import 'package:englishbox/domain/mastery.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late ItemsRepository items;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    items = ItemsRepository(db);
  });

  tearDown(() => db.close());

  const reluctant = NewItem(
    type: ItemType.word,
    english: ' reluctant ',
    hungarian: 'vonakodó, kelletlen',
    partOfSpeech: PartOfSpeech.adjective,
    level: CefrLevel.b2,
    source: 'lesson',
    tags: ['#work', 'Feelings', 'work'],
    examples: [
      NewExample('He was reluctant to admit he was wrong.',
          hungarian: 'Nem szívesen ismerte be, hogy tévedett.'),
      NewExample('Many people are reluctant to change their habits.'),
    ],
  );

  test('a word with examples is saved with its sentences and tags', () async {
    final id = await items.createItem(reluctant);

    final detail = await items.getItemDetail(id);
    expect(detail, isNotNull);
    expect(detail!.item.english, 'reluctant');
    expect(detail.item.partOfSpeech, PartOfSpeech.adjective);
    expect(detail.item.level, CefrLevel.b2);
    expect(detail.mastery, Mastery.newItem);
    expect(detail.tags.map((t) => t.name), ['feelings', 'work']);
    expect(detail.examples.map((e) => e.english), [
      'He was reluctant to admit he was wrong.',
      'Many people are reluctant to change their habits.',
    ]);
    expect(detail.examples.first.type, ItemType.sentence);

    final counts = await items.watchCountsByType().first;
    expect(counts[ItemType.word], 1);
    expect(counts[ItemType.sentence], 2);
    expect(counts[ItemType.rule], 0);
  });

  test('a grammar rule keeps its formula and wrong examples', () async {
    final id = await items.createItem(const NewItem(
      type: ItemType.rule,
      english: 'Second conditional',
      ruleCategory: 'Conditionals',
      formula: [
        FormulaBlock('If', isKeyword: true),
        FormulaBlock('past simple'),
        FormulaBlock('would', isKeyword: true),
        FormulaBlock('verb'),
      ],
      examples: [NewExample('If I had more time, I would travel more.')],
      mistakes: [
        NewMistake('If I would have more time, I would travel.',
            explanation: 'No „would” in the if-part.'),
      ],
    ));

    final detail = (await items.getItemDetail(id))!;
    expect(detail.item.formula, hasLength(4));
    expect(detail.item.formula.first, const FormulaBlock('If', isKeyword: true));
    expect(detail.mistakes.single.explanation, 'No „would” in the if-part.');
    expect(detail.examples, hasLength(1));
  });

  test('library search and type filter', () async {
    await items.createItem(reluctant);
    await items.createItem(const NewItem(
      type: ItemType.phrase,
      english: 'get over',
      hungarian: 'túlteszi magát valamin',
      phraseKind: PhraseKind.phrasalVerb,
    ));

    final phrases = await items.watchItems(type: ItemType.phrase).first;
    expect(phrases.map((e) => e.item.english), ['get over']);

    final byHungarian = await items.watchItems(search: 'VONAKOD').first;
    expect(byHungarian.map((e) => e.item.english), ['reluctant']);

    final all = await items.watchItems().first;
    expect(all.first.item.english, 'get over', reason: 'newest first');
  });

  test('search ignores accents and case, and looks in tags', () async {
    await items.createItem(reluctant);

    Future<List<String>> search(String term) async =>
        (await items.watchItems(type: ItemType.word, search: term).first)
            .map((e) => e.item.english)
            .toList();

    expect(await search('VONAKODO'), ['reluctant'], reason: 'ó == o');
    expect(await search('#feelings'), ['reluctant'], reason: 'tag search');
    expect(await search('nothing like this'), isEmpty);
  });

  test('level, tag and favourite filters', () async {
    final id = await items.createItem(reluctant);
    await items.createItem(const NewItem(type: ItemType.word, english: 'deadline', level: CefrLevel.a2));
    final workTag = (await TagsRepository(db).watchTagsWithCounts().first)
        .firstWhere((t) => t.tag.name == 'work')
        .tag;

    Future<List<String>> words({CefrLevel? level, int? tagId, bool fav = false}) async =>
        (await items
                .watchItems(type: ItemType.word, level: level, tagId: tagId, favoritesOnly: fav)
                .first)
            .map((e) => e.item.english)
            .toList();

    expect(await words(level: CefrLevel.a2), ['deadline']);
    expect(await words(tagId: workTag.id), ['reluctant']);
    expect(await words(fav: true), isEmpty);
    await items.toggleFavorite(id);
    expect(await words(fav: true), ['reluctant']);
  });

  test('addExample appends a sentence with the parent level and tags', () async {
    final id = await items.createItem(reluctant);
    final sentenceId = await items.addExample(
      id,
      const NewExample('I was reluctant to go.', hungarian: 'Nem akartam menni.'),
    );

    final detail = (await items.getItemDetail(id))!;
    expect(detail.examples.last.english, 'I was reluctant to go.');
    expect(detail.examples, hasLength(3));

    final sentence = (await items.getItemDetail(sentenceId))!;
    expect(sentence.item.level, CefrLevel.b2);
    expect(sentence.tags.map((t) => t.name), ['feelings', 'work']);
    expect(sentence.exampleOf.map((i) => i.english), ['reluctant']);
  });

  test('a rule knows which items link to it', () async {
    final ruleId = await items.createItem(
      const NewItem(type: ItemType.rule, english: 'Phrasal verbs'),
    );
    final phraseId = await items.createItem(
      const NewItem(type: ItemType.phrase, english: 'get over'),
    );
    await items.link(phraseId, ruleId, LinkRole.grammar);

    expect((await items.getItemDetail(ruleId))!.linkedFrom.map((i) => i.english), ['get over']);
    expect((await items.getItemDetail(phraseId))!.linkedGrammar.map((i) => i.english),
        ['Phrasal verbs']);
  });

  test('deleting an item removes its links but keeps the example sentences',
      () async {
    final id = await items.createItem(reluctant);
    await items.deleteItem(id);

    expect(await items.getItemDetail(id), isNull);
    final counts = await items.watchCountsByType().first;
    expect(counts[ItemType.word], 0);
    expect(counts[ItemType.sentence], 2);
    expect(await db.select(db.itemLinks).get(), isEmpty);
  });

  test('toggleFavorite flips the flag', () async {
    final id = await items.createItem(reluctant);
    await items.toggleFavorite(id);
    expect((await items.getItemDetail(id))!.item.isFavorite, isTrue);
    await items.toggleFavorite(id);
    expect((await items.getItemDetail(id))!.item.isFavorite, isFalse);
  });

  test('tag counts', () async {
    await items.createItem(reluctant);
    final tags = await TagsRepository(db).watchTagsWithCounts().first;
    // a szó + 2 példamondat mind megkapja a címkéket
    expect({for (final t in tags) t.tag.name: t.count}, {'feelings': 3, 'work': 3});
  });

  test('settings start with the defaults and can be updated', () async {
    final settings = SettingsRepository(db);
    final initial = await settings.get();
    expect(initial.levelNow, CefrLevel.b1);
    expect(initial.levelGoal, CefrLevel.c1);
    expect(initial.dailyGoal, 5);
    expect(initial.reminderMinutes, 19 * 60 + 30);

    await settings.update(const AppSettingsCompanion(
      username: Value('Daniel'),
      dailyGoal: Value(10),
    ));
    final updated = await settings.get();
    expect(updated.username, 'Daniel');
    expect(updated.dailyGoal, 10);
    expect(updated.accent, Accent.british);
  });
}
