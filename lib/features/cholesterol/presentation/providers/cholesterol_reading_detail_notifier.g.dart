// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cholesterol_reading_detail_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Riverpod family notifier watching a single cholesterol reading by its [id].

@ProviderFor(CholesterolReadingDetail)
final cholesterolReadingDetailProvider = CholesterolReadingDetailFamily._();

/// Riverpod family notifier watching a single cholesterol reading by its [id].
final class CholesterolReadingDetailProvider
    extends
        $StreamNotifierProvider<CholesterolReadingDetail, CholesterolReading?> {
  /// Riverpod family notifier watching a single cholesterol reading by its [id].
  CholesterolReadingDetailProvider._({
    required CholesterolReadingDetailFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'cholesterolReadingDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$cholesterolReadingDetailHash();

  @override
  String toString() {
    return r'cholesterolReadingDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  CholesterolReadingDetail create() => CholesterolReadingDetail();

  @override
  bool operator ==(Object other) {
    return other is CholesterolReadingDetailProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$cholesterolReadingDetailHash() =>
    r'92a1b75cc908ae70d330e7e992cb603ea27fbb5e';

/// Riverpod family notifier watching a single cholesterol reading by its [id].

final class CholesterolReadingDetailFamily extends $Family
    with
        $ClassFamilyOverride<
          CholesterolReadingDetail,
          AsyncValue<CholesterolReading?>,
          CholesterolReading?,
          Stream<CholesterolReading?>,
          int
        > {
  CholesterolReadingDetailFamily._()
    : super(
        retry: null,
        name: r'cholesterolReadingDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Riverpod family notifier watching a single cholesterol reading by its [id].

  CholesterolReadingDetailProvider call(int id) =>
      CholesterolReadingDetailProvider._(argument: id, from: this);

  @override
  String toString() => r'cholesterolReadingDetailProvider';
}

/// Riverpod family notifier watching a single cholesterol reading by its [id].

abstract class _$CholesterolReadingDetail
    extends $StreamNotifier<CholesterolReading?> {
  late final _$args = ref.$arg as int;
  int get id => _$args;

  Stream<CholesterolReading?> build(int id);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<CholesterolReading?>, CholesterolReading?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<CholesterolReading?>, CholesterolReading?>,
              AsyncValue<CholesterolReading?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
