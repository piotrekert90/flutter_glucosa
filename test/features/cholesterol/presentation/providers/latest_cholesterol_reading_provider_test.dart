import 'dart:async';

import 'package:flutter_glucosa/features/cholesterol/data/providers/cholesterol_reading_repository_provider.dart';
import 'package:flutter_glucosa/features/cholesterol/domain/entities/cholesterol_reading.dart';
import 'package:flutter_glucosa/features/cholesterol/domain/repositories/cholesterol_reading_repository.dart';
import 'package:flutter_glucosa/features/cholesterol/presentation/providers/latest_cholesterol_reading_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCholesterolReadingRepository extends Mock
    implements CholesterolReadingRepository {}

void main() {
  late MockCholesterolReadingRepository mockRepo;
  late ProviderContainer container;

  final testReading = CholesterolReading(
    id: 1,
    totalMgDl: 188,
    ldlMgDl: 105,
    hdlMgDl: 62,
    createdAt: DateTime(2026, 10, 2, 8, 0),
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

  group('latestCholesterolReadingProvider', () {
    test('emits latest reading from repository watchLatest() stream', () async {
      when(
        () => mockRepo.watchLatest(),
      ).thenAnswer((_) => Stream.value(testReading));

      container.listen(latestCholesterolReadingProvider, (_, _) {});
      final state = await container.read(
        latestCholesterolReadingProvider.future,
      );

      expect(state, equals(testReading));
      verify(() => mockRepo.watchLatest()).called(1);
    });

    test('emits null when no readings exist', () async {
      when(() => mockRepo.watchLatest()).thenAnswer((_) => Stream.value(null));

      container.listen(latestCholesterolReadingProvider, (_, _) {});
      final state = await container.read(
        latestCholesterolReadingProvider.future,
      );

      expect(state, isNull);
    });
  });
}
