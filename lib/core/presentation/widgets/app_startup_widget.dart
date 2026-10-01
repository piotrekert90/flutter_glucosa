import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../../providers/app_startup_provider.dart';
import '../theme/app_theme.dart';

/// Root initialization wrapper managing asynchronous service initialization state.
///
/// Watches [appStartupProvider] and renders [onLoaded] upon successful setup,
/// displaying a loading indicator or retryable error view during intermediate states.
class AppStartupWidget extends ConsumerWidget {
  /// Creates an initialization wrapper with an [onLoaded] child builder.
  const AppStartupWidget({super.key, required this.onLoaded});

  /// Widget builder executed when startup services are fully initialized.
  final WidgetBuilder onLoaded;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appStartupState = ref.watch(appStartupProvider);

    return appStartupState.when(
      data: (_) => onLoaded(context),
      loading: () => const AppStartupLoadingWidget(),
      error: (error, _) => AppStartupErrorWidget(
        message: error.toString(),
        onRetry: () => ref.invalidate(appStartupProvider),
      ),
    );
  }
}

/// Standalone loading screen displayed during asynchronous app initialization.
class AppStartupLoadingWidget extends StatelessWidget {
  /// Creates a standalone startup loading screen widget.
  const AppStartupLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: const Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}

/// Standalone error screen displayed when critical application startup services fail.
class AppStartupErrorWidget extends StatelessWidget {
  /// Creates an error screen displaying [message] with an [onRetry] callback.
  const AppStartupErrorWidget({
    super.key,
    required this.message,
    required this.onRetry,
  });

  /// The error description explaining the startup failure.
  final String message;

  /// Callback executed when the user taps the retry button.
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Builder(
        builder: (innerContext) {
          final l10n = AppLocalizations.of(innerContext);
          final colorScheme = Theme.of(innerContext).colorScheme;
          return Scaffold(
            body: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: colorScheme.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n?.initializationFailed ?? 'Initialization Failed',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      message,
                      style: TextStyle(
                        fontSize: 14,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: onRetry,
                      icon: const Icon(Icons.refresh),
                      label: Text(l10n?.tryAgain ?? 'Try again'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
