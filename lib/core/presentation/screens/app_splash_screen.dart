import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';

/// The in-app splash screen shown during startup initialization.
///
/// Visually mimics the native splash screen and responds to the app's internal
/// theme (dark/light) regardless of the host OS theme.
class AppSplashScreen extends StatelessWidget {
  /// Creates an [AppSplashScreen] displayed while the app initializes.
  const AppSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    final bgColor = colorScheme.surface;
    final assetPath = isDark
        ? 'assets/icon/splash_dark.png'
        : 'assets/icon/splash_light.png';

    return Scaffold(
      backgroundColor: bgColor,
      body: Semantics(
        label: AppLocalizations.of(context)?.appTitle ?? 'Glucosa',
        textDirection: TextDirection.ltr,
        child: Center(
          child: Image.asset(
            assetPath,
            width: 288,
            height: 288,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
