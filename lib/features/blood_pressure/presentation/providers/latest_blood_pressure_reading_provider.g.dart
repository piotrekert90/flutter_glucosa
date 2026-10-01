// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'latest_blood_pressure_reading_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Stream provider delivering the most recent [BloodPressureReading], or `null` if empty.

@ProviderFor(latestBloodPressureReading)
final latestBloodPressureReadingProvider =
    LatestBloodPressureReadingProvider._();

/// Stream provider delivering the most recent [BloodPressureReading], or `null` if empty.

final class LatestBloodPressureReadingProvider
    extends
        $FunctionalProvider<
          AsyncValue<BloodPressureReading?>,
          BloodPressureReading?,
          Stream<BloodPressureReading?>
        >
    with
        $FutureModifier<BloodPressureReading?>,
        $StreamProvider<BloodPressureReading?> {
  /// Stream provider delivering the most recent [BloodPressureReading], or `null` if empty.
  LatestBloodPressureReadingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'latestBloodPressureReadingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$latestBloodPressureReadingHash();

  @$internal
  @override
  $StreamProviderElement<BloodPressureReading?> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<BloodPressureReading?> create(Ref ref) {
    return latestBloodPressureReading(ref);
  }
}

String _$latestBloodPressureReadingHash() =>
    r'2e5f357b3f4be2e529cd872f229784c72c8aaa6a';
