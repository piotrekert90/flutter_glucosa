// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetUserProfileModelCollection on Isar {
  IsarCollection<UserProfileModel> get userProfileModels => this.collection();
}

const UserProfileModelSchema = CollectionSchema(
  name: r'UserProfileModel',
  id: -8790468936041821297,
  properties: {
    r'diabetesType': PropertySchema(
      id: 0,
      name: r'diabetesType',
      type: IsarType.string,
    ),
    r'firstDayOfWeek': PropertySchema(
      id: 1,
      name: r'firstDayOfWeek',
      type: IsarType.string,
    ),
    r'isBiometricLockEnabled': PropertySchema(
      id: 2,
      name: r'isBiometricLockEnabled',
      type: IsarType.bool,
    ),
    r'isNotificationsEnabled': PropertySchema(
      id: 3,
      name: r'isNotificationsEnabled',
      type: IsarType.bool,
    ),
    r'isOnboardingCompleted': PropertySchema(
      id: 4,
      name: r'isOnboardingCompleted',
      type: IsarType.bool,
    ),
    r'name': PropertySchema(id: 5, name: r'name', type: IsarType.string),
    r'preferredGlucoseUnit': PropertySchema(
      id: 6,
      name: r'preferredGlucoseUnit',
      type: IsarType.string,
    ),
    r'preferredHbA1cUnit': PropertySchema(
      id: 7,
      name: r'preferredHbA1cUnit',
      type: IsarType.string,
    ),
    r'preferredWeightUnit': PropertySchema(
      id: 8,
      name: r'preferredWeightUnit',
      type: IsarType.string,
    ),
    r'targetRangeMaxMgDl': PropertySchema(
      id: 9,
      name: r'targetRangeMaxMgDl',
      type: IsarType.long,
    ),
    r'targetRangeMinMgDl': PropertySchema(
      id: 10,
      name: r'targetRangeMinMgDl',
      type: IsarType.long,
    ),
    r'targetRangePreset': PropertySchema(
      id: 11,
      name: r'targetRangePreset',
      type: IsarType.string,
    ),
    r'themeMode': PropertySchema(
      id: 12,
      name: r'themeMode',
      type: IsarType.string,
    ),
  },

  estimateSize: _userProfileModelEstimateSize,
  serialize: _userProfileModelSerialize,
  deserialize: _userProfileModelDeserialize,
  deserializeProp: _userProfileModelDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},

  getId: _userProfileModelGetId,
  getLinks: _userProfileModelGetLinks,
  attach: _userProfileModelAttach,
  version: '3.3.2',
);

int _userProfileModelEstimateSize(
  UserProfileModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.diabetesType.length * 3;
  bytesCount += 3 + object.firstDayOfWeek.length * 3;
  bytesCount += 3 + object.name.length * 3;
  bytesCount += 3 + object.preferredGlucoseUnit.length * 3;
  bytesCount += 3 + object.preferredHbA1cUnit.length * 3;
  bytesCount += 3 + object.preferredWeightUnit.length * 3;
  bytesCount += 3 + object.targetRangePreset.length * 3;
  bytesCount += 3 + object.themeMode.length * 3;
  return bytesCount;
}

void _userProfileModelSerialize(
  UserProfileModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.diabetesType);
  writer.writeString(offsets[1], object.firstDayOfWeek);
  writer.writeBool(offsets[2], object.isBiometricLockEnabled);
  writer.writeBool(offsets[3], object.isNotificationsEnabled);
  writer.writeBool(offsets[4], object.isOnboardingCompleted);
  writer.writeString(offsets[5], object.name);
  writer.writeString(offsets[6], object.preferredGlucoseUnit);
  writer.writeString(offsets[7], object.preferredHbA1cUnit);
  writer.writeString(offsets[8], object.preferredWeightUnit);
  writer.writeLong(offsets[9], object.targetRangeMaxMgDl);
  writer.writeLong(offsets[10], object.targetRangeMinMgDl);
  writer.writeString(offsets[11], object.targetRangePreset);
  writer.writeString(offsets[12], object.themeMode);
}

UserProfileModel _userProfileModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = UserProfileModel();
  object.diabetesType = reader.readString(offsets[0]);
  object.firstDayOfWeek = reader.readString(offsets[1]);
  object.id = id;
  object.isBiometricLockEnabled = reader.readBool(offsets[2]);
  object.isNotificationsEnabled = reader.readBool(offsets[3]);
  object.isOnboardingCompleted = reader.readBool(offsets[4]);
  object.name = reader.readString(offsets[5]);
  object.preferredGlucoseUnit = reader.readString(offsets[6]);
  object.preferredHbA1cUnit = reader.readString(offsets[7]);
  object.preferredWeightUnit = reader.readString(offsets[8]);
  object.targetRangeMaxMgDl = reader.readLong(offsets[9]);
  object.targetRangeMinMgDl = reader.readLong(offsets[10]);
  object.targetRangePreset = reader.readString(offsets[11]);
  object.themeMode = reader.readString(offsets[12]);
  return object;
}

