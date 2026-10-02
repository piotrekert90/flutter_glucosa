// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'widget_sync_observer.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Observer pushing glucose updates to native home screen widgets.
///
/// Listens to the glucose readings stream and user profile changes, keeping
/// WidgetKit / AppWidget payloads fresh after every write, edit, or delete.
/// Labels are resolved through [lookupAppLocalizations] using the platform
/// locale, so no [BuildContext] is required. Kept alive by [App].

@ProviderFor(WidgetSyncObserver)
final widgetSyncObserverProvider = WidgetSyncObserverProvider._();

/// Observer pushing glucose updates to native home screen widgets.
///
/// Listens to the glucose readings stream and user profile changes, keeping
/// WidgetKit / AppWidget payloads fresh after every write, edit, or delete.
/// Labels are resolved through [lookupAppLocalizations] using the platform
/// locale, so no [BuildContext] is required. Kept alive by [App].
final class WidgetSyncObserverProvider
    extends $AsyncNotifierProvider<WidgetSyncObserver, void> {
  /// Observer pushing glucose updates to native home screen widgets.
  ///
  /// Listens to the glucose readings stream and user profile changes, keeping
  /// WidgetKit / AppWidget payloads fresh after every write, edit, or delete.
  /// Labels are resolved through [lookupAppLocalizations] using the platform
  /// locale, so no [BuildContext] is required. Kept alive by [App].
  WidgetSyncObserverProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'widgetSyncObserverProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$widgetSyncObserverHash();

  @$internal
  @override
  WidgetSyncObserver create() => WidgetSyncObserver();
}

String _$widgetSyncObserverHash() =>
    r'7ba8915a66ddaa307e1ce2c7893b816863572bb4';

/// Observer pushing glucose updates to native home screen widgets.
///
/// Listens to the glucose readings stream and user profile changes, keeping
/// WidgetKit / AppWidget payloads fresh after every write, edit, or delete.
/// Labels are resolved through [lookupAppLocalizations] using the platform
/// locale, so no [BuildContext] is required. Kept alive by [App].

abstract class _$WidgetSyncObserver extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
