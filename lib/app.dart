import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_glucosa/l10n/app_localizations.dart';

import 'core/domain/enums/enums.dart';
import 'core/integrations/biometrics/biometric_lock_observer.dart';
import 'core/integrations/biometrics/biometric_lock_provider.dart';
import 'core/presentation/screens/biometric_shield_screen.dart';
import 'core/presentation/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'features/settings/presentation/providers/user_profile_notifier.dart';

/// Root application widget configuring themes, navigation, and core Material3 setup.
///
/// Reactively subscribes to [userProfileProvider] to apply dark, light, or system
/// theme modes dynamically, uses [appRouterProvider] for declarative routing,
/// and manages biometric shielding overlay via [biometricLockProvider].
class App extends ConsumerStatefulWidget {
  /// Creates a new root [App] widget instance.
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  BiometricLockObserver? _biometricObserver;

  @override
  void initState() {
    super.initState();
    _biometricObserver = BiometricLockObserver(
      isBiometricLockEnabled: () =>
          ref.read(userProfileProvider).value?.isBiometricLockEnabled ?? false,
      isAppLocked: () => ref.read(biometricLockProvider),
      onLockStateChanged: (locked) {
        ref.read(biometricLockProvider.notifier).setLocked(locked);
      },
    );
  }

  @override
  void dispose() {
    _biometricObserver?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(userProfileProvider).value;
    final router = ref.watch(appRouterProvider);
    final isLocked = ref.watch(biometricLockProvider);

    return MaterialApp.router(
      routerConfig: router,
      onGenerateTitle: (context) {
        final title = AppLocalizations.of(context)?.appTitle ?? 'Glucosa';
        return kDebugMode ? '$title (Dev)' : title;
      },
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _toFlutterThemeMode(
        profile?.themeMode ?? UserThemeMode.system,
      ),
      builder: (context, child) {
        return Stack(
          children: [?child, if (isLocked) const BiometricShieldScreen()],
        );
      },
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
