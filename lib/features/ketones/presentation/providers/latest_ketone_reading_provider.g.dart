// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'latest_ketone_reading_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Stream provider delivering the most recent [KetoneReading], or `null` if empty.

@ProviderFor(latestKetoneReading)
final latestKetoneReadingProvider = LatestKetoneReadingProvider._();

/// Stream provider delivering the most recent [KetoneReading], or `null` if empty.

final class LatestKetoneReadingProvider
    extends
        $FunctionalProvider<
          AsyncValue<KetoneReading?>,
          KetoneReading?,
          Stream<KetoneReading?>
        >
    with $FutureModifier<KetoneReading?>, $StreamProvider<KetoneReading?> {
  /// Stream provider delivering the most recent [KetoneReading], or `null` if empty.
  LatestKetoneReadingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'latestKetoneReadingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$latestKetoneReadingHash();

  @$internal
  @override
  $StreamProviderElement<KetoneReading?> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<KetoneReading?> create(Ref ref) {
    return latestKetoneReading(ref);
  }
}

String _$latestKetoneReadingHash() =>
    r'860e2100fff22d09cd6037921dc080b0c65120f1';
