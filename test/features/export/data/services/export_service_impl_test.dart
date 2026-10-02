import 'package:flutter/material.dart';
import 'package:flutter_glucosa/core/domain/enums/glucose_unit.dart';
import 'package:flutter_glucosa/core/domain/enums/hba1c_unit.dart';
import 'package:flutter_glucosa/core/domain/enums/meal_context.dart';
import 'package:flutter_glucosa/core/domain/enums/metric_type.dart';
import 'package:flutter_glucosa/core/domain/enums/weight_unit.dart';
import 'package:flutter_glucosa/features/blood_pressure/domain/entities/blood_pressure_reading.dart';
import 'package:flutter_glucosa/features/cholesterol/domain/entities/cholesterol_reading.dart';
import 'package:flutter_glucosa/features/export/data/services/export_service_impl.dart';
import 'package:flutter_glucosa/features/glucose/domain/entities/glucose_reading.dart';
import 'package:flutter_glucosa/features/hba1c/domain/entities/hba1c_reading.dart';
import 'package:flutter_glucosa/features/ketones/domain/entities/ketone_reading.dart';
import 'package:flutter_glucosa/features/weight/domain/entities/weight_reading.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/fake_blood_pressure_reading_repository.dart';
import '../../../../helpers/fake_cholesterol_reading_repository.dart';
import '../../../../helpers/fake_glucose_reading_repository.dart';
import '../../../../helpers/fake_hba1c_reading_repository.dart';
import '../../../../helpers/fake_ketone_reading_repository.dart';
import '../../../../helpers/fake_weight_reading_repository.dart';

