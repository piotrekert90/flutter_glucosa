import 'package:flutter/material.dart';
import 'package:flutter_glucosa/core/integrations/health/health_service_provider.dart';
import 'package:flutter_glucosa/features/settings/presentation/widgets/components/health_connect_install_dialog.dart';
import 'package:flutter_glucosa/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/fake_health_service.dart';

void main() {
  Future<void> pumpDialog(
    WidgetTester tester, {
    FakeHealthService? healthService,
  }) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          if (healthService != null)
            healthServiceProvider.overrideWithValue(healthService),
        ],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(body: HealthConnectInstallDialog()),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('HealthConnectInstallDialog', () {
    testWidgets('shows install prompt texts', (tester) async {
      await pumpDialog(tester);

      expect(find.text('Health Connect Required'), findsOneWidget);
      expect(
        find.textContaining('Google Health Connect', findRichText: true),
        findsWidgets,
      );
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Install from Play Store'), findsOneWidget);
    });

    testWidgets('cancel dismisses the dialog', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) => Scaffold(
              body: TextButton(
                onPressed: () => HealthConnectInstallDialog.show(context),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      expect(find.text('Health Connect Required'), findsOneWidget);

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(find.text('Health Connect Required'), findsNothing);
    });
  });
}
