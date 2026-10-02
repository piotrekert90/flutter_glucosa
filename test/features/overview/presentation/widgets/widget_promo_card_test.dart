import 'package:flutter/material.dart';
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
  });
}
