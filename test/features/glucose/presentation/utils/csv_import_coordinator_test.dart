import 'package:flutter/material.dart';
import 'package:flutter_glucosa/core/domain/enums/meal_context.dart';
import 'package:flutter_glucosa/core/errors/failure.dart';
import 'package:flutter_glucosa/features/glucose/data/providers/csv_import_service_provider.dart';
import 'package:flutter_glucosa/features/glucose/data/services/csv_glucose_import_service.dart';
import 'package:flutter_glucosa/features/glucose/domain/entities/glucose_reading.dart';
import 'package:flutter_glucosa/features/glucose/domain/services/csv_glucose_importer.dart';
import 'package:flutter_glucosa/features/glucose/presentation/utils/csv_import_coordinator.dart';
import 'package:flutter_glucosa/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/fake_glucose_reading_repository.dart';

class _FakeImportService extends CsvGlucoseImportService {
  _FakeImportService() : super(repository: FakeGlucoseReadingRepository());

  CsvAnalysisOutcome outcome = const CsvAnalysisFailure(
    CsvErrorType.fileTooLarge,
  );
  Object? analyzeError;
  (int?, Failure?)? confirmResult;

  @override
  Future<CsvAnalysisOutcome> analyzeFile(String filePath) async {
    if (analyzeError != null) throw analyzeError!;
    return outcome;
  }

  @override
  Future<(int?, Failure?)> confirmImport(List<GlucoseReading> entries) async {
    return confirmResult ?? ((entries.length, null));
  }
}

void main() {
  final l10n = lookupAppLocalizations(const Locale('en'));

  late _FakeImportService fakeService;
  late BuildContext capturedContext;
  late WidgetRef capturedRef;

  Future<void> pumpHarness(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          csvGlucoseImportServiceProvider.overrideWithValue(fakeService),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: Consumer(
              builder: (context, ref, _) {
                capturedContext = context;
                capturedRef = ref;
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  GlucoseReading reading(int id) => GlucoseReading(
    id: id,
    readingMgDl: 120,
    mealContext: MealContext.fasting,
    createdAt: DateTime(2026, 9, id + 1, 10),
  );

  CsvAnalysisSuccess successOutcome() => CsvAnalysisSuccess((
    validEntries: [reading(1), reading(2)],
    skippedRowCount: 0,
    duplicateCount: 0,
    earliestDate: DateTime(2026, 9, 2, 10),
    latestDate: DateTime(2026, 9, 3, 10),
  ));

  setUp(() {
    fakeService = _FakeImportService();
  });

  group('CsvImportCoordinator.pickAnalyzeConfirm', () {
    testWidgets('returns null when the user cancels the picker', (
      tester,
    ) async {
      await pumpHarness(tester);

      final result = await CsvImportCoordinator.pickAnalyzeConfirm(
        capturedContext,
        capturedRef,
        pickCsvPath: () async => null,
      );

      expect(result, isNull);
    });

    testWidgets('shows an error when analysis fails', (tester) async {
      await pumpHarness(tester);
      fakeService.outcome = const CsvAnalysisFailure(CsvErrorType.fileTooLarge);

      final result = await CsvImportCoordinator.pickAnalyzeConfirm(
        capturedContext,
        capturedRef,
        pickCsvPath: () async => '/tmp/data.csv',
      );

      expect(result, isNull);
      await tester.pump();
      expect(find.text(l10n.csvImportErrorTooLarge), findsOneWidget);
    });

    testWidgets('returns imported count when confirmed', (tester) async {
      await pumpHarness(tester);
      fakeService.outcome = successOutcome();
      CsvAnalysisSuccess? confirmedOutcome;
      Future<bool> confirm(BuildContext context, CsvAnalysisSuccess o) async {
        confirmedOutcome = o;
        return true;
      }

      final result = await CsvImportCoordinator.pickAnalyzeConfirm(
        capturedContext,
        capturedRef,
        pickCsvPath: () async => '/tmp/data.csv',
        confirmAnalysis: confirm,
      );

      expect(result, 2);
      expect(confirmedOutcome, isA<CsvAnalysisSuccess>());
    });

    testWidgets('returns null when the user rejects the preview', (
      tester,
    ) async {
      await pumpHarness(tester);
      fakeService.outcome = successOutcome();

      final result = await CsvImportCoordinator.pickAnalyzeConfirm(
        capturedContext,
        capturedRef,
        pickCsvPath: () async => '/tmp/data.csv',
        confirmAnalysis: (_, _) async => false,
      );

      expect(result, isNull);
    });

    testWidgets('shows an error when the commit fails', (tester) async {
      await pumpHarness(tester);
      fakeService.outcome = successOutcome();
      fakeService.confirmResult = (null, const DatabaseFailure('db down'));

      final result = await CsvImportCoordinator.pickAnalyzeConfirm(
        capturedContext,
        capturedRef,
        pickCsvPath: () async => '/tmp/data.csv',
        confirmAnalysis: (_, _) async => true,
      );

      expect(result, isNull);
      await tester.pump();
      expect(find.text(l10n.csvImportErrorInvalid), findsOneWidget);
    });

    testWidgets('shows an error when analysis throws', (tester) async {
      await pumpHarness(tester);
      fakeService.analyzeError = Exception('disk gone');

      // runAsync: the crash-reporting path awaits real platform channels
      // that never resolve in the fake-async widget zone.
      final result = await tester.runAsync(
        () => CsvImportCoordinator.pickAnalyzeConfirm(
          capturedContext,
          capturedRef,
          pickCsvPath: () async => '/tmp/data.csv',
        ),
      );

      expect(result, isNull);
      await tester.pump();
      expect(find.text(l10n.csvImportErrorPick), findsOneWidget);
    });
  });
}
