// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'latest_hba1c_reading_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Stream provider delivering the most recent laboratory or recorded [HbA1cReading], or `null` if empty.

@ProviderFor(latestHbA1cReading)
final latestHbA1cReadingProvider = LatestHbA1cReadingProvider._();

/// Stream provider delivering the most recent laboratory or recorded [HbA1cReading], or `null` if empty.

final class LatestHbA1cReadingProvider
    extends
        $FunctionalProvider<
          AsyncValue<HbA1cReading?>,
          HbA1cReading?,
          Stream<HbA1cReading?>
        >
    with $FutureModifier<HbA1cReading?>, $StreamProvider<HbA1cReading?> {
  /// Stream provider delivering the most recent laboratory or recorded [HbA1cReading], or `null` if empty.
  LatestHbA1cReadingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'latestHbA1cReadingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$latestHbA1cReadingHash();

  @$internal
  @override
  $StreamProviderElement<HbA1cReading?> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<HbA1cReading?> create(Ref ref) {
    return latestHbA1cReading(ref);
  }
}

String _$latestHbA1cReadingHash() =>
    r'9e9141faa78ea1eb14ce646bbbf610fbc71dc189';
