// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'estimated_hba1c_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Future provider calculating estimated HbA1c percentage from the average of all glucose readings.
///
/// Returns `null` if no glucose readings exist in the database.

@ProviderFor(estimatedHbA1c)
final estimatedHbA1cProvider = EstimatedHbA1cProvider._();

/// Future provider calculating estimated HbA1c percentage from the average of all glucose readings.
///
/// Returns `null` if no glucose readings exist in the database.

final class EstimatedHbA1cProvider
    extends $FunctionalProvider<AsyncValue<double?>, double?, FutureOr<double?>>
    with $FutureModifier<double?>, $FutureProvider<double?> {
  /// Future provider calculating estimated HbA1c percentage from the average of all glucose readings.
  ///
  /// Returns `null` if no glucose readings exist in the database.
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

String _$estimatedHbA1cHash() => r'5a929c29713080c63c64e308546e888cc0897f17';
