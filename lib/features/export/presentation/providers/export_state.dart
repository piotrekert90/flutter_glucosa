import '../../../../core/domain/enums/metric_type.dart';
import '../../domain/models/date_range_filter.dart';

/// Typed export failure allowing the UI to localize messages.
enum ExportError {
  /// Export attempted with no metrics selected.
  emptyMetrics,

  /// Export failed with an unexpected error (see [ExportState.errorDetails]).
  exportFailed,
}

/// Presentation state for data export configuration and progress.
class ExportState {
  /// Date range constraint for exported records, or null for all available records.
  final DateRangeFilter? dateRange;

  /// Set of metric types selected for inclusion in the export.
  final Set<MetricType> selectedMetrics;

  /// Whether an export and share operation is currently in progress.
  final bool isExporting;

  /// Total count of records matching the current date range and selected metrics.
  final int matchingRecordCount;

  /// Typed error from the most recent export attempt, if any.
  final ExportError? error;

  /// Raw detail for unexpected failures (logged, never shown raw to users).
  final String? errorDetails;

  /// Creates an immutable [ExportState].
  const ExportState({
    this.dateRange,
    this.selectedMetrics = const {
      MetricType.glucose,
      MetricType.hba1c,
      MetricType.bloodPressure,
      MetricType.ketones,
      MetricType.cholesterol,
      MetricType.weight,
    },
    this.isExporting = false,
    this.matchingRecordCount = 0,
    this.error,
    this.errorDetails,
  });

  /// Returns a copy of this state with updated properties.
  ExportState copyWith({
    DateRangeFilter? dateRange,
    bool clearDateRange = false,
    Set<MetricType>? selectedMetrics,
    bool? isExporting,
    int? matchingRecordCount,
    ExportError? error,
    String? errorDetails,
    bool clearError = false,
  }) {
    return ExportState(
      dateRange: clearDateRange ? null : (dateRange ?? this.dateRange),
      selectedMetrics: selectedMetrics ?? this.selectedMetrics,
      isExporting: isExporting ?? this.isExporting,
      matchingRecordCount: matchingRecordCount ?? this.matchingRecordCount,
      error: clearError ? null : (error ?? this.error),
      errorDetails: clearError ? null : (errorDetails ?? this.errorDetails),
    );
  }
}
