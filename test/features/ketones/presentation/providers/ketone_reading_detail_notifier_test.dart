import 'dart:async';

import 'package:flutter_glucosa/features/ketones/data/providers/ketone_reading_repository_provider.dart';
import 'package:flutter_glucosa/features/ketones/domain/entities/ketone_reading.dart';
import 'package:flutter_glucosa/features/ketones/domain/repositories/ketone_reading_repository.dart';
import 'package:flutter_glucosa/features/ketones/presentation/providers/ketone_reading_detail_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockKetoneReadingRepository extends Mock
    implements KetoneReadingRepository {}

void main() {
  late MockKetoneReadingRepository mockRepo;
  late ProviderContainer container;

  final testReading = KetoneReading(
    id: 42,
    readingMmolL: 0.7,
    createdAt: DateTime(2026, 10, 2, 10, 0),
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

  group('KetoneReadingDetail', () {
    test('build() watches reading by id and emits value', () async {
      when(
        () => mockRepo.watchById(42),
      ).thenAnswer((_) => Stream.value(testReading));

      container.listen(ketoneReadingDetailProvider(42), (_, _) {});
      final state = await container.read(
        ketoneReadingDetailProvider(42).future,
      );

      expect(state, equals(testReading));
      verify(() => mockRepo.watchById(42)).called(1);
    });

    test('build() emits null when reading does not exist', () async {
      when(() => mockRepo.watchById(99)).thenAnswer((_) => Stream.value(null));

      container.listen(ketoneReadingDetailProvider(99), (_, _) {});
      final state = await container.read(
        ketoneReadingDetailProvider(99).future,
      );

      expect(state, isNull);
    });
  });
}
