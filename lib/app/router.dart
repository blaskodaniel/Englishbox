import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../domain/enums.dart';
import '../features/add/add_item_screen.dart';
import '../features/collections/collections_screen.dart';
import '../features/item_detail/item_detail_screen.dart';
import '../features/library/library_screen.dart';
import '../features/progress/progress_screen.dart';
import '../features/review/review_providers.dart';
import '../features/review/review_screen.dart';
import '../features/review/review_session_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/today/today_screen.dart';
import '../widgets/app_shell.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/today',
  routes: [
    // A négy fül, mindegyik saját navigációs veremmel.
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => AppShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [GoRoute(path: '/today', builder: (context, state) => const TodayScreen())],
        ),
        StatefulShellBranch(
          routes: [GoRoute(path: '/library', builder: (context, state) => const LibraryScreen())],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/review',
              builder: (context, state) => const ReviewScreen(),
              routes: [
                // /review/session?mode=mix – a gyökér navigátorra kerül, így
                // eltakarja az alsó sávot.
                GoRoute(
                  path: 'session',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => ReviewSessionScreen(
                    mode:
                        ReviewMode.values.asNameMap()[state.uri.queryParameters['mode']] ??
                        ReviewMode.mix,
                  ),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [GoRoute(path: '/progress', builder: (context, state) => const ProgressScreen())],
        ),
      ],
    ),

    // Teljes képernyős oldalak, alsó sáv nélkül.
    // /add?type=phrase&text=walk%20me%20through
    GoRoute(
      path: '/add',
      builder: (context, state) {
        final params = state.uri.queryParameters;
        return AddItemScreen(
          initialType: ItemType.values.asNameMap()[params['type']] ?? ItemType.word,
          initialText: params['text'] ?? '',
        );
      },
    ),
    GoRoute(
      path: '/item/:id',
      // Az elem azonosítóját is a kulcsba tesszük, így ha egy részletről egy
      // másik elem részletére lépünk, új képernyő-állapot jön létre.
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return ItemDetailScreen(key: ValueKey(id), itemId: id);
      },
    ),
    // Szerkesztés: ugyanaz az űrlap, mint az Add, előre kitöltve.
    GoRoute(
      path: '/item/:id/edit',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return AddItemScreen(key: ValueKey('edit-$id'), editItemId: id);
      },
    ),
    GoRoute(path: '/settings', builder: (context, state) => const SettingsScreen()),
    GoRoute(path: '/tags', builder: (context, state) => const CollectionsScreen()),
  ],
);
