// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ketone_reading_detail_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Riverpod family notifier watching a single ketone reading by its [id].

@ProviderFor(KetoneReadingDetail)
final ketoneReadingDetailProvider = KetoneReadingDetailFamily._();

/// Riverpod family notifier watching a single ketone reading by its [id].
final class KetoneReadingDetailProvider
    extends $StreamNotifierProvider<KetoneReadingDetail, KetoneReading?> {
  /// Riverpod family notifier watching a single ketone reading by its [id].
  KetoneReadingDetailProvider._({
    required KetoneReadingDetailFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'ketoneReadingDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$ketoneReadingDetailHash();

  @override
  String toString() {
    return r'ketoneReadingDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  KetoneReadingDetail create() => KetoneReadingDetail();

  @override
  bool operator ==(Object other) {
    return other is KetoneReadingDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$ketoneReadingDetailHash() =>
    r'3e85f7ff4db4b2a832a80678d9a65de6812ccf20';

/// Riverpod family notifier watching a single ketone reading by its [id].

final class KetoneReadingDetailFamily extends $Family
    with
        $ClassFamilyOverride<
          KetoneReadingDetail,
          AsyncValue<KetoneReading?>,
          KetoneReading?,
          Stream<KetoneReading?>,
          int
        > {
  KetoneReadingDetailFamily._()
    : super(
        retry: null,
        name: r'ketoneReadingDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Riverpod family notifier watching a single ketone reading by its [id].

  KetoneReadingDetailProvider call(int id) =>
      KetoneReadingDetailProvider._(argument: id, from: this);

  @override
  String toString() => r'ketoneReadingDetailProvider';
}

/// Riverpod family notifier watching a single ketone reading by its [id].

abstract class _$KetoneReadingDetail extends $StreamNotifier<KetoneReading?> {
  late final _$args = ref.$arg as int;
  int get id => _$args;

  Stream<KetoneReading?> build(int id);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<KetoneReading?>, KetoneReading?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<KetoneReading?>, KetoneReading?>,
              AsyncValue<KetoneReading?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
