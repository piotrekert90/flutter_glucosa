import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_boilerplate/core/presentation/widgets/app_startup_widget.dart';
import 'package:flutter_riverpod_boilerplate/core/providers/app_startup_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppStartupWidget Tests', () {
    testWidgets(
      'Displays AppStartupLoadingWidget while startup is in progress',
      (tester) async {
        final completer = Completer<void>();

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              appStartupProvider.overrideWith((ref) => completer.future),
            ],
            child: AppStartupWidget(
              onLoaded: (_) => const MaterialApp(
                home: Scaffold(body: Text('Loaded App Content')),
              ),
            ),
          ),
        );

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(find.text('Loaded App Content'), findsNothing);

        completer.complete();
        await tester.pumpAndSettle();

        expect(find.text('Loaded App Content'), findsOneWidget);
        expect(find.byType(CircularProgressIndicator), findsNothing);
      },
    );

    testWidgets(
      'Renders onLoaded content when appStartup succeeds immediately',
      (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [appStartupProvider.overrideWith((ref) async {})],
            child: AppStartupWidget(
              onLoaded: (_) => const MaterialApp(
                home: Scaffold(body: Text('App Successfully Loaded')),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.text('App Successfully Loaded'), findsOneWidget);
      },
    );

    testWidgets('Displays AppStartupErrorWidget and allows retry on failure', (
      tester,
    ) async {
      var shouldFail = true;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appStartupProvider.overrideWith((ref) async {
              if (shouldFail) {
                throw Exception('Database lock error');
              }
            }),
          ],
          child: AppStartupWidget(
            onLoaded: (_) => const MaterialApp(
              home: Scaffold(body: Text('App Recovered Content')),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Initialization Failed'), findsOneWidget);
      expect(find.textContaining('Database lock error'), findsOneWidget);
      expect(find.widgetWithText(FilledButton, 'Try again'), findsOneWidget);
      expect(find.text('App Recovered Content'), findsNothing);

      // Simulate recovery and retry
      shouldFail = false;
      await tester.tap(find.widgetWithText(FilledButton, 'Try again'));
      await tester.pumpAndSettle();

      expect(find.text('App Recovered Content'), findsOneWidget);
      expect(find.text('Initialization Failed'), findsNothing);
    });
  });
}
