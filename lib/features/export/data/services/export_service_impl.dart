import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/domain/enums/glucose_unit.dart';
import '../../../../core/domain/enums/hba1c_unit.dart';
import '../../../../core/domain/enums/metric_type.dart';
import '../../../../core/domain/enums/weight_unit.dart';
import '../../../../core/domain/utils/glucose_converter.dart';
import '../../../blood_pressure/domain/repositories/blood_pressure_reading_repository.dart';
import '../../../cholesterol/domain/repositories/cholesterol_reading_repository.dart';
import '../../../glucose/domain/repositories/glucose_reading_repository.dart';
import '../../../hba1c/domain/repositories/hba1c_reading_repository.dart';
import '../../../ketones/domain/repositories/ketone_reading_repository.dart';
import '../../../weight/domain/repositories/weight_reading_repository.dart';
import '../../domain/services/export_service.dart';

/// Concrete implementation of [ExportService] that aggregates readings and creates CSV files.
class ExportServiceImpl implements ExportService {
  /// Repository for blood glucose measurements.
  final GlucoseReadingRepository glucoseRepo;

  /// Repository for HbA1c measurements.
  final HbA1cReadingRepository hba1cRepo;

  /// Repository for blood pressure measurements.
  final BloodPressureReadingRepository bpRepo;

  /// Repository for ketone measurements.
  final KetoneReadingRepository ketoneRepo;

  /// Repository for cholesterol measurements.
  final CholesterolReadingRepository cholesterolRepo;

  /// Repository for weight measurements.
  final WeightReadingRepository weightRepo;

  /// Creates an [ExportServiceImpl] with repositories for all six health metrics.
  ExportServiceImpl({
    required this.glucoseRepo,
    required this.hba1cRepo,
    required this.bpRepo,
    required this.ketoneRepo,
    required this.cholesterolRepo,
    required this.weightRepo,
  });

  @override
  Future<String> generateCsv({
    DateTimeRange? dateRange,
    Set<MetricType>? metrics,
    GlucoseUnit? glucoseUnit,
    HbA1cUnit? hba1cUnit,
    WeightUnit? weightUnit,
  }) async {
    final records = await _gatherRecords(
      dateRange: dateRange,
      metrics: metrics,
      glucoseUnit: glucoseUnit ?? GlucoseUnit.mgDl,
      hba1cUnit: hba1cUnit ?? HbA1cUnit.percentage,
      weightUnit: weightUnit ?? WeightUnit.kilograms,
    );

    records.sort((a, b) => b.dateTime.compareTo(a.dateTime));

    final buffer = StringBuffer();
    buffer.writeln('"Type","Date","Time","Value","Unit","Details","Notes"');

    final dateFormat = DateFormat('yyyy-MM-dd');
    final timeFormat = DateFormat('HH:mm');

    for (final r in records) {
      final line = [
        _escapeCsv(r.metricName),
        _escapeCsv(dateFormat.format(r.dateTime)),
        _escapeCsv(timeFormat.format(r.dateTime)),
        _escapeCsv(r.value),
        _escapeCsv(r.unit),
        _escapeCsv(r.details),
        _escapeCsv(r.notes),
      ].join(',');
      buffer.writeln(line);
    }

    return buffer.toString();
  }

  @override
  Future<int> countRecords({
    DateTimeRange? dateRange,
    Set<MetricType>? metrics,
  }) async {
    final records = await _gatherRecords(
      dateRange: dateRange,
      metrics: metrics,
      glucoseUnit: GlucoseUnit.mgDl,
      hba1cUnit: HbA1cUnit.percentage,
      weightUnit: WeightUnit.kilograms,
    );
    return records.length;
  }

