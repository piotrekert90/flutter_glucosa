import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_boilerplate/core/router/app_router.dart';
import 'package:flutter_riverpod_boilerplate/core/router/app_routes.dart';
import 'package:flutter_riverpod_boilerplate/features/settings/data/providers/user_preferences_repository_provider.dart';
import 'package:flutter_riverpod_boilerplate/features/settings/presentation/screens/licenses_screen.dart';
import 'package:flutter_riverpod_boilerplate/features/settings/presentation/screens/privacy_policy_screen.dart';
import 'package:flutter_riverpod_boilerplate/features/settings/presentation/screens/settings_screen.dart';
import 'package:flutter_riverpod_boilerplate/features/todos/data/providers/todo_repository_provider.dart';
import 'package:flutter_riverpod_boilerplate/features/todos/presentation/screens/todo_screen.dart';
import 'package:flutter_riverpod_boilerplate/features/todos/presentation/screens/todo_screen_detail.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/fake_todo_repository.dart';
import '../../helpers/fake_user_preferences_repository.dart';

void main() {
  late FakeTodoRepository fakeTodoRepository;
  late FakeUserPreferencesRepository fakeUserPreferencesRepository;

  setUp(() {
    fakeTodoRepository = FakeTodoRepository();
    fakeUserPreferencesRepository = FakeUserPreferencesRepository();
  });

  tearDown(() {
    fakeTodoRepository.dispose();
    fakeUserPreferencesRepository.dispose();
  });

  Widget createTestApp({String? initialLocation}) {
    return ProviderScope(
      overrides: [
        todoRepositoryProvider.overrideWithValue(fakeTodoRepository),
        userPreferencesRepositoryProvider.overrideWithValue(
          fakeUserPreferencesRepository,
        ),
      ],
      child: Consumer(
        builder: (context, ref, _) {
          final router = ref.watch(appRouterProvider);
          if (initialLocation != null) {
            router.go(initialLocation);
          }
          return MaterialApp.router(routerConfig: router);
        },
      ),
    );
  }

  group('AppRouter Tests', () {
    test('AppRoute enum definitions have correct paths and names', () {
      expect(AppRoute.todos.path, '/');
      expect(AppRoute.todos.name, 'todos');
      expect(AppRoute.todoDetail.path, 'todos/:id');
      expect(AppRoute.todoDetail.name, 'todo_detail');
      expect(AppRoute.settings.path, '/settings');
      expect(AppRoute.settings.name, 'settings');
    });

    testWidgets('Renders TodoScreen on initial "/" route', (tester) async {
      await tester.pumpWidget(createTestApp());
      await tester.pumpAndSettle();

      expect(find.byType(TodoScreen), findsOneWidget);
    });

    testWidgets('Navigates to SettingsScreen on "/settings" route', (
      tester,
    ) async {
      await tester.pumpWidget(createTestApp(initialLocation: '/settings'));
      await tester.pumpAndSettle();

      expect(find.byType(SettingsScreen), findsOneWidget);
    });

    testWidgets('Navigates to LicensesScreen on "/settings/licenses" route', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestApp(initialLocation: '/settings/licenses'),
      );
      await tester.pump();

      expect(find.byType(LicensesScreen), findsOneWidget);
    });

    testWidgets(
      'Navigates to PrivacyPolicyScreen on "/settings/privacy-policy" route',
      (tester) async {
        await tester.pumpWidget(
          createTestApp(initialLocation: '/settings/privacy-policy'),
        );
        await tester.pumpAndSettle();

        expect(find.byType(PrivacyPolicyScreen), findsOneWidget);
      },
    );

    testWidgets('Navigates to TodoDetailScreen on "/todos/:id" route', (
      tester,
    ) async {
      final created = await fakeTodoRepository.add(title: 'Router Todo');
      expect(created.$1, isTrue);

      final todos = await fakeTodoRepository.watchAll().first;
      final todoId = todos.first.id;

      await tester.pumpWidget(createTestApp(initialLocation: '/todos/$todoId'));
      await tester.pumpAndSettle();

      expect(find.byType(TodoDetailScreen), findsOneWidget);
    });

    testWidgets('Renders error screen on unknown route', (tester) async {
      await tester.pumpWidget(
        createTestApp(initialLocation: '/unknown-route-404'),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('Page not found'), findsOneWidget);
    });
  });
}
