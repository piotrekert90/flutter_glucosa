import 'package:flutter/material.dart';
import 'package:flutter_glucosa/core/domain/enums/glucose_unit.dart';
import 'package:flutter_glucosa/core/domain/value_objects/glucose_target_range.dart';
import 'package:flutter_glucosa/core/presentation/theme/app_theme.dart';
import 'package:flutter_glucosa/features/statistics/domain/entities/period_comparison.dart';
import 'package:flutter_glucosa/features/statistics/presentation/widgets/sections/period_comparison_card.dart';
import 'package:flutter_glucosa/l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildTestWidget({GlucosePeriodComparisonResult? comparisonOverride}) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: SingleChildScrollView(
          child: PeriodComparisonCard(
            readings: const [],
            unit: GlucoseUnit.mgDl,
            targetRange: const GlucoseTargetRange.ada(),
            comparisonOverride: comparisonOverride,
          ),
        ),
      ),
    );
  }

  group('PeriodComparisonCard', () {
    testWidgets('renders empty state when insufficient data is present', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(PeriodComparisonCard), findsOneWidget);
      expect(find.text('Period Comparison'), findsOneWidget);
      expect(
        find.text('More data needed in both periods to compare'),
        findsOneWidget,
      );
    });

    testWidgets(
      'renders clinical comparative metrics when comparison data is available',
      (tester) async {
        final mockResult = GlucosePeriodComparisonResult(
          currentPeriod: GlucosePeriodSummary(
            start: DateTime(2026, 10, 8),
            end: DateTime(2026, 10, 14, 23, 59, 59, 999),
            meanGlucoseMgDl: 110.0,
            glucoseSd: 15.0,
            tirPercentage: 85.0,
            tarPercentage: 10.0,
            tbrPercentage: 5.0,
            hypoCount: 1,
            hyperCount: 2,
            readingCount: 20,
          ),
          previousPeriod: GlucosePeriodSummary(
            start: DateTime(2026, 10, 1),
            end: DateTime(2026, 10, 7, 23, 59, 59, 999),
            meanGlucoseMgDl: 125.0,
            glucoseSd: 22.0,
            tirPercentage: 70.0,
            tarPercentage: 20.0,
            tbrPercentage: 10.0,
            hypoCount: 3,
            hyperCount: 4,
            readingCount: 18,
          ),
          deltaMeanGlucose: -15.0,
          deltaGlucoseSd: -7.0,
          deltaTirPercentage: 15.0,
          deltaReadingCount: 2,
          deltaHypoCount: -2,
          hasComparisonData: true,
        );

        await tester.pumpWidget(
          buildTestWidget(comparisonOverride: mockResult),
        );
        await tester.pumpAndSettle();

        expect(find.text('8 Oct – 14 Oct'), findsOneWidget);
        expect(find.text('vs 1 Oct – 7 Oct'), findsOneWidget);

        expect(find.text('Mean Glucose'), findsOneWidget);
        expect(find.text('110 mg/dL'), findsOneWidget);
        expect(find.text('125 mg/dL'), findsOneWidget);
        expect(find.text('-15'), findsOneWidget);

        expect(find.text('Time in Range'), findsOneWidget);
        expect(find.text('85%'), findsOneWidget);
        expect(find.text('70%'), findsOneWidget);
        expect(find.text('+15.0%'), findsOneWidget);

        expect(find.text('Hypo Events'), findsOneWidget);
        expect(find.text('1'), findsWidgets);
        expect(find.text('3'), findsWidgets);
        expect(find.text('-2'), findsOneWidget);
      },
    );
  });
}
