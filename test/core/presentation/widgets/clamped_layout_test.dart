import 'package:flutter/material.dart';
import 'package:flutter_riverpod_boilerplate/core/presentation/widgets/clamped_layout.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ClampedLayout', () {
    testWidgets('constrains child width within specified maxWidth', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ClampedLayout(
              maxWidth: 500,
              child: SizedBox(
                key: Key('child'),
                width: double.infinity,
                height: 100,
              ),
            ),
          ),
        ),
      );

      final box = tester.getRect(find.byKey(const Key('child')));
      expect(box.width, 500.0);
    });

    testWidgets('applies optional padding when provided', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ClampedLayout(
              padding: EdgeInsets.all(16),
              child: Text('Content'),
            ),
          ),
        ),
      );

      final paddingFinder = find.byType(Padding);
      expect(paddingFinder, findsOneWidget);
      final padding = tester.widget<Padding>(paddingFinder);
      expect(padding.padding, const EdgeInsets.all(16));
    });
  });
}
