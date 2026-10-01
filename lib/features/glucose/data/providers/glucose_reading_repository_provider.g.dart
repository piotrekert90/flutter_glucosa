// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'glucose_reading_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Dependency injection provider supplying a [GlucoseReadingRepository] instance.

@ProviderFor(glucoseReadingRepository)
final glucoseReadingRepositoryProvider = GlucoseReadingRepositoryProvider._();

/// Dependency injection provider supplying a [GlucoseReadingRepository] instance.

final class GlucoseReadingRepositoryProvider
    extends
        $FunctionalProvider<
          GlucoseReadingRepository,
          GlucoseReadingRepository,
          GlucoseReadingRepository
        >
    with $Provider<GlucoseReadingRepository> {
  /// Dependency injection provider supplying a [GlucoseReadingRepository] instance.
  GlucoseReadingRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'glucoseReadingRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$glucoseReadingRepositoryHash();

  @$internal
  @override
  $ProviderElement<GlucoseReadingRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GlucoseReadingRepository create(Ref ref) {
    return glucoseReadingRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GlucoseReadingRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GlucoseReadingRepository>(value),
    );
  }
}

String _$glucoseReadingRepositoryHash() =>
    r'1ad9375cd77c4ad554fda6e4c42dfd15e00323b3';
