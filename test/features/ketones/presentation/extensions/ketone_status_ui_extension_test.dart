import 'package:flutter/material.dart';
import 'package:flutter_glucosa/core/presentation/theme/app_feedback_theme.dart';
import 'package:flutter_glucosa/features/ketones/domain/enums/ketone_status.dart';
import 'package:flutter_glucosa/features/ketones/presentation/extensions/ketone_status_ui_extension.dart';
import 'package:flutter_glucosa/l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final l10n = lookupAppLocalizations(const Locale('en'));

  group('KetoneStatusUiExtension', () {
    test('localizedName returns correct strings for all statuses', () {
      expect(KetoneStatus.normal.localizedName(l10n), l10n.ketoneStatusNormal);
      expect(
        KetoneStatus.elevated.localizedName(l10n),
        l10n.ketoneStatusElevated,
      );
      expect(KetoneStatus.high.localizedName(l10n), l10n.ketoneStatusHigh);
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
        KetoneStatus.normal.foregroundColor(darkContext),
        AppFeedbackTheme.successForegroundDark,
      );
      expect(
        KetoneStatus.elevated.foregroundColor(darkContext),
        AppFeedbackTheme.warningForegroundDark,
      );
      expect(
        KetoneStatus.high.foregroundColor(darkContext),
        AppFeedbackTheme.errorForegroundDark,
      );

      expect(
        KetoneStatus.normal.foregroundColor(lightContext),
        AppFeedbackTheme.successForegroundLight,
      );
      expect(
        KetoneStatus.elevated.foregroundColor(lightContext),
        AppFeedbackTheme.warningForegroundLight,
      );
      expect(
        KetoneStatus.high.foregroundColor(lightContext),
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
        KetoneStatus.normal.backgroundColor(darkContext),
        AppFeedbackTheme.successBackgroundDark,
      );
      expect(
        KetoneStatus.elevated.backgroundColor(darkContext),
        AppFeedbackTheme.warningBackgroundDark,
      );
      expect(
        KetoneStatus.high.backgroundColor(darkContext),
        AppFeedbackTheme.errorBackgroundDark,
      );

      expect(
        KetoneStatus.normal.backgroundColor(lightContext),
        AppFeedbackTheme.successBackgroundLight,
      );
      expect(
        KetoneStatus.elevated.backgroundColor(lightContext),
        AppFeedbackTheme.warningBackgroundLight,
      );
      expect(
        KetoneStatus.high.backgroundColor(lightContext),
        AppFeedbackTheme.errorBackgroundLight,
      );
    });
  });
}
