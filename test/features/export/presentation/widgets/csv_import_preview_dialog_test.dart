import 'package:flutter/material.dart';
import 'package:flutter_glucosa/core/domain/enums/meal_context.dart';
import 'package:flutter_glucosa/features/export/presentation/widgets/csv_import_preview_dialog.dart';
import 'package:flutter_glucosa/features/glucose/domain/entities/glucose_reading.dart';
import 'package:flutter_glucosa/features/glucose/domain/services/csv_glucose_importer.dart';
import 'package:flutter_glucosa/l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  CsvImportAnalysis buildAnalysis() {
    return (
      validEntries: [
        GlucoseReading(
          readingMgDl: 120,
          mealContext: MealContext.fasting,
          createdAt: DateTime(2026, 9, 20, 7, 30),
        ),
        GlucoseReading(
          readingMgDl: 145,
          mealContext: MealContext.afterLunch,
          createdAt: DateTime(2026, 9, 21, 12, 15),
        ),
      ],
      skippedRowCount: 3,
      duplicateCount: 1,
      earliestDate: DateTime(2026, 9, 20, 7, 30),
      latestDate: DateTime(2026, 9, 21, 12, 15),
    );
  }

  Future<void> pumpOpener(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () async {
                final confirmed = await CsvImportPreviewDialog.show(
                  context,
                  analysis: buildAnalysis(),
                );
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('confirmed=$confirmed')),
                  );
                }
              },
              child: const Text('open'),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('CsvImportPreviewDialog', () {
    testWidgets('shows valid, skipped, and duplicate counts', (tester) async {
      await pumpOpener(tester);

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.text('Import Preview'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
      expect(find.textContaining('ready to import'), findsOneWidget);
      expect(find.textContaining('3 rows skipped'), findsOneWidget);
      expect(find.textContaining('1 duplicate'), findsOneWidget);

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(find.text('confirmed=false'), findsOneWidget);
    });

    testWidgets('static show returns true on confirm', (tester) async {
      await pumpOpener(tester);

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Import'));
      await tester.pumpAndSettle();

      expect(find.text('confirmed=true'), findsOneWidget);
    });
  });
}
