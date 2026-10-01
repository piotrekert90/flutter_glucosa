// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weight_reading_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the singleton [WeightReadingRepository] implementation backed by Isar.

@ProviderFor(weightReadingRepository)
final weightReadingRepositoryProvider = WeightReadingRepositoryProvider._();

/// Provides the singleton [WeightReadingRepository] implementation backed by Isar.

final class WeightReadingRepositoryProvider
    extends
        $FunctionalProvider<
          WeightReadingRepository,
          WeightReadingRepository,
          WeightReadingRepository
        >
    with $Provider<WeightReadingRepository> {
  /// Provides the singleton [WeightReadingRepository] implementation backed by Isar.
  WeightReadingRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'weightReadingRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$weightReadingRepositoryHash();

  @$internal
  @override
  $ProviderElement<WeightReadingRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  WeightReadingRepository create(Ref ref) {
    return weightReadingRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WeightReadingRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WeightReadingRepository>(value),
    );
  }
}

String _$weightReadingRepositoryHash() =>
    r'b7b20b4851974162efaa8bea8d31581b2a80df90';
