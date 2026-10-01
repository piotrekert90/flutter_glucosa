// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weight_reading_detail_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Riverpod family notifier watching a single weight reading by its [id].

@ProviderFor(WeightReadingDetail)
final weightReadingDetailProvider = WeightReadingDetailFamily._();

/// Riverpod family notifier watching a single weight reading by its [id].
final class WeightReadingDetailProvider
    extends $StreamNotifierProvider<WeightReadingDetail, WeightReading?> {
  /// Riverpod family notifier watching a single weight reading by its [id].
  WeightReadingDetailProvider._({
    required WeightReadingDetailFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'weightReadingDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$weightReadingDetailHash();

  @override
  String toString() {
    return r'weightReadingDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  WeightReadingDetail create() => WeightReadingDetail();

  @override
  bool operator ==(Object other) {
    return other is WeightReadingDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$weightReadingDetailHash() =>
    r'78d5c17deead446b05655a826aecda01b1c32eff';

/// Riverpod family notifier watching a single weight reading by its [id].

final class WeightReadingDetailFamily extends $Family
    with
        $ClassFamilyOverride<
          WeightReadingDetail,
          AsyncValue<WeightReading?>,
          WeightReading?,
          Stream<WeightReading?>,
          int
        > {
  WeightReadingDetailFamily._()
    : super(
        retry: null,
        name: r'weightReadingDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Riverpod family notifier watching a single weight reading by its [id].

  WeightReadingDetailProvider call(int id) =>
      WeightReadingDetailProvider._(argument: id, from: this);

  @override
  String toString() => r'weightReadingDetailProvider';
}

/// Riverpod family notifier watching a single weight reading by its [id].

abstract class _$WeightReadingDetail extends $StreamNotifier<WeightReading?> {
  late final _$args = ref.$arg as int;
  int get id => _$args;

  Stream<WeightReading?> build(int id);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<WeightReading?>, WeightReading?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<WeightReading?>, WeightReading?>,
              AsyncValue<WeightReading?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
