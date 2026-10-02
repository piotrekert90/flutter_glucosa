import 'package:flutter/material.dart';
import 'package:flutter_glucosa/core/domain/enums/glucose_unit.dart';
import 'package:flutter_glucosa/core/domain/enums/hba1c_unit.dart';
import 'package:flutter_glucosa/features/hba1c/data/providers/hba1c_reading_repository_provider.dart';
import 'package:flutter_glucosa/features/hba1c/presentation/screens/hba1c_calculator_screen.dart';
import 'package:flutter_glucosa/features/settings/data/providers/user_profile_repository_provider.dart';
import 'package:flutter_glucosa/features/settings/domain/entities/user_profile.dart';
import 'package:flutter_glucosa/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/fake_hba1c_reading_repository.dart';
import '../../../../helpers/fake_user_profile_repository.dart';

void main() {
  late FakeHbA1cReadingRepository fakeHbA1cRepo;
  late FakeUserProfileRepository fakeProfileRepo;

  setUp(() {
    fakeHbA1cRepo = FakeHbA1cReadingRepository();
    fakeProfileRepo = FakeUserProfileRepository(
      initialProfile: const UserProfile(
        preferredGlucoseUnit: GlucoseUnit.mgDl,
        preferredHbA1cUnit: HbA1cUnit.percentage,
      ),
    );
  });

  tearDown(() {
    fakeHbA1cRepo.dispose();
    fakeProfileRepo.dispose();
  });

  Widget createWidget() {
    return ProviderScope(
      overrides: [
        hbA1cReadingRepositoryProvider.overrideWithValue(fakeHbA1cRepo),
        userProfileRepositoryProvider.overrideWithValue(fakeProfileRepo),
      ],
      child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: HbA1cCalculatorScreen(),
      ),
    );
  }

  group('HbA1cCalculatorScreen', () {
    testWidgets('renders all initial screen elements', (tester) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createWidget());
      await tester.pumpAndSettle();

      expect(find.text('HbA1c Calculator'), findsOneWidget);
      expect(find.text('Average Glucose'), findsOneWidget);
      expect(find.text('Estimated HbA1c'), findsOneWidget);
      expect(
        find.textContaining('Calculations are based on the ADAG study formula'),
        findsOneWidget,
      );
      expect(find.text('Save as HbA1c Reading'), findsOneWidget);

      // Save button is initially disabled because inputs are empty
      final buttonFinder = find.widgetWithText(
        FilledButton,
        'Save as HbA1c Reading',
      );
      final button = tester.widget<FilledButton>(buttonFinder);
      expect(button.onPressed, isNull);
    });

    testWidgets('calculates estimated HbA1c from average glucose input', (
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

      final textFields = find.byType(TextField);
      final glucoseField = textFields.first;
      final hba1cField = textFields.last;

      await tester.enterText(glucoseField, '154');
      await tester.pumpAndSettle();

      final hba1cWidget = tester.widget<TextField>(hba1cField);
      // (154 + 46.7) / 28.7 = 6.99
      expect(hba1cWidget.controller?.text, '6.99');

      // Save button should now be enabled
      final buttonFinder = find.widgetWithText(
        FilledButton,
        'Save as HbA1c Reading',
      );
      final button = tester.widget<FilledButton>(buttonFinder);
      expect(button.onPressed, isNotNull);
    });

    testWidgets('calculates estimated average glucose from HbA1c input', (
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

      final textFields = find.byType(TextField);
      final glucoseField = textFields.first;
      final hba1cField = textFields.last;

      await tester.enterText(hba1cField, '7.0');
      await tester.pumpAndSettle();

      final glucoseWidget = tester.widget<TextField>(glucoseField);
      // 7.0 * 28.7 - 46.7 = 154
      expect(glucoseWidget.controller?.text, '154');
    });

    testWidgets(
      'changing glucose unit between mg/dL and mmol/L recalculates values',
      (tester) async {
        tester.view.physicalSize = const Size(800, 1400);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        await tester.pumpWidget(createWidget());
        await tester.pumpAndSettle();

        final textFields = find.byType(TextField);
        final glucoseField = textFields.first;

        await tester.enterText(glucoseField, '180');
        await tester.pumpAndSettle();

        // Switch to mmol/L
        await tester.tap(find.text('mmol/L'));
        await tester.pumpAndSettle();

        final glucoseWidget = tester.widget<TextField>(glucoseField);
        // 180 / 18 = 10.0
        expect(glucoseWidget.controller?.text, '10.0');
      },
    );

    testWidgets(
      'saving calculated reading adds entity to repository and shows snackbar',
      (tester) async {
        tester.view.physicalSize = const Size(800, 1400);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        await tester.pumpWidget(createWidget());
        await tester.pumpAndSettle();

        final textFields = find.byType(TextField);
        await tester.enterText(textFields.first, '154');
        await tester.pumpAndSettle();

        final buttonFinder = find.widgetWithText(
          FilledButton,
          'Save as HbA1c Reading',
        );
        await tester.tap(buttonFinder);
        await tester.pumpAndSettle();

        final all = await fakeHbA1cRepo.getAll();
        expect(all.length, 1);
        expect(all.first.readingPercentage, 6.99);
        expect(
          all.first.notes,
          contains('Estimated from average glucose calculator'),
        );
        expect(find.text('HbA1c reading saved successfully'), findsOneWidget);
      },
    );

    testWidgets(
      'clearing glucose input clears estimated HbA1c and disables save',
      (tester) async {
        tester.view.physicalSize = const Size(800, 1400);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        await tester.pumpWidget(createWidget());
        await tester.pumpAndSettle();

        final textFields = find.byType(TextField);
        final glucoseField = textFields.first;
        final hba1cField = textFields.last;

        await tester.enterText(glucoseField, '154');
        await tester.pumpAndSettle();

        await tester.enterText(glucoseField, '');
        await tester.pumpAndSettle();

        final hba1cWidget = tester.widget<TextField>(hba1cField);
        expect(hba1cWidget.controller?.text, isEmpty);

        final buttonFinder = find.widgetWithText(
          FilledButton,
          'Save as HbA1c Reading',
        );
        final button = tester.widget<FilledButton>(buttonFinder);
        expect(button.onPressed, isNull);
      },
    );
  });
}
