// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminder_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetReminderModelCollection on Isar {
  IsarCollection<ReminderModel> get reminderModels => this.collection();
}

const ReminderModelSchema = CollectionSchema(
  name: r'ReminderModel',
  id: -6553527084112746384,
  properties: {
    r'hourOfDay': PropertySchema(
      id: 0,
      name: r'hourOfDay',
      type: IsarType.long,
    ),
    r'isActive': PropertySchema(id: 1, name: r'isActive', type: IsarType.bool),
    r'isOneTime': PropertySchema(
      id: 2,
      name: r'isOneTime',
      type: IsarType.bool,
    ),
    r'label': PropertySchema(id: 3, name: r'label', type: IsarType.string),
    r'metricType': PropertySchema(
      id: 4,
      name: r'metricType',
      type: IsarType.string,
    ),
    r'minute': PropertySchema(id: 5, name: r'minute', type: IsarType.long),
  },

  estimateSize: _reminderModelEstimateSize,
  serialize: _reminderModelSerialize,
  deserialize: _reminderModelDeserialize,
  deserializeProp: _reminderModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'metricType': IndexSchema(
      id: -8102819702908295017,
      name: r'metricType',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'metricType',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
    r'isActive': IndexSchema(
      id: 8092228061260947457,
      name: r'isActive',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'isActive',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _reminderModelGetId,
  getLinks: _reminderModelGetLinks,
  attach: _reminderModelAttach,
  version: '3.3.2',
);

int _reminderModelEstimateSize(
  ReminderModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.label.length * 3;
  bytesCount += 3 + object.metricType.length * 3;
  return bytesCount;
}

void _reminderModelSerialize(
  ReminderModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.hourOfDay);
  writer.writeBool(offsets[1], object.isActive);
  writer.writeBool(offsets[2], object.isOneTime);
  writer.writeString(offsets[3], object.label);
  writer.writeString(offsets[4], object.metricType);
  writer.writeLong(offsets[5], object.minute);
}

ReminderModel _reminderModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ReminderModel();
  object.hourOfDay = reader.readLong(offsets[0]);
  object.id = id;
  object.isActive = reader.readBool(offsets[1]);
  object.isOneTime = reader.readBool(offsets[2]);
  object.label = reader.readString(offsets[3]);
  object.metricType = reader.readString(offsets[4]);
  object.minute = reader.readLong(offsets[5]);
  return object;
}

P _reminderModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _reminderModelGetId(ReminderModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _reminderModelGetLinks(ReminderModel object) {
  return [];
}

void _reminderModelAttach(
  IsarCollection<dynamic> col,
  Id id,
  ReminderModel object,
) {
  object.id = id;
}

extension ReminderModelQueryWhereSort
    on QueryBuilder<ReminderModel, ReminderModel, QWhere> {
  QueryBuilder<ReminderModel, ReminderModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<ReminderModel, ReminderModel, QAfterWhere> anyIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'isActive'),
      );
    });
  }
}

