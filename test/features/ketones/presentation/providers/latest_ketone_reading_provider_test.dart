import 'dart:async';

import 'package:flutter_glucosa/features/ketones/data/providers/ketone_reading_repository_provider.dart';
import 'package:flutter_glucosa/features/ketones/domain/entities/ketone_reading.dart';
import 'package:flutter_glucosa/features/ketones/domain/repositories/ketone_reading_repository.dart';
import 'package:flutter_glucosa/features/ketones/presentation/providers/latest_ketone_reading_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockKetoneReadingRepository extends Mock
    implements KetoneReadingRepository {}

void main() {
  late MockKetoneReadingRepository mockRepo;
  late ProviderContainer container;

  final testReading = KetoneReading(
    id: 1,
    readingMmolL: 0.5,
    createdAt: DateTime(2026, 10, 2, 8, 0),
  );

  setUp(() {
    mockRepo = MockKetoneReadingRepository();
    container = ProviderContainer(
      overrides: [ketoneReadingRepositoryProvider.overrideWithValue(mockRepo)],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('latestKetoneReadingProvider', () {
    test('emits latest reading from repository watchLatest() stream', () async {
      when(
        () => mockRepo.watchLatest(),
      ).thenAnswer((_) => Stream.value(testReading));

      container.listen(latestKetoneReadingProvider, (_, _) {});
      final state = await container.read(latestKetoneReadingProvider.future);

      expect(state, equals(testReading));
      verify(() => mockRepo.watchLatest()).called(1);
    });

    test('emits null when no readings exist', () async {
      when(() => mockRepo.watchLatest()).thenAnswer((_) => Stream.value(null));

      container.listen(latestKetoneReadingProvider, (_, _) {});
      final state = await container.read(latestKetoneReadingProvider.future);

      expect(state, isNull);
    });
  });
}
