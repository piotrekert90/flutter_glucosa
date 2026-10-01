import 'dart:async';

import 'package:flutter_glucosa/features/cholesterol/data/providers/cholesterol_reading_repository_provider.dart';
import 'package:flutter_glucosa/features/cholesterol/domain/entities/cholesterol_reading.dart';
import 'package:flutter_glucosa/features/cholesterol/domain/repositories/cholesterol_reading_repository.dart';
import 'package:flutter_glucosa/features/cholesterol/presentation/providers/cholesterol_reading_detail_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCholesterolReadingRepository extends Mock
    implements CholesterolReadingRepository {}

void main() {
  late MockCholesterolReadingRepository mockRepo;
  late ProviderContainer container;

  final testReading = CholesterolReading(
    id: 42,
    totalMgDl: 195,
    ldlMgDl: 115,
    hdlMgDl: 58,
    createdAt: DateTime(2026, 10, 2, 10, 0),
  );

  setUp(() {
    mockRepo = MockCholesterolReadingRepository();
    container = ProviderContainer(
      overrides: [
        cholesterolReadingRepositoryProvider.overrideWithValue(mockRepo),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('CholesterolReadingDetail', () {
    test('build() watches reading by id and emits value', () async {
      when(
        () => mockRepo.watchById(42),
      ).thenAnswer((_) => Stream.value(testReading));

      container.listen(cholesterolReadingDetailProvider(42), (_, _) {});
      final state = await container.read(
        cholesterolReadingDetailProvider(42).future,
      );

      expect(state, equals(testReading));
      verify(() => mockRepo.watchById(42)).called(1);
    });

    test('build() emits null when reading does not exist', () async {
      when(() => mockRepo.watchById(99)).thenAnswer((_) => Stream.value(null));

      container.listen(cholesterolReadingDetailProvider(99), (_, _) {});
      final state = await container.read(
        cholesterolReadingDetailProvider(99).future,
      );

      expect(state, isNull);
    });
  });
}
