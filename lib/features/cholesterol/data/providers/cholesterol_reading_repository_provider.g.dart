// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cholesterol_reading_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the singleton [CholesterolReadingRepository] implementation backed by Isar.

@ProviderFor(cholesterolReadingRepository)
final cholesterolReadingRepositoryProvider =
    CholesterolReadingRepositoryProvider._();

/// Provides the singleton [CholesterolReadingRepository] implementation backed by Isar.

final class CholesterolReadingRepositoryProvider
    extends
        $FunctionalProvider<
          CholesterolReadingRepository,
          CholesterolReadingRepository,
          CholesterolReadingRepository
        >
    with $Provider<CholesterolReadingRepository> {
  /// Provides the singleton [CholesterolReadingRepository] implementation backed by Isar.
  CholesterolReadingRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cholesterolReadingRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cholesterolReadingRepositoryHash();

  @$internal
  @override
  $ProviderElement<CholesterolReadingRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CholesterolReadingRepository create(Ref ref) {
    return cholesterolReadingRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CholesterolReadingRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CholesterolReadingRepository>(value),
    );
  }
}

String _$cholesterolReadingRepositoryHash() =>
    r'74568d17483716740b97af5b2999fa67a0d70e1a';
