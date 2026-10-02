import 'package:flutter/material.dart';
import 'package:flutter_glucosa/core/domain/enums/glucose_unit.dart';
import 'package:flutter_glucosa/core/domain/enums/hba1c_unit.dart';
import 'package:flutter_glucosa/core/domain/enums/metric_type.dart';
import 'package:flutter_glucosa/core/domain/enums/weight_unit.dart';
import 'package:flutter_glucosa/features/export/domain/services/export_service.dart';

/// In-memory fake implementation of [ExportService] for testing.
class FakeExportService implements ExportService {
  /// Result returned by [generateCsv].
  String csvToReturn;

  /// Result returned by [countRecords].
  int countToReturn;

  /// Number of times [exportAndShare] was called.
  int exportAndShareCallCount = 0;

  /// Last arguments passed to [exportAndShare].
  DateTimeRange? lastDateRange;
  Set<MetricType>? lastMetrics;
  GlucoseUnit? lastGlucoseUnit;
  HbA1cUnit? lastHbA1cUnit;
  WeightUnit? lastWeightUnit;

  /// Creates a [FakeExportService] with optional default outputs.
  FakeExportService({
    this.csvToReturn = 'header\ndata',
    this.countToReturn = 10,
  });

  @override
  Future<String> generateCsv({
    DateTimeRange? dateRange,
    Set<MetricType>? metrics,
    GlucoseUnit? glucoseUnit,
    HbA1cUnit? hba1cUnit,
    WeightUnit? weightUnit,
  }) async {
    lastDateRange = dateRange;
    lastMetrics = metrics;
    lastGlucoseUnit = glucoseUnit;
    lastHbA1cUnit = hba1cUnit;
    lastWeightUnit = weightUnit;
    return csvToReturn;
  }

  @override
  Future<int> countRecords({
    DateTimeRange? dateRange,
    Set<MetricType>? metrics,
  }) async {
    lastDateRange = dateRange;
    lastMetrics = metrics;
    return countToReturn;
  }

  @override
  Future<void> exportAndShare({
    DateTimeRange? dateRange,
    Set<MetricType>? metrics,
    GlucoseUnit? glucoseUnit,
    HbA1cUnit? hba1cUnit,
    WeightUnit? weightUnit,
  }) async {
    exportAndShareCallCount++;
    lastDateRange = dateRange;
    lastMetrics = metrics;
    lastGlucoseUnit = glucoseUnit;
    lastHbA1cUnit = hba1cUnit;
    lastWeightUnit = weightUnit;
  }
}
