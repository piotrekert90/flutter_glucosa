// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hba1c_reading_list_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Riverpod state notifier managing the reactive stream of all HbA1c readings.

@ProviderFor(HbA1cReadingList)
final hbA1cReadingListProvider = HbA1cReadingListProvider._();

/// Riverpod state notifier managing the reactive stream of all HbA1c readings.
final class HbA1cReadingListProvider
    extends $StreamNotifierProvider<HbA1cReadingList, List<HbA1cReading>> {
  /// Riverpod state notifier managing the reactive stream of all HbA1c readings.
  HbA1cReadingListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'hbA1cReadingListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$hbA1cReadingListHash();

  @$internal
  @override
  HbA1cReadingList create() => HbA1cReadingList();
}

String _$hbA1cReadingListHash() => r'684cf10c09c73380f0c5e8fd4f7d2a987fa94fc1';

/// Riverpod state notifier managing the reactive stream of all HbA1c readings.

abstract class _$HbA1cReadingList extends $StreamNotifier<List<HbA1cReading>> {
  Stream<List<HbA1cReading>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<HbA1cReading>>, List<HbA1cReading>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<HbA1cReading>>, List<HbA1cReading>>,
              AsyncValue<List<HbA1cReading>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
