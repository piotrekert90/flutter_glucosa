// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blood_pressure_reading_detail_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Riverpod family notifier watching a single BP reading by its [id].

@ProviderFor(BloodPressureReadingDetail)
final bloodPressureReadingDetailProvider = BloodPressureReadingDetailFamily._();

/// Riverpod family notifier watching a single BP reading by its [id].
final class BloodPressureReadingDetailProvider
    extends
        $StreamNotifierProvider<
          BloodPressureReadingDetail,
          BloodPressureReading?
        > {
  /// Riverpod family notifier watching a single BP reading by its [id].
  BloodPressureReadingDetailProvider._({
    required BloodPressureReadingDetailFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'bloodPressureReadingDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$bloodPressureReadingDetailHash();

  @override
  String toString() {
    return r'bloodPressureReadingDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  BloodPressureReadingDetail create() => BloodPressureReadingDetail();

  @override
  bool operator ==(Object other) {
    return other is BloodPressureReadingDetailProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$bloodPressureReadingDetailHash() =>
    r'14ff4530b8d7a419870075a3147e4994d293cc40';

/// Riverpod family notifier watching a single BP reading by its [id].

final class BloodPressureReadingDetailFamily extends $Family
    with
        $ClassFamilyOverride<
          BloodPressureReadingDetail,
          AsyncValue<BloodPressureReading?>,
          BloodPressureReading?,
          Stream<BloodPressureReading?>,
          int
        > {
  BloodPressureReadingDetailFamily._()
    : super(
        retry: null,
        name: r'bloodPressureReadingDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Riverpod family notifier watching a single BP reading by its [id].

  BloodPressureReadingDetailProvider call(int id) =>
      BloodPressureReadingDetailProvider._(argument: id, from: this);

  @override
  String toString() => r'bloodPressureReadingDetailProvider';
}

/// Riverpod family notifier watching a single BP reading by its [id].

abstract class _$BloodPressureReadingDetail
    extends $StreamNotifier<BloodPressureReading?> {
  late final _$args = ref.$arg as int;
  int get id => _$args;

  Stream<BloodPressureReading?> build(int id);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<BloodPressureReading?>, BloodPressureReading?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<BloodPressureReading?>,
                BloodPressureReading?
              >,
              AsyncValue<BloodPressureReading?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
