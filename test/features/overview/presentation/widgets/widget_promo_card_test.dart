import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_glucosa/core/presentation/theme/app_theme.dart';
import 'package:flutter_glucosa/features/overview/presentation/widgets/widget_promo_card.dart';
import 'package:flutter_glucosa/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('WidgetPromoCard', () {
    testWidgets('stays hidden without a native widget host', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(body: WidgetPromoCard()),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Glucose at a glance'), findsNothing);
      expect(find.text('Pin'), findsNothing);
    });

    testWidgets('renders pin action on a 360dp phone when eligible', (
      tester,
    ) async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(const MethodChannel('home_widget'), (
            call,
          ) async {
            switch (call.method) {
              case 'isRequestPinWidgetSupported':
                return true;
              case 'getInstalledWidgets':
                return <dynamic>[];
              default:
                return null;
            }
          });

      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 3.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            theme: AppTheme.lightTheme,
            home: const Scaffold(body: WidgetPromoCard()),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Glucose at a glance'), findsOneWidget);
      expect(find.text('Pin'), findsOneWidget);
    });
  });
}
