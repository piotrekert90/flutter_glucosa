import 'dart:async';

import 'package:flutter_glucosa/features/weight/data/providers/weight_reading_repository_provider.dart';
import 'package:flutter_glucosa/features/weight/domain/entities/weight_reading.dart';
import 'package:flutter_glucosa/features/weight/domain/repositories/weight_reading_repository.dart';
import 'package:flutter_glucosa/features/weight/presentation/providers/latest_weight_reading_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockWeightReadingRepository extends Mock
    implements WeightReadingRepository {}

void main() {
  late MockWeightReadingRepository mockRepo;
  late ProviderContainer container;

  final testReading = WeightReading(
    id: 1,
    readingKg: 75.5,
    createdAt: DateTime(2026, 10, 2, 8, 0),
  );

  setUp(() {
    mockRepo = MockWeightReadingRepository();
    container = ProviderContainer(
      overrides: [weightReadingRepositoryProvider.overrideWithValue(mockRepo)],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('latestWeightReadingProvider', () {
    test('emits latest reading from repository watchLatest() stream', () async {
      when(
        () => mockRepo.watchLatest(),
      ).thenAnswer((_) => Stream.value(testReading));

      container.listen(latestWeightReadingProvider, (_, _) {});
      final state = await container.read(latestWeightReadingProvider.future);

      expect(state, equals(testReading));
      verify(() => mockRepo.watchLatest()).called(1);
    });

    test('emits null when no readings exist', () async {
      when(() => mockRepo.watchLatest()).thenAnswer((_) => Stream.value(null));

      container.listen(latestWeightReadingProvider, (_, _) {});
      final state = await container.read(latestWeightReadingProvider.future);

      expect(state, isNull);
    });
  });
}
