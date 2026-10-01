import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_boilerplate/core/providers/app_provider_observer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AppProviderObserver', () {
    test('observes provider lifecycle without throwing', () {
      final container = ProviderContainer(
        observers: const [AppProviderObserver()],
      );

      final simpleProvider = Provider.autoDispose<int>((ref) => 1);
      expect(container.read(simpleProvider), 1);

      container.invalidate(simpleProvider);
      expect(container.read(simpleProvider), 1);

      container.dispose();
    });

    test('observes providerDidFail without throwing', () {
      final container = ProviderContainer(
        observers: const [AppProviderObserver()],
      );

      final failingProvider = Provider<int>(
        (ref) => throw StateError('Diagnostic test error'),
      );

      expect(() => container.read(failingProvider), throwsA(isA<Exception>()));

      container.dispose();
    });
  });
}
