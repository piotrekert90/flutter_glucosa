import 'dart:io';

import 'package:flutter_glucosa/core/domain/enums/meal_context.dart';
import 'package:flutter_glucosa/features/glucose/data/services/csv_glucose_import_service.dart';
import 'package:flutter_glucosa/features/glucose/domain/entities/glucose_reading.dart';
import 'package:flutter_glucosa/features/glucose/domain/services/csv_glucose_importer.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/fake_glucose_reading_repository.dart';

void main() {
  group('CsvGlucoseImportService', () {
    late FakeGlucoseReadingRepository fakeRepository;
    late CsvGlucoseImportService service;
    late Directory tempDir;

    setUp(() async {
      fakeRepository = FakeGlucoseReadingRepository();
      service = CsvGlucoseImportService(repository: fakeRepository);
      tempDir = await Directory.systemTemp.createTemp('csv_import_test');
    });

    tearDown(() async {
      fakeRepository.dispose();
      await tempDir.delete(recursive: true);
    });

    Future<String> writeFile(String name, String content) async {
      final file = File('${tempDir.path}/$name');
      await file.writeAsString(content);
      return file.path;
    }

    const validCsv =
        '"Type","Date","Time","Value","Unit","Details","Notes"\n'
        '"Glucose","2026-09-20","07:30","120","mg/dL","fasting",""\n'
        '"Glucose","2026-09-20","12:15","145","mg/dL","afterLunch",""\n';

    test('analyzeFile returns success with entries for valid file', () async {
      final path = await writeFile('valid.csv', validCsv);

      final outcome = await service.analyzeFile(path);

      expect(outcome, isA<CsvAnalysisSuccess>());
      final analysis = (outcome as CsvAnalysisSuccess).analysis;
      expect(analysis.validEntries, hasLength(2));
      expect(analysis.duplicateCount, 0);
      expect(analysis.skippedRowCount, 0);
    });

    test(
      'analyzeFile filters timestamps duplicating existing records',
      () async {
        await fakeRepository.add(
          GlucoseReading(
            readingMgDl: 120,
            mealContext: MealContext.fasting,
            createdAt: DateTime(2026, 9, 20, 7, 30),
          ),
        );
        final path = await writeFile('dup.csv', validCsv);

        final outcome = await service.analyzeFile(path);

        expect(outcome, isA<CsvAnalysisSuccess>());
        final analysis = (outcome as CsvAnalysisSuccess).analysis;
        expect(analysis.validEntries, hasLength(1));
        expect(analysis.duplicateCount, 1);
        expect(
          analysis.validEntries.single.createdAt,
          DateTime(2026, 9, 20, 12, 15),
        );
      },
    );

    test('analyzeFile filters within-file duplicate timestamps', () async {
      const csv =
          'Date,Value\n'
          '2026-09-20,120\n'
          '2026-09-20,130\n';
      final path = await writeFile('inner_dup.csv', csv);

      final outcome = await service.analyzeFile(path);

      expect(outcome, isA<CsvAnalysisSuccess>());
      final analysis = (outcome as CsvAnalysisSuccess).analysis;
      expect(analysis.validEntries, hasLength(1));
      expect(analysis.duplicateCount, 1);
    });

    test(
      'analyzeFile returns noEntries when everything is a duplicate',
      () async {
        await fakeRepository.add(
          GlucoseReading(
            readingMgDl: 120,
            mealContext: MealContext.other,
            createdAt: DateTime(2026, 9, 20),
          ),
        );
        final path = await writeFile(
          'all_dup.csv',
          'Date,Value\n2026-09-20,120\n',
        );

        final outcome = await service.analyzeFile(path);

        expect(outcome, isA<CsvAnalysisFailure>());
        expect(
          (outcome as CsvAnalysisFailure).errorType,
          CsvErrorType.noEntries,
        );
      },
    );

    test('analyzeFile returns invalidFormat for unparseable content', () async {
      final path = await writeFile('bad.csv', 'Foo,Bar\n1,2\n');

      final outcome = await service.analyzeFile(path);

      expect(outcome, isA<CsvAnalysisFailure>());
      expect(
        (outcome as CsvAnalysisFailure).errorType,
        CsvErrorType.invalidFormat,
      );
    });

    test('analyzeFile returns fileTooLarge above 5 MB limit', () async {
      final file = File('${tempDir.path}/big.csv');
      final sink = file.openWrite();
      sink.writeln('Date,Value');
      const row = '2026-09-20,120\n';
      const repetitions =
          (CsvGlucoseImportService.maxFileSizeBytes ~/ row.length) + 10;
      for (int i = 0; i < repetitions; i++) {
        sink.writeln('2026-09-20,120');
      }
      await sink.close();

      final outcome = await service.analyzeFile(file.path);

      expect(outcome, isA<CsvAnalysisFailure>());
      expect(
        (outcome as CsvAnalysisFailure).errorType,
        CsvErrorType.fileTooLarge,
      );
    });

    test(
      'confirmImport persists entries atomically and returns count',
      () async {
        final entries = [
          GlucoseReading(
            readingMgDl: 120,
            mealContext: MealContext.fasting,
            createdAt: DateTime(2026, 9, 20, 7, 30),
          ),
          GlucoseReading(
            readingMgDl: 145,
            mealContext: MealContext.afterLunch,
            createdAt: DateTime(2026, 9, 20, 12, 15),
          ),
        ];

        final (count, failure) = await service.confirmImport(entries);

        expect(failure, isNull);
        expect(count, 2);
        expect(await fakeRepository.getAll(), hasLength(2));
      },
    );
  });
}
