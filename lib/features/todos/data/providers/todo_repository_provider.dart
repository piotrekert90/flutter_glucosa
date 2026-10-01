import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/providers/isar_provider.dart';
import '../../domain/repositories/todo_repository.dart';
import '../repositories/todo_repository_impl.dart';

part 'todo_repository_provider.g.dart';

/// Provides a persistent singleton instance of [TodoRepository] backed by Isar.
@Riverpod(keepAlive: true)
TodoRepository todoRepository(Ref ref) {
  return TodoRepositoryImpl(ref.watch(isarProvider));
}
