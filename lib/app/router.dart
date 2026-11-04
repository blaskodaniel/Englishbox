import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../domain/enums.dart';
import '../features/add/add_item_screen.dart';
import '../features/item_detail/item_detail_screen.dart';
import '../features/library/library_screen.dart';
import '../widgets/app_shell.dart';
import '../widgets/placeholder_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/today',
  routes: [
    // A négy fül, mindegyik saját navigációs veremmel.
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          AppShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/today',
            builder: (context, state) => const PlaceholderScreen(
              title: 'Today',
              links: {'Settings': '/settings', 'Tags': '/tags'},
            ),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/library',
            builder: (context, state) => const LibraryScreen(),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/review',
            builder: (context, state) => const PlaceholderScreen(title: 'Review'),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/progress',
            builder: (context, state) => const PlaceholderScreen(title: 'Progress'),
          ),
        ]),
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
    GoRoute(
      path: '/settings',
      builder: (context, state) =>
          const PlaceholderScreen(title: 'Settings', showAppBar: true),
    ),
    GoRoute(
      path: '/tags',
      builder: (context, state) =>
          const PlaceholderScreen(title: 'Collections & tags', showAppBar: true),
    ),
  ],
);