void main() {
  late FakeGlucoseReadingRepository glucoseRepo;
  late FakeHbA1cReadingRepository hba1cRepo;
  late FakeBloodPressureReadingRepository bpRepo;
  late FakeKetoneReadingRepository ketoneRepo;
  late FakeCholesterolReadingRepository cholesterolRepo;
  late FakeWeightReadingRepository weightRepo;
  late ExportServiceImpl exportService;

  setUp(() {
    glucoseRepo = FakeGlucoseReadingRepository();
    hba1cRepo = FakeHbA1cReadingRepository();
    bpRepo = FakeBloodPressureReadingRepository();
    ketoneRepo = FakeKetoneReadingRepository();
    cholesterolRepo = FakeCholesterolReadingRepository();
    weightRepo = FakeWeightReadingRepository();

    exportService = ExportServiceImpl(
      glucoseRepo: glucoseRepo,
      hba1cRepo: hba1cRepo,
      bpRepo: bpRepo,
      ketoneRepo: ketoneRepo,
      cholesterolRepo: cholesterolRepo,
      weightRepo: weightRepo,
    );
  });

  tearDown(() {
    glucoseRepo.dispose();
    hba1cRepo.dispose();
    bpRepo.dispose();
    ketoneRepo.dispose();
    cholesterolRepo.dispose();
    weightRepo.dispose();
  });

  group('ExportServiceImpl.countRecords', () {
    test('returns 0 when all repositories are empty', () async {
      final count = await exportService.countRecords();
      expect(count, 0);
    });

    test('counts all records across all metrics when unconstrained', () async {
      await glucoseRepo.add(
        GlucoseReading(
          readingMgDl: 110,
          mealContext: MealContext.fasting,
          createdAt: DateTime(2026, 10, 1, 8),
        ),
      );
      await hba1cRepo.add(
        HbA1cReading(
          readingPercentage: 6.2,
          createdAt: DateTime(2026, 10, 1, 9),
        ),
      );
      await bpRepo.add(
        BloodPressureReading(
          systolicMmHg: 120,
          diastolicMmHg: 80,
          createdAt: DateTime(2026, 10, 1, 10),
        ),
      );

      final count = await exportService.countRecords();
      expect(count, 3);
    });

    test('filters record count by selected metrics', () async {
      await glucoseRepo.add(
        GlucoseReading(
          readingMgDl: 110,
          mealContext: MealContext.fasting,
          createdAt: DateTime(2026, 10, 1, 8),
        ),
      );
      await weightRepo.add(
        WeightReading(readingKg: 78.0, createdAt: DateTime(2026, 10, 1, 9)),
      );

      final count = await exportService.countRecords(
        metrics: {MetricType.glucose},
      );
      expect(count, 1);
    });

    test('filters record count by date range', () async {
      await glucoseRepo.add(
        GlucoseReading(
          readingMgDl: 100,
          mealContext: MealContext.fasting,
          createdAt: DateTime(2026, 9, 20),
        ),
      );
      await glucoseRepo.add(
        GlucoseReading(
          readingMgDl: 120,
          mealContext: MealContext.beforeBreakfast,
          createdAt: DateTime(2026, 10, 1, 8),
        ),
      );

      final count = await exportService.countRecords(
        dateRange: DateTimeRange(
          start: DateTime(2026, 10, 1),
          end: DateTime(2026, 10, 2),
        ),
      );
      expect(count, 1);
    });
  });

  group('ExportServiceImpl.generateCsv', () {
    test('outputs valid CSV header for empty data', () async {
      final csv = await exportService.generateCsv();
      expect(
        csv.trim(),
        '"Type","Date","Time","Value","Unit","Details","Notes"',
      );
    });

    test('exports and formats all metric types with standard units', () async {
      await glucoseRepo.add(
        GlucoseReading(
          readingMgDl: 125,
          mealContext: MealContext.beforeLunch,
          notes: 'Lunch check',
          createdAt: DateTime(2026, 10, 1, 12, 15),
        ),
      );
      await hba1cRepo.add(
        HbA1cReading(
          readingPercentage: 6.8,
          notes: 'Lab result',
          createdAt: DateTime(2026, 10, 1, 10, 0),
        ),
      );
      await bpRepo.add(
        BloodPressureReading(
          systolicMmHg: 130,
          diastolicMmHg: 85,
          notes: 'After walk',
          createdAt: DateTime(2026, 10, 1, 11, 0),
        ),
      );
      await ketoneRepo.add(
        KetoneReading(
          readingMmolL: 0.6,
          notes: 'Morning strip',
          createdAt: DateTime(2026, 10, 1, 8, 30),
        ),
      );
      await cholesterolRepo.add(
        CholesterolReading(
          totalMgDl: 195,
          ldlMgDl: 115,
          hdlMgDl: 52,
          notes: 'Annual checkup',
          createdAt: DateTime(2026, 10, 1, 9, 30),
        ),
      );
      await weightRepo.add(
        WeightReading(
          readingKg: 76.5,
          notes: 'Morning weigh-in',
          createdAt: DateTime(2026, 10, 1, 7, 0),
        ),
      );

      final csv = await exportService.generateCsv();
      final lines = csv.trim().split('\n');

      expect(lines.length, 7); // 1 header + 6 records
      expect(lines[0], '"Type","Date","Time","Value","Unit","Details","Notes"');

      // Descending time sort: 12:15 (Glucose) should be first
      expect(
        lines[1],
        contains('"Glucose","2026-10-01","12:15","125","mg/dL"'),
      );
      expect(lines[1], contains('"beforeLunch","Lunch check"'));

      // 11:00 (Blood Pressure)
      expect(
        lines[2],
        contains(
          '"Blood Pressure","2026-10-01","11:00","130/85","mmHg","","After walk"',
        ),
      );

      // 10:00 (HbA1c)
      expect(
        lines[3],
        contains('"HbA1c","2026-10-01","10:00","6.8","%","","Lab result"'),
      );

      // 09:30 (Cholesterol)
      expect(
        lines[4],
        contains(
          '"Cholesterol","2026-10-01","09:30","195","mg/dL","LDL: 115, HDL: 52","Annual checkup"',
        ),
      );

      // 08:30 (Ketones)
      expect(
        lines[5],
        contains(
          '"Ketones","2026-10-01","08:30","0.6","mmol/L","","Morning strip"',
        ),
      );

      // 07:00 (Weight)
      expect(
        lines[6],
        contains(
          '"Weight","2026-10-01","07:00","76.5","kg","","Morning weigh-in"',
        ),
      );
    });

    test('supports converted units (mmol/L, mmol/mol, lbs)', () async {
      await glucoseRepo.add(
        GlucoseReading(
          readingMgDl: 180,
          mealContext: MealContext.afterDinner,
          createdAt: DateTime(2026, 10, 1, 20, 0),
        ),
      );
      await hba1cRepo.add(
        HbA1cReading(
          readingPercentage: 7.0,
          createdAt: DateTime(2026, 10, 1, 10, 0),
        ),
      );
      await weightRepo.add(
        WeightReading(readingKg: 100.0, createdAt: DateTime(2026, 10, 1, 8, 0)),
      );

      final csv = await exportService.generateCsv(
        glucoseUnit: GlucoseUnit.mmolL,
        hba1cUnit: HbA1cUnit.mmolMol,
        weightUnit: WeightUnit.pounds,
      );

      expect(csv, contains('"Glucose","2026-10-01","20:00","10.0","mmol/L"'));
      expect(csv, contains('"HbA1c","2026-10-01","10:00","53.0","mmol/mol"'));
      expect(csv, contains('"Weight","2026-10-01","08:00","220.5","lbs"'));
    });

    test('properly escapes quotes, commas, and special characters', () async {
      await glucoseRepo.add(
        GlucoseReading(
          readingMgDl: 100,
          mealContext: MealContext.bedtime,
          notes: 'Had "special", nice snack\nLate evening',
          createdAt: DateTime(2026, 10, 1, 23, 0),
        ),
      );

      final csv = await exportService.generateCsv();
      expect(csv, contains('"Had ""special"", nice snack\nLate evening"'));
    });
  });
}
