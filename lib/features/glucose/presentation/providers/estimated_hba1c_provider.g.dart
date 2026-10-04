// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'estimated_hba1c_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Clock provider supplying the current timestamp, overridable in tests.

@ProviderFor(estimatedHbA1cClock)
final estimatedHbA1cClockProvider = EstimatedHbA1cClockProvider._();

/// Clock provider supplying the current timestamp, overridable in tests.

final class EstimatedHbA1cClockProvider
    extends $FunctionalProvider<DateTime, DateTime, DateTime>
    with $Provider<DateTime> {
  /// Clock provider supplying the current timestamp, overridable in tests.
  EstimatedHbA1cClockProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'estimatedHbA1cClockProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$estimatedHbA1cClockHash();

  @$internal
  @override
  $ProviderElement<DateTime> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DateTime create(Ref ref) {
    return estimatedHbA1cClock(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DateTime value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DateTime>(value),
    );
  }
}

String _$estimatedHbA1cClockHash() =>
    r'31ae7092e12caeb493c93a64f695cfef30620ff4';

/// Future provider calculating estimated HbA1c percentage from the 90-day average of glucose readings.
///
/// Returns `null` if fewer than [minReadingsForEstimatedHbA1c] readings exist within the last 90 days.

@ProviderFor(estimatedHbA1c)
final estimatedHbA1cProvider = EstimatedHbA1cProvider._();

/// Future provider calculating estimated HbA1c percentage from the 90-day average of glucose readings.
///
/// Returns `null` if fewer than [minReadingsForEstimatedHbA1c] readings exist within the last 90 days.

final class EstimatedHbA1cProvider
    extends $FunctionalProvider<AsyncValue<double?>, double?, FutureOr<double?>>
    with $FutureModifier<double?>, $FutureProvider<double?> {
  /// Future provider calculating estimated HbA1c percentage from the 90-day average of glucose readings.
  ///
  /// Returns `null` if fewer than [minReadingsForEstimatedHbA1c] readings exist within the last 90 days.
  EstimatedHbA1cProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'estimatedHbA1cProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$estimatedHbA1cHash();

  @$internal
  @override
  $FutureProviderElement<double?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<double?> create(Ref ref) {
    return estimatedHbA1c(ref);
  }
}

String _$estimatedHbA1cHash() => r'92165c08667a92d52243eaedb1a96c8b2de748b8';
