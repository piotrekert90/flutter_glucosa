import 'dart:async';

import 'package:flutter_glucosa/core/domain/enums/metric_type.dart';
import 'package:flutter_glucosa/core/errors/failure.dart';
import 'package:flutter_glucosa/features/reminders/domain/entities/reminder.dart';
import 'package:flutter_glucosa/features/reminders/domain/repositories/reminder_repository.dart';
import 'package:flutter_glucosa/features/reminders/presentation/providers/reminder_list_notifier.dart';
import 'package:flutter_glucosa/features/reminders/presentation/providers/reminder_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockReminderRepository extends Mock implements ReminderRepository {}

const _testReminder1 = Reminder(
  id: 1,
  label: 'Morning Glucose',
  metricType: MetricType.glucose,
  hourOfDay: 8,
  minute: 0,
  isActive: true,
  isOneTime: false,
);

const _testReminder2 = Reminder(
  id: 2,
  label: 'Evening BP',
  metricType: MetricType.bloodPressure,
  hourOfDay: 20,
  minute: 30,
  isActive: false,
  isOneTime: true,
);

ProviderContainer _makeContainer(MockReminderRepository mock) {
  return ProviderContainer(
    overrides: [reminderRepositoryProvider.overrideWithValue(mock)],
  );
}

void main() {
  late MockReminderRepository mockRepo;
  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(_testReminder1);
  });

  setUp(() {
    mockRepo = MockReminderRepository();
  });

  tearDown(() {
    container.dispose();
  });

  group('ReminderList - build()', () {
    test('emits reminders list from repository watchAll() stream', () async {
      when(
        () => mockRepo.watchAll(),
      ).thenAnswer((_) => Stream.value([_testReminder1, _testReminder2]));

      container = _makeContainer(mockRepo);
      container.listen(reminderListProvider, (_, _) {});

      final state = await container.read(reminderListProvider.future);
      expect(state, equals([_testReminder1, _testReminder2]));
    });

    test('updates state when new event is added to stream', () async {
      final controller = StreamController<List<Reminder>>.broadcast();
      when(() => mockRepo.watchAll()).thenAnswer((_) => controller.stream);

      container = _makeContainer(mockRepo);
      final states = <AsyncValue<List<Reminder>>>[];
      container.listen(
        reminderListProvider,
        (_, next) => states.add(next),
        fireImmediately: true,
      );

      controller.add([_testReminder1]);
      await container.read(reminderListProvider.future);

      controller.add([_testReminder1, _testReminder2]);
      await Future.microtask(() {});

      final state = container.read(reminderListProvider);
      expect(state, isA<AsyncData<List<Reminder>>>());
      expect(state.value, [_testReminder1, _testReminder2]);

      await controller.close();
    });
  });

  group('ReminderList - CRUD & toggle operations', () {
    test('addReminder delegates to repository.add()', () async {
      when(() => mockRepo.watchAll()).thenAnswer((_) => const Stream.empty());
      when(() => mockRepo.add(any())).thenAnswer((_) async => (true, null));

      container = _makeContainer(mockRepo);
      final notifier = container.read(reminderListProvider.notifier);

      final result = await notifier.addReminder(_testReminder1);

      expect(result.$1, isTrue);
      expect(result.$2, isNull);
      verify(() => mockRepo.add(_testReminder1)).called(1);
    });

    test('updateReminder delegates to repository.update()', () async {
      when(() => mockRepo.watchAll()).thenAnswer((_) => const Stream.empty());
      when(() => mockRepo.update(any())).thenAnswer((_) async => (true, null));

      container = _makeContainer(mockRepo);
      final notifier = container.read(reminderListProvider.notifier);

      final result = await notifier.updateReminder(_testReminder1);

      expect(result.$1, isTrue);
      expect(result.$2, isNull);
      verify(() => mockRepo.update(_testReminder1)).called(1);
    });

    test(
      'toggleReminder finds reminder, updates isActive, and calls repo.update',
      () async {
        when(() => mockRepo.watchAll()).thenAnswer((_) => const Stream.empty());
        when(() => mockRepo.getById(1)).thenAnswer((_) async => _testReminder1);
        when(
          () => mockRepo.update(any()),
        ).thenAnswer((_) async => (true, null));

        container = _makeContainer(mockRepo);
        final notifier = container.read(reminderListProvider.notifier);

        final result = await notifier.toggleReminder(1, false);

        expect(result.$1, isTrue);
        expect(result.$2, isNull);
        verify(
          () => mockRepo.update(
            any(
              that: predicate<Reminder>(
                (r) => r.id == 1 && r.isActive == false,
              ),
            ),
          ),
        ).called(1);
      },
    );

    test('toggleReminder returns NotFoundFailure when id not found', () async {
      when(() => mockRepo.watchAll()).thenAnswer((_) => const Stream.empty());
      when(() => mockRepo.getById(99)).thenAnswer((_) async => null);

      container = _makeContainer(mockRepo);
      final notifier = container.read(reminderListProvider.notifier);

      final result = await notifier.toggleReminder(99, true);

      expect(result.$1, isFalse);
      expect(result.$2, isA<NotFoundFailure>());
    });

    test('deleteReminder delegates to repository.delete()', () async {
      when(() => mockRepo.watchAll()).thenAnswer((_) => const Stream.empty());
      when(() => mockRepo.delete(any())).thenAnswer((_) async => (true, null));

      container = _makeContainer(mockRepo);
      final notifier = container.read(reminderListProvider.notifier);

      final result = await notifier.deleteReminder(1);

      expect(result.$1, isTrue);
      expect(result.$2, isNull);
      verify(() => mockRepo.delete(1)).called(1);
    });

    test('returns failure record when repository operation fails', () async {
      when(() => mockRepo.watchAll()).thenAnswer((_) => const Stream.empty());
      when(
        () => mockRepo.add(any()),
      ).thenAnswer((_) async => (false, const DatabaseFailure('Write failed')));

      container = _makeContainer(mockRepo);
      final notifier = container.read(reminderListProvider.notifier);

      final result = await notifier.addReminder(_testReminder1);

      expect(result.$1, isFalse);
      expect(result.$2, isA<DatabaseFailure>());
      expect(result.$2?.message, 'Write failed');
    });
  });
}
