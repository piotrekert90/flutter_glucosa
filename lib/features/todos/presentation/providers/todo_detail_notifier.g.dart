// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_detail_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Riverpod family state notifier managing state for a single todo item identified by its ID.
///
/// Subscribes directly to [TodoRepository.watchById] for live single-item UI updates.

@ProviderFor(TodoDetail)
final todoDetailProvider = TodoDetailFamily._();

/// Riverpod family state notifier managing state for a single todo item identified by its ID.
///
/// Subscribes directly to [TodoRepository.watchById] for live single-item UI updates.
final class TodoDetailProvider
    extends $StreamNotifierProvider<TodoDetail, Todo?> {
  /// Riverpod family state notifier managing state for a single todo item identified by its ID.
  ///
  /// Subscribes directly to [TodoRepository.watchById] for live single-item UI updates.
  TodoDetailProvider._({
    required TodoDetailFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'todoDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$todoDetailHash();

  @override
  String toString() {
    return r'todoDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  TodoDetail create() => TodoDetail();

  @override
  bool operator ==(Object other) {
    return other is TodoDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$todoDetailHash() => r'b31202548e5c4b10f5c7a59c98f7ea91a1c09b16';

/// Riverpod family state notifier managing state for a single todo item identified by its ID.
///
/// Subscribes directly to [TodoRepository.watchById] for live single-item UI updates.

final class TodoDetailFamily extends $Family
    with
        $ClassFamilyOverride<
          TodoDetail,
          AsyncValue<Todo?>,
          Todo?,
          Stream<Todo?>,
          int
        > {
  TodoDetailFamily._()
    : super(
        retry: null,
        name: r'todoDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Riverpod family state notifier managing state for a single todo item identified by its ID.
  ///
  /// Subscribes directly to [TodoRepository.watchById] for live single-item UI updates.

  TodoDetailProvider call(int id) =>
      TodoDetailProvider._(argument: id, from: this);

  @override
  String toString() => r'todoDetailProvider';
}

/// Riverpod family state notifier managing state for a single todo item identified by its ID.
///
/// Subscribes directly to [TodoRepository.watchById] for live single-item UI updates.

abstract class _$TodoDetail extends $StreamNotifier<Todo?> {
  late final _$args = ref.$arg as int;
  int get id => _$args;

  Stream<Todo?> build(int id);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Todo?>, Todo?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Todo?>, Todo?>,
              AsyncValue<Todo?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
