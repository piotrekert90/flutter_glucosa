import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/presentation/widgets/app_startup_widget.dart';
import 'core/providers/app_provider_observer.dart';
import 'core/utils/crash_reporter.dart';

/// Main entrypoint function for the application.
///
/// Configures edge-to-edge system overlays, diagnostics error hooks, and launches
/// [AppStartupWidget] inside the root [ProviderScope] with [AppProviderObserver].
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configure true edge-to-edge mode and transparent system overlays for modern devices.
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    ),
  );

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    AppCrashReporter.recordError(
      details.exception,
      details.stack,
      reason: 'FlutterError: ${details.context?.toDescription()}',
      fatal: true,
    );
  };

  ui.PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    AppCrashReporter.recordError(
      error,
      stack,
      reason: 'Unhandled asynchronous platform error',
      fatal: true,
    );
    return true;
  };

  runApp(
    ProviderScope(
      observers: const [AppProviderObserver()],
      child: AppStartupWidget(onLoaded: (context) => const App()),
    ),
  );
}
