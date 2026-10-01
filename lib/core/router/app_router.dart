import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/settings/presentation/screens/licenses_screen.dart';
import '../../features/settings/presentation/screens/privacy_policy_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/todos/presentation/screens/todo_screen.dart';
import '../../features/todos/presentation/screens/todo_screen_detail.dart';
import '../../l10n/app_localizations.dart';
import 'app_routes.dart';

part 'app_router.g.dart';

/// Configures the application [GoRouter] instance with declarative routes and error handling.
@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  return GoRouter(
    initialLocation: AppRoute.todos.path,
    debugLogDiagnostics: kDebugMode,
    routes: [
      GoRoute(
        path: AppRoute.todos.path,
        name: AppRoute.todos.name,
        builder: (BuildContext context, GoRouterState state) =>
            const TodoScreen(),
        routes: [
          GoRoute(
            path: AppRoute.todoDetail.path,
            name: AppRoute.todoDetail.name,
            builder: (BuildContext context, GoRouterState state) {
              final idParam = state.pathParameters['id'];
              final todoId = int.tryParse(idParam ?? '') ?? 0;
              return TodoDetailScreen(todoId: todoId);
            },
          ),
        ],
      ),
      GoRoute(
        path: AppRoute.settings.path,
        name: AppRoute.settings.name,
        builder: (BuildContext context, GoRouterState state) =>
            const SettingsScreen(),
        routes: [
          GoRoute(
            path: AppRoute.licenses.path,
            name: AppRoute.licenses.name,
            builder: (BuildContext context, GoRouterState state) =>
                const LicensesScreen(),
          ),
          GoRoute(
            path: AppRoute.privacyPolicy.path,
            name: AppRoute.privacyPolicy.name,
            builder: (BuildContext context, GoRouterState state) =>
                const PrivacyPolicyScreen(),
          ),
        ],
      ),
    ],
    errorBuilder: (BuildContext context, GoRouterState state) {
      final l10n = AppLocalizations.of(context);
      return Scaffold(
        body: Center(
          child: Text(
            l10n?.pageNotFound(state.uri.toString()) ??
                'Page not found: ${state.uri}',
          ),
        ),
      );
    },
  );
}
