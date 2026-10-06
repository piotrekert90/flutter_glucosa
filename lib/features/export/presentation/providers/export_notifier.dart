import 'dart:async';

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/domain/enums/metric_type.dart';
import '../../../settings/data/providers/user_profile_repository_provider.dart';
import '../../domain/models/date_range_filter.dart';
import '../../data/providers/export_service_provider.dart';
import 'export_state.dart';

part 'export_notifier.g.dart';

/// Riverpod state notifier managing data export configuration, metrics selection, and sharing.
@riverpod
class ExportNotifier extends _$ExportNotifier {
  int _countRequestId = 0;

  Future<void> _updateMatchingRecordCount({
    required DateTimeRange? dateRange,
    required Set<MetricType> metrics,
  }) async {
    final requestId = ++_countRequestId;
    final exportService = ref.read(exportServiceProvider);
    final count = await exportService.countRecords(
      dateRange: dateRange != null
          ? DateRangeFilter(start: dateRange.start, end: dateRange.end)
          : null,
      metrics: metrics,
    );
    if (requestId != _countRequestId) return;
    final current = state.value;
    if (current != null) {
      state = AsyncData(current.copyWith(matchingRecordCount: count));
    }
  }

  @override
  FutureOr<ExportState> build() async {
    final exportService = ref.watch(exportServiceProvider);
    final count = await exportService.countRecords(
      dateRange: null,
      metrics: MetricType.values.toSet(),
    );
    return ExportState(matchingRecordCount: count);
  }

  /// Sets the date range filter and recalculates matching record count.
  ///
  /// [range] The target boundary dates or null to include all records.
  Future<void> setDateRange(DateTimeRange? range) async {
    final current = state.value ?? const ExportState();

    state = AsyncData(
      current.copyWith(
        dateRange: range,
        clearDateRange: range == null,
        clearError: true,
      ),
    );

    await _updateMatchingRecordCount(
      dateRange: range,
      metrics: current.selectedMetrics,
    );
  }

  /// Toggles inclusion of a specific [metric] in the export dataset.
  ///
  /// [metric] The metric type to toggle on or off.
  Future<void> toggleMetric(MetricType metric) async {
    final current = state.value ?? const ExportState();
    final updated = Set<MetricType>.from(current.selectedMetrics);
    if (updated.contains(metric)) {
      updated.remove(metric);
    } else {
      updated.add(metric);
    }

    state = AsyncData(
      current.copyWith(selectedMetrics: updated, clearError: true),
    );

    await _updateMatchingRecordCount(
      dateRange: current.dateRange,
      metrics: updated,
    );
  }

  /// Selects or deselects all metric types at once.
  ///
  /// [selectAll] True to include all metric types, false to deselect all.
  Future<void> setSelectAllMetrics(bool selectAll) async {
    final current = state.value ?? const ExportState();
    final updated = selectAll ? MetricType.values.toSet() : <MetricType>{};

    state = AsyncData(
      current.copyWith(selectedMetrics: updated, clearError: true),
    );

    await _updateMatchingRecordCount(
      dateRange: current.dateRange,
      metrics: updated,
    );
  }

  /// Generates the CSV export and invokes the platform share sheet.
  ///
  /// Returns `true` if export initiated successfully, or `false` on error.
  Future<bool> exportAndShare() async {
    final current = state.value ?? const ExportState();
    if (current.selectedMetrics.isEmpty) {
      state = AsyncData(current.copyWith(error: ExportError.emptyMetrics));
      return false;
    }

    state = AsyncData(current.copyWith(isExporting: true, clearError: true));

    try {
      final exportService = ref.read(exportServiceProvider);
      final profile = await ref.read(userProfileRepositoryProvider).get();
      final dateRange = current.dateRange;
      await exportService.exportAndShare(
        dateRange: dateRange != null
            ? DateRangeFilter(start: dateRange.start, end: dateRange.end)
            : null,
        metrics: current.selectedMetrics,
        glucoseUnit: profile.preferredGlucoseUnit,
        hba1cUnit: profile.preferredHbA1cUnit,
        weightUnit: profile.preferredWeightUnit,
      );
      state = AsyncData(
        (state.value ?? current).copyWith(isExporting: false, clearError: true),
      );
      return true;
    } catch (e) {
      state = AsyncData(
        (state.value ?? current).copyWith(
          isExporting: false,
          error: ExportError.exportFailed,
          errorDetails: e.toString(),
        ),
      );
      return false;
    }
  }

  /// Sets a rolling date-range preset ending now.
  ///
  /// [days] Length of the window, or `null` to include all records.
  Future<void> setLastDaysPreset(int? days) async {
    if (days == null) {
      return setDateRange(null);
    }
    final now = DateTime.now();
    return setDateRange(
      DateTimeRange(
        start: now.subtract(Duration(days: days)),
        end: now,
      ),
    );
  }
}
