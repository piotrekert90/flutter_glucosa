import 'package:flutter/material.dart';

import '../../../../core/domain/enums/metric_type.dart';

/// Presentation state for data export configuration and progress.
class ExportState {
  /// Date range constraint for exported records, or null for all available records.
  final DateTimeRange? dateRange;

  /// Set of metric types selected for inclusion in the export.
  final Set<MetricType> selectedMetrics;

  /// Whether an export and share operation is currently in progress.
  final bool isExporting;

  /// Total count of records matching the current date range and selected metrics.
  final int matchingRecordCount;

  /// Optional error message from the most recent export attempt.
  final String? errorMessage;

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
    this.errorMessage,
  });

  /// Returns a copy of this state with updated properties.
  ExportState copyWith({
    DateTimeRange? dateRange,
    bool clearDateRange = false,
    Set<MetricType>? selectedMetrics,
    bool? isExporting,
    int? matchingRecordCount,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return ExportState(
      dateRange: clearDateRange ? null : (dateRange ?? this.dateRange),
      selectedMetrics: selectedMetrics ?? this.selectedMetrics,
      isExporting: isExporting ?? this.isExporting,
      matchingRecordCount: matchingRecordCount ?? this.matchingRecordCount,
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
    );
  }
}
