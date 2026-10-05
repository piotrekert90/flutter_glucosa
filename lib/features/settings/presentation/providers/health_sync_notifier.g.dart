// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_sync_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Riverpod notifier encapsulating platform health-store sync orchestration.
///
/// Keeps data-layer coordination (permission checks, sync passes, profile
/// timestamp updates) out of widgets so [HealthSyncSection] only renders
/// state and forwards user events.

@ProviderFor(HealthSync)
final healthSyncProvider = HealthSyncProvider._();

/// Riverpod notifier encapsulating platform health-store sync orchestration.
///
/// Keeps data-layer coordination (permission checks, sync passes, profile
/// timestamp updates) out of widgets so [HealthSyncSection] only renders
/// state and forwards user events.
final class HealthSyncProvider
    extends $NotifierProvider<HealthSync, HealthSyncUiState> {
  /// Riverpod notifier encapsulating platform health-store sync orchestration.
  ///
  /// Keeps data-layer coordination (permission checks, sync passes, profile
  /// timestamp updates) out of widgets so [HealthSyncSection] only renders
  /// state and forwards user events.
  HealthSyncProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'healthSyncProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$healthSyncHash();

  @$internal
  @override
  HealthSync create() => HealthSync();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HealthSyncUiState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HealthSyncUiState>(value),
    );
  }
}

String _$healthSyncHash() => r'ce5d1c40631a8695a0c03642ac346bc6e9479b99';

/// Riverpod notifier encapsulating platform health-store sync orchestration.
///
/// Keeps data-layer coordination (permission checks, sync passes, profile
/// timestamp updates) out of widgets so [HealthSyncSection] only renders
/// state and forwards user events.

abstract class _$HealthSync extends $Notifier<HealthSyncUiState> {
  HealthSyncUiState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<HealthSyncUiState, HealthSyncUiState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<HealthSyncUiState, HealthSyncUiState>,
              HealthSyncUiState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
