import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:englishbox/data/db.dart';
import 'package:englishbox/data/repositories/items_repository.dart';
import 'package:englishbox/domain/drafts.dart';
import 'package:englishbox/domain/enums.dart';
import 'package:englishbox/domain/formula.dart';
import 'package:englishbox/features/item_detail/item_detail_screen.dart';
import 'package:englishbox/features/library/library_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'test_app.dart';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  late AppDatabase db;
  late ItemsRepository items;
  late int wordId;
  late int ruleId;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    items = ItemsRepository(db);
    wordId = await items.createItem(const NewItem(
      type: ItemType.word,
      english: 'reluctant',
      hungarian: 'vonakodó',
      partOfSpeech: PartOfSpeech.adjective,
      level: CefrLevel.b2,
      tags: ['work'],
      examples: [NewExample('He was reluctant to admit it.')],
    ));
    ruleId = await items.createItem(const NewItem(
      type: ItemType.rule,
      english: 'Second conditional',
      ruleCategory: 'Conditionals',
      notes: 'Imaginary situations.\n• If-part: past simple\n• Result: would + verb',
      formula: [FormulaBlock('If', isKeyword: true), FormulaBlock('past simple')],
      trapNote: 'Hungarian uses „ha … -nék”.',
      mistakes: [NewMistake('If I would have time…', explanation: 'No would in the if-part.')],
    ));
  });

  tearDown(() => db.close());

  final routes = [
    GoRoute(path: '/library', builder: (_, _) => const LibraryScreen()),
    GoRoute(
      path: '/item/:id',
      builder: (_, state) {
        final id = int.parse(state.pathParameters['id']!);
        return ItemDetailScreen(key: ValueKey(id), itemId: id);
      },
    ),
    GoRoute(path: '/add', builder: (_, _) => const Text('add screen')),
    GoRoute(path: '/tags', builder: (_, _) => const Text('tags screen')),
  ];

  testWidgets('library lists items and filters by type and search', (tester) async {
    await pumpTestApp(tester, db: db, routes: routes, initialLocation: '/library');

    expect(find.text('reluctant'), findsOneWidget);
    expect(find.text('Second conditional'), findsOneWidget);
    expect(find.text('He was reluctant to admit it.'), findsOneWidget);
    expect(find.text('ADJECTIVE'), findsOneWidget);
    expect(find.text('If + past simple'), findsOneWidget, reason: 'rule subtitle = formula');

    await tester.ensureVisible(find.text('Grammar'));
    await tester.tap(find.text('Grammar'));
    await tester.pumpAndSettle();
    expect(find.text('reluctant'), findsNothing);
    expect(find.text('Second conditional'), findsOneWidget);

    await tester.ensureVisible(find.text('All'));
    await tester.tap(find.text('All'));
    await tester.enterText(find.byType(TextField), 'vonakodo');
    await tester.pumpAndSettle();
    expect(find.text('reluctant'), findsOneWidget);
    expect(find.text('Second conditional'), findsNothing);

    await tester.enterText(find.byType(TextField), 'zzz');
    await tester.pumpAndSettle();
    expect(find.text('Nothing matches'), findsOneWidget);
    await unmountTestApp(tester);
  });

  testWidgets('tapping a row opens the detail with examples', (tester) async {
    await pumpTestApp(tester, db: db, routes: routes, initialLocation: '/library');

    await tester.tap(find.text('reluctant'));
    await tester.pumpAndSettle();

    expect(find.text('ADJECTIVE'), findsOneWidget);
    expect(find.text('vonakodó'), findsOneWidget);
    expect(find.text('EXAMPLES · 1'), findsOneWidget);
    expect(find.text('Add your own example'), findsOneWidget);
    await unmountTestApp(tester);
  });

  testWidgets('adding your own example updates the detail and awards XP', (tester) async {
    await pumpTestApp(tester, db: db, routes: routes, initialLocation: '/item/$wordId');

    await tester.tap(find.text('Add your own example'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, 'I felt reluctant to leave.');
    await tester.pump(); // az „Add” gomb a beírás után válik aktívvá
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();

    expect(find.text('EXAMPLES · 2'), findsOneWidget);
    final xp = await db.select(db.xpEvents).getSingle();
    expect((xp.amount, xp.reason), (10, XpReason.addExample));
    await unmountTestApp(tester);
  });

  testWidgets('favourite and delete', (tester) async {
    await pumpTestApp(tester, db: db, routes: routes, initialLocation: '/library');
    await tester.tap(find.text('reluctant'));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Add to favourites'));
    await tester.pumpAndSettle();
    expect(find.byTooltip('Remove from favourites'), findsOneWidget);

    await tester.tap(find.byTooltip('Delete'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Delete'));
    await tester.pumpAndSettle();

    // Visszakerültünk a Librarybe, a szó eltűnt, a példamondat megmaradt.
    expect(find.text('reluctant'), findsNothing);
    expect(find.text('He was reluctant to admit it.'), findsOneWidget);
    await unmountTestApp(tester);
  });

  testWidgets('rule detail shows formula, notes, mistakes and trap', (tester) async {
    await pumpTestApp(tester, db: db, routes: routes, initialLocation: '/item/$ruleId');

    expect(find.text('GRAMMAR · CONDITIONALS'), findsOneWidget);
    expect(find.text('Second conditional'), findsOneWidget);
    expect(find.text('If'), findsOneWidget);
    expect(find.text('USE IT WHEN'), findsOneWidget);
    expect(find.text('If-part: past simple'), findsOneWidget);
    expect(find.text('If I would have time…'), findsOneWidget);
    expect(find.text('Hungarian trap'), findsOneWidget);
    expect(find.text('Collect an example'), findsOneWidget);
    await unmountTestApp(tester);
  });
}
