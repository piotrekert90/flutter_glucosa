// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hba1c_reading_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the singleton [HbA1cReadingRepository] implementation backed by Isar.

@ProviderFor(hbA1cReadingRepository)
final hbA1cReadingRepositoryProvider = HbA1cReadingRepositoryProvider._();

/// Provides the singleton [HbA1cReadingRepository] implementation backed by Isar.

final class HbA1cReadingRepositoryProvider
    extends
        $FunctionalProvider<
          HbA1cReadingRepository,
          HbA1cReadingRepository,
          HbA1cReadingRepository
        >
    with $Provider<HbA1cReadingRepository> {
  /// Provides the singleton [HbA1cReadingRepository] implementation backed by Isar.
  HbA1cReadingRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'hbA1cReadingRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$hbA1cReadingRepositoryHash();

  @$internal
  @override
  $ProviderElement<HbA1cReadingRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  HbA1cReadingRepository create(Ref ref) {
    return hbA1cReadingRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HbA1cReadingRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HbA1cReadingRepository>(value),
    );
  }
}

String _$hbA1cReadingRepositoryHash() =>
    r'380e8c02cb1ca1052ea951c756334a801b31c0d1';
