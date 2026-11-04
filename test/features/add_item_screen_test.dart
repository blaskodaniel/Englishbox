import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:englishbox/app/theme.dart';
import 'package:englishbox/data/db.dart';
import 'package:englishbox/data/providers.dart';
import 'package:englishbox/domain/enums.dart';
import 'package:englishbox/features/add/add_item_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  late AppDatabase db;

  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  Future<void> pumpAddScreen(WidgetTester tester, {String path = '/add'}) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    final router = GoRouter(
      initialLocation: path,
      routes: [
        GoRoute(
          path: '/add',
          builder: (context, state) => AddItemScreen(
            initialType: ItemType.values.asNameMap()[state.uri.queryParameters['type']] ??
                ItemType.word,
            initialText: state.uri.queryParameters['text'] ?? '',
          ),
        ),
        GoRoute(
          path: '/item/:id',
          builder: (context, state) => Text('detail ${state.pathParameters['id']}'),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: MaterialApp.router(theme: buildAppTheme(), routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('saving a word with an example stores it and awards XP', (tester) async {
    await pumpAddScreen(tester);

    expect(find.text('New word'), findsOneWidget);
    expect(find.text('+5 XP'), findsOneWidget);

    final fields = find.byType(TextField);
    await tester.enterText(fields.at(0), 'reluctant');
    await tester.enterText(fields.at(1), 'vonakodó');
    await tester.tap(find.text('adjective'));
    await tester.enterText(
      find.widgetWithText(TextField, 'Type a new example sentence…'),
      'He was reluctant to admit it.',
    );
    await tester.pump();

    // A félig beírt példa is beleszámít: 5 + 5
    expect(find.text('+10 XP'), findsOneWidget);

    await tester.ensureVisible(find.text('Save to box'));
    await tester.tap(find.text('Save to box'));
    await tester.pumpAndSettle();

    expect(find.text('detail 1'), findsOneWidget);

    final items = await db.select(db.items).get();
    expect(items.map((i) => (i.type, i.english)), [
      (ItemType.word, 'reluctant'),
      (ItemType.sentence, 'He was reluctant to admit it.'),
    ]);
    expect(items.first.partOfSpeech, PartOfSpeech.adjective);
    expect(items.first.level, CefrLevel.b1, reason: 'default from settings');

    final xp = await db.select(db.xpEvents).getSingle();
    expect(xp.amount, 10);
  });

  testWidgets('switching type keeps the text and changes the form', (tester) async {
    await pumpAddScreen(tester, path: '/add?type=phrase&text=walk%20me%20through');

    expect(find.text('New phrase'), findsOneWidget);
    expect(find.text('walk me through'), findsOneWidget);
    expect(find.text('phrasal verb'), findsOneWidget);

    await tester.tap(find.text('Rule'));
    await tester.pumpAndSettle();

    expect(find.text('New grammar rule'), findsOneWidget);
    expect(find.text('walk me through'), findsOneWidget);
    expect(find.text('Save rule'), findsOneWidget);
  });

  testWidgets('save is disabled until the main field is filled', (tester) async {
    await pumpAddScreen(tester);

    await tester.ensureVisible(find.text('Save to box'));
    await tester.tap(find.text('Save to box'));
    await tester.pumpAndSettle();

    expect(find.text('New word'), findsOneWidget);
    expect(await db.select(db.items).get(), isEmpty);
  });
}
