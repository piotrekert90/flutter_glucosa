import 'package:flutter/material.dart';
import 'package:flutter_glucosa/core/presentation/theme/app_feedback_theme.dart';
import 'package:flutter_glucosa/features/hba1c/domain/enums/hba1c_status.dart';
import 'package:flutter_glucosa/features/hba1c/presentation/extensions/hba1c_status_ui_extension.dart';
import 'package:flutter_glucosa/l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final l10n = lookupAppLocalizations(const Locale('en'));

  group('HbA1cStatusUiExtension', () {
    test('localizedName returns correct strings for all statuses', () {
      expect(HbA1cStatus.normal.localizedName(l10n), l10n.hba1cStatusNormal);
      expect(
        HbA1cStatus.elevated.localizedName(l10n),
        l10n.hba1cStatusElevated,
      );
      expect(HbA1cStatus.high.localizedName(l10n), l10n.hba1cStatusHigh);
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
        HbA1cStatus.normal.foregroundColor(darkContext),
        AppFeedbackTheme.successForegroundDark,
      );
      expect(
        HbA1cStatus.elevated.foregroundColor(darkContext),
        AppFeedbackTheme.warningForegroundDark,
      );
      expect(
        HbA1cStatus.high.foregroundColor(darkContext),
        AppFeedbackTheme.errorForegroundDark,
      );

      expect(
        HbA1cStatus.normal.foregroundColor(lightContext),
        AppFeedbackTheme.successForegroundLight,
      );
      expect(
        HbA1cStatus.elevated.foregroundColor(lightContext),
        AppFeedbackTheme.warningForegroundLight,
      );
      expect(
        HbA1cStatus.high.foregroundColor(lightContext),
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
        HbA1cStatus.normal.backgroundColor(darkContext),
        AppFeedbackTheme.successBackgroundDark,
      );
      expect(
        HbA1cStatus.elevated.backgroundColor(darkContext),
        AppFeedbackTheme.warningBackgroundDark,
      );
      expect(
        HbA1cStatus.high.backgroundColor(darkContext),
        AppFeedbackTheme.errorBackgroundDark,
      );

      expect(
        HbA1cStatus.normal.backgroundColor(lightContext),
        AppFeedbackTheme.successBackgroundLight,
      );
      expect(
        HbA1cStatus.elevated.backgroundColor(lightContext),
        AppFeedbackTheme.warningBackgroundLight,
      );
      expect(
        HbA1cStatus.high.backgroundColor(lightContext),
        AppFeedbackTheme.errorBackgroundLight,
      );
    });
  });
}
