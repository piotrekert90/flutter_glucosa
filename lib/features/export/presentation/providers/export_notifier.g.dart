// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'export_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Riverpod state notifier managing data export configuration, metrics selection, and sharing.

@ProviderFor(ExportNotifier)
final exportProvider = ExportNotifierProvider._();

/// Riverpod state notifier managing data export configuration, metrics selection, and sharing.
final class ExportNotifierProvider
    extends $AsyncNotifierProvider<ExportNotifier, ExportState> {
  /// Riverpod state notifier managing data export configuration, metrics selection, and sharing.
  ExportNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'exportProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$exportNotifierHash();

  @$internal
  @override
  ExportNotifier create() => ExportNotifier();
}

String _$exportNotifierHash() => r'ee5fd42cf44419a5dac9955d0c5ee84f07872a2c';

/// Riverpod state notifier managing data export configuration, metrics selection, and sharing.

abstract class _$ExportNotifier extends $AsyncNotifier<ExportState> {
  FutureOr<ExportState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<ExportState>, ExportState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ExportState>, ExportState>,
              AsyncValue<ExportState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
