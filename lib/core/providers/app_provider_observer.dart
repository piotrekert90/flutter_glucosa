import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/app_logger.dart';

/// Riverpod provider lifecycle observer for diagnostic logging.
///
/// Dispatches provider additions, updates, disposals, and runtime errors to [AppLogger].
final class AppProviderObserver extends ProviderObserver {
  /// Creates an [AppProviderObserver].
  const AppProviderObserver();

  @override
  void didAddProvider(ProviderObserverContext context, Object? value) {
    AppLogger.debug(
      'Provider initialized: ${context.provider.name ?? context.provider.runtimeType}',
      tag: 'Riverpod',
    );
  }

  @override
  void didUpdateProvider(
    ProviderObserverContext context,
    Object? previousValue,
    Object? newValue,
  ) {
    AppLogger.debug(
      'Provider updated: ${context.provider.name ?? context.provider.runtimeType}',
      tag: 'Riverpod',
    );
  }

  @override
  void didDisposeProvider(ProviderObserverContext context) {
    AppLogger.debug(
      'Provider disposed: ${context.provider.name ?? context.provider.runtimeType}',
      tag: 'Riverpod',
    );
  }

  @override
  void providerDidFail(
    ProviderObserverContext context,
    Object error,
    StackTrace stackTrace,
  ) {
    AppLogger.error(
      'Provider failed: ${context.provider.name ?? context.provider.runtimeType}',
      tag: 'Riverpod',
      error: error,
      stackTrace: stackTrace,
    );
  }
}
