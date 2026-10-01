// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'latest_weight_reading_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Stream provider delivering the most recent [WeightReading], or `null` if empty.

@ProviderFor(latestWeightReading)
final latestWeightReadingProvider = LatestWeightReadingProvider._();

/// Stream provider delivering the most recent [WeightReading], or `null` if empty.

final class LatestWeightReadingProvider
    extends
        $FunctionalProvider<
          AsyncValue<WeightReading?>,
          WeightReading?,
          Stream<WeightReading?>
        >
    with $FutureModifier<WeightReading?>, $StreamProvider<WeightReading?> {
  /// Stream provider delivering the most recent [WeightReading], or `null` if empty.
  LatestWeightReadingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'latestWeightReadingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$latestWeightReadingHash();

  @$internal
  @override
  $StreamProviderElement<WeightReading?> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<WeightReading?> create(Ref ref) {
    return latestWeightReading(ref);
  }
}

String _$latestWeightReadingHash() =>
    r'0274c807d94f7b1658ce9794d57de2035e68b13b';
