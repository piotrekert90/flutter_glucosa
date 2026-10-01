import 'package:flutter/material.dart';
import 'package:flutter_glucosa/core/presentation/theme/app_theme.dart';
import 'package:flutter_glucosa/features/ketones/domain/entities/ketone_reading.dart';
import 'package:flutter_glucosa/features/ketones/presentation/widgets/ketone_reading_card.dart';
import 'package:flutter_glucosa/l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

final _testReading = KetoneReading(
  id: 1,
  readingMmolL: 0.4,
  createdAt: DateTime(2026, 10, 2, 7, 30),
  notes: 'Fasting check',
);

Widget createWidget({required KetoneReading reading, VoidCallback? onTap}) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    theme: AppTheme.lightTheme,
    home: Scaffold(
      body: KetoneReadingCard(reading: reading, onTap: onTap),
    ),
  );
}

void main() {
  group('KetoneReadingCard', () {
    testWidgets('renders reading value, unit, status and note', (tester) async {
      await tester.pumpWidget(createWidget(reading: _testReading));
      await tester.pumpAndSettle();

      expect(find.text('0.4'), findsOneWidget);
      expect(find.text('mmol/L'), findsOneWidget);
      expect(find.text('Normal (<0.6)'), findsOneWidget);
      expect(find.text('Fasting check'), findsOneWidget);
    });

    testWidgets('renders elevated status badge for 0.6-1.5 mmol/L', (
      tester,
    ) async {
      final elevatedReading = _testReading.copyWith(readingMmolL: 1.0);
      await tester.pumpWidget(createWidget(reading: elevatedReading));
      await tester.pumpAndSettle();

      expect(find.text('Elevated (0.6-1.5)'), findsOneWidget);
    });

    testWidgets('renders high status badge when ketones exceed 1.5', (
      tester,
    ) async {
      final highReading = _testReading.copyWith(readingMmolL: 2.8);
      await tester.pumpWidget(createWidget(reading: highReading));
      await tester.pumpAndSettle();

      expect(find.text('High (>1.5)'), findsOneWidget);
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
