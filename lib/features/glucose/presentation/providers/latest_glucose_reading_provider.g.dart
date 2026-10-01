// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'latest_glucose_reading_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Stream provider delivering the most recent [GlucoseReading], or `null` if no readings exist.

@ProviderFor(latestGlucoseReading)
final latestGlucoseReadingProvider = LatestGlucoseReadingProvider._();

/// Stream provider delivering the most recent [GlucoseReading], or `null` if no readings exist.

final class LatestGlucoseReadingProvider
    extends
        $FunctionalProvider<
          AsyncValue<GlucoseReading?>,
          GlucoseReading?,
          Stream<GlucoseReading?>
        >
    with $FutureModifier<GlucoseReading?>, $StreamProvider<GlucoseReading?> {
  /// Stream provider delivering the most recent [GlucoseReading], or `null` if no readings exist.
  LatestGlucoseReadingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'latestGlucoseReadingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$latestGlucoseReadingHash();

  @$internal
  @override
  $StreamProviderElement<GlucoseReading?> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<GlucoseReading?> create(Ref ref) {
    return latestGlucoseReading(ref);
  }
}

String _$latestGlucoseReadingHash() =>
    r'cad7de96b99cd5d58410c0f25dcbe131bcf9f3d2';
