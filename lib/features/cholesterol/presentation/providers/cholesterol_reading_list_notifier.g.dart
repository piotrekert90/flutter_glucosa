// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cholesterol_reading_list_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Riverpod state notifier managing the reactive stream of all cholesterol readings.

@ProviderFor(CholesterolReadingList)
final cholesterolReadingListProvider = CholesterolReadingListProvider._();

/// Riverpod state notifier managing the reactive stream of all cholesterol readings.
final class CholesterolReadingListProvider
    extends
        $StreamNotifierProvider<
          CholesterolReadingList,
          List<CholesterolReading>
        > {
  /// Riverpod state notifier managing the reactive stream of all cholesterol readings.
  CholesterolReadingListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cholesterolReadingListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cholesterolReadingListHash();

  @$internal
  @override
  CholesterolReadingList create() => CholesterolReadingList();
}

String _$cholesterolReadingListHash() =>
    r'7aa7bf8bfa390566d553194372a6fc52eb2b1ed7';

/// Riverpod state notifier managing the reactive stream of all cholesterol readings.

abstract class _$CholesterolReadingList
    extends $StreamNotifier<List<CholesterolReading>> {
  Stream<List<CholesterolReading>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<CholesterolReading>>,
              List<CholesterolReading>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<CholesterolReading>>,
                List<CholesterolReading>
              >,
              AsyncValue<List<CholesterolReading>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
