@Tags(['screenshot'])
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:local_auth_platform_interface/local_auth_platform_interface.dart';

import 'package:flutter_glucosa/core/integrations/biometrics/biometric_service.dart';
import 'package:flutter_glucosa/core/presentation/screens/biometric_shield_screen.dart';
import 'package:flutter_glucosa/core/presentation/theme/app_theme.dart';
import 'package:flutter_glucosa/l10n/app_localizations.dart';
import 'helpers/screenshot_test_helper.dart';

class _FakeLocalAuthPlatform extends LocalAuthPlatform {
  final Future<bool> Function()? authenticateHandler;

  _FakeLocalAuthPlatform({this.authenticateHandler});

  @override
  Future<bool> deviceSupportsBiometrics() async => true;

  @override
  Future<bool> isDeviceSupported() async => true;

  @override
  Future<List<BiometricType>> getEnrolledBiometrics() async => [
    BiometricType.fingerprint,
  ];

  @override
  Future<bool> authenticate({
    required String localizedReason,
    required Iterable<AuthMessages> authMessages,
    AuthenticationOptions options = const AuthenticationOptions(),
  }) async {
    final handler = authenticateHandler;
    return handler != null ? await handler() : true;
  }
}

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  final effectiveLocales = getEffectiveLocales();
  final prefix = getScreenshotPrefix();

  setUpAll(() async {
    await initScreenshotEnvironment(binding);
    // Keep authentication pending so the shield screen remains stably displayed
    final completer = Completer<bool>();
    LocalAuthPlatform.instance = _FakeLocalAuthPlatform(
      authenticateHandler: () => completer.future,
    );
    BiometricService.resetForTesting();
  });

  group('06_biometric Screenshot Generator', () {
    for (final localeCode in effectiveLocales) {
      for (final isDark in [false, true]) {
        final themeLabel = isDark ? 'dark' : 'light';
        final theme = isDark ? AppTheme.darkTheme : AppTheme.lightTheme;
        final themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
        final locale = Locale(localeCode);

        // 06_biometric / 01_biometric_lock
        testWidgets(
          'Capture 06_biometric/01_biometric_lock [$localeCode] [$themeLabel]',
          (WidgetTester tester) async {
            await tester.pumpWidget(
              MaterialApp(
                debugShowCheckedModeBanner: false,
                locale: locale,
                supportedLocales: AppLocalizations.supportedLocales,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                theme: theme,
                themeMode: themeMode,
                home: ScreenshotDeviceFrame(
                  isDark: isDark,
                  child: const BiometricShieldScreen(),
                ),
              ),
            );

            await tester.pump();
            await tester.pump(const Duration(milliseconds: 300));

            await binding.takeScreenshot(
              '$prefix$localeCode/06_biometric/01_biometric_lock_$themeLabel',
            );
          },
          tags: 'screenshot',
        );
      }
    }
  });
}
