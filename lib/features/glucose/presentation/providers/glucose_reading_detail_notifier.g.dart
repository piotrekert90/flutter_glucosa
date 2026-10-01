// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'glucose_reading_detail_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Riverpod family notifier watching a single glucose reading by its [id].

@ProviderFor(GlucoseReadingDetail)
final glucoseReadingDetailProvider = GlucoseReadingDetailFamily._();

/// Riverpod family notifier watching a single glucose reading by its [id].
final class GlucoseReadingDetailProvider
    extends $StreamNotifierProvider<GlucoseReadingDetail, GlucoseReading?> {
  /// Riverpod family notifier watching a single glucose reading by its [id].
  GlucoseReadingDetailProvider._({
    required GlucoseReadingDetailFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'glucoseReadingDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$glucoseReadingDetailHash();

  @override
  String toString() {
    return r'glucoseReadingDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  GlucoseReadingDetail create() => GlucoseReadingDetail();

  @override
  bool operator ==(Object other) {
    return other is GlucoseReadingDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$glucoseReadingDetailHash() =>
    r'959b68df1cf98e9a5e53bfb94caaf397cfae0f49';

/// Riverpod family notifier watching a single glucose reading by its [id].

final class GlucoseReadingDetailFamily extends $Family
    with
        $ClassFamilyOverride<
          GlucoseReadingDetail,
          AsyncValue<GlucoseReading?>,
          GlucoseReading?,
          Stream<GlucoseReading?>,
          int
        > {
  GlucoseReadingDetailFamily._()
    : super(
        retry: null,
        name: r'glucoseReadingDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Riverpod family notifier watching a single glucose reading by its [id].

  GlucoseReadingDetailProvider call(int id) =>
      GlucoseReadingDetailProvider._(argument: id, from: this);

  @override
  String toString() => r'glucoseReadingDetailProvider';
}

/// Riverpod family notifier watching a single glucose reading by its [id].

abstract class _$GlucoseReadingDetail extends $StreamNotifier<GlucoseReading?> {
  late final _$args = ref.$arg as int;
  int get id => _$args;

  Stream<GlucoseReading?> build(int id);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<GlucoseReading?>, GlucoseReading?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<GlucoseReading?>, GlucoseReading?>,
              AsyncValue<GlucoseReading?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
