// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'blood_pressure_reading_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetBloodPressureReadingModelCollection on Isar {
  IsarCollection<BloodPressureReadingModel> get bloodPressureReadingModels =>
      this.collection();
}

const BloodPressureReadingModelSchema = CollectionSchema(
  name: r'BloodPressureReadingModel',
  id: -8666739834572067212,
  properties: {
    r'createdAt': PropertySchema(
      id: 0,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'diastolicMmHg': PropertySchema(
      id: 1,
      name: r'diastolicMmHg',
      type: IsarType.long,
    ),
    r'notes': PropertySchema(id: 2, name: r'notes', type: IsarType.string),
    r'systolicMmHg': PropertySchema(
      id: 3,
      name: r'systolicMmHg',
      type: IsarType.long,
    ),
  },

  estimateSize: _bloodPressureReadingModelEstimateSize,
  serialize: _bloodPressureReadingModelSerialize,
  deserialize: _bloodPressureReadingModelDeserialize,
  deserializeProp: _bloodPressureReadingModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'createdAt': IndexSchema(
      id: -3433535483987302584,
      name: r'createdAt',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'createdAt',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _bloodPressureReadingModelGetId,
  getLinks: _bloodPressureReadingModelGetLinks,
  attach: _bloodPressureReadingModelAttach,
  version: '3.3.2',
);

int _bloodPressureReadingModelEstimateSize(
  BloodPressureReadingModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.notes;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _bloodPressureReadingModelSerialize(
  BloodPressureReadingModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeLong(offsets[1], object.diastolicMmHg);
  writer.writeString(offsets[2], object.notes);
  writer.writeLong(offsets[3], object.systolicMmHg);
}

BloodPressureReadingModel _bloodPressureReadingModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = BloodPressureReadingModel();
  object.createdAt = reader.readDateTime(offsets[0]);
  object.diastolicMmHg = reader.readLong(offsets[1]);
  object.id = id;
  object.notes = reader.readStringOrNull(offsets[2]);
  object.systolicMmHg = reader.readLong(offsets[3]);
  return object;
}

P _bloodPressureReadingModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _bloodPressureReadingModelGetId(BloodPressureReadingModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _bloodPressureReadingModelGetLinks(
  BloodPressureReadingModel object,
) {
  return [];
}

void _bloodPressureReadingModelAttach(
  IsarCollection<dynamic> col,
  Id id,
  BloodPressureReadingModel object,
) {
  object.id = id;
}

extension BloodPressureReadingModelQueryWhereSort
    on
        QueryBuilder<
          BloodPressureReadingModel,
          BloodPressureReadingModel,
          QWhere
        > {
  QueryBuilder<
    BloodPressureReadingModel,
    BloodPressureReadingModel,
    QAfterWhere
  >
  anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<
    BloodPressureReadingModel,
    BloodPressureReadingModel,
    QAfterWhere
  >
  anyCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'createdAt'),
      );
    });
  }
}

