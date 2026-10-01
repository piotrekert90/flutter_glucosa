import 'package:flutter/material.dart';
import 'package:flutter_glucosa/core/presentation/theme/app_theme.dart';
import 'package:flutter_glucosa/features/blood_pressure/domain/entities/blood_pressure_reading.dart';
import 'package:flutter_glucosa/features/blood_pressure/presentation/widgets/blood_pressure_reading_card.dart';
import 'package:flutter_glucosa/l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

final _testReading = BloodPressureReading(
  id: 1,
  systolicMmHg: 118,
  diastolicMmHg: 76,
  createdAt: DateTime(2026, 10, 2, 7, 30),
  notes: 'Morning check',
);

Widget createWidget({
  required BloodPressureReading reading,
  VoidCallback? onTap,
}) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    theme: AppTheme.lightTheme,
    home: Scaffold(
      body: BloodPressureReadingCard(reading: reading, onTap: onTap),
    ),
  );
}

void main() {
  group('BloodPressureReadingCard', () {
    testWidgets('renders reading value, unit, status and note', (tester) async {
      await tester.pumpWidget(createWidget(reading: _testReading));
      await tester.pumpAndSettle();

      expect(find.text('118/76'), findsOneWidget);
      expect(find.text('mmHg'), findsOneWidget);
      expect(find.text('Normal (<120/80)'), findsOneWidget);
      expect(find.text('Morning check'), findsOneWidget);
    });

    testWidgets('renders elevated status badge for 120-129/<80', (
      tester,
    ) async {
      final elevatedReading = _testReading.copyWith(
        systolicMmHg: 125,
        diastolicMmHg: 78,
      );
      await tester.pumpWidget(createWidget(reading: elevatedReading));
      await tester.pumpAndSettle();

      expect(find.text('Elevated (120-129/<80)'), findsOneWidget);
    });

    testWidgets('renders high status badge when systolic >= 130', (
      tester,
    ) async {
      final highReading = _testReading.copyWith(
        systolicMmHg: 142,
        diastolicMmHg: 92,
      );
      await tester.pumpWidget(createWidget(reading: highReading));
      await tester.pumpAndSettle();

      expect(find.text('High (≥130/80)'), findsOneWidget);
    });

    testWidgets('invokes onTap callback when card is tapped', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        createWidget(
          reading: _testReading,
          onTap: () {
            tapped = true;
          },
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(Card));
      expect(tapped, isTrue);
    });
  });
}