extension ReminderModelQueryWhere
    on QueryBuilder<ReminderModel, ReminderModel, QWhereClause> {
  QueryBuilder<ReminderModel, ReminderModel, QAfterWhereClause> idEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<ReminderModel, ReminderModel, QAfterWhereClause> idNotEqualTo(
    Id id,
  ) {
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

  QueryBuilder<ReminderModel, ReminderModel, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ReminderModel, ReminderModel, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ReminderModel, ReminderModel, QAfterWhereClause> idBetween(
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

  QueryBuilder<ReminderModel, ReminderModel, QAfterWhereClause>
  metricTypeEqualTo(String metricType) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'metricType', value: [metricType]),
      );
    });
  }

  QueryBuilder<ReminderModel, ReminderModel, QAfterWhereClause>
  metricTypeNotEqualTo(String metricType) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'metricType',
                lower: [],
                upper: [metricType],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'metricType',
                lower: [metricType],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'metricType',
                lower: [metricType],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'metricType',
                lower: [],
                upper: [metricType],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<ReminderModel, ReminderModel, QAfterWhereClause> isActiveEqualTo(
    bool isActive,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'isActive', value: [isActive]),
      );
    });
  }

  QueryBuilder<ReminderModel, ReminderModel, QAfterWhereClause>
  isActiveNotEqualTo(bool isActive) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'isActive',
                lower: [],
                upper: [isActive],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'isActive',
                lower: [isActive],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'isActive',
                lower: [isActive],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'isActive',
                lower: [],
                upper: [isActive],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension ReminderModelQueryFilter
    on QueryBuilder<ReminderModel, ReminderModel, QFilterCondition> {
  QueryBuilder<ReminderModel, ReminderModel, QAfterFilterCondition>
  hourOfDayEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'hourOfDay', value: value),
      );
    });
  }

  QueryBuilder<ReminderModel, ReminderModel, QAfterFilterCondition>
  hourOfDayGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'hourOfDay',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ReminderModel, ReminderModel, QAfterFilterCondition>
  hourOfDayLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'hourOfDay',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ReminderModel, ReminderModel, QAfterFilterCondition>
  hourOfDayBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'hourOfDay',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<ReminderModel, ReminderModel, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<ReminderModel, ReminderModel, QAfterFilterCondition>
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

  QueryBuilder<ReminderModel, ReminderModel, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
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

  QueryBuilder<ReminderModel, ReminderModel, QAfterFilterCondition> idBetween(
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

  QueryBuilder<ReminderModel, ReminderModel, QAfterFilterCondition>
  isActiveEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isActive', value: value),
      );
    });
  }

  QueryBuilder<ReminderModel, ReminderModel, QAfterFilterCondition>
  isOneTimeEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isOneTime', value: value),
      );
    });
  }

  QueryBuilder<ReminderModel, ReminderModel, QAfterFilterCondition>
  labelEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'label',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ReminderModel, ReminderModel, QAfterFilterCondition>
  labelGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'label',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ReminderModel, ReminderModel, QAfterFilterCondition>
  labelLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'label',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ReminderModel, ReminderModel, QAfterFilterCondition>
  labelBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'label',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ReminderModel, ReminderModel, QAfterFilterCondition>
  labelStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'label',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ReminderModel, ReminderModel, QAfterFilterCondition>
  labelEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'label',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ReminderModel, ReminderModel, QAfterFilterCondition>
  labelContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'label',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ReminderModel, ReminderModel, QAfterFilterCondition>
  labelMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'label',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ReminderModel, ReminderModel, QAfterFilterCondition>
  labelIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'label', value: ''),
      );
    });
  }

  QueryBuilder<ReminderModel, ReminderModel, QAfterFilterCondition>
  labelIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'label', value: ''),
      );
    });
  }

  QueryBuilder<ReminderModel, ReminderModel, QAfterFilterCondition>
  metricTypeEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'metricType',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ReminderModel, ReminderModel, QAfterFilterCondition>
  metricTypeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'metricType',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ReminderModel, ReminderModel, QAfterFilterCondition>
  metricTypeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'metricType',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ReminderModel, ReminderModel, QAfterFilterCondition>
  metricTypeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'metricType',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ReminderModel, ReminderModel, QAfterFilterCondition>
  metricTypeStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'metricType',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ReminderModel, ReminderModel, QAfterFilterCondition>
  metricTypeEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'metricType',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ReminderModel, ReminderModel, QAfterFilterCondition>
  metricTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'metricType',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ReminderModel, ReminderModel, QAfterFilterCondition>
  metricTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'metricType',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ReminderModel, ReminderModel, QAfterFilterCondition>
  metricTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'metricType', value: ''),
      );
    });
  }

  QueryBuilder<ReminderModel, ReminderModel, QAfterFilterCondition>
  metricTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'metricType', value: ''),
      );
    });
  }

  QueryBuilder<ReminderModel, ReminderModel, QAfterFilterCondition>
  minuteEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'minute', value: value),
      );
    });
  }

  QueryBuilder<ReminderModel, ReminderModel, QAfterFilterCondition>
  minuteGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'minute',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ReminderModel, ReminderModel, QAfterFilterCondition>
  minuteLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'minute',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ReminderModel, ReminderModel, QAfterFilterCondition>
  minuteBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'minute',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension ReminderModelQueryObject
    on QueryBuilder<ReminderModel, ReminderModel, QFilterCondition> {}

extension ReminderModelQueryLinks
    on QueryBuilder<ReminderModel, ReminderModel, QFilterCondition> {}

