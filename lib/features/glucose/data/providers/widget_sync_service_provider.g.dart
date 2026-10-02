// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'widget_sync_service_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Dependency injection provider supplying the shared [WidgetSyncService].

@ProviderFor(widgetSyncService)
final widgetSyncServiceProvider = WidgetSyncServiceProvider._();

/// Dependency injection provider supplying the shared [WidgetSyncService].

final class WidgetSyncServiceProvider
    extends
        $FunctionalProvider<
          WidgetSyncService,
          WidgetSyncService,
          WidgetSyncService
        >
    with $Provider<WidgetSyncService> {
  /// Dependency injection provider supplying the shared [WidgetSyncService].
  WidgetSyncServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'widgetSyncServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$widgetSyncServiceHash();

  @$internal
  @override
  $ProviderElement<WidgetSyncService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  WidgetSyncService create(Ref ref) {
    return widgetSyncService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WidgetSyncService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WidgetSyncService>(value),
    );
  }
}

String _$widgetSyncServiceHash() => r'5f93f13897d22140977d1318fb81b06a75348a61';
