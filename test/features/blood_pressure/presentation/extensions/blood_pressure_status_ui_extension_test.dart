import 'package:flutter/material.dart';
import 'package:flutter_glucosa/core/presentation/theme/app_feedback_theme.dart';
import 'package:flutter_glucosa/features/blood_pressure/domain/enums/blood_pressure_status.dart';
import 'package:flutter_glucosa/features/blood_pressure/presentation/extensions/blood_pressure_status_ui_extension.dart';
import 'package:flutter_glucosa/l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final l10n = lookupAppLocalizations(const Locale('en'));

  group('BloodPressureStatusUiExtension', () {
    test('localizedName returns correct strings for all statuses', () {
      expect(
        BloodPressureStatus.normal.localizedName(l10n),
        l10n.bpStatusNormal,
      );
      expect(
        BloodPressureStatus.elevated.localizedName(l10n),
        l10n.bpStatusElevated,
      );
      expect(BloodPressureStatus.high.localizedName(l10n), l10n.bpStatusHigh);
      expect(
        BloodPressureStatus.crisis.localizedName(l10n),
        l10n.bpStatusCrisis,
      );
    });

    testWidgets('foregroundColor maps severity to semantic colors', (
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

      expect(
        BloodPressureStatus.normal.foregroundColor(darkContext),
        AppFeedbackTheme.successForegroundDark,
      );
      expect(
        BloodPressureStatus.elevated.foregroundColor(darkContext),
        AppFeedbackTheme.warningForegroundDark,
      );
      expect(
        BloodPressureStatus.high.foregroundColor(darkContext),
        AppFeedbackTheme.errorForegroundDark,
      );
      expect(
        BloodPressureStatus.crisis.foregroundColor(darkContext),
        AppFeedbackTheme.errorForegroundDark,
      );

      expect(
        BloodPressureStatus.normal.foregroundColor(lightContext),
        AppFeedbackTheme.successForegroundLight,
      );
      expect(
        BloodPressureStatus.elevated.foregroundColor(lightContext),
        AppFeedbackTheme.warningForegroundLight,
      );
      expect(
        BloodPressureStatus.high.foregroundColor(lightContext),
        AppFeedbackTheme.errorForegroundLight,
      );
      expect(
        BloodPressureStatus.crisis.foregroundColor(lightContext),
        AppFeedbackTheme.errorForegroundLight,
      );
    });

    testWidgets('backgroundColor maps severity to semantic colors', (
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

      expect(
        BloodPressureStatus.normal.backgroundColor(darkContext),
        AppFeedbackTheme.successBackgroundDark,
      );
      expect(
        BloodPressureStatus.elevated.backgroundColor(darkContext),
        AppFeedbackTheme.warningBackgroundDark,
      );
      expect(
        BloodPressureStatus.crisis.backgroundColor(darkContext),
        AppFeedbackTheme.errorBackgroundDark,
      );

      expect(
        BloodPressureStatus.normal.backgroundColor(lightContext),
        AppFeedbackTheme.successBackgroundLight,
      );
      expect(
        BloodPressureStatus.elevated.backgroundColor(lightContext),
        AppFeedbackTheme.warningBackgroundLight,
      );
      expect(
        BloodPressureStatus.crisis.backgroundColor(lightContext),
        AppFeedbackTheme.errorBackgroundLight,
      );
    });
  });
}
