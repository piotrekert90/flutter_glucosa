import 'package:isar_community/isar.dart';

import '../../../../core/domain/enums/enums.dart';
import '../../../../core/domain/value_objects/glucose_target_range.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/errors/result.dart';
import '../../../blood_pressure/data/models/blood_pressure_reading_model.dart';
import '../../../cholesterol/data/models/cholesterol_reading_model.dart';
import '../../../glucose/data/models/glucose_reading_model.dart';
import '../../../hba1c/data/models/hba1c_reading_model.dart';
import '../../../ketones/data/models/ketone_reading_model.dart';
import '../../../reminders/data/models/reminder_model.dart';
import '../../../weight/data/models/weight_reading_model.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/user_profile_repository.dart';
import '../mappers/user_profile_mapper.dart';
import '../models/user_profile_model.dart';

/// Concrete implementation of [UserProfileRepository] backed by Isar storage.
///
/// Manages singleton user settings and diabetes profile state in Isar database transactions.
class UserProfileRepositoryImpl implements UserProfileRepository {
  /// Creates a profile repository instance backed by the given [_isar] database.
  UserProfileRepositoryImpl(this._isar);

  final Isar _isar;

  UserProfile _mapOrDefault(UserProfileModel? model) {
    return model?.toEntity() ?? UserProfile.defaults();
  }

  Future<UserProfileModel> _getOrCreateModel() async {
    final existing = await _isar.userProfileModels.get(userProfileSingletonId);

    if (existing != null) {
      return existing;
    }

    final model = UserProfile.defaults().toModel();
    await _isar.userProfileModels.put(model);
    return model;
  }

  @override
  Stream<UserProfile> watch() {
    return _isar.userProfileModels
        .watchObject(userProfileSingletonId, fireImmediately: true)
        .map(_mapOrDefault)
        .handleError((Object error, StackTrace stack) {
          throw DatabaseFailure('Failed to watch user profile: $error');
        });
  }

  @override
  Future<UserProfile> get() async {
    try {
      final model = await _isar.userProfileModels.get(userProfileSingletonId);
      return _mapOrDefault(model);
    } catch (e) {
      throw DatabaseFailure('Failed to load user profile: $e');
    }
  }

  @override
  Future<CommandResult> save(UserProfile profile) async {
    try {
      await _isar.writeTxn(() async {
        final model = profile.toModel();
        await _isar.userProfileModels.put(model);
      });
      return (true, null);
    } on IsarError catch (e) {
      return (false, DatabaseFailure(e.message));
    } catch (e) {
      return (false, DatabaseFailure('Unexpected error saving profile: $e'));
    }
  }

  @override
  Future<CommandResult> updateThemeMode(UserThemeMode themeMode) async {
    try {
      await _isar.writeTxn(() async {
        final model = await _getOrCreateModel();
        model.themeMode = themeMode.name;
        await _isar.userProfileModels.put(model);
      });
      return (true, null);
    } on IsarError catch (e) {
      return (false, DatabaseFailure(e.message));
    } catch (e) {
      return (false, DatabaseFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<CommandResult> updateNotificationsEnabled(bool isEnabled) async {
    try {
      await _isar.writeTxn(() async {
        final model = await _getOrCreateModel();
        model.isNotificationsEnabled = isEnabled;
        await _isar.userProfileModels.put(model);
      });
      return (true, null);
    } on IsarError catch (e) {
      return (false, DatabaseFailure(e.message));
    } catch (e) {
      return (false, DatabaseFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<CommandResult> updateBiometricLockEnabled(bool isEnabled) async {
    try {
      await _isar.writeTxn(() async {
        final model = await _getOrCreateModel();
        model.isBiometricLockEnabled = isEnabled;
        await _isar.userProfileModels.put(model);
      });
      return (true, null);
    } on IsarError catch (e) {
      return (false, DatabaseFailure(e.message));
    } catch (e) {
      return (false, DatabaseFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<CommandResult> updateFirstDayOfWeek(
    FirstDayOfWeek firstDayOfWeek,
  ) async {
    try {
      await _isar.writeTxn(() async {
        final model = await _getOrCreateModel();
        model.firstDayOfWeek = firstDayOfWeek.name;
        await _isar.userProfileModels.put(model);
      });
      return (true, null);
    } on IsarError catch (e) {
      return (false, DatabaseFailure(e.message));
    } catch (e) {
      return (false, DatabaseFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<CommandResult> updateGlucoseUnit(GlucoseUnit unit) async {
    try {
      await _isar.writeTxn(() async {
        final model = await _getOrCreateModel();
        model.preferredGlucoseUnit = unit.name;
        await _isar.userProfileModels.put(model);
      });
      return (true, null);
    } on IsarError catch (e) {
      return (false, DatabaseFailure(e.message));
    } catch (e) {
      return (false, DatabaseFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<CommandResult> updateTargetRange(GlucoseTargetRange range) async {
    try {
      await _isar.writeTxn(() async {
        final model = await _getOrCreateModel();
        model.targetRangePreset = range.preset.name;
        model.targetRangeMinMgDl = range.minMgDl;
        model.targetRangeMaxMgDl = range.maxMgDl;
        await _isar.userProfileModels.put(model);
      });
      return (true, null);
    } on IsarError catch (e) {
      return (false, DatabaseFailure(e.message));
    } catch (e) {
      return (false, DatabaseFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<CommandResult> completeOnboarding() async {
    try {
      await _isar.writeTxn(() async {
        final model = await _getOrCreateModel();
        model.isOnboardingCompleted = true;
        await _isar.userProfileModels.put(model);
      });
      return (true, null);
    } on IsarError catch (e) {
      return (false, DatabaseFailure(e.message));
    } catch (e) {
      return (false, DatabaseFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<CommandResult> wipeAllData() async {
    try {
      await _isar.writeTxn(() async {
        await _isar.glucoseReadingModels.clear();
        await _isar.hbA1cReadingModels.clear();
        await _isar.bloodPressureReadingModels.clear();
        await _isar.ketoneReadingModels.clear();
        await _isar.cholesterolReadingModels.clear();
        await _isar.weightReadingModels.clear();
        await _isar.reminderModels.clear();
        await _isar.userProfileModels.clear();
        await _isar.userProfileModels.put(UserProfile.defaults().toModel());
      });
      return (true, null);
    } on IsarError catch (e) {
      return (false, DatabaseFailure(e.message));
    } catch (e) {
      return (false, DatabaseFailure('Unexpected error: $e'));
    }
  }
}
