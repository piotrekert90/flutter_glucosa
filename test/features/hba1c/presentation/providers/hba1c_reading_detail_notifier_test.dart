import 'dart:async';

import 'package:flutter_glucosa/features/hba1c/data/providers/hba1c_reading_repository_provider.dart';
import 'package:flutter_glucosa/features/hba1c/domain/entities/hba1c_reading.dart';
import 'package:flutter_glucosa/features/hba1c/domain/repositories/hba1c_reading_repository.dart';
import 'package:flutter_glucosa/features/hba1c/presentation/providers/hba1c_reading_detail_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockHbA1cReadingRepository extends Mock
    implements HbA1cReadingRepository {}

void main() {
  late MockHbA1cReadingRepository mockRepo;
  late ProviderContainer container;

  final testReading = HbA1cReading(
    id: 42,
    readingPercentage: 6.7,
    createdAt: DateTime(2026, 10, 2, 10, 0),
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

  group('HbA1cReadingDetail', () {
    test('build() watches reading by id and emits value', () async {
      when(
        () => mockRepo.watchById(42),
      ).thenAnswer((_) => Stream.value(testReading));

      container.listen(hbA1cReadingDetailProvider(42), (_, _) {});
      final state = await container.read(hbA1cReadingDetailProvider(42).future);

      expect(state, equals(testReading));
      verify(() => mockRepo.watchById(42)).called(1);
    });

    test('build() emits null when reading does not exist', () async {
      when(() => mockRepo.watchById(99)).thenAnswer((_) => Stream.value(null));

      container.listen(hbA1cReadingDetailProvider(99), (_, _) {});
      final state = await container.read(hbA1cReadingDetailProvider(99).future);

      expect(state, isNull);
    });
  });
}
