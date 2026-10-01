import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/blood_pressure/presentation/screens/add_edit_blood_pressure_reading_screen.dart';
import '../../features/glucose/presentation/screens/add_edit_glucose_reading_screen.dart';
import '../../features/hba1c/presentation/screens/add_edit_hba1c_reading_screen.dart';
import '../../features/ketones/presentation/screens/add_edit_ketone_reading_screen.dart';
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
      GoRoute(
        path: AppRoute.addGlucose.path,
        name: AppRoute.addGlucose.name,
        builder: (BuildContext context, GoRouterState state) =>
            const AddEditGlucoseReadingScreen(),
      ),
      GoRoute(
        path: AppRoute.editGlucose.path,
        name: AppRoute.editGlucose.name,
        builder: (BuildContext context, GoRouterState state) {
          final idString = state.pathParameters['id'];
          final id = int.tryParse(idString ?? '');
          return AddEditGlucoseReadingScreen(readingId: id);
        },
      ),
      GoRoute(
        path: AppRoute.addHba1c.path,
        name: AppRoute.addHba1c.name,
        builder: (BuildContext context, GoRouterState state) =>
            const AddEditHbA1cReadingScreen(),
      ),
      GoRoute(
        path: AppRoute.editHba1c.path,
        name: AppRoute.editHba1c.name,
        builder: (BuildContext context, GoRouterState state) {
          final idString = state.pathParameters['id'];
          final id = int.tryParse(idString ?? '');
          return AddEditHbA1cReadingScreen(readingId: id);
        },
      ),
      GoRoute(
        path: AppRoute.addBloodPressure.path,
        name: AppRoute.addBloodPressure.name,
        builder: (BuildContext context, GoRouterState state) =>
            const AddEditBloodPressureReadingScreen(),
      ),
      GoRoute(
        path: AppRoute.editBloodPressure.path,
        name: AppRoute.editBloodPressure.name,
        builder: (BuildContext context, GoRouterState state) {
          final idString = state.pathParameters['id'];
          final id = int.tryParse(idString ?? '');
          return AddEditBloodPressureReadingScreen(readingId: id);
        },
      ),
      GoRoute(
        path: AppRoute.addKetones.path,
        name: AppRoute.addKetones.name,
        builder: (BuildContext context, GoRouterState state) =>
            const AddEditKetoneReadingScreen(),
      ),
      GoRoute(
        path: AppRoute.editKetones.path,
        name: AppRoute.editKetones.name,
        builder: (BuildContext context, GoRouterState state) {
          final idString = state.pathParameters['id'];
          final id = int.tryParse(idString ?? '');
          return AddEditKetoneReadingScreen(readingId: id);
        },
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
