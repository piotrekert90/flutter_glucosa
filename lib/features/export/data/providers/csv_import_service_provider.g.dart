// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'csv_import_service_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Dependency injection provider supplying a [CsvGlucoseImportService] instance.

@ProviderFor(csvGlucoseImportService)
final csvGlucoseImportServiceProvider = CsvGlucoseImportServiceProvider._();

/// Dependency injection provider supplying a [CsvGlucoseImportService] instance.

final class CsvGlucoseImportServiceProvider
    extends
        $FunctionalProvider<
          CsvGlucoseImportService,
          CsvGlucoseImportService,
          CsvGlucoseImportService
        >
    with $Provider<CsvGlucoseImportService> {
  /// Dependency injection provider supplying a [CsvGlucoseImportService] instance.
  CsvGlucoseImportServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'csvGlucoseImportServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$csvGlucoseImportServiceHash();

  @$internal
  @override
  $ProviderElement<CsvGlucoseImportService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CsvGlucoseImportService create(Ref ref) {
    return csvGlucoseImportService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CsvGlucoseImportService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CsvGlucoseImportService>(value),
    );
  }
}

String _$csvGlucoseImportServiceHash() =>
    r'9eea59b4e5d972b7785a03b40a4a6f232b32c431';
