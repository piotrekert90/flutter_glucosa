// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminder_list_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Riverpod state notifier managing the reactive stream of scheduled reminders.

@ProviderFor(ReminderList)
final reminderListProvider = ReminderListProvider._();

/// Riverpod state notifier managing the reactive stream of scheduled reminders.
final class ReminderListProvider
    extends $StreamNotifierProvider<ReminderList, List<Reminder>> {
  /// Riverpod state notifier managing the reactive stream of scheduled reminders.
  ReminderListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reminderListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reminderListHash();

  @$internal
  @override
  ReminderList create() => ReminderList();
}

String _$reminderListHash() => r'583a0e3f919232de63357798665041fc1ca3a4dd';

/// Riverpod state notifier managing the reactive stream of scheduled reminders.

abstract class _$ReminderList extends $StreamNotifier<List<Reminder>> {
  Stream<List<Reminder>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Reminder>>, List<Reminder>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Reminder>>, List<Reminder>>,
              AsyncValue<List<Reminder>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