P _userProfileModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readBool(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readLong(offset)) as P;
    case 10:
      return (reader.readLong(offset)) as P;
    case 11:
      return (reader.readString(offset)) as P;
    case 12:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _userProfileModelGetId(UserProfileModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _userProfileModelGetLinks(UserProfileModel object) {
  return [];
}

void _userProfileModelAttach(
  IsarCollection<dynamic> col,
  Id id,
  UserProfileModel object,
) {
  object.id = id;
}

extension UserProfileModelQueryWhereSort
    on QueryBuilder<UserProfileModel, UserProfileModel, QWhere> {
  QueryBuilder<UserProfileModel, UserProfileModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension UserProfileModelQueryWhere
    on QueryBuilder<UserProfileModel, UserProfileModel, QWhereClause> {
  QueryBuilder<UserProfileModel, UserProfileModel, QAfterWhereClause> idEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterWhereClause>
  idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterWhereClause>
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension UserProfileModelQueryFilter
    on QueryBuilder<UserProfileModel, UserProfileModel, QFilterCondition> {
  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  diabetesTypeEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'diabetesType',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  diabetesTypeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'diabetesType',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  diabetesTypeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'diabetesType',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  diabetesTypeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'diabetesType',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  diabetesTypeStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'diabetesType',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  diabetesTypeEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'diabetesType',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  diabetesTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'diabetesType',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  diabetesTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'diabetesType',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  diabetesTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'diabetesType', value: ''),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  diabetesTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'diabetesType', value: ''),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  firstDayOfWeekEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'firstDayOfWeek',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  firstDayOfWeekGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'firstDayOfWeek',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  firstDayOfWeekLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'firstDayOfWeek',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  firstDayOfWeekBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'firstDayOfWeek',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  firstDayOfWeekStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'firstDayOfWeek',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  firstDayOfWeekEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'firstDayOfWeek',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  firstDayOfWeekContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'firstDayOfWeek',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  firstDayOfWeekMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'firstDayOfWeek',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  firstDayOfWeekIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'firstDayOfWeek', value: ''),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  firstDayOfWeekIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'firstDayOfWeek', value: ''),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  idGreaterThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  idLessThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  isBiometricLockEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'isBiometricLockEnabled',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  isNotificationsEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'isNotificationsEnabled',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  isOnboardingCompletedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'isOnboardingCompleted',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  nameEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'name',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  nameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  nameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  nameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'name',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  preferredGlucoseUnitEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'preferredGlucoseUnit',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  preferredGlucoseUnitGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'preferredGlucoseUnit',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  preferredGlucoseUnitLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'preferredGlucoseUnit',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  preferredGlucoseUnitBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'preferredGlucoseUnit',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  preferredGlucoseUnitStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'preferredGlucoseUnit',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  preferredGlucoseUnitEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'preferredGlucoseUnit',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  preferredGlucoseUnitContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'preferredGlucoseUnit',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  preferredGlucoseUnitMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'preferredGlucoseUnit',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  preferredGlucoseUnitIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'preferredGlucoseUnit', value: ''),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  preferredGlucoseUnitIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          property: r'preferredGlucoseUnit',
          value: '',
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  preferredHbA1cUnitEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'preferredHbA1cUnit',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  preferredHbA1cUnitGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'preferredHbA1cUnit',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  preferredHbA1cUnitLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'preferredHbA1cUnit',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  preferredHbA1cUnitBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'preferredHbA1cUnit',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  preferredHbA1cUnitStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'preferredHbA1cUnit',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  preferredHbA1cUnitEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'preferredHbA1cUnit',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  preferredHbA1cUnitContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'preferredHbA1cUnit',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  preferredHbA1cUnitMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'preferredHbA1cUnit',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  preferredHbA1cUnitIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'preferredHbA1cUnit', value: ''),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  preferredHbA1cUnitIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'preferredHbA1cUnit', value: ''),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  preferredWeightUnitEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'preferredWeightUnit',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  preferredWeightUnitGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'preferredWeightUnit',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  preferredWeightUnitLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'preferredWeightUnit',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  preferredWeightUnitBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'preferredWeightUnit',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  preferredWeightUnitStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'preferredWeightUnit',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  preferredWeightUnitEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'preferredWeightUnit',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  preferredWeightUnitContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'preferredWeightUnit',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  preferredWeightUnitMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'preferredWeightUnit',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  preferredWeightUnitIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'preferredWeightUnit', value: ''),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  preferredWeightUnitIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          property: r'preferredWeightUnit',
          value: '',
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  targetRangeMaxMgDlEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'targetRangeMaxMgDl', value: value),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  targetRangeMaxMgDlGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'targetRangeMaxMgDl',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  targetRangeMaxMgDlLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'targetRangeMaxMgDl',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  targetRangeMaxMgDlBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'targetRangeMaxMgDl',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  targetRangeMinMgDlEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'targetRangeMinMgDl', value: value),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  targetRangeMinMgDlGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'targetRangeMinMgDl',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  targetRangeMinMgDlLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'targetRangeMinMgDl',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  targetRangeMinMgDlBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'targetRangeMinMgDl',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  targetRangePresetEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'targetRangePreset',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  targetRangePresetGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'targetRangePreset',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  targetRangePresetLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'targetRangePreset',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  targetRangePresetBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'targetRangePreset',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  targetRangePresetStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'targetRangePreset',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  targetRangePresetEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'targetRangePreset',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  targetRangePresetContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'targetRangePreset',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  targetRangePresetMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'targetRangePreset',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  targetRangePresetIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'targetRangePreset', value: ''),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  targetRangePresetIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'targetRangePreset', value: ''),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  themeModeEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'themeMode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  themeModeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'themeMode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  themeModeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'themeMode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  themeModeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'themeMode',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  themeModeStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'themeMode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  themeModeEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'themeMode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  themeModeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'themeMode',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  themeModeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'themeMode',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  themeModeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'themeMode', value: ''),
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterFilterCondition>
  themeModeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'themeMode', value: ''),
      );
    });
  }
}

