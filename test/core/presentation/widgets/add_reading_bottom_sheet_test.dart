import 'package:flutter/material.dart';
import 'package:flutter_glucosa/core/presentation/widgets/add_reading_bottom_sheet.dart';
import 'package:flutter_glucosa/l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

/// Labels and destination markers for all six metric options.
const _destinations = <String, String>{
  'Blood Glucose': 'glucose-form',
  'HbA1c': 'hba1c-form',
  'Blood Pressure': 'bp-form',
  'Ketones': 'ketones-form',
  'Cholesterol': 'cholesterol-form',
  'Weight': 'weight-form',
};

const _addPaths = <String, String>{
  'Blood Glucose': '/glucose/add',
  'HbA1c': '/hba1c/add',
  'Blood Pressure': '/blood-pressure/add',
  'Ketones': '/ketones/add',
  'Cholesterol': '/cholesterol/add',
  'Weight': '/weight/add',
};

Widget _createTestApp() {
  final routes = <GoRoute>[
    GoRoute(
      path: '/',
      builder: (context, state) => Scaffold(
        body: TextButton(
          onPressed: () => showAddReadingBottomSheet(context),
          child: const Text('open sheet'),
        ),
      ),
    ),
    for (final entry in _addPaths.entries)
      GoRoute(
        path: entry.value,
        builder: (context, state) => Text(_destinations[entry.key]!),
      ),
  ];

  final router = GoRouter(routes: routes);

  return MaterialApp.router(
    routerConfig: router,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
  );
}

void main() {
  group('AddReadingBottomSheet', () {
    testWidgets('renders title and all six metric options', (tester) async {
      await tester.pumpWidget(_createTestApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('open sheet'));
      await tester.pumpAndSettle();

      expect(find.text('Add reading'), findsOneWidget);
      for (final label in _destinations.keys) {
        expect(find.text(label), findsOneWidget);
      }
      expect(find.byType(ListTile), findsNWidgets(6));
    });

    testWidgets('each option navigates to its add form', (tester) async {
      await tester.pumpWidget(_createTestApp());
      await tester.pumpAndSettle();

      for (final entry in _destinations.entries) {
        await tester.tap(find.text('open sheet'));
        await tester.pumpAndSettle();

        await tester.scrollUntilVisible(
          find.text(entry.key),
          100,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.tap(find.text(entry.key));
        await tester.pumpAndSettle();

        expect(find.text(entry.value), findsOneWidget);

        // Return to the home route for the next option.
        final context = tester.element(find.text(entry.value));
        GoRouter.of(context).go('/');
        await tester.pumpAndSettle();
      }
    });
  });
}
