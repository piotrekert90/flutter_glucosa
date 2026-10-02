import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_glucosa/features/settings/presentation/widgets/components/wipe_data_dialog.dart';
import 'package:flutter_glucosa/l10n/app_localizations.dart';

void main() {
  Widget buildTestWidget({required Widget child}) {
    return MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: child),
    );
  }

  testWidgets(
    'WipeDataDialog renders title, warning message, and action buttons',
    (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          child: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => WipeDataDialog.show(context),
              child: const Text('Open Dialog'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      expect(find.byType(WipeDataDialog), findsOneWidget);
      expect(find.text('Are you sure?'), findsOneWidget);
      expect(
        find.text(
          'This action cannot be undone. All your blood glucose readings and settings will be permanently lost.',
        ),
        findsOneWidget,
      );
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Wipe Everything'), findsOneWidget);
    },
  );

  testWidgets('WipeDataDialog returns false when Cancel is pressed', (
    tester,
  ) async {
    bool? confirmed;
    await tester.pumpWidget(
      buildTestWidget(
        child: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () async {
              confirmed = await WipeDataDialog.show(context);
            },
            child: const Text('Open Dialog'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open Dialog'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(find.byType(WipeDataDialog), findsNothing);
    expect(confirmed, isFalse);
  });

  testWidgets('WipeDataDialog returns true when Wipe Everything is pressed', (
    tester,
  ) async {
    bool? confirmed;
    await tester.pumpWidget(
      buildTestWidget(
        child: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () async {
              confirmed = await WipeDataDialog.show(context);
            },
            child: const Text('Open Dialog'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open Dialog'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Wipe Everything'));
    await tester.pumpAndSettle();

    expect(find.byType(WipeDataDialog), findsNothing);
    expect(confirmed, isTrue);
  });
}
