import 'dart:async';

import 'package:flutter_glucosa/features/weight/data/providers/weight_reading_repository_provider.dart';
import 'package:flutter_glucosa/features/weight/domain/entities/weight_reading.dart';
import 'package:flutter_glucosa/features/weight/domain/repositories/weight_reading_repository.dart';
import 'package:flutter_glucosa/features/weight/presentation/providers/weight_reading_detail_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockWeightReadingRepository extends Mock
    implements WeightReadingRepository {}

void main() {
  late MockWeightReadingRepository mockRepo;
  late ProviderContainer container;

  final testReading = WeightReading(
    id: 42,
    readingKg: 75.5,
    createdAt: DateTime(2026, 10, 2, 10, 0),
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

  group('WeightReadingDetail', () {
    test('build() watches reading by id and emits value', () async {
      when(
        () => mockRepo.watchById(42),
      ).thenAnswer((_) => Stream.value(testReading));

      container.listen(weightReadingDetailProvider(42), (_, _) {});
      final state = await container.read(
        weightReadingDetailProvider(42).future,
      );

      expect(state, equals(testReading));
      verify(() => mockRepo.watchById(42)).called(1);
    });

    test('build() emits null when reading does not exist', () async {
      when(() => mockRepo.watchById(99)).thenAnswer((_) => Stream.value(null));

      container.listen(weightReadingDetailProvider(99), (_, _) {});
      final state = await container.read(
        weightReadingDetailProvider(99).future,
      );

      expect(state, isNull);
    });
  });
}
