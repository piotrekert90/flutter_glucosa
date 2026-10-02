import 'package:flutter/material.dart';
import 'package:flutter_glucosa/core/presentation/theme/app_theme.dart';
import 'package:flutter_glucosa/features/statistics/presentation/widgets/sections/habits_activity_card.dart';
import 'package:flutter_glucosa/l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildTestWidget({
    required int streak,
    required int bestStreak,
    required int compliancePct,
  }) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: SingleChildScrollView(
          child: HabitsActivityCard(
            streak: streak,
            bestStreak: bestStreak,
            compliancePct: compliancePct,
          ),
        ),
      ),
    );
  }

  group('HabitsActivityCard', () {
    testWidgets('renders streak and compliance metrics accurately', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(streak: 5, bestStreak: 14, compliancePct: 82),
      );
      await tester.pumpAndSettle();

      expect(find.byType(HabitsActivityCard), findsOneWidget);
      expect(find.text('Habits & Streaks'), findsOneWidget);
      expect(find.text('Current Streak'), findsOneWidget);
      expect(find.text('5 days'), findsOneWidget);
      expect(find.text('Best Streak'), findsOneWidget);
      expect(find.text('14 days'), findsOneWidget);
      expect(find.text('Monthly Compliance'), findsOneWidget);
      expect(find.text('82%'), findsOneWidget);
    });

    testWidgets('handles zero streak correctly with singular day format', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestWidget(streak: 1, bestStreak: 1, compliancePct: 10),
      );
      await tester.pumpAndSettle();

      expect(find.text('1 day'), findsNWidgets(2));
      expect(find.text('10%'), findsOneWidget);
    });
  });
}
