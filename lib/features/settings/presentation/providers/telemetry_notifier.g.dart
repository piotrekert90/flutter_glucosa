// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'telemetry_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Riverpod notifier exposing the diagnostics collection consent flag.
///
/// Backed by [TelemetrySettings] (SharedPreferences) so the toggle works
/// before Firebase initializes and survives Isar data wipes.

@ProviderFor(Telemetry)
final telemetryProvider = TelemetryProvider._();

/// Riverpod notifier exposing the diagnostics collection consent flag.
///
/// Backed by [TelemetrySettings] (SharedPreferences) so the toggle works
/// before Firebase initializes and survives Isar data wipes.
final class TelemetryProvider extends $NotifierProvider<Telemetry, bool> {
  /// Riverpod notifier exposing the diagnostics collection consent flag.
  ///
  /// Backed by [TelemetrySettings] (SharedPreferences) so the toggle works
  /// before Firebase initializes and survives Isar data wipes.
  TelemetryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'telemetryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$telemetryHash();

  @$internal
  @override
  Telemetry create() => Telemetry();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$telemetryHash() => r'f6faa9f174ec093673ff980f48d52813e925b7ce';

/// Riverpod notifier exposing the diagnostics collection consent flag.
///
/// Backed by [TelemetrySettings] (SharedPreferences) so the toggle works
/// before Firebase initializes and survives Isar data wipes.

abstract class _$Telemetry extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
