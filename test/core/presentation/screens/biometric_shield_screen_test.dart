import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_auth_platform_interface/local_auth_platform_interface.dart';
import 'package:flutter_glucosa/core/integrations/biometrics/biometric_lock_provider.dart';
import 'package:flutter_glucosa/core/integrations/biometrics/biometric_service.dart';
import 'package:flutter_glucosa/core/presentation/screens/biometric_shield_screen.dart';
import 'package:flutter_glucosa/features/settings/data/providers/user_profile_repository_provider.dart';
import 'package:flutter_glucosa/features/settings/domain/entities/user_profile.dart';
import 'package:flutter_glucosa/l10n/app_localizations.dart';

import '../../../helpers/fake_user_profile_repository.dart';

class FakeLocalAuthPlatform extends LocalAuthPlatform {
  FakeLocalAuthPlatform({
    this.supportsBiometrics = true,
    this.deviceSupported = true,
    this.enrolledBiometrics = const [BiometricType.fingerprint],
    this.authenticateHandler,
  });

  final bool supportsBiometrics;
  final bool deviceSupported;
  final List<BiometricType> enrolledBiometrics;
  final Future<bool> Function()? authenticateHandler;

  @override
  Future<bool> deviceSupportsBiometrics() async => supportsBiometrics;

  @override
  Future<bool> isDeviceSupported() async => deviceSupported;

  @override
  Future<List<BiometricType>> getEnrolledBiometrics() async =>
      enrolledBiometrics;

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
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakeUserProfileRepository repository;

  Widget buildTestWidget({required ProviderContainer container}) {
    return UncontrolledProviderScope(
      container: container,
      child: const MaterialApp(
        locale: Locale('en'),
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: BiometricShieldScreen(),
      ),
    );
  }

  setUp(() {
    LocalAuthPlatform.instance = FakeLocalAuthPlatform();
    repository = FakeUserProfileRepository(
      initialProfile: const UserProfile(
        name: 'Test Patient',
        isBiometricLockEnabled: true,
      ),
    );
    BiometricService.resetForTesting();
  });

  tearDown(() {
    LocalAuthPlatform.instance = FakeLocalAuthPlatform();
    repository.dispose();
  });

  group('BiometricShieldScreen Tests', () {
    testWidgets('renders lock icon, title, description, and unlock button', (
      tester,
    ) async {
      final container = ProviderContainer(
        overrides: [
          userProfileRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(buildTestWidget(container: container));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.lock_outline), findsOneWidget);
      expect(find.byIcon(Icons.fingerprint), findsOneWidget);
      expect(find.byType(FilledButton), findsOneWidget);
      expect(find.text('Unlock'), findsOneWidget);
    });

    testWidgets('successful authentication unlocks the app', (tester) async {
      final container = ProviderContainer(
        overrides: [
          userProfileRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);
      container.read(biometricLockProvider.notifier).setLocked(true);

      await tester.pumpWidget(buildTestWidget(container: container));
      await tester.pumpAndSettle();

      expect(container.read(biometricLockProvider), isFalse);
    });

    testWidgets('disables unlock button while authentication is in progress', (
      tester,
    ) async {
      final completer = Completer<bool>();
      LocalAuthPlatform.instance = FakeLocalAuthPlatform(
        authenticateHandler: () => completer.future,
      );

      final container = ProviderContainer(
        overrides: [
          userProfileRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);
      container.read(biometricLockProvider.notifier).setLocked(true);

      await tester.pumpWidget(buildTestWidget(container: container));
      await tester.pump();
      await tester.pump();

      final button = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(button.onPressed, isNull);

      completer.complete(true);
      await tester.pumpAndSettle();

      expect(container.read(biometricLockProvider), isFalse);
    });

    testWidgets(
      'terminal failure opens lock recovery dialog and user can disable lock',
      (tester) async {
        LocalAuthPlatform.instance = FakeLocalAuthPlatform(
          supportsBiometrics: false,
          deviceSupported: false,
          enrolledBiometrics: const [],
        );

        final container = ProviderContainer(
          overrides: [
            userProfileRepositoryProvider.overrideWithValue(repository),
          ],
        );
        addTearDown(container.dispose);
        container.read(biometricLockProvider.notifier).setLocked(true);

        await tester.pumpWidget(buildTestWidget(container: container));
        await tester.pumpAndSettle();

        expect(find.byType(AlertDialog), findsOneWidget);

        await tester.tap(find.widgetWithText(TextButton, 'Disable Lock'));
        await tester.pumpAndSettle();

        expect(container.read(biometricLockProvider), isFalse);
        final profile = await repository.get();
        expect(profile.isBiometricLockEnabled, isFalse);
      },
    );

    testWidgets('terminal failure dialog can be dismissed with cancel', (
      tester,
    ) async {
      LocalAuthPlatform.instance = FakeLocalAuthPlatform(
        supportsBiometrics: false,
        deviceSupported: false,
        enrolledBiometrics: const [],
      );

      final container = ProviderContainer(
        overrides: [
          userProfileRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);
      container.read(biometricLockProvider.notifier).setLocked(true);

      await tester.pumpWidget(buildTestWidget(container: container));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);

      await tester.tap(find.widgetWithText(TextButton, 'Cancel'));
      await tester.pumpAndSettle();

      expect(container.read(biometricLockProvider), isTrue);
    });

    testWidgets('lockedOut failure shows a retry snackbar and stays locked', (
      tester,
    ) async {
      LocalAuthPlatform.instance = FakeLocalAuthPlatform(
        authenticateHandler: () async => throw const LocalAuthException(
          code: LocalAuthExceptionCode.temporaryLockout,
        ),
      );

      final container = ProviderContainer(
        overrides: [
          userProfileRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);
      container.read(biometricLockProvider.notifier).setLocked(true);

      await tester.pumpWidget(buildTestWidget(container: container));
      // First frame triggers postFrameCallback and shows snackbar
      await tester.pump();
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(container.read(biometricLockProvider), isTrue);
      expect(find.byType(AlertDialog), findsNothing);

      await tester.pumpAndSettle();
    });
  });
}
