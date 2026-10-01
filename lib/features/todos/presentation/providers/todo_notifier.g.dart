// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Riverpod state notifier managing the reactive stream of todo items.
///
/// Listens directly to [TodoRepository.watchAll] streams and exposes UI state actions
/// for creating, toggling, and deleting todo entities.

@ProviderFor(TodoList)
final todoListProvider = TodoListProvider._();

/// Riverpod state notifier managing the reactive stream of todo items.
///
/// Listens directly to [TodoRepository.watchAll] streams and exposes UI state actions
/// for creating, toggling, and deleting todo entities.
final class TodoListProvider
    extends $StreamNotifierProvider<TodoList, List<Todo>> {
  /// Riverpod state notifier managing the reactive stream of todo items.
  ///
  /// Listens directly to [TodoRepository.watchAll] streams and exposes UI state actions
  /// for creating, toggling, and deleting todo entities.
  TodoListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'todoListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$todoListHash();

  @$internal
  @override
  TodoList create() => TodoList();
}

String _$todoListHash() => r'9d4e7b49fddc081ddb5d8b89ca984cabde2c464e';

/// Riverpod state notifier managing the reactive stream of todo items.
///
/// Listens directly to [TodoRepository.watchAll] streams and exposes UI state actions
/// for creating, toggling, and deleting todo entities.

abstract class _$TodoList extends $StreamNotifier<List<Todo>> {
  Stream<List<Todo>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Todo>>, List<Todo>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Todo>>, List<Todo>>,
              AsyncValue<List<Todo>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
