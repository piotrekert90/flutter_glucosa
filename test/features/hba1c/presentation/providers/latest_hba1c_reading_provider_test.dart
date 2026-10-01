import 'dart:async';

import 'package:flutter_glucosa/features/hba1c/data/providers/hba1c_reading_repository_provider.dart';
import 'package:flutter_glucosa/features/hba1c/domain/entities/hba1c_reading.dart';
import 'package:flutter_glucosa/features/hba1c/domain/repositories/hba1c_reading_repository.dart';
import 'package:flutter_glucosa/features/hba1c/presentation/providers/latest_hba1c_reading_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockHbA1cReadingRepository extends Mock
    implements HbA1cReadingRepository {}

void main() {
  late MockHbA1cReadingRepository mockRepo;
  late ProviderContainer container;

  final testReading = HbA1cReading(
    id: 1,
    readingPercentage: 6.3,
    createdAt: DateTime(2026, 10, 2, 8, 0),
  );

  setUp(() {
    mockRepo = MockHbA1cReadingRepository();
    container = ProviderContainer(
      overrides: [hbA1cReadingRepositoryProvider.overrideWithValue(mockRepo)],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('latestHbA1cReadingProvider', () {
    test('emits latest reading from repository watchLatest() stream', () async {
      when(
        () => mockRepo.watchLatest(),
      ).thenAnswer((_) => Stream.value(testReading));

      container.listen(latestHbA1cReadingProvider, (_, _) {});
      final state = await container.read(latestHbA1cReadingProvider.future);

      expect(state, equals(testReading));
      verify(() => mockRepo.watchLatest()).called(1);
    });

    test('emits null when no readings exist', () async {
      when(() => mockRepo.watchLatest()).thenAnswer((_) => Stream.value(null));

      container.listen(latestHbA1cReadingProvider, (_, _) {});
      final state = await container.read(latestHbA1cReadingProvider.future);

      expect(state, isNull);
    });
  });
}
