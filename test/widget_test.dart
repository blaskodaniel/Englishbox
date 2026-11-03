import 'package:englishbox/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App starts with the bottom navigation', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: EnglishboxApp()));
    await tester.pumpAndSettle();

    expect(find.text('Library'), findsOneWidget);
    expect(find.text('Progress'), findsOneWidget);
  });
}
