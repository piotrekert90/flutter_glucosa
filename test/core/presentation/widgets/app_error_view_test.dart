import 'package:flutter/material.dart';
import 'package:flutter_riverpod_boilerplate/core/presentation/widgets/app_error_view.dart';
import 'package:flutter_riverpod_boilerplate/l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppErrorView', () {
    testWidgets('renders message and retry button with callback', (
      tester,
    ) async {
      var retryCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: AppErrorView(
              message: 'Connection failed',
              onRetry: () => retryCalled = true,
            ),
          ),
        ),
      );

      expect(find.text('Error: Connection failed'), findsOneWidget);
      expect(find.byType(FilledButton), findsOneWidget);

      await tester.tap(find.byType(FilledButton));
      await tester.pump();

      expect(retryCalled, isTrue);
    });

    testWidgets('does not render button when onRetry is null', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(body: AppErrorView(message: 'Something broke')),
        ),
      );

      expect(find.text('Error: Something broke'), findsOneWidget);
      expect(find.byType(FilledButton), findsNothing);
    });
  });
}
