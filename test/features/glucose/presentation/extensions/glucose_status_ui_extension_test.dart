import 'package:flutter/material.dart';
import 'package:flutter_glucosa/core/domain/enums/glucose_status.dart';
import 'package:flutter_glucosa/core/domain/enums/meal_context.dart';
import 'package:flutter_glucosa/core/presentation/theme/app_feedback_theme.dart';
import 'package:flutter_glucosa/features/glucose/presentation/extensions/glucose_status_ui_extension.dart';
import 'package:flutter_glucosa/l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final l10n = lookupAppLocalizations(const Locale('en'));

  group('GlucoseStatusUiExtension', () {
    test('localizedName returns correct strings for all statuses', () {
      expect(
        GlucoseStatus.hypoglycemia.localizedName(l10n),
        l10n.statusHypoglycemia,
      );
      expect(GlucoseStatus.low.localizedName(l10n), l10n.statusLow);
      expect(GlucoseStatus.inRange.localizedName(l10n), l10n.statusInRange);
      expect(GlucoseStatus.high.localizedName(l10n), l10n.statusHigh);
      expect(
        GlucoseStatus.hyperglycemia.localizedName(l10n),
        l10n.statusHyperglycemia,
      );
    });

    testWidgets('foregroundColor respects dark and light theme brightness', (
      tester,
    ) async {
      late BuildContext darkContext;
      late BuildContext lightContext;

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          home: Column(
            children: [
              Theme(
                data: ThemeData(brightness: Brightness.dark),
                child: Builder(
                  builder: (context) {
                    darkContext = context;
                    return const SizedBox.shrink();
                  },
                ),
              ),
              Theme(
                data: ThemeData(brightness: Brightness.light),
                child: Builder(
                  builder: (context) {
                    lightContext = context;
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      );

      // Dark mode assertions
      expect(
        GlucoseStatus.hypoglycemia.foregroundColor(darkContext),
        equals(AppFeedbackTheme.errorForegroundDark),
      );
      expect(
        GlucoseStatus.hyperglycemia.foregroundColor(darkContext),
        equals(AppFeedbackTheme.errorForegroundDark),
      );
      expect(
        GlucoseStatus.low.foregroundColor(darkContext),
        equals(AppFeedbackTheme.warningForegroundDark),
      );
      expect(
        GlucoseStatus.high.foregroundColor(darkContext),
        equals(AppFeedbackTheme.warningForegroundDark),
      );
      expect(
        GlucoseStatus.inRange.foregroundColor(darkContext),
        equals(AppFeedbackTheme.successForegroundDark),
      );

      // Light mode assertions
      expect(
        GlucoseStatus.hypoglycemia.foregroundColor(lightContext),
        equals(AppFeedbackTheme.errorForegroundLight),
      );
      expect(
        GlucoseStatus.hyperglycemia.foregroundColor(lightContext),
        equals(AppFeedbackTheme.errorForegroundLight),
      );
      expect(
        GlucoseStatus.low.foregroundColor(lightContext),
        equals(AppFeedbackTheme.warningForegroundLight),
      );
      expect(
        GlucoseStatus.high.foregroundColor(lightContext),
        equals(AppFeedbackTheme.warningForegroundLight),
      );
      expect(
        GlucoseStatus.inRange.foregroundColor(lightContext),
        equals(AppFeedbackTheme.successForegroundLight),
      );
    });

    testWidgets('backgroundColor respects dark and light theme brightness', (
      tester,
    ) async {
      late BuildContext darkContext;
      late BuildContext lightContext;

      await tester.pumpWidget(
        MaterialApp(
          home: Column(
            children: [
              Theme(
                data: ThemeData(brightness: Brightness.dark),
                child: Builder(
                  builder: (context) {
                    darkContext = context;
                    return const SizedBox.shrink();
                  },
                ),
              ),
              Theme(
                data: ThemeData(brightness: Brightness.light),
                child: Builder(
                  builder: (context) {
                    lightContext = context;
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      );

      // Dark mode assertions
      expect(
        GlucoseStatus.hypoglycemia.backgroundColor(darkContext),
        equals(AppFeedbackTheme.errorBackgroundDark),
      );
      expect(
        GlucoseStatus.hyperglycemia.backgroundColor(darkContext),
        equals(AppFeedbackTheme.errorBackgroundDark),
      );
      expect(
        GlucoseStatus.low.backgroundColor(darkContext),
        equals(AppFeedbackTheme.warningBackgroundDark),
      );
      expect(
        GlucoseStatus.high.backgroundColor(darkContext),
        equals(AppFeedbackTheme.warningBackgroundDark),
      );
      expect(
        GlucoseStatus.inRange.backgroundColor(darkContext),
        equals(AppFeedbackTheme.successBackgroundDark),
      );

      // Light mode assertions
      expect(
        GlucoseStatus.hypoglycemia.backgroundColor(lightContext),
        equals(AppFeedbackTheme.errorBackgroundLight),
      );
      expect(
        GlucoseStatus.hyperglycemia.backgroundColor(lightContext),
        equals(AppFeedbackTheme.errorBackgroundLight),
      );
      expect(
        GlucoseStatus.low.backgroundColor(lightContext),
        equals(AppFeedbackTheme.warningBackgroundLight),
      );
      expect(
        GlucoseStatus.high.backgroundColor(lightContext),
        equals(AppFeedbackTheme.warningBackgroundLight),
      );
      expect(
        GlucoseStatus.inRange.backgroundColor(lightContext),
        equals(AppFeedbackTheme.successBackgroundLight),
      );
    });
  });

  group('MealContextUiExtension', () {
    test('localizedName returns correct strings for all contexts', () {
      expect(
        MealContext.beforeBreakfast.localizedName(l10n),
        equals(l10n.mealContextBeforeBreakfast),
      );
      expect(
        MealContext.afterBreakfast.localizedName(l10n),
        equals(l10n.mealContextAfterBreakfast),
      );
      expect(
        MealContext.beforeLunch.localizedName(l10n),
        equals(l10n.mealContextBeforeLunch),
      );
      expect(
        MealContext.afterLunch.localizedName(l10n),
        equals(l10n.mealContextAfterLunch),
      );
      expect(
        MealContext.beforeDinner.localizedName(l10n),
        equals(l10n.mealContextBeforeDinner),
      );
      expect(
        MealContext.afterDinner.localizedName(l10n),
        equals(l10n.mealContextAfterDinner),
      );
      expect(
        MealContext.snack.localizedName(l10n),
        equals(l10n.mealContextSnack),
      );
      expect(
        MealContext.bedtime.localizedName(l10n),
        equals(l10n.mealContextBedtime),
      );
      expect(
        MealContext.night.localizedName(l10n),
        equals(l10n.mealContextNight),
      );
      expect(
        MealContext.fasting.localizedName(l10n),
        equals(l10n.mealContextFasting),
      );
      expect(
        MealContext.recheck.localizedName(l10n),
        equals(l10n.mealContextRecheck),
      );
      expect(
        MealContext.other.localizedName(l10n),
        equals(l10n.mealContextOther),
      );
    });
  });
}
