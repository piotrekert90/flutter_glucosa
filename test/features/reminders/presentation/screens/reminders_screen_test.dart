import 'package:flutter/material.dart';
import 'package:flutter_glucosa/core/domain/enums/metric_type.dart';
import 'package:flutter_glucosa/features/reminders/domain/entities/reminder.dart';
import 'package:flutter_glucosa/features/reminders/domain/repositories/reminder_repository.dart';
import 'package:flutter_glucosa/features/reminders/presentation/providers/reminder_repository_provider.dart';
import 'package:flutter_glucosa/features/reminders/presentation/screens/reminders_screen.dart';
import 'package:flutter_glucosa/features/reminders/presentation/widgets/reminder_card.dart';
import 'package:flutter_glucosa/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/fake_reminder_repository.dart';

class MockReminderRepository extends Mock implements ReminderRepository {}

void main() {
  late FakeReminderRepository fakeRepo;

  setUpAll(() {
    registerFallbackValue(
      const Reminder(
        label: 'fallback',
        metricType: MetricType.glucose,
        hourOfDay: 8,
        minute: 0,
      ),
    );
  });

  setUp(() {
    fakeRepo = FakeReminderRepository();
  });

  tearDown(() {
    fakeRepo.dispose();
  });

  Widget createWidget({FakeReminderRepository? repo}) {
    return ProviderScope(
      overrides: [
        reminderRepositoryProvider.overrideWithValue(repo ?? fakeRepo),
      ],
      child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: RemindersScreen(),
      ),
    );
  }

  group('RemindersScreen', () {
    testWidgets('renders empty state when no reminders exist', (tester) async {
      await tester.pumpWidget(createWidget());
      await tester.pumpAndSettle();

      expect(find.text('Reminders'), findsOneWidget);
      expect(find.text('No reminders scheduled'), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('renders list of reminders when items exist', (tester) async {
      const r1 = Reminder(
        id: 1,
        label: 'Morning Glucose',
        metricType: MetricType.glucose,
        hourOfDay: 8,
        minute: 0,
        isActive: true,
      );
      const r2 = Reminder(
        id: 2,
        label: 'Evening BP',
        metricType: MetricType.bloodPressure,
        hourOfDay: 20,
        minute: 0,
        isActive: false,
      );

      await fakeRepo.add(r1);
      await fakeRepo.add(r2);

      await tester.pumpWidget(createWidget());
      await tester.pumpAndSettle();

      expect(find.byType(ReminderCard), findsNWidgets(2));
      expect(find.text('Morning Glucose'), findsOneWidget);
      expect(find.text('Evening BP'), findsOneWidget);
    });

    testWidgets('tapping FAB opens add dialog and saves new reminder', (
      tester,
    ) async {
      await tester.pumpWidget(createWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      expect(find.text('Add Reminder'), findsNWidgets(2)); // FAB + Sheet title
      expect(find.byType(TextFormField), findsOneWidget);

      await tester.enterText(find.byType(TextFormField), 'Post-lunch Glucose');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      final all = await fakeRepo.getAll();
      expect(all.length, equals(1));
      expect(all.first.label, equals('Post-lunch Glucose'));
      expect(find.text('Post-lunch Glucose'), findsOneWidget);
    });

    testWidgets('toggling switch updates reminder in repository', (
      tester,
    ) async {
      const r1 = Reminder(
        id: 1,
        label: 'Toggle Test',
        metricType: MetricType.weight,
        hourOfDay: 7,
        minute: 0,
        isActive: true,
      );

      await fakeRepo.add(r1);

      await tester.pumpWidget(createWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      final all = await fakeRepo.getAll();
      expect(all.first.isActive, isFalse);
    });

    testWidgets(
      'swiping reminder shows confirmation dialog and deletes on confirm',
      (tester) async {
        const r1 = Reminder(
          id: 1,
          label: 'Delete Test',
          metricType: MetricType.cholesterol,
          hourOfDay: 10,
          minute: 0,
        );

        await fakeRepo.add(r1);

        await tester.pumpWidget(createWidget());
        await tester.pumpAndSettle();

        expect(find.text('Delete Test'), findsOneWidget);

        // Drag to trigger dismiss
        await tester.drag(find.byType(Dismissible), const Offset(-500, 0));
        await tester.pumpAndSettle();

        expect(
          find.text('Are you sure you want to delete this reminder?'),
          findsOneWidget,
        );

        await tester.tap(find.byType(FilledButton));
        await tester.pumpAndSettle();

        final all = await fakeRepo.getAll();
        expect(all, isEmpty);
        expect(find.text('Delete Test'), findsNothing);
      },
    );
  });
}
