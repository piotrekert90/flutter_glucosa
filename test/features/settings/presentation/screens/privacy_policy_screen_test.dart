import 'package:flutter/material.dart';
import 'package:flutter_riverpod_boilerplate/features/settings/presentation/screens/privacy_policy_screen.dart';
import 'package:flutter_riverpod_boilerplate/l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('PrivacyPolicyScreen renders title and contact button', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 1800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: PrivacyPolicyScreen(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Privacy Policy'), findsOneWidget);
    expect(find.text('contact@example.com'), findsOneWidget);
  });
}
