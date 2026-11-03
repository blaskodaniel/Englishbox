import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
            builder: (context, state) => const PlaceholderScreen(
              title: 'Library',
              links: {'Open item #1': '/item/1'},
            ),
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
    GoRoute(
      path: '/add',
      builder: (context, state) =>
          const PlaceholderScreen(title: 'New item', showAppBar: true),
    ),
    GoRoute(
      path: '/item/:id',
      builder: (context, state) => PlaceholderScreen(
        title: 'Item ${state.pathParameters['id']}',
        showAppBar: true,
      ),
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
