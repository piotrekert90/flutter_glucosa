import 'package:flutter/material.dart';
import 'package:flutter_glucosa/core/domain/enums/metric_type.dart';
import 'package:flutter_glucosa/features/reminders/domain/entities/reminder.dart';
import 'package:flutter_glucosa/features/reminders/presentation/widgets/reminder_card.dart';
import 'package:flutter_glucosa/l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget createWidget({
    required Reminder reminder,
    ValueChanged<bool>? onToggle,
    VoidCallback? onTap,
  }) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: MediaQuery(
          data: const MediaQueryData(alwaysUse24HourFormat: true),
          child: ReminderCard(
            reminder: reminder,
            onToggle: onToggle,
            onTap: onTap,
          ),
        ),
      ),
    );
  }

  group('ReminderCard', () {
    testWidgets(
      'renders time, label, metric, and recurrence for active reminder',
      (tester) async {
        const reminder = Reminder(
          id: 1,
          label: 'Morning Glucose',
          metricType: MetricType.glucose,
          hourOfDay: 8,
          minute: 15,
          isActive: true,
          isOneTime: false,
        );

        await tester.pumpWidget(createWidget(reminder: reminder));

        expect(find.text('08:15'), findsOneWidget);
        expect(find.text('Morning Glucose'), findsOneWidget);
        expect(find.text('Blood Glucose'), findsOneWidget);
        expect(find.text('Daily'), findsOneWidget);

        final switchWidget = tester.widget<Switch>(find.byType(Switch));
        expect(switchWidget.value, isTrue);
      },
    );

    testWidgets('renders One-time indicator when isOneTime is true', (
      tester,
    ) async {
      const reminder = Reminder(
        id: 2,
        label: 'BP Check',
        metricType: MetricType.bloodPressure,
        hourOfDay: 14,
        minute: 0,
        isActive: false,
        isOneTime: true,
      );

      await tester.pumpWidget(createWidget(reminder: reminder));

      expect(find.text('14:00'), findsOneWidget);
      expect(find.text('BP Check'), findsOneWidget);
      expect(find.text('Blood Pressure'), findsOneWidget);
      expect(find.text('Once'), findsOneWidget);

      final switchWidget = tester.widget<Switch>(find.byType(Switch));
      expect(switchWidget.value, isFalse);
    });

    testWidgets('invokes onToggle callback when switch is toggled', (
      tester,
    ) async {
      bool? toggledValue;
      const reminder = Reminder(
        id: 3,
        label: 'Test Reminder',
        metricType: MetricType.weight,
        hourOfDay: 7,
        minute: 30,
        isActive: true,
      );

      await tester.pumpWidget(
        createWidget(reminder: reminder, onToggle: (val) => toggledValue = val),
      );

      await tester.tap(find.byType(Switch));
      await tester.pump();

      expect(toggledValue, isFalse);
    });

    testWidgets('invokes onTap callback when card is tapped', (tester) async {
      bool tapped = false;
      const reminder = Reminder(
        id: 4,
        label: 'Tappable Reminder',
        metricType: MetricType.ketones,
        hourOfDay: 18,
        minute: 0,
      );

      await tester.pumpWidget(
        createWidget(reminder: reminder, onTap: () => tapped = true),
      );

      await tester.tap(find.byType(ReminderCard));
      await tester.pump();

      expect(tapped, isTrue);
    });
  });
}
