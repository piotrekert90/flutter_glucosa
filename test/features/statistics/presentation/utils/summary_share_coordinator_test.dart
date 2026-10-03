import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_glucosa/core/domain/enums/enums.dart';
import 'package:flutter_glucosa/features/glucose/domain/entities/glucose_reading.dart';
import 'package:flutter_glucosa/features/settings/domain/entities/user_profile.dart';
import 'package:flutter_glucosa/features/statistics/presentation/utils/summary_share_coordinator.dart';
import 'package:flutter_glucosa/l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const shareChannel = MethodChannel('dev.fluttercommunity.plus/share');
  final calls = <MethodCall>[];

  setUp(() {
    calls.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(shareChannel, (MethodCall call) async {
          calls.add(call);
          return 'success';
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(shareChannel, null);
  });

  group('SummaryShareCoordinator', () {
    testWidgets('does not invoke share when readings are empty', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () async {
                  await SummaryShareCoordinator.shareDoctorSummary(
                    context,
                    readings: [],
                    profile: UserProfile.defaults(),
                  );
                },
                child: const Text('Share'),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Share'));
      await tester.pumpAndSettle();

      expect(calls, isEmpty);
    });

    testWidgets('does not invoke share when l10n is absent from context', (
      tester,
    ) async {
      final now = DateTime(2026, 10, 3, 12, 0);
      final reading = GlucoseReading(
        id: 1,
        readingMgDl: 110,
        mealContext: MealContext.afterBreakfast,
        createdAt: now,
      );

      // MaterialApp without AppLocalizations delegates
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () async {
                  await SummaryShareCoordinator.shareDoctorSummary(
                    context,
                    readings: [reading],
                    profile: UserProfile.defaults(),
                    now: now,
                  );
                },
                child: const Text('Share'),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Share'));
      await tester.pumpAndSettle();

      expect(calls, isEmpty);
    });

    testWidgets(
      'formats summary and dispatches to system share sheet when readings present',
      (tester) async {
        final now = DateTime(2026, 10, 3, 12, 0);
        final reading = GlucoseReading(
          id: 1,
          readingMgDl: 125,
          mealContext: MealContext.afterLunch,
          createdAt: now,
        );

        await tester.pumpWidget(
          MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () async {
                    await SummaryShareCoordinator.shareDoctorSummary(
                      context,
                      readings: [reading],
                      profile: UserProfile.defaults(),
                      now: now,
                    );
                  },
                  child: const Text('Share'),
                );
              },
            ),
          ),
        );

        await tester.tap(find.text('Share'));
        await tester.pumpAndSettle();

        expect(calls, hasLength(1));
        expect(calls.first.method, equals('share'));
        final args = calls.first.arguments as Map;
        expect(args['subject'], contains('Clinical Health Summary'));
        expect(args['text'], contains('Glucosa — Clinical Health Summary'));
        expect(args['text'], contains('125 mg/dL'));
      },
    );
  });
}
