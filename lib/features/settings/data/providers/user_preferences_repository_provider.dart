import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/providers/isar_provider.dart';
import '../../domain/repositories/user_preferences_repository.dart';
import '../repositories/user_preferences_repository_impl.dart';

part 'user_preferences_repository_provider.g.dart';

/// Provides a persistent singleton instance of [UserPreferencesRepository] backed by Isar.
@Riverpod(keepAlive: true)
UserPreferencesRepository userPreferencesRepository(Ref ref) {
  return UserPreferencesRepositoryImpl(ref.watch(isarProvider));
}
