import 'package:flutter/material.dart';
import 'package:flutter_glucosa/core/domain/enums/enums.dart';
import 'package:flutter_glucosa/core/domain/value_objects/glucose_target_range.dart';
import 'package:flutter_glucosa/features/glucose/domain/entities/glucose_reading.dart';
import 'package:flutter_glucosa/features/settings/domain/entities/user_profile.dart';
import 'package:flutter_glucosa/features/statistics/presentation/utils/progress_summary_formatter.dart';
import 'package:flutter_glucosa/l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:intl/date_symbol_data_local.dart';

void main() {
  group('ProgressSummaryFormatter', () {
    final now = DateTime(2026, 10, 14, 12);
    late AppLocalizations l10n;

    setUpAll(() async {
      await initializeDateFormatting('en');
      l10n = await AppLocalizations.delegate.load(const Locale('en'));
    });

    test('returns empty string when readings list is empty', () {
      final summary = ProgressSummaryFormatter.format(
        readings: [],
        profile: const UserProfile(name: 'John Doe'),
        l10n: l10n,
        now: now,
      );
      expect(summary, isEmpty);
    });

    test(
      'formats clinical summary with patient name, glucose metrics, and TIR breakdown',
      () {
        final readings = [
          GlucoseReading(
            id: 1,
            readingMgDl: 100,
            createdAt: DateTime(2026, 10, 10, 8),
            mealContext: MealContext.fasting,
          ),
          GlucoseReading(
            id: 2,
            readingMgDl: 120,
            createdAt: DateTime(2026, 10, 12, 12),
            mealContext: MealContext.afterBreakfast,
          ),
          GlucoseReading(
            id: 3,
            readingMgDl: 60, // hypo
            createdAt: DateTime(2026, 10, 14, 9),
            mealContext: MealContext.fasting,
          ),
        ];

        const profile = UserProfile(
          name: 'Jane Doe',
          preferredGlucoseUnit: GlucoseUnit.mgDl,
          targetRange: GlucoseTargetRange.ada(),
        );

        final summary = ProgressSummaryFormatter.format(
          readings: readings,
          profile: profile,
          l10n: l10n,
          windowDays: 7,
          now: now,
        );

        expect(summary, contains('Glucosa — Clinical Health Summary'));
        expect(summary, contains('Patient: Jane Doe'));
        expect(
          summary,
          contains('Mean Blood Glucose: 93 mg/dL'),
        ); // (100+120+60)/3 = 93.33
        expect(
          summary,
          contains('Estimated HbA1c: 4.9%'),
        ); // (93.33 + 46.7) / 28.7 = 4.88% -> 4.9%
        expect(summary, contains('In Range: 66.7%')); // 2 of 3
        expect(summary, contains('Below Range (Hypo): 33.3%')); // 1 of 3
        expect(summary, contains('Total Readings Logged: 3'));
        expect(summary, contains('Hypoglycemic Incidents: 1'));
      },
    );

    test('formats correctly when preferred unit is mmol/L', () {
      final readings = [
        GlucoseReading(
          id: 1,
          readingMgDl: 90, // 5.0 mmol/L
          createdAt: DateTime(2026, 10, 14, 8),
          mealContext: MealContext.fasting,
        ),
      ];

      const profile = UserProfile(
        name: 'Alex',
        preferredGlucoseUnit: GlucoseUnit.mmolL,
        targetRange: GlucoseTargetRange.ada(),
      );

      final summary = ProgressSummaryFormatter.format(
        readings: readings,
        profile: profile,
        l10n: l10n,
        windowDays: 7,
        now: now,
      );

      expect(summary, contains('Mean Blood Glucose: 5.0 mmol/L'));
      expect(summary, contains('Target Range: 3.9 – 10.0 mmol/L'));
    });
  });
}