extension BloodPressureReadingModelQueryWhere
    on
        QueryBuilder<
          BloodPressureReadingModel,
          BloodPressureReadingModel,
          QWhereClause
        > {
  QueryBuilder<
    BloodPressureReadingModel,
    BloodPressureReadingModel,
    QAfterWhereClause
  >
  idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<
    BloodPressureReadingModel,
    BloodPressureReadingModel,
    QAfterWhereClause
  >
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

  QueryBuilder<
    BloodPressureReadingModel,
    BloodPressureReadingModel,
    QAfterWhereClause
  >
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<
    BloodPressureReadingModel,
    BloodPressureReadingModel,
    QAfterWhereClause
  >
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<
    BloodPressureReadingModel,
    BloodPressureReadingModel,
    QAfterWhereClause
  >
  idBetween(
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

  QueryBuilder<
    BloodPressureReadingModel,
    BloodPressureReadingModel,
    QAfterWhereClause
  >
  createdAtEqualTo(DateTime createdAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'createdAt', value: [createdAt]),
      );
    });
  }

  QueryBuilder<
    BloodPressureReadingModel,
    BloodPressureReadingModel,
    QAfterWhereClause
  >
  createdAtNotEqualTo(DateTime createdAt) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'createdAt',
                lower: [],
                upper: [createdAt],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'createdAt',
                lower: [createdAt],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'createdAt',
                lower: [createdAt],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'createdAt',
                lower: [],
                upper: [createdAt],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<
    BloodPressureReadingModel,
    BloodPressureReadingModel,
    QAfterWhereClause
  >
  createdAtGreaterThan(DateTime createdAt, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'createdAt',
          lower: [createdAt],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<
    BloodPressureReadingModel,
    BloodPressureReadingModel,
    QAfterWhereClause
  >
  createdAtLessThan(DateTime createdAt, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'createdAt',
          lower: [],
          upper: [createdAt],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<
    BloodPressureReadingModel,
    BloodPressureReadingModel,
    QAfterWhereClause
  >
  createdAtBetween(
    DateTime lowerCreatedAt,
    DateTime upperCreatedAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'createdAt',
          lower: [lowerCreatedAt],
          includeLower: includeLower,
          upper: [upperCreatedAt],
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension BloodPressureReadingModelQueryFilter
    on
        QueryBuilder<
          BloodPressureReadingModel,
          BloodPressureReadingModel,
          QFilterCondition
        > {
  QueryBuilder<
    BloodPressureReadingModel,
    BloodPressureReadingModel,
    QAfterFilterCondition
  >
  createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'createdAt', value: value),
      );
    });
  }

  QueryBuilder<
    BloodPressureReadingModel,
    BloodPressureReadingModel,
    QAfterFilterCondition
  >
  createdAtGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'createdAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    BloodPressureReadingModel,
    BloodPressureReadingModel,
    QAfterFilterCondition
  >
  createdAtLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'createdAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    BloodPressureReadingModel,
    BloodPressureReadingModel,
    QAfterFilterCondition
  >
  createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'createdAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    BloodPressureReadingModel,
    BloodPressureReadingModel,
    QAfterFilterCondition
  >
  diastolicMmHgEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'diastolicMmHg', value: value),
      );
    });
  }

  QueryBuilder<
    BloodPressureReadingModel,
    BloodPressureReadingModel,
    QAfterFilterCondition
  >
  diastolicMmHgGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'diastolicMmHg',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    BloodPressureReadingModel,
    BloodPressureReadingModel,
    QAfterFilterCondition
  >
  diastolicMmHgLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'diastolicMmHg',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    BloodPressureReadingModel,
    BloodPressureReadingModel,
    QAfterFilterCondition
  >
  diastolicMmHgBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'diastolicMmHg',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    BloodPressureReadingModel,
    BloodPressureReadingModel,
    QAfterFilterCondition
  >
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<
    BloodPressureReadingModel,
    BloodPressureReadingModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    BloodPressureReadingModel,
    BloodPressureReadingModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    BloodPressureReadingModel,
    BloodPressureReadingModel,
    QAfterFilterCondition
  >
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

  QueryBuilder<
    BloodPressureReadingModel,
    BloodPressureReadingModel,
    QAfterFilterCondition
  >
  notesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'notes'),
      );
    });
  }

  QueryBuilder<
    BloodPressureReadingModel,
    BloodPressureReadingModel,
    QAfterFilterCondition
  >
  notesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'notes'),
      );
    });
  }

  QueryBuilder<
    BloodPressureReadingModel,
    BloodPressureReadingModel,
    QAfterFilterCondition
  >
  notesEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'notes',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    BloodPressureReadingModel,
    BloodPressureReadingModel,
    QAfterFilterCondition
  >
  notesGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'notes',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    BloodPressureReadingModel,
    BloodPressureReadingModel,
    QAfterFilterCondition
  >
  notesLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'notes',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    BloodPressureReadingModel,
    BloodPressureReadingModel,
    QAfterFilterCondition
  >
  notesBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'notes',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    BloodPressureReadingModel,
    BloodPressureReadingModel,
    QAfterFilterCondition
  >
  notesStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'notes',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    BloodPressureReadingModel,
    BloodPressureReadingModel,
    QAfterFilterCondition
  >
  notesEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'notes',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    BloodPressureReadingModel,
    BloodPressureReadingModel,
    QAfterFilterCondition
  >
  notesContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'notes',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    BloodPressureReadingModel,
    BloodPressureReadingModel,
    QAfterFilterCondition
  >
  notesMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'notes',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    BloodPressureReadingModel,
    BloodPressureReadingModel,
    QAfterFilterCondition
  >
  notesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'notes', value: ''),
      );
    });
  }

  QueryBuilder<
    BloodPressureReadingModel,
    BloodPressureReadingModel,
    QAfterFilterCondition
  >
  notesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'notes', value: ''),
      );
    });
  }

  QueryBuilder<
    BloodPressureReadingModel,
    BloodPressureReadingModel,
    QAfterFilterCondition
  >
  systolicMmHgEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'systolicMmHg', value: value),
      );
    });
  }

  QueryBuilder<
    BloodPressureReadingModel,
    BloodPressureReadingModel,
    QAfterFilterCondition
  >
  systolicMmHgGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'systolicMmHg',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    BloodPressureReadingModel,
    BloodPressureReadingModel,
    QAfterFilterCondition
  >
  systolicMmHgLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'systolicMmHg',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    BloodPressureReadingModel,
    BloodPressureReadingModel,
    QAfterFilterCondition
  >
  systolicMmHgBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'systolicMmHg',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension BloodPressureReadingModelQueryObject
    on
        QueryBuilder<
          BloodPressureReadingModel,
          BloodPressureReadingModel,
          QFilterCondition
        > {}

