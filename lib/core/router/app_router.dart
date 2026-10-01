import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/history/presentation/screens/history_screen.dart';
import '../../features/overview/presentation/screens/overview_screen.dart';
import '../../features/settings/presentation/screens/licenses_screen.dart';
import '../../features/settings/presentation/screens/privacy_policy_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../l10n/app_localizations.dart';
import '../presentation/navigation/adaptive_navigation_scaffold.dart';
import 'app_routes.dart';

part 'app_router.g.dart';

/// Configures the application [GoRouter] instance with declarative routes and error handling.
@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  return GoRouter(
    initialLocation: AppRoute.overview.path,
    debugLogDiagnostics: kDebugMode,
    routes: [
      StatefulShellRoute.indexedStack(
        builder:
            (
              BuildContext context,
              GoRouterState state,
              StatefulNavigationShell navigationShell,
            ) {
              final l10n = AppLocalizations.of(context);
              return AdaptiveNavigationScaffold(
                body: navigationShell,
                currentIndex: navigationShell.currentIndex,
                onDestinationSelected: (index) => navigationShell.goBranch(
                  index,
                  initialLocation: index == navigationShell.currentIndex,
                ),
                destinations: [
                  AdaptiveNavigationDestination(
                    icon: const Icon(Icons.dashboard_outlined),
                    selectedIcon: const Icon(Icons.dashboard),
                    label: l10n?.navOverview ?? 'Overview',
                  ),
                  AdaptiveNavigationDestination(
                    icon: const Icon(Icons.history_outlined),
                    selectedIcon: const Icon(Icons.history),
                    label: l10n?.navHistory ?? 'History',
                  ),
                  AdaptiveNavigationDestination(
                    icon: const Icon(Icons.settings_outlined),
                    selectedIcon: const Icon(Icons.settings),
                    label: l10n?.navSettings ?? 'Settings',
                  ),
                ],
              );
            },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoute.overview.path,
                name: AppRoute.overview.name,
                builder: (BuildContext context, GoRouterState state) =>
                    const OverviewScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoute.history.path,
                name: AppRoute.history.name,
                builder: (BuildContext context, GoRouterState state) =>
                    const HistoryScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
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
