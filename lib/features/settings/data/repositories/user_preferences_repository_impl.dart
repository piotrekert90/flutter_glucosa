import 'package:isar_community/isar.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/errors/result.dart';
import '../../domain/entities/user_preferences.dart';
import '../../domain/repositories/user_preferences_repository.dart';
import '../mappers/user_preferences_mapper.dart';
import '../models/user_preferences_model.dart';

/// Concrete implementation of [UserPreferencesRepository] backed by Isar storage.
///
/// Manages singleton user settings state in Isar database transactions and converts
/// raw storage models to domain [UserPreferences] entities.
class UserPreferencesRepositoryImpl implements UserPreferencesRepository {
  /// Creates a preferences repository instance backed by the given [_isar] database.
  UserPreferencesRepositoryImpl(this._isar);

  final Isar _isar;

  UserPreferences _mapOrDefault(UserPreferencesModel? model) {
    return model?.toEntity() ?? UserPreferences.defaults();
  }

  Future<UserPreferencesModel> _getOrCreateModel() async {
    final existing = await _isar.userPreferencesModels.get(
      userPreferencesSingletonId,
    );

    if (existing != null) {
      return existing;
    }

    final model = UserPreferences.defaults().toModel();
    await _isar.userPreferencesModels.put(model);
    return model;
  }

  /// Watches for updates to the singleton user preferences object.
  ///
  /// Emits a continuous [Stream] containing updated [UserPreferences] whenever the underlying
  /// user preferences record changes in Isar storage.
  ///
  /// Throws [DatabaseFailure] if a database watch stream error occurs.
  @override
  Stream<UserPreferences> watch() {
    return _isar.userPreferencesModels
        .watchObject(userPreferencesSingletonId, fireImmediately: true)
        .map(_mapOrDefault)
        .handleError((Object error, StackTrace stack) {
          throw DatabaseFailure('Failed to watch preferences: $error');
        });
  }

  /// Fetches the current user preferences snapshot.
  ///
  /// Throws [DatabaseFailure] if reading user preferences from storage fails.
  @override
  Future<UserPreferences> get() async {
    try {
      final model = await _isar.userPreferencesModels.get(
        userPreferencesSingletonId,
      );
      return _mapOrDefault(model);
    } catch (e) {
      throw DatabaseFailure('Failed to load preferences: $e');
    }
  }

  /// Updates the application theme setting to [themeMode].
  @override
  Future<CommandResult> updateThemeMode(UserThemeMode themeMode) async {
    try {
      await _isar.writeTxn(() async {
        final model = await _getOrCreateModel();
        model.themeMode = themeMode.name;
        await _isar.userPreferencesModels.put(model);
      });
      return (true, null);
    } on IsarError catch (e) {
      return (false, DatabaseFailure(e.message));
    } catch (e) {
      return (false, DatabaseFailure('Unexpected error: $e'));
    }
  }

  /// Updates whether application notifications are enabled to [isEnabled].
  @override
  Future<CommandResult> updateNotificationsEnabled(bool isEnabled) async {
    try {
      await _isar.writeTxn(() async {
        final model = await _getOrCreateModel();
        model.isNotificationsEnabled = isEnabled;
        await _isar.userPreferencesModels.put(model);
      });
      return (true, null);
    } on IsarError catch (e) {
      return (false, DatabaseFailure(e.message));
    } catch (e) {
      return (false, DatabaseFailure('Unexpected error: $e'));
    }
  }
}
