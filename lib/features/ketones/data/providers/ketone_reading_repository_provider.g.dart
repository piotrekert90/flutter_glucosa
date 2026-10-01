// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ketone_reading_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the singleton [KetoneReadingRepository] implementation backed by Isar.

@ProviderFor(ketoneReadingRepository)
final ketoneReadingRepositoryProvider = KetoneReadingRepositoryProvider._();

/// Provides the singleton [KetoneReadingRepository] implementation backed by Isar.

final class KetoneReadingRepositoryProvider
    extends
        $FunctionalProvider<
          KetoneReadingRepository,
          KetoneReadingRepository,
          KetoneReadingRepository
        >
    with $Provider<KetoneReadingRepository> {
  /// Provides the singleton [KetoneReadingRepository] implementation backed by Isar.
  KetoneReadingRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ketoneReadingRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ketoneReadingRepositoryHash();

  @$internal
  @override
  $ProviderElement<KetoneReadingRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  KetoneReadingRepository create(Ref ref) {
    return ketoneReadingRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(KetoneReadingRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<KetoneReadingRepository>(value),
    );
  }
}

String _$ketoneReadingRepositoryHash() =>
    r'd641adb3011efed83c2207fc8ce519804cfcf12c';
