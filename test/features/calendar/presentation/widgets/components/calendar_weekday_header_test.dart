import 'package:flutter/material.dart';
import 'package:flutter_glucosa/core/domain/enums/first_day_of_week.dart';
import 'package:flutter_glucosa/features/calendar/presentation/widgets/components/calendar_weekday_header.dart';
import 'package:flutter_glucosa/l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CalendarWeekdayHeader', () {
    Widget buildHeader(FirstDayOfWeek firstDayOfWeek) {
      return MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: CalendarWeekdayHeader(firstDayOfWeek: firstDayOfWeek),
        ),
      );
    }

    testWidgets('renders seven weekday labels starting on Monday', (
      tester,
    ) async {
      await tester.pumpWidget(buildHeader(FirstDayOfWeek.monday));
      await tester.pumpAndSettle();

      expect(find.byType(CalendarWeekdayHeader), findsOneWidget);
      expect(find.text('Mon'), findsOneWidget);
      expect(find.text('Sun'), findsOneWidget);
    });

    testWidgets('renders seven weekday labels starting on Sunday', (
      tester,
    ) async {
      await tester.pumpWidget(buildHeader(FirstDayOfWeek.sunday));
      await tester.pumpAndSettle();

      expect(find.byType(CalendarWeekdayHeader), findsOneWidget);
      expect(find.text('Sun'), findsOneWidget);
      expect(find.text('Mon'), findsOneWidget);
    });

    testWidgets('renders with system setting', (tester) async {
      await tester.pumpWidget(buildHeader(FirstDayOfWeek.system));
      await tester.pumpAndSettle();

      expect(find.byType(CalendarWeekdayHeader), findsOneWidget);
    });
  });
}