extension ReminderModelQuerySortBy
    on QueryBuilder<ReminderModel, ReminderModel, QSortBy> {
  QueryBuilder<ReminderModel, ReminderModel, QAfterSortBy> sortByHourOfDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hourOfDay', Sort.asc);
    });
  }

  QueryBuilder<ReminderModel, ReminderModel, QAfterSortBy>
  sortByHourOfDayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hourOfDay', Sort.desc);
    });
  }

  QueryBuilder<ReminderModel, ReminderModel, QAfterSortBy> sortByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<ReminderModel, ReminderModel, QAfterSortBy>
  sortByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<ReminderModel, ReminderModel, QAfterSortBy> sortByIsOneTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOneTime', Sort.asc);
    });
  }

  QueryBuilder<ReminderModel, ReminderModel, QAfterSortBy>
  sortByIsOneTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOneTime', Sort.desc);
    });
  }

  QueryBuilder<ReminderModel, ReminderModel, QAfterSortBy> sortByLabel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'label', Sort.asc);
    });
  }

  QueryBuilder<ReminderModel, ReminderModel, QAfterSortBy> sortByLabelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'label', Sort.desc);
    });
  }

  QueryBuilder<ReminderModel, ReminderModel, QAfterSortBy> sortByMetricType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'metricType', Sort.asc);
    });
  }

  QueryBuilder<ReminderModel, ReminderModel, QAfterSortBy>
  sortByMetricTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'metricType', Sort.desc);
    });
  }

  QueryBuilder<ReminderModel, ReminderModel, QAfterSortBy> sortByMinute() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'minute', Sort.asc);
    });
  }

  QueryBuilder<ReminderModel, ReminderModel, QAfterSortBy> sortByMinuteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'minute', Sort.desc);
    });
  }
}

extension ReminderModelQuerySortThenBy
    on QueryBuilder<ReminderModel, ReminderModel, QSortThenBy> {
  QueryBuilder<ReminderModel, ReminderModel, QAfterSortBy> thenByHourOfDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hourOfDay', Sort.asc);
    });
  }

  QueryBuilder<ReminderModel, ReminderModel, QAfterSortBy>
  thenByHourOfDayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hourOfDay', Sort.desc);
    });
  }

  QueryBuilder<ReminderModel, ReminderModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ReminderModel, ReminderModel, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ReminderModel, ReminderModel, QAfterSortBy> thenByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<ReminderModel, ReminderModel, QAfterSortBy>
  thenByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<ReminderModel, ReminderModel, QAfterSortBy> thenByIsOneTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOneTime', Sort.asc);
    });
  }

  QueryBuilder<ReminderModel, ReminderModel, QAfterSortBy>
  thenByIsOneTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOneTime', Sort.desc);
    });
  }

  QueryBuilder<ReminderModel, ReminderModel, QAfterSortBy> thenByLabel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'label', Sort.asc);
    });
  }

  QueryBuilder<ReminderModel, ReminderModel, QAfterSortBy> thenByLabelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'label', Sort.desc);
    });
  }

  QueryBuilder<ReminderModel, ReminderModel, QAfterSortBy> thenByMetricType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'metricType', Sort.asc);
    });
  }

  QueryBuilder<ReminderModel, ReminderModel, QAfterSortBy>
  thenByMetricTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'metricType', Sort.desc);
    });
  }

  QueryBuilder<ReminderModel, ReminderModel, QAfterSortBy> thenByMinute() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'minute', Sort.asc);
    });
  }

  QueryBuilder<ReminderModel, ReminderModel, QAfterSortBy> thenByMinuteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'minute', Sort.desc);
    });
  }
}

extension ReminderModelQueryWhereDistinct
    on QueryBuilder<ReminderModel, ReminderModel, QDistinct> {
  QueryBuilder<ReminderModel, ReminderModel, QDistinct> distinctByHourOfDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hourOfDay');
    });
  }

  QueryBuilder<ReminderModel, ReminderModel, QDistinct> distinctByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isActive');
    });
  }

  QueryBuilder<ReminderModel, ReminderModel, QDistinct> distinctByIsOneTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isOneTime');
    });
  }

  QueryBuilder<ReminderModel, ReminderModel, QDistinct> distinctByLabel({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'label', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ReminderModel, ReminderModel, QDistinct> distinctByMetricType({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'metricType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ReminderModel, ReminderModel, QDistinct> distinctByMinute() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'minute');
    });
  }
}

extension ReminderModelQueryProperty
    on QueryBuilder<ReminderModel, ReminderModel, QQueryProperty> {
  QueryBuilder<ReminderModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ReminderModel, int, QQueryOperations> hourOfDayProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hourOfDay');
    });
  }

  QueryBuilder<ReminderModel, bool, QQueryOperations> isActiveProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isActive');
    });
  }

  QueryBuilder<ReminderModel, bool, QQueryOperations> isOneTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isOneTime');
    });
  }

  QueryBuilder<ReminderModel, String, QQueryOperations> labelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'label');
    });
  }

  QueryBuilder<ReminderModel, String, QQueryOperations> metricTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'metricType');
    });
  }

  QueryBuilder<ReminderModel, int, QQueryOperations> minuteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'minute');
    });
  }
}
