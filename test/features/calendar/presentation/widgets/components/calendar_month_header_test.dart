import 'package:flutter/material.dart';
import 'package:flutter_glucosa/features/calendar/presentation/widgets/components/calendar_month_header.dart';
import 'package:flutter_glucosa/l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CalendarMonthHeader', () {
    Widget buildHeader({
      required DateTime focusedMonth,
      required VoidCallback onPreviousMonth,
      required VoidCallback onNextMonth,
      VoidCallback? onJumpToToday,
    }) {
      return MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: CalendarMonthHeader(
            focusedMonth: focusedMonth,
            onPreviousMonth: onPreviousMonth,
            onNextMonth: onNextMonth,
            onJumpToToday: onJumpToToday,
          ),
        ),
      );
    }

    testWidgets(
      'renders month and year title and triggers navigation callbacks',
      (tester) async {
        var prevCalled = false;
        var nextCalled = false;
        var jumpCalled = false;

        await tester.pumpWidget(
          buildHeader(
            focusedMonth: DateTime(2026, 10, 1),
            onPreviousMonth: () => prevCalled = true,
            onNextMonth: () => nextCalled = true,
            onJumpToToday: () => jumpCalled = true,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.textContaining('October 2026'), findsOneWidget);

        await tester.tap(find.byTooltip('Previous month'));
        expect(prevCalled, isTrue);

        await tester.tap(find.byTooltip('Next month'));
        expect(nextCalled, isTrue);

        await tester.tap(find.text('Today'));
        expect(jumpCalled, isTrue);
      },
    );
  });
}
