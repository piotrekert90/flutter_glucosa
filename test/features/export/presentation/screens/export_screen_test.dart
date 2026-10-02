import 'package:flutter/material.dart';
import 'package:flutter_glucosa/features/export/presentation/providers/export_service_provider.dart';
import 'package:flutter_glucosa/features/export/presentation/screens/export_screen.dart';
import 'package:flutter_glucosa/features/settings/data/providers/user_profile_repository_provider.dart';
import 'package:flutter_glucosa/features/settings/domain/entities/user_profile.dart';
import 'package:flutter_glucosa/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/fake_export_service.dart';
import '../../../../helpers/fake_user_profile_repository.dart';

void main() {
  late FakeExportService fakeExportService;
  late FakeUserProfileRepository fakeProfileRepo;

  setUp(() {
    fakeExportService = FakeExportService(countToReturn: 24);
    fakeProfileRepo = FakeUserProfileRepository(
      initialProfile: UserProfile.defaults(),
    );
  });

  tearDown(() {
    fakeProfileRepo.dispose();
  });

  Widget createWidget({
    FakeExportService? exportService,
    FakeUserProfileRepository? profileRepo,
  }) {
    return ProviderScope(
      overrides: [
        exportServiceProvider.overrideWithValue(
          exportService ?? fakeExportService,
        ),
        userProfileRepositoryProvider.overrideWithValue(
          profileRepo ?? fakeProfileRepo,
        ),
      ],
      child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: ExportScreen(),
      ),
    );
  }

  group('ExportScreen', () {
    testWidgets('renders all main elements', (tester) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createWidget());
      await tester.pumpAndSettle();

      expect(find.text('Export Data'), findsOneWidget);
      expect(find.text('Export measurements to CSV format'), findsOneWidget);
      expect(find.text('Date Range'), findsOneWidget);
      expect(find.text('All Time'), findsOneWidget);
      expect(find.text('Last 7 days'), findsOneWidget);
      expect(find.text('Last 30 days'), findsOneWidget);
      expect(find.text('Last 90 days'), findsOneWidget);
      expect(find.text('Custom range'), findsOneWidget);
      expect(find.text('Metrics to Include'), findsOneWidget);
      expect(find.text('Blood Glucose'), findsOneWidget);
      expect(find.text('24 records selected'), findsOneWidget);
      expect(find.text('Export & Share'), findsOneWidget);
    });

    testWidgets('toggling metric checkbox updates selection', (tester) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createWidget());
      await tester.pumpAndSettle();

      final glucoseCheckbox = find.widgetWithText(
        CheckboxListTile,
        'Blood Glucose',
      );
      expect(glucoseCheckbox, findsOneWidget);

      await tester.tap(glucoseCheckbox);
      await tester.pumpAndSettle();

      final checkboxWidget = tester.widget<CheckboxListTile>(glucoseCheckbox);
      expect(checkboxWidget.value, isFalse);
    });

    testWidgets('deselect all and select all toggles all metrics', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createWidget());
      await tester.pumpAndSettle();

      // Initially "Deselect All" is shown because all 6 are selected
      expect(find.text('Deselect All'), findsOneWidget);

      await tester.tap(find.text('Deselect All'));
      await tester.pumpAndSettle();

      // Now "Select All" should be shown
      expect(find.text('Select All'), findsOneWidget);

      // And button should be disabled since 0 metrics are selected
      final buttonFinder = find.widgetWithText(FilledButton, 'Export & Share');
      final button = tester.widget<FilledButton>(buttonFinder);
      expect(button.onPressed, isNull);

      // Tap "Select All"
      await tester.tap(find.text('Select All'));
      await tester.pumpAndSettle();

      expect(find.text('Deselect All'), findsOneWidget);
    });

    testWidgets('tapping Export & Share invokes service and shows snackbar', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createWidget());
      await tester.pumpAndSettle();

      final buttonFinder = find.widgetWithText(FilledButton, 'Export & Share');
      await tester.tap(buttonFinder);
      await tester.pumpAndSettle();

      expect(fakeExportService.exportAndShareCallCount, 1);
      expect(find.text('Export completed successfully'), findsOneWidget);
    });

    testWidgets('selecting date preset updates active filter', (tester) async {
      await tester.pumpWidget(createWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Last 7 days'));
      await tester.pumpAndSettle();

      expect(fakeExportService.lastDateRange, isNotNull);
    });
  });
}
