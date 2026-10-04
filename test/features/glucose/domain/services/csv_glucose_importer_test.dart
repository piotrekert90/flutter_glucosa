import 'package:flutter_glucosa/core/domain/enums/meal_context.dart';
import 'package:flutter_glucosa/features/glucose/domain/services/csv_glucose_importer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CsvGlucoseImporter.parse', () {
    test(
      'parses Glucosa native export format with glucose rows only',
      () async {
        const csv =
            '"Type","Date","Time","Value","Unit","Details","Notes"\n'
            '"Glucose","2026-09-20","07:30","120","mg/dL","fasting","Morning"\n'
            '"Weight","2026-09-20","07:31","80.0","kg","",""\n'
            '"Glucose","2026-09-20","12:15","145","mg/dL","afterLunch",""\n';

        final result = await CsvGlucoseImporter.parse(csv);

        expect(result.validEntries, hasLength(2));
        expect(result.skippedRowCount, 0);
        expect(result.validEntries[0].readingMgDl, 120);
        expect(result.validEntries[0].createdAt, DateTime(2026, 9, 20, 7, 30));
        expect(result.validEntries[0].mealContext, MealContext.fasting);
        expect(result.validEntries[0].notes, 'Morning');
        expect(result.validEntries[1].mealContext, MealContext.afterLunch);
        expect(result.earliestDate, DateTime(2026, 9, 20, 7, 30));
        expect(result.latestDate, DateTime(2026, 9, 20, 12, 15));
      },
    );

    test('detects semicolon and tab delimiters', () async {
      const semicolon =
          'Date;Time;Value;Unit;Notes\n'
          '20.09.2026;07:30;120;mg/dL;ok\n';
      final semi = await CsvGlucoseImporter.parse(semicolon);
      expect(semi.validEntries, hasLength(1));
      expect(semi.validEntries.single.readingMgDl, 120);

      const tab = 'Date\tValue\n2026-09-20\t130\n';
      final tabbed = await CsvGlucoseImporter.parse(tab);
      expect(tabbed.validEntries, hasLength(1));
      expect(tabbed.validEntries.single.readingMgDl, 130);
    });

    test('strips UTF-8 BOM and parses third-party aliases', () async {
      const csv =
          '\uFEFFDatum,Uhrzeit,Blutzucker,Notizen\n'
          '2026-09-20,07:30,110,morning\n';

      final result = await CsvGlucoseImporter.parse(csv);

      expect(result.validEntries, hasLength(1));
      expect(result.validEntries.single.readingMgDl, 110);
    });

    test('converts mmol/L values to mg/dL', () async {
      const csv =
          'Date,Time,Glucose,Unit\n'
          '2026-09-20,07:30,6.7,mmol/L\n'
          '2026-09-20,12:00,7.0,mmol/L\n';

      final result = await CsvGlucoseImporter.parse(csv);

      expect(result.validEntries, hasLength(2));
      expect(result.validEntries[0].readingMgDl, 121);
      expect(result.validEntries[1].readingMgDl, 126);
    });

    test(
      'defaults unit-less values to mg/dL and repairs decimal commas',
      () async {
        const csv = 'Date;Value\n20.09.2026;120,5\n';

        final result = await CsvGlucoseImporter.parse(csv);

        expect(result.validEntries, hasLength(1));
        expect(result.validEntries.single.readingMgDl, 121);
      },
    );

    test('supports US slash dates and AM/PM times', () async {
      const csv =
          'Date,Time,Value\n'
          '09/20/2026,9:26 AM,140\n'
          '09/20/2026,2:30 PM,160\n';

      final result = await CsvGlucoseImporter.parse(csv);

      expect(result.validEntries, hasLength(2));
      expect(result.validEntries[0].createdAt, DateTime(2026, 9, 20, 9, 26));
      expect(result.validEntries[1].createdAt, DateTime(2026, 9, 20, 14, 30));
    });

    test('skips malformed rows and counts them', () async {
      const csv =
          'Date,Value\n'
          '2026-09-20,120\n'
          'not-a-date,130\n'
          '2026-09-20,--\n'
          '2026-09-20,9999\n'
          '2026-09-20,\n';

      final result = await CsvGlucoseImporter.parse(csv);

      expect(result.validEntries, hasLength(1));
      expect(result.skippedRowCount, 4);
    });

    test('rejects future and pre-2000 timestamps', () async {
      final future = DateTime.now().add(const Duration(days: 2));
      final futureStr =
          '${future.year}-${future.month.toString().padLeft(2, '0')}-${future.day.toString().padLeft(2, '0')}';
      final csv =
          'Date,Value\n'
          '$futureStr,120\n'
          '1999-12-31,120\n'
          '2026-09-20,120\n';

      final result = await CsvGlucoseImporter.parse(csv);

      expect(result.validEntries, hasLength(1));
      expect(result.skippedRowCount, 2);
    });

    test('maps meal context aliases and truncates long notes', () async {
      final longNote = 'x' * 600;
      final csv =
          'Date,Value,Meal,Notes\n'
          '2026-09-20,120,before breakfast,ok\n'
          '2026-09-20,130,po obiedzie,$longNote\n'
          '2026-09-20,140,unknown-context,\n';

      final result = await CsvGlucoseImporter.parse(csv);

      expect(result.validEntries, hasLength(3));
      expect(result.validEntries[0].mealContext, MealContext.beforeBreakfast);
      expect(result.validEntries[1].mealContext, MealContext.afterLunch);
      expect(result.validEntries[1].notes, hasLength(500));
      expect(result.validEntries[2].mealContext, MealContext.other);
      expect(result.validEntries[2].notes, isNull);
    });

    test('throws FormatException on empty content', () async {
      expect(
        () => CsvGlucoseImporter.parse('   \n  '),
        throwsA(isA<FormatException>()),
      );
    });

    test('throws FormatException when header columns are missing', () async {
      const csv = 'Foo,Bar\n1,2\n';
      expect(
        () => CsvGlucoseImporter.parse(csv),
        throwsA(isA<FormatException>()),
      );
    });

    test(
      'respects injected now timestamp for futureLimit and time-only dates',
      () async {
        final fixedNow = DateTime(2026, 5, 10, 12, 0);
        const csv =
            'Date,Value\n'
            '2026-05-10 14:00,120\n' // within 24h of fixedNow -> accepted
            '2026-05-12 10:00,130\n'; // > 24h past fixedNow -> skipped as future anomaly

        final result = await CsvGlucoseImporter.parse(csv, now: fixedNow);
        expect(result.validEntries, hasLength(1));
        expect(result.validEntries.first.readingMgDl, 120);
        expect(result.skippedRowCount, 1);
      },
    );
  });
}
