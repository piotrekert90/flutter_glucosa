// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'glucose_health_sync_coordinator_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Dependency injection provider supplying a [GlucoseHealthSyncCoordinator].

@ProviderFor(glucoseHealthSyncCoordinator)
final glucoseHealthSyncCoordinatorProvider =
    GlucoseHealthSyncCoordinatorProvider._();

/// Dependency injection provider supplying a [GlucoseHealthSyncCoordinator].

final class GlucoseHealthSyncCoordinatorProvider
    extends
        $FunctionalProvider<
          GlucoseHealthSyncCoordinator,
          GlucoseHealthSyncCoordinator,
          GlucoseHealthSyncCoordinator
        >
    with $Provider<GlucoseHealthSyncCoordinator> {
  /// Dependency injection provider supplying a [GlucoseHealthSyncCoordinator].
  GlucoseHealthSyncCoordinatorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'glucoseHealthSyncCoordinatorProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$glucoseHealthSyncCoordinatorHash();

  @$internal
  @override
  $ProviderElement<GlucoseHealthSyncCoordinator> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GlucoseHealthSyncCoordinator create(Ref ref) {
    return glucoseHealthSyncCoordinator(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GlucoseHealthSyncCoordinator value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GlucoseHealthSyncCoordinator>(value),
    );
  }
}

String _$glucoseHealthSyncCoordinatorHash() =>
    r'd0e3283dd2890c7e3d8fc9bd75b8bb37dadec250';