  @override
  Future<void> exportAndShare({
    DateTimeRange? dateRange,
    Set<MetricType>? metrics,
    GlucoseUnit? glucoseUnit,
    HbA1cUnit? hba1cUnit,
    WeightUnit? weightUnit,
  }) async {
    final csvData = await generateCsv(
      dateRange: dateRange,
      metrics: metrics,
      glucoseUnit: glucoseUnit,
      hba1cUnit: hba1cUnit,
      weightUnit: weightUnit,
    );

    final tempDir = await getTemporaryDirectory();
    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final file = File('${tempDir.path}/glucosa_export_$timestamp.csv');
    await file.writeAsString(csvData);

    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path, mimeType: 'text/csv')],
        subject: 'Glucosa Health Data Export',
      ),
    );
  }

  Future<List<_ExportRecord>> _gatherRecords({
    DateTimeRange? dateRange,
    Set<MetricType>? metrics,
    required GlucoseUnit glucoseUnit,
    required HbA1cUnit hba1cUnit,
    required WeightUnit weightUnit,
  }) async {
    final selectedMetrics = metrics ?? MetricType.values.toSet();
    final results = <_ExportRecord>[];

    if (selectedMetrics.contains(MetricType.glucose)) {
      final all = await glucoseRepo.getAll();
      for (final r in all) {
        if (_inRange(r.createdAt, dateRange)) {
          final displayVal = glucoseUnit == GlucoseUnit.mmolL
              ? GlucoseConverter.mgDlToMmolL(r.readingMgDl).toStringAsFixed(1)
              : r.readingMgDl.toString();
          results.add(
            _ExportRecord(
              dateTime: r.createdAt,
              metricName: 'Glucose',
              value: displayVal,
              unit: glucoseUnit.displayName,
              details: r.mealContext.name,
              notes: r.notes ?? '',
            ),
          );
        }
      }
    }

    if (selectedMetrics.contains(MetricType.hba1c)) {
      final all = await hba1cRepo.getAll();
      for (final r in all) {
        if (_inRange(r.createdAt, dateRange)) {
          final displayVal = hba1cUnit == HbA1cUnit.mmolMol
              ? GlucoseConverter.percentageToMmolMol(
                  r.readingPercentage,
                ).toStringAsFixed(1)
              : r.readingPercentage.toStringAsFixed(1);
          results.add(
            _ExportRecord(
              dateTime: r.createdAt,
              metricName: 'HbA1c',
              value: displayVal,
              unit: hba1cUnit.displayName,
              details: '',
              notes: r.notes ?? '',
            ),
          );
        }
      }
    }

    if (selectedMetrics.contains(MetricType.bloodPressure)) {
      final all = await bpRepo.getAll();
      for (final r in all) {
        if (_inRange(r.createdAt, dateRange)) {
          results.add(
            _ExportRecord(
              dateTime: r.createdAt,
              metricName: 'Blood Pressure',
              value: '${r.systolicMmHg}/${r.diastolicMmHg}',
              unit: 'mmHg',
              details: '',
              notes: r.notes ?? '',
            ),
          );
        }
      }
    }

    if (selectedMetrics.contains(MetricType.ketones)) {
      final all = await ketoneRepo.getAll();
      for (final r in all) {
        if (_inRange(r.createdAt, dateRange)) {
          results.add(
            _ExportRecord(
              dateTime: r.createdAt,
              metricName: 'Ketones',
              value: r.readingMmolL.toStringAsFixed(1),
              unit: 'mmol/L',
              details: '',
              notes: r.notes ?? '',
            ),
          );
        }
      }
    }

    if (selectedMetrics.contains(MetricType.cholesterol)) {
      final all = await cholesterolRepo.getAll();
      for (final r in all) {
        if (_inRange(r.createdAt, dateRange)) {
          results.add(
            _ExportRecord(
              dateTime: r.createdAt,
              metricName: 'Cholesterol',
              value: r.totalMgDl.toString(),
              unit: 'mg/dL',
              details: 'LDL: ${r.ldlMgDl}, HDL: ${r.hdlMgDl}',
              notes: r.notes ?? '',
            ),
          );
        }
      }
    }

    if (selectedMetrics.contains(MetricType.weight)) {
      final all = await weightRepo.getAll();
      for (final r in all) {
        if (_inRange(r.createdAt, dateRange)) {
          final displayVal = weightUnit == WeightUnit.pounds
              ? GlucoseConverter.kgToLbs(r.readingKg).toStringAsFixed(1)
              : r.readingKg.toStringAsFixed(1);
          results.add(
            _ExportRecord(
              dateTime: r.createdAt,
              metricName: 'Weight',
              value: displayVal,
              unit: weightUnit.displayName,
              details: '',
              notes: r.notes ?? '',
            ),
          );
        }
      }
    }

    return results;
  }

  bool _inRange(DateTime dt, DateTimeRange? range) {
    if (range == null) return true;
    final start = DateTime(
      range.start.year,
      range.start.month,
      range.start.day,
    );
    final end = DateTime(
      range.end.year,
      range.end.month,
      range.end.day,
      23,
      59,
      59,
      999,
    );
    return (dt.isAfter(start) || dt.isAtSameMomentAs(start)) &&
        (dt.isBefore(end) || dt.isAtSameMomentAs(end));
  }

  String _escapeCsv(String value) {
    return '"${value.replaceAll('"', '""')}"';
  }
}

class _ExportRecord {
  final DateTime dateTime;
  final String metricName;
  final String value;
  final String unit;
  final String details;
  final String notes;

  _ExportRecord({
    required this.dateTime,
    required this.metricName,
    required this.value,
    required this.unit,
    required this.details,
    required this.notes,
  });
}
