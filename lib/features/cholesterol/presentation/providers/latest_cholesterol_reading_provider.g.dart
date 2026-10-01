// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'latest_cholesterol_reading_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Stream provider delivering the most recent [CholesterolReading], or `null` if empty.

@ProviderFor(latestCholesterolReading)
final latestCholesterolReadingProvider = LatestCholesterolReadingProvider._();

/// Stream provider delivering the most recent [CholesterolReading], or `null` if empty.

final class LatestCholesterolReadingProvider
    extends
        $FunctionalProvider<
          AsyncValue<CholesterolReading?>,
          CholesterolReading?,
          Stream<CholesterolReading?>
        >
    with
        $FutureModifier<CholesterolReading?>,
        $StreamProvider<CholesterolReading?> {
  /// Stream provider delivering the most recent [CholesterolReading], or `null` if empty.
  LatestCholesterolReadingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'latestCholesterolReadingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$latestCholesterolReadingHash();

  @$internal
  @override
  $StreamProviderElement<CholesterolReading?> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<CholesterolReading?> create(Ref ref) {
    return latestCholesterolReading(ref);
  }
}

String _$latestCholesterolReadingHash() =>
    r'c8cdb8e974130b4a3eafaeb28b70406be1d4bea7';
