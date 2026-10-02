// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'export_service_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the singleton [ExportService] instance configured with all metric repositories.

@ProviderFor(exportService)
final exportServiceProvider = ExportServiceProvider._();

/// Provides the singleton [ExportService] instance configured with all metric repositories.

final class ExportServiceProvider
    extends $FunctionalProvider<ExportService, ExportService, ExportService>
    with $Provider<ExportService> {
  /// Provides the singleton [ExportService] instance configured with all metric repositories.
  ExportServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'exportServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$exportServiceHash();

  @$internal
  @override
  $ProviderElement<ExportService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ExportService create(Ref ref) {
    return exportService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ExportService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ExportService>(value),
    );
  }
}

String _$exportServiceHash() => r'b98528d726d19bd5c4edfb670717cdeb26cc0321';
