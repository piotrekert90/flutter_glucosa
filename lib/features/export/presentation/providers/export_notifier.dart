import 'dart:async';

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/domain/enums/metric_type.dart';
import '../../../settings/data/providers/user_profile_repository_provider.dart';
import 'export_service_provider.dart';
import 'export_state.dart';

part 'export_notifier.g.dart';

/// Riverpod state notifier managing data export configuration, metrics selection, and sharing.
@riverpod
class ExportNotifier extends _$ExportNotifier {
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
    final exportService = ref.read(exportServiceProvider);

    state = AsyncData(
      current.copyWith(
        dateRange: range,
        clearDateRange: range == null,
        clearErrorMessage: true,
      ),
    );

    final count = await exportService.countRecords(
      dateRange: range,
      metrics: current.selectedMetrics,
    );

    state = AsyncData(
      (state.value ?? current).copyWith(matchingRecordCount: count),
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

    final exportService = ref.read(exportServiceProvider);

    state = AsyncData(
      current.copyWith(selectedMetrics: updated, clearErrorMessage: true),
    );

    final count = await exportService.countRecords(
      dateRange: current.dateRange,
      metrics: updated,
    );

    state = AsyncData(
      (state.value ?? current).copyWith(matchingRecordCount: count),
    );
  }

  /// Selects or deselects all metric types at once.
  ///
  /// [selectAll] True to include all metric types, false to deselect all.
  Future<void> setSelectAllMetrics(bool selectAll) async {
    final current = state.value ?? const ExportState();
    final updated = selectAll ? MetricType.values.toSet() : <MetricType>{};
    final exportService = ref.read(exportServiceProvider);

    state = AsyncData(
      current.copyWith(selectedMetrics: updated, clearErrorMessage: true),
    );

    final count = await exportService.countRecords(
      dateRange: current.dateRange,
      metrics: updated,
    );

    state = AsyncData(
      (state.value ?? current).copyWith(matchingRecordCount: count),
    );
  }

  /// Generates the CSV export and invokes the platform share sheet.
  ///
  /// Returns `true` if export initiated successfully, or `false` on error.
  Future<bool> exportAndShare() async {
    final current = state.value ?? const ExportState();
    if (current.selectedMetrics.isEmpty) {
      state = AsyncData(
        current.copyWith(errorMessage: 'Select at least one metric to export.'),
      );
      return false;
    }

    state = AsyncData(
      current.copyWith(isExporting: true, clearErrorMessage: true),
    );

    try {
      final exportService = ref.read(exportServiceProvider);
      final profile = await ref.read(userProfileRepositoryProvider).get();
      await exportService.exportAndShare(
        dateRange: current.dateRange,
        metrics: current.selectedMetrics,
        glucoseUnit: profile.preferredGlucoseUnit,
        hba1cUnit: profile.preferredHbA1cUnit,
        weightUnit: profile.preferredWeightUnit,
      );
      state = AsyncData(
        (state.value ?? current).copyWith(
          isExporting: false,
          clearErrorMessage: true,
        ),
      );
      return true;
    } catch (e) {
      state = AsyncData(
        (state.value ?? current).copyWith(
          isExporting: false,
          errorMessage: e.toString(),
        ),
      );
      return false;
    }
  }
}
