import 'package:flutter/material.dart';
import 'package:flutter_glucosa/core/presentation/theme/app_feedback_theme.dart';
import 'package:flutter_glucosa/features/cholesterol/domain/enums/cholesterol_status.dart';
import 'package:flutter_glucosa/features/cholesterol/presentation/extensions/cholesterol_status_ui_extension.dart';
import 'package:flutter_glucosa/l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final l10n = lookupAppLocalizations(const Locale('en'));

  group('CholesterolStatusUiExtension', () {
    test('localizedName returns correct strings for all statuses', () {
      expect(
        CholesterolStatus.normal.localizedName(l10n),
        l10n.cholesterolStatusNormal,
      );
      expect(
        CholesterolStatus.borderline.localizedName(l10n),
        l10n.cholesterolStatusElevated,
      );
      expect(
        CholesterolStatus.high.localizedName(l10n),
        l10n.cholesterolStatusHigh,
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
        CholesterolStatus.normal.foregroundColor(darkContext),
        AppFeedbackTheme.successForegroundDark,
      );
      expect(
        CholesterolStatus.borderline.foregroundColor(darkContext),
        AppFeedbackTheme.warningForegroundDark,
      );
      expect(
        CholesterolStatus.high.foregroundColor(darkContext),
        AppFeedbackTheme.errorForegroundDark,
      );

      expect(
        CholesterolStatus.normal.foregroundColor(lightContext),
        AppFeedbackTheme.successForegroundLight,
      );
      expect(
        CholesterolStatus.borderline.foregroundColor(lightContext),
        AppFeedbackTheme.warningForegroundLight,
      );
      expect(
        CholesterolStatus.high.foregroundColor(lightContext),
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
        CholesterolStatus.normal.backgroundColor(darkContext),
        AppFeedbackTheme.successBackgroundDark,
      );
      expect(
        CholesterolStatus.borderline.backgroundColor(darkContext),
        AppFeedbackTheme.warningBackgroundDark,
      );
      expect(
        CholesterolStatus.high.backgroundColor(darkContext),
        AppFeedbackTheme.errorBackgroundDark,
      );

      expect(
        CholesterolStatus.normal.backgroundColor(lightContext),
        AppFeedbackTheme.successBackgroundLight,
      );
      expect(
        CholesterolStatus.borderline.backgroundColor(lightContext),
        AppFeedbackTheme.warningBackgroundLight,
      );
      expect(
        CholesterolStatus.high.backgroundColor(lightContext),
        AppFeedbackTheme.errorBackgroundLight,
      );
    });
  });
}
