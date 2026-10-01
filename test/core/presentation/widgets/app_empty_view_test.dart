import 'package:flutter/material.dart';
import 'package:flutter_riverpod_boilerplate/core/presentation/widgets/app_empty_view.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppEmptyView', () {
    testWidgets('renders title and default icon', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: AppEmptyView(title: 'No Items Found')),
        ),
      );

      expect(find.text('No Items Found'), findsOneWidget);
      expect(find.byIcon(Icons.inbox_outlined), findsOneWidget);
    });

    testWidgets('renders description and custom icon when provided', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppEmptyView(
              title: 'Empty State',
              description: 'Try adding an item below',
              icon: Icons.search_off,
            ),
          ),
        ),
      );

      expect(find.text('Empty State'), findsOneWidget);
      expect(find.text('Try adding an item below'), findsOneWidget);
      expect(find.byIcon(Icons.search_off), findsOneWidget);
    });
  });
}
