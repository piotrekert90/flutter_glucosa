import 'package:flutter_glucosa/features/glucose/presentation/providers/estimated_hba1c_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('estimatedHbA1cClock', () {
    testWidgets('refreshes itself after the next local midnight', (
      tester,
    ) async {
      final container = ProviderContainer();
      var refreshes = 0;
      container.listen<DateTime>(
        estimatedHbA1cClockProvider,
        (previous, next) => refreshes++,
      );
      final first = container.read(estimatedHbA1cClockProvider);

      // Let real time advance so the rebuilt value is observably different.
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 5)),
      );
      await tester.pump(const Duration(hours: 25));

      expect(refreshes, 1);
      final second = container.read(estimatedHbA1cClockProvider);
      expect(second.isAfter(first), isTrue);

      container.dispose();
    });

    testWidgets('does not leave a pending timer after disposal', (
      tester,
    ) async {
      final container = ProviderContainer();
      container.read(estimatedHbA1cClockProvider);

      container.dispose();

      await tester.pump(const Duration(hours: 25));
    });
  });
}
