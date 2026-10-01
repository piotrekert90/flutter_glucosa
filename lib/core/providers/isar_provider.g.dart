// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'isar_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Asynchronously initializes and provides the singleton [Isar] database instance.

@ProviderFor(isarDb)
final isarDbProvider = IsarDbProvider._();

/// Asynchronously initializes and provides the singleton [Isar] database instance.

final class IsarDbProvider
    extends $FunctionalProvider<AsyncValue<Isar>, Isar, FutureOr<Isar>>
    with $FutureModifier<Isar>, $FutureProvider<Isar> {
  /// Asynchronously initializes and provides the singleton [Isar] database instance.
  IsarDbProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isarDbProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isarDbHash();

  @$internal
  @override
  $FutureProviderElement<Isar> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Isar> create(Ref ref) {
    return isarDb(ref);
  }
}

String _$isarDbHash() => r'03d3b50ad77f93c6796506e7248504a3a8a0d9c0';

/// Provides the synchronous [Isar] database instance for repositories.
///
/// Pre-warmed during application startup by `appStartupProvider`.

@ProviderFor(isar)
final isarProvider = IsarProvider._();

/// Provides the synchronous [Isar] database instance for repositories.
///
/// Pre-warmed during application startup by `appStartupProvider`.

final class IsarProvider extends $FunctionalProvider<Isar, Isar, Isar>
    with $Provider<Isar> {
  /// Provides the synchronous [Isar] database instance for repositories.
  ///
  /// Pre-warmed during application startup by `appStartupProvider`.
  IsarProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isarProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isarHash();

  @$internal
  @override
  $ProviderElement<Isar> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Isar create(Ref ref) {
    return isar(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Isar value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Isar>(value),
    );
  }
}

String _$isarHash() => r'e2558ca561cf0ac6a53459cc7ba6623dc231a019';
