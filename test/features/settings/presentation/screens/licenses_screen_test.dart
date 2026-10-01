import 'package:flutter/material.dart';
import 'package:flutter_riverpod_boilerplate/features/settings/presentation/screens/licenses_screen.dart';
import 'package:flutter_riverpod_boilerplate/l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';

void main() {
  testWidgets('LicensesScreen renders app bar and header info', (tester) async {
    final packageInfo = PackageInfo(
      appName: 'Flutter Boilerplate',
      packageName: 'com.example.flutter_riverpod_boilerplate',
      version: '1.0.0',
      buildNumber: '1',
    );

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: LicensesScreen(packageInfo: packageInfo),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Licenses'), findsOneWidget);
  });
}
