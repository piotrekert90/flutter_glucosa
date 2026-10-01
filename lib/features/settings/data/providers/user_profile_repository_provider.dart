import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/providers/isar_provider.dart';
import '../../domain/repositories/user_profile_repository.dart';
import '../repositories/user_profile_repository_impl.dart';

part 'user_profile_repository_provider.g.dart';

/// Provides the singleton [UserProfileRepository] backed by the Isar database.
@Riverpod(keepAlive: true)
UserProfileRepository userProfileRepository(Ref ref) {
  final isar = ref.watch(isarProvider);
  return UserProfileRepositoryImpl(isar);
}
