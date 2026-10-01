// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blood_pressure_reading_list_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Riverpod state notifier managing the reactive stream of all BP readings.

@ProviderFor(BloodPressureReadingList)
final bloodPressureReadingListProvider = BloodPressureReadingListProvider._();

/// Riverpod state notifier managing the reactive stream of all BP readings.
final class BloodPressureReadingListProvider
    extends
        $StreamNotifierProvider<
          BloodPressureReadingList,
          List<BloodPressureReading>
        > {
  /// Riverpod state notifier managing the reactive stream of all BP readings.
  BloodPressureReadingListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bloodPressureReadingListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bloodPressureReadingListHash();

  @$internal
  @override
  BloodPressureReadingList create() => BloodPressureReadingList();
}

String _$bloodPressureReadingListHash() =>
    r'bedbb2ea723b2fe398ddb13a6d548e6f052a071e';

/// Riverpod state notifier managing the reactive stream of all BP readings.

abstract class _$BloodPressureReadingList
    extends $StreamNotifier<List<BloodPressureReading>> {
  Stream<List<BloodPressureReading>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<BloodPressureReading>>,
              List<BloodPressureReading>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<BloodPressureReading>>,
                List<BloodPressureReading>
              >,
              AsyncValue<List<BloodPressureReading>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
