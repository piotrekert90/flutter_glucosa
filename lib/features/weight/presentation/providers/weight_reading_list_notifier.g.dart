// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weight_reading_list_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Riverpod state notifier managing the reactive stream of all weight readings.

@ProviderFor(WeightReadingList)
final weightReadingListProvider = WeightReadingListProvider._();

/// Riverpod state notifier managing the reactive stream of all weight readings.
final class WeightReadingListProvider
    extends $StreamNotifierProvider<WeightReadingList, List<WeightReading>> {
  /// Riverpod state notifier managing the reactive stream of all weight readings.
  WeightReadingListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'weightReadingListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$weightReadingListHash();

  @$internal
  @override
  WeightReadingList create() => WeightReadingList();
}

String _$weightReadingListHash() => r'1027765ddca68b1a5e22f0c0ff7c4c52d35800b0';

/// Riverpod state notifier managing the reactive stream of all weight readings.

abstract class _$WeightReadingList
    extends $StreamNotifier<List<WeightReading>> {
  Stream<List<WeightReading>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<WeightReading>>, List<WeightReading>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<WeightReading>>, List<WeightReading>>,
              AsyncValue<List<WeightReading>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
