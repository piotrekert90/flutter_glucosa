import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_boilerplate/l10n/app_localizations.dart';

import 'features/settings/domain/entities/user_preferences.dart';
import 'features/settings/presentation/providers/user_preferences_notifier.dart';
import 'core/presentation/theme/app_theme.dart';
import 'core/router/app_router.dart';

/// Root application widget configuring themes, navigation, and core Material3 setup.
///
/// Reactively subscribes to [userPreferencesProvider] to apply dark, light, or system
/// theme modes dynamically, and uses [appRouterProvider] for declarative routing.
class App extends ConsumerWidget {
  /// Creates a new root [App] widget instance.
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preferences = ref.watch(userPreferencesProvider).value;
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      routerConfig: router,
      onGenerateTitle: (context) {
        final title = AppLocalizations.of(context)?.appTitle ?? 'Todo Flow';
        return kDebugMode ? '$title (Dev)' : title;
      },
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _toFlutterThemeMode(
        preferences?.themeMode ?? UserThemeMode.system,
      ),
    );
  }

  ThemeMode _toFlutterThemeMode(UserThemeMode themeMode) {
    return switch (themeMode) {
      UserThemeMode.light => ThemeMode.light,
      UserThemeMode.dark => ThemeMode.dark,
      UserThemeMode.system => ThemeMode.system,
    };
  }
}
