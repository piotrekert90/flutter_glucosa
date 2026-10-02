import 'package:flutter/material.dart';
import 'package:flutter_glucosa/features/overview/domain/daily_tip_provider.dart';
import 'package:flutter_glucosa/features/overview/presentation/widgets/daily_tip_card.dart';
import 'package:flutter_glucosa/l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DailyTipProvider', () {
    test('cycles within tipCount across the year', () {
      for (var month = 1; month <= 12; month++) {
        final index = DailyTipProvider.indexFor(DateTime(2026, month, 15));
        expect(index, greaterThanOrEqualTo(0));
        expect(index, lessThan(DailyTipProvider.tipCount));
      }
    });

    test('returns the same index for the same date', () {
      final date = DateTime(2026, 5, 20);
      expect(DailyTipProvider.indexFor(date), DailyTipProvider.indexFor(date));
    });

    test('wraps around after tipCount days', () {
      final start = DateTime(2026, 1, 1);
      expect(
        DailyTipProvider.indexFor(start),
        DailyTipProvider.indexFor(
          start.add(const Duration(days: DailyTipProvider.tipCount)),
        ),
      );
    });
  });

  group('DailyTipCard', () {
    testWidgets('renders title and tip text', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(body: DailyTipCard()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Daily tip'), findsOneWidget);
      expect(find.byIcon(Icons.lightbulb_outline_rounded), findsOneWidget);
    });
  });
}
