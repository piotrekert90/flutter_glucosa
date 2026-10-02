import 'package:flutter/material.dart';
import 'package:flutter_glucosa/features/overview/presentation/widgets/today_shimmer_skeleton.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TodayShimmerSkeleton', () {
    testWidgets('renders pulsing placeholder bars', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: TodayShimmerSkeleton())),
      );
      await tester.pump();

      expect(find.byType(TodayShimmerSkeleton), findsOneWidget);
      // Hero block plus three metric rows.
      expect(find.byType(AnimatedBuilder), findsWidgets);

      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(const Duration(milliseconds: 500));
    });

    testWidgets('disposes without leaking tickers', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: TodayShimmerSkeleton())),
      );
      await tester.pump();
      await tester.pumpWidget(const MaterialApp(home: Scaffold()));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });
  });
}