extension UserProfileModelQueryObject
    on QueryBuilder<UserProfileModel, UserProfileModel, QFilterCondition> {}

extension UserProfileModelQueryLinks
    on QueryBuilder<UserProfileModel, UserProfileModel, QFilterCondition> {}

extension UserProfileModelQuerySortBy
    on QueryBuilder<UserProfileModel, UserProfileModel, QSortBy> {
  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
  sortByDiabetesType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'diabetesType', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
  sortByDiabetesTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'diabetesType', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
  sortByFirstDayOfWeek() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstDayOfWeek', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
  sortByFirstDayOfWeekDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstDayOfWeek', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
  sortByIsBiometricLockEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isBiometricLockEnabled', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
  sortByIsBiometricLockEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isBiometricLockEnabled', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
  sortByIsNotificationsEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isNotificationsEnabled', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
  sortByIsNotificationsEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isNotificationsEnabled', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
  sortByIsOnboardingCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOnboardingCompleted', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
  sortByIsOnboardingCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOnboardingCompleted', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
  sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
  sortByPreferredGlucoseUnit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'preferredGlucoseUnit', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
  sortByPreferredGlucoseUnitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'preferredGlucoseUnit', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
  sortByPreferredHbA1cUnit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'preferredHbA1cUnit', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
  sortByPreferredHbA1cUnitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'preferredHbA1cUnit', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
  sortByPreferredWeightUnit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'preferredWeightUnit', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
  sortByPreferredWeightUnitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'preferredWeightUnit', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
  sortByTargetRangeMaxMgDl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetRangeMaxMgDl', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
  sortByTargetRangeMaxMgDlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetRangeMaxMgDl', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
  sortByTargetRangeMinMgDl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetRangeMinMgDl', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
  sortByTargetRangeMinMgDlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetRangeMinMgDl', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
  sortByTargetRangePreset() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetRangePreset', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
  sortByTargetRangePresetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetRangePreset', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
  sortByThemeMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'themeMode', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
  sortByThemeModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'themeMode', Sort.desc);
    });
  }
}

