import 'package:flutter/material.dart';
import 'package:flutter_glucosa/core/presentation/theme/app_theme.dart';
import 'package:flutter_glucosa/features/cholesterol/domain/entities/cholesterol_reading.dart';
import 'package:flutter_glucosa/features/cholesterol/presentation/widgets/cholesterol_reading_card.dart';
import 'package:flutter_glucosa/l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

final _testReading = CholesterolReading(
  id: 1,
  totalMgDl: 190,
  ldlMgDl: 110,
  hdlMgDl: 55,
  createdAt: DateTime(2026, 10, 2, 7, 30),
  notes: 'Annual panel',
);

Widget createWidget({
  required CholesterolReading reading,
  VoidCallback? onTap,
}) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    theme: AppTheme.lightTheme,
    home: Scaffold(
      body: CholesterolReadingCard(reading: reading, onTap: onTap),
    ),
  );
}

void main() {
  group('CholesterolReadingCard', () {
    testWidgets('renders total value, unit, status, lipids and note', (
      tester,
    ) async {
      await tester.pumpWidget(createWidget(reading: _testReading));
      await tester.pumpAndSettle();

      expect(find.text('190'), findsOneWidget);
      expect(find.text('mg/dL'), findsOneWidget);
      expect(find.text('Normal (<200)'), findsOneWidget);
      expect(find.text('LDL 110 · HDL 55'), findsOneWidget);
      expect(find.text('Annual panel'), findsOneWidget);
    });

    testWidgets('renders borderline status badge for total 200-239', (
      tester,
    ) async {
      final borderlineReading = _testReading.copyWith(totalMgDl: 220);
      await tester.pumpWidget(createWidget(reading: borderlineReading));
      await tester.pumpAndSettle();

      expect(find.text('Borderline (200-239)'), findsOneWidget);
    });

    testWidgets('renders high status badge when total is at least 240', (
      tester,
    ) async {
      final highReading = _testReading.copyWith(totalMgDl: 250);
      await tester.pumpWidget(createWidget(reading: highReading));
      await tester.pumpAndSettle();

      expect(find.text('High (≥240)'), findsOneWidget);
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
