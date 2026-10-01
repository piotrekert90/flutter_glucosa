// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hba1c_reading_detail_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Riverpod family notifier watching a single HbA1c reading by its [id].

@ProviderFor(HbA1cReadingDetail)
final hbA1cReadingDetailProvider = HbA1cReadingDetailFamily._();

/// Riverpod family notifier watching a single HbA1c reading by its [id].
final class HbA1cReadingDetailProvider
    extends $StreamNotifierProvider<HbA1cReadingDetail, HbA1cReading?> {
  /// Riverpod family notifier watching a single HbA1c reading by its [id].
  HbA1cReadingDetailProvider._({
    required HbA1cReadingDetailFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'hbA1cReadingDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$hbA1cReadingDetailHash();

  @override
  String toString() {
    return r'hbA1cReadingDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  HbA1cReadingDetail create() => HbA1cReadingDetail();

  @override
  bool operator ==(Object other) {
    return other is HbA1cReadingDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$hbA1cReadingDetailHash() =>
    r'f15c42a5bf2591be1b913e35f5fe9eb545bdfb5c';

/// Riverpod family notifier watching a single HbA1c reading by its [id].

final class HbA1cReadingDetailFamily extends $Family
    with
        $ClassFamilyOverride<
          HbA1cReadingDetail,
          AsyncValue<HbA1cReading?>,
          HbA1cReading?,
          Stream<HbA1cReading?>,
          int
        > {
  HbA1cReadingDetailFamily._()
    : super(
        retry: null,
        name: r'hbA1cReadingDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Riverpod family notifier watching a single HbA1c reading by its [id].

  HbA1cReadingDetailProvider call(int id) =>
      HbA1cReadingDetailProvider._(argument: id, from: this);

  @override
  String toString() => r'hbA1cReadingDetailProvider';
}

/// Riverpod family notifier watching a single HbA1c reading by its [id].

abstract class _$HbA1cReadingDetail extends $StreamNotifier<HbA1cReading?> {
  late final _$args = ref.$arg as int;
  int get id => _$args;

  Stream<HbA1cReading?> build(int id);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<HbA1cReading?>, HbA1cReading?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<HbA1cReading?>, HbA1cReading?>,
              AsyncValue<HbA1cReading?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
