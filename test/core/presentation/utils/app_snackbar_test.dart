import 'package:flutter/material.dart';
import 'package:flutter_riverpod_boilerplate/core/presentation/utils/app_snackbar.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppSnackBar', () {
    testWidgets('displays snackbar with message and type', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    AppSnackBar.show(
                      context,
                      message: 'Action completed',
                      type: SnackBarType.success,
                    );
                  },
                  child: const Text('Show'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show'));
      await tester.pump();

      expect(find.text('Action completed'), findsOneWidget);
      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('shows action button when provided', (tester) async {
      var actionTriggered = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    AppSnackBar.show(
                      context,
                      message: 'Deleted',
                      type: SnackBarType.warning,
                      action: SnackBarAction(
                        label: 'Undo',
                        onPressed: () {
                          actionTriggered = true;
                        },
                      ),
                    );
                  },
                  child: const Text('Trigger'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Trigger'));
      await tester.pumpAndSettle();

      expect(find.text('Undo'), findsOneWidget);
      await tester.tap(find.text('Undo'));
      await tester.pumpAndSettle();

      expect(actionTriggered, isTrue);
    });
  });
}