extension UserProfileModelQuerySortThenBy
    on QueryBuilder<UserProfileModel, UserProfileModel, QSortThenBy> {
  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
  thenByDiabetesType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'diabetesType', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
  thenByDiabetesTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'diabetesType', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
  thenByFirstDayOfWeek() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstDayOfWeek', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
  thenByFirstDayOfWeekDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'firstDayOfWeek', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
  thenByIsBiometricLockEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isBiometricLockEnabled', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
  thenByIsBiometricLockEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isBiometricLockEnabled', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
  thenByIsNotificationsEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isNotificationsEnabled', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
  thenByIsNotificationsEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isNotificationsEnabled', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
  thenByIsOnboardingCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOnboardingCompleted', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
  thenByIsOnboardingCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOnboardingCompleted', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
  thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
  thenByPreferredGlucoseUnit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'preferredGlucoseUnit', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
  thenByPreferredGlucoseUnitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'preferredGlucoseUnit', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
  thenByPreferredHbA1cUnit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'preferredHbA1cUnit', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
  thenByPreferredHbA1cUnitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'preferredHbA1cUnit', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
  thenByPreferredWeightUnit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'preferredWeightUnit', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
  thenByPreferredWeightUnitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'preferredWeightUnit', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
  thenByTargetRangeMaxMgDl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetRangeMaxMgDl', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
  thenByTargetRangeMaxMgDlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetRangeMaxMgDl', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
  thenByTargetRangeMinMgDl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetRangeMinMgDl', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
  thenByTargetRangeMinMgDlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetRangeMinMgDl', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
  thenByTargetRangePreset() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetRangePreset', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
  thenByTargetRangePresetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetRangePreset', Sort.desc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
  thenByThemeMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'themeMode', Sort.asc);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QAfterSortBy>
  thenByThemeModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'themeMode', Sort.desc);
    });
  }
}

extension UserProfileModelQueryWhereDistinct
    on QueryBuilder<UserProfileModel, UserProfileModel, QDistinct> {
  QueryBuilder<UserProfileModel, UserProfileModel, QDistinct>
  distinctByDiabetesType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'diabetesType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QDistinct>
  distinctByFirstDayOfWeek({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'firstDayOfWeek',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QDistinct>
  distinctByIsBiometricLockEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isBiometricLockEnabled');
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QDistinct>
  distinctByIsNotificationsEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isNotificationsEnabled');
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QDistinct>
  distinctByIsOnboardingCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isOnboardingCompleted');
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QDistinct> distinctByName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QDistinct>
  distinctByPreferredGlucoseUnit({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'preferredGlucoseUnit',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QDistinct>
  distinctByPreferredHbA1cUnit({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'preferredHbA1cUnit',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QDistinct>
  distinctByPreferredWeightUnit({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'preferredWeightUnit',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QDistinct>
  distinctByTargetRangeMaxMgDl() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'targetRangeMaxMgDl');
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QDistinct>
  distinctByTargetRangeMinMgDl() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'targetRangeMinMgDl');
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QDistinct>
  distinctByTargetRangePreset({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'targetRangePreset',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<UserProfileModel, UserProfileModel, QDistinct>
  distinctByThemeMode({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'themeMode', caseSensitive: caseSensitive);
    });
  }
}

extension UserProfileModelQueryProperty
    on QueryBuilder<UserProfileModel, UserProfileModel, QQueryProperty> {
  QueryBuilder<UserProfileModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<UserProfileModel, String, QQueryOperations>
  diabetesTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'diabetesType');
    });
  }

  QueryBuilder<UserProfileModel, String, QQueryOperations>
  firstDayOfWeekProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'firstDayOfWeek');
    });
  }

  QueryBuilder<UserProfileModel, bool, QQueryOperations>
  isBiometricLockEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isBiometricLockEnabled');
    });
  }

  QueryBuilder<UserProfileModel, bool, QQueryOperations>
  isNotificationsEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isNotificationsEnabled');
    });
  }

  QueryBuilder<UserProfileModel, bool, QQueryOperations>
  isOnboardingCompletedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isOnboardingCompleted');
    });
  }

  QueryBuilder<UserProfileModel, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<UserProfileModel, String, QQueryOperations>
  preferredGlucoseUnitProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'preferredGlucoseUnit');
    });
  }

  QueryBuilder<UserProfileModel, String, QQueryOperations>
  preferredHbA1cUnitProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'preferredHbA1cUnit');
    });
  }

  QueryBuilder<UserProfileModel, String, QQueryOperations>
  preferredWeightUnitProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'preferredWeightUnit');
    });
  }

  QueryBuilder<UserProfileModel, int, QQueryOperations>
  targetRangeMaxMgDlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'targetRangeMaxMgDl');
    });
  }

  QueryBuilder<UserProfileModel, int, QQueryOperations>
  targetRangeMinMgDlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'targetRangeMinMgDl');
    });
  }

  QueryBuilder<UserProfileModel, String, QQueryOperations>
  targetRangePresetProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'targetRangePreset');
    });
  }

  QueryBuilder<UserProfileModel, String, QQueryOperations> themeModeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'themeMode');
    });
  }
}
