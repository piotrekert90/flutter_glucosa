// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'glucose_reading_list_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Riverpod state notifier managing the reactive stream of all glucose readings.

@ProviderFor(GlucoseReadingList)
final glucoseReadingListProvider = GlucoseReadingListProvider._();

/// Riverpod state notifier managing the reactive stream of all glucose readings.
final class GlucoseReadingListProvider
    extends $StreamNotifierProvider<GlucoseReadingList, List<GlucoseReading>> {
  /// Riverpod state notifier managing the reactive stream of all glucose readings.
  GlucoseReadingListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'glucoseReadingListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$glucoseReadingListHash();

  @$internal
  @override
  GlucoseReadingList create() => GlucoseReadingList();
}

String _$glucoseReadingListHash() =>
    r'aa1a7af0a20da1aa52b9556733560de837be9518';

/// Riverpod state notifier managing the reactive stream of all glucose readings.

abstract class _$GlucoseReadingList
    extends $StreamNotifier<List<GlucoseReading>> {
  Stream<List<GlucoseReading>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<List<GlucoseReading>>, List<GlucoseReading>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<GlucoseReading>>,
                List<GlucoseReading>
              >,
              AsyncValue<List<GlucoseReading>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
