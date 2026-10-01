import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_boilerplate/core/errors/failure.dart';
import 'package:flutter_riverpod_boilerplate/core/router/app_routes.dart';
import 'package:flutter_riverpod_boilerplate/features/todos/data/providers/todo_repository_provider.dart';
import 'package:flutter_riverpod_boilerplate/features/todos/domain/entities/todo.dart';
import 'package:flutter_riverpod_boilerplate/features/todos/presentation/providers/todo_notifier.dart';
import 'package:flutter_riverpod_boilerplate/features/todos/presentation/screens/todo_screen.dart';
import 'package:flutter_riverpod_boilerplate/features/todos/presentation/widgets/todo_list_item.dart';
import 'package:flutter_riverpod_boilerplate/l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../../../../helpers/fake_todo_repository.dart';

class FailingTodoRepository extends FakeTodoRepository {
  FailingTodoRepository({super.initialTodos});

  bool failToggle = false;
  bool failDelete = false;
  bool failAdd = false;
  bool failWatch = false;

  @override
  Stream<List<Todo>> watchAll() async* {
    if (failWatch) {
      throw const DatabaseFailure('Storage read error');
    }
    yield* super.watchAll();
  }

  @override
  Future<(bool, Failure?)> toggleCompleted({required int id}) async {
    if (failToggle) return (false, const DatabaseFailure('Failed to toggle'));
    return super.toggleCompleted(id: id);
  }

  @override
  Future<(bool, Failure?)> delete({required int id}) async {
    if (failDelete) return (false, const DatabaseFailure('Failed to delete'));
    return super.delete(id: id);
  }

  @override
  Future<(bool, Failure?)> add({required String title}) async {
    if (failAdd) return (false, const DatabaseFailure('Failed to add'));
    return super.add(title: title);
  }
}

class ErrorTodoListNotifier extends TodoList {
  @override
  Stream<List<Todo>> build() {
    return Stream.error(const DatabaseFailure('Storage read error'));
  }
}

void main() {
  late FailingTodoRepository repository;

  setUp(() {
    repository = FailingTodoRepository();
  });

  tearDown(() {
    repository.dispose();
  });

  Widget buildSubject({GoRouter? router}) {
    final defaultRouter =
        router ??
        GoRouter(
          initialLocation: '/',
          routes: [
            GoRoute(
              path: '/',
              name: AppRoute.todos.name,
              builder: (context, state) => const TodoScreen(),
            ),
            GoRoute(
              path: '/settings',
              name: AppRoute.settings.name,
              builder: (context, state) =>
                  const Scaffold(body: Text('Settings Screen')),
            ),
          ],
        );

    return ProviderScope(
      overrides: [todoRepositoryProvider.overrideWithValue(repository)],
      child: MaterialApp.router(
        routerConfig: defaultRouter,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    );
  }

  group('TodoScreen', () {
    testWidgets('renders empty view when todos list is empty', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      expect(find.text('No tasks found'), findsOneWidget);
      expect(
        find.text('Add your first task using the button below'),
        findsOneWidget,
      );
      expect(find.byType(ListView), findsNothing);
    });

    testWidgets('renders list of todos when tasks exist', (tester) async {
      repository = FailingTodoRepository(
        initialTodos: [
          Todo(
            id: 1,
            title: 'First task',
            isCompleted: false,
            createdAt: DateTime(2026, 9, 18, 10, 0),
          ),
          Todo(
            id: 2,
            title: 'Second task',
            isCompleted: true,
            createdAt: DateTime(2026, 9, 18, 11, 0),
          ),
        ],
      );

      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      expect(find.text('First task'), findsOneWidget);
      expect(find.text('Second task'), findsOneWidget);
      expect(find.byType(TodoListItem), findsNWidgets(2));
    });

    testWidgets('toggles todo completion when checkbox is tapped', (
      tester,
    ) async {
      repository = FailingTodoRepository(
        initialTodos: [
          Todo(
            id: 1,
            title: 'Task to toggle',
            isCompleted: false,
            createdAt: DateTime(2026, 9, 18, 10, 0),
          ),
        ],
      );

      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      final checkboxFinder = find.byType(Checkbox);
      expect(checkboxFinder, findsOneWidget);

      await tester.tap(checkboxFinder);
      await tester.pumpAndSettle();

      final updated = repository.currentTodos.first;
      expect(updated.isCompleted, isTrue);
    });

    testWidgets('deletes todo when dismissed via swipe', (tester) async {
      repository = FailingTodoRepository(
        initialTodos: [
          Todo(
            id: 1,
            title: 'Task to delete',
            isCompleted: false,
            createdAt: DateTime(2026, 9, 18, 10, 0),
          ),
        ],
      );

      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      expect(find.text('Task to delete'), findsOneWidget);

      await tester.drag(find.byType(Dismissible), const Offset(-500.0, 0.0));
      await tester.pumpAndSettle();

      expect(repository.currentTodos, isEmpty);
      expect(find.text('Task deleted'), findsOneWidget);
    });

    testWidgets('shows error view when state is AsyncError', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            todoListProvider.overrideWith(() => ErrorTodoListNotifier()),
          ],
          child: MaterialApp.router(
            routerConfig: GoRouter(
              routes: [
                GoRoute(
                  path: '/',
                  builder: (context, state) => const TodoScreen(),
                ),
              ],
            ),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Failed to load tasks'), findsOneWidget);
      expect(find.text('Try again'), findsOneWidget);

      await tester.tap(find.text('Try again'));
      await tester.pump();
    });

    testWidgets('adds new todo via FAB dialog', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField), 'Brand new task');
      await tester.pump();

      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle();

      expect(
        repository.currentTodos.any((t) => t.title == 'Brand new task'),
        isTrue,
      );
      expect(find.text('Brand new task'), findsOneWidget);
    });

    testWidgets('navigates to settings when settings icon is tapped', (
      tester,
    ) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.settings_outlined));
      await tester.pumpAndSettle();

      expect(find.text('Settings Screen'), findsOneWidget);
    });

    testWidgets('shows error snackbar when toggle fails', (tester) async {
      repository = FailingTodoRepository(
        initialTodos: [
          Todo(
            id: 1,
            title: 'Task',
            isCompleted: false,
            createdAt: DateTime(2026, 9, 18, 10, 0),
          ),
        ],
      );
      repository.failToggle = true;

      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();

      expect(find.text('Failed to toggle'), findsOneWidget);
    });

    testWidgets('shows error snackbar when delete fails', (tester) async {
      repository = FailingTodoRepository(
        initialTodos: [
          Todo(
            id: 1,
            title: 'Task',
            isCompleted: false,
            createdAt: DateTime(2026, 9, 18, 10, 0),
          ),
        ],
      );
      repository.failDelete = true;

      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      await tester.drag(find.byType(Dismissible), const Offset(-500.0, 0.0));
      await tester.pumpAndSettle();

      expect(find.text('Failed to delete'), findsOneWidget);
    });

    testWidgets('shows error snackbar when add fails', (tester) async {
      repository.failAdd = true;

      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField), 'New Task');
      await tester.pump();

      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle();

      expect(find.text('Failed to add'), findsOneWidget);
    });
  });
}
