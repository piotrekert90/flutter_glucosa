// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blood_pressure_reading_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the singleton [BloodPressureReadingRepository] implementation backed by Isar.

@ProviderFor(bloodPressureReadingRepository)
final bloodPressureReadingRepositoryProvider =
    BloodPressureReadingRepositoryProvider._();

/// Provides the singleton [BloodPressureReadingRepository] implementation backed by Isar.

final class BloodPressureReadingRepositoryProvider
    extends
        $FunctionalProvider<
          BloodPressureReadingRepository,
          BloodPressureReadingRepository,
          BloodPressureReadingRepository
        >
    with $Provider<BloodPressureReadingRepository> {
  /// Provides the singleton [BloodPressureReadingRepository] implementation backed by Isar.
  BloodPressureReadingRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bloodPressureReadingRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bloodPressureReadingRepositoryHash();

  @$internal
  @override
  $ProviderElement<BloodPressureReadingRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  BloodPressureReadingRepository create(Ref ref) {
    return bloodPressureReadingRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BloodPressureReadingRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BloodPressureReadingRepository>(
        value,
      ),
    );
  }
}

String _$bloodPressureReadingRepositoryHash() =>
    r'676c68e7c72659438c20d7fe4770facfdb1ffa15';