extension BloodPressureReadingModelQueryLinks
    on
        QueryBuilder<
          BloodPressureReadingModel,
          BloodPressureReadingModel,
          QFilterCondition
        > {}

extension BloodPressureReadingModelQuerySortBy
    on
        QueryBuilder<
          BloodPressureReadingModel,
          BloodPressureReadingModel,
          QSortBy
        > {
  QueryBuilder<
    BloodPressureReadingModel,
    BloodPressureReadingModel,
    QAfterSortBy
  >
  sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<
    BloodPressureReadingModel,
    BloodPressureReadingModel,
    QAfterSortBy
  >
  sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<
    BloodPressureReadingModel,
    BloodPressureReadingModel,
    QAfterSortBy
  >
  sortByDiastolicMmHg() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'diastolicMmHg', Sort.asc);
    });
  }

  QueryBuilder<
    BloodPressureReadingModel,
    BloodPressureReadingModel,
    QAfterSortBy
  >
  sortByDiastolicMmHgDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'diastolicMmHg', Sort.desc);
    });
  }

  QueryBuilder<
    BloodPressureReadingModel,
    BloodPressureReadingModel,
    QAfterSortBy
  >
  sortByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<
    BloodPressureReadingModel,
    BloodPressureReadingModel,
    QAfterSortBy
  >
  sortByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<
    BloodPressureReadingModel,
    BloodPressureReadingModel,
    QAfterSortBy
  >
  sortBySystolicMmHg() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'systolicMmHg', Sort.asc);
    });
  }

  QueryBuilder<
    BloodPressureReadingModel,
    BloodPressureReadingModel,
    QAfterSortBy
  >
  sortBySystolicMmHgDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'systolicMmHg', Sort.desc);
    });
  }
}

extension BloodPressureReadingModelQuerySortThenBy
    on
        QueryBuilder<
          BloodPressureReadingModel,
          BloodPressureReadingModel,
          QSortThenBy
        > {
  QueryBuilder<
    BloodPressureReadingModel,
    BloodPressureReadingModel,
    QAfterSortBy
  >
  thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<
    BloodPressureReadingModel,
    BloodPressureReadingModel,
    QAfterSortBy
  >
  thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<
    BloodPressureReadingModel,
    BloodPressureReadingModel,
    QAfterSortBy
  >
  thenByDiastolicMmHg() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'diastolicMmHg', Sort.asc);
    });
  }

  QueryBuilder<
    BloodPressureReadingModel,
    BloodPressureReadingModel,
    QAfterSortBy
  >
  thenByDiastolicMmHgDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'diastolicMmHg', Sort.desc);
    });
  }

  QueryBuilder<
    BloodPressureReadingModel,
    BloodPressureReadingModel,
    QAfterSortBy
  >
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<
    BloodPressureReadingModel,
    BloodPressureReadingModel,
    QAfterSortBy
  >
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<
    BloodPressureReadingModel,
    BloodPressureReadingModel,
    QAfterSortBy
  >
  thenByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<
    BloodPressureReadingModel,
    BloodPressureReadingModel,
    QAfterSortBy
  >
  thenByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<
    BloodPressureReadingModel,
    BloodPressureReadingModel,
    QAfterSortBy
  >
  thenBySystolicMmHg() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'systolicMmHg', Sort.asc);
    });
  }

  QueryBuilder<
    BloodPressureReadingModel,
    BloodPressureReadingModel,
    QAfterSortBy
  >
  thenBySystolicMmHgDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'systolicMmHg', Sort.desc);
    });
  }
}

extension BloodPressureReadingModelQueryWhereDistinct
    on
        QueryBuilder<
          BloodPressureReadingModel,
          BloodPressureReadingModel,
          QDistinct
        > {
  QueryBuilder<BloodPressureReadingModel, BloodPressureReadingModel, QDistinct>
  distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<BloodPressureReadingModel, BloodPressureReadingModel, QDistinct>
  distinctByDiastolicMmHg() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'diastolicMmHg');
    });
  }

  QueryBuilder<BloodPressureReadingModel, BloodPressureReadingModel, QDistinct>
  distinctByNotes({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notes', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BloodPressureReadingModel, BloodPressureReadingModel, QDistinct>
  distinctBySystolicMmHg() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'systolicMmHg');
    });
  }
}

extension BloodPressureReadingModelQueryProperty
    on
        QueryBuilder<
          BloodPressureReadingModel,
          BloodPressureReadingModel,
          QQueryProperty
        > {
  QueryBuilder<BloodPressureReadingModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<BloodPressureReadingModel, DateTime, QQueryOperations>
  createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<BloodPressureReadingModel, int, QQueryOperations>
  diastolicMmHgProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'diastolicMmHg');
    });
  }

  QueryBuilder<BloodPressureReadingModel, String?, QQueryOperations>
  notesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notes');
    });
  }

  QueryBuilder<BloodPressureReadingModel, int, QQueryOperations>
  systolicMmHgProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'systolicMmHg');
    });
  }
}
