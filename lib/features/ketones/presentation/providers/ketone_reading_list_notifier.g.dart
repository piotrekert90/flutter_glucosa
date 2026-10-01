// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ketone_reading_list_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Riverpod state notifier managing the reactive stream of all ketone readings.

@ProviderFor(KetoneReadingList)
final ketoneReadingListProvider = KetoneReadingListProvider._();

/// Riverpod state notifier managing the reactive stream of all ketone readings.
final class KetoneReadingListProvider
    extends $StreamNotifierProvider<KetoneReadingList, List<KetoneReading>> {
  /// Riverpod state notifier managing the reactive stream of all ketone readings.
  KetoneReadingListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ketoneReadingListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ketoneReadingListHash();

  @$internal
  @override
  KetoneReadingList create() => KetoneReadingList();
}

String _$ketoneReadingListHash() => r'75d92d092cd13e5a3020063dda81b7cba83f6eb5';

/// Riverpod state notifier managing the reactive stream of all ketone readings.

abstract class _$KetoneReadingList
    extends $StreamNotifier<List<KetoneReading>> {
  Stream<List<KetoneReading>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<KetoneReading>>, List<KetoneReading>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<KetoneReading>>, List<KetoneReading>>,
              AsyncValue<List<KetoneReading>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
