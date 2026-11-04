import 'package:englishbox/app/theme.dart';
import 'package:englishbox/data/db.dart';
import 'package:englishbox/data/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

/// Közös tesztkeret: telefonméretű képernyő, a mi témánk, memóriabeli adatbázis
/// és egy kis router a megadott útvonalakkal.
Future<void> pumpTestApp(
  WidgetTester tester, {
  required AppDatabase db,
  required List<RouteBase> routes,
  required String initialLocation,
}) async {
  tester.view.physicalSize = const Size(1170, 2532);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);

  final router = GoRouter(initialLocation: initialLocation, routes: routes);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [databaseProvider.overrideWithValue(db)],
      child: MaterialApp.router(theme: buildAppTheme(), routerConfig: router),
    ),
  );
  await tester.pumpAndSettle();
}

/// A teszt végén leszereli az appot, és kivárja, hogy a drift lezárja az élő
/// lekérdezéseit (ezt egy azonnali időzítővel teszi, amit a teszt különben
/// „pending timer”-ként jelezne).
Future<void> unmountTestApp(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox());
  // Két kör: a lezáró időzítő maga is ütemezhet egy újabbat.
  await tester.pump(const Duration(milliseconds: 10));
  await tester.pump(const Duration(milliseconds: 10));
}
