// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'glucose_reading_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetGlucoseReadingModelCollection on Isar {
  IsarCollection<GlucoseReadingModel> get glucoseReadingModels =>
      this.collection();
}

const GlucoseReadingModelSchema = CollectionSchema(
  name: r'GlucoseReadingModel',
  id: 5465275309291115831,
  properties: {
    r'createdAt': PropertySchema(
      id: 0,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'mealContext': PropertySchema(
      id: 1,
      name: r'mealContext',
      type: IsarType.string,
    ),
    r'notes': PropertySchema(id: 2, name: r'notes', type: IsarType.string),
    r'readingMgDl': PropertySchema(
      id: 3,
      name: r'readingMgDl',
      type: IsarType.long,
    ),
  },

  estimateSize: _glucoseReadingModelEstimateSize,
  serialize: _glucoseReadingModelSerialize,
  deserialize: _glucoseReadingModelDeserialize,
  deserializeProp: _glucoseReadingModelDeserializeProp,
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

  getId: _glucoseReadingModelGetId,
  getLinks: _glucoseReadingModelGetLinks,
  attach: _glucoseReadingModelAttach,
  version: '3.3.2',
);

int _glucoseReadingModelEstimateSize(
  GlucoseReadingModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.mealContext.length * 3;
  {
    final value = object.notes;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _glucoseReadingModelSerialize(
  GlucoseReadingModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeString(offsets[1], object.mealContext);
  writer.writeString(offsets[2], object.notes);
  writer.writeLong(offsets[3], object.readingMgDl);
}

GlucoseReadingModel _glucoseReadingModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = GlucoseReadingModel();
  object.createdAt = reader.readDateTime(offsets[0]);
  object.id = id;
  object.mealContext = reader.readString(offsets[1]);
  object.notes = reader.readStringOrNull(offsets[2]);
  object.readingMgDl = reader.readLong(offsets[3]);
  return object;
}

P _glucoseReadingModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _glucoseReadingModelGetId(GlucoseReadingModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _glucoseReadingModelGetLinks(
  GlucoseReadingModel object,
) {
  return [];
}

void _glucoseReadingModelAttach(
  IsarCollection<dynamic> col,
  Id id,
  GlucoseReadingModel object,
) {
  object.id = id;
}

extension GlucoseReadingModelQueryWhereSort
    on QueryBuilder<GlucoseReadingModel, GlucoseReadingModel, QWhere> {
  QueryBuilder<GlucoseReadingModel, GlucoseReadingModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<GlucoseReadingModel, GlucoseReadingModel, QAfterWhere>
  anyCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'createdAt'),
      );
    });
  }
}

extension GlucoseReadingModelQueryWhere
    on QueryBuilder<GlucoseReadingModel, GlucoseReadingModel, QWhereClause> {
  QueryBuilder<GlucoseReadingModel, GlucoseReadingModel, QAfterWhereClause>
  idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<GlucoseReadingModel, GlucoseReadingModel, QAfterWhereClause>
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

  QueryBuilder<GlucoseReadingModel, GlucoseReadingModel, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<GlucoseReadingModel, GlucoseReadingModel, QAfterWhereClause>
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<GlucoseReadingModel, GlucoseReadingModel, QAfterWhereClause>
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

  QueryBuilder<GlucoseReadingModel, GlucoseReadingModel, QAfterWhereClause>
  createdAtEqualTo(DateTime createdAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'createdAt', value: [createdAt]),
      );
    });
  }

  QueryBuilder<GlucoseReadingModel, GlucoseReadingModel, QAfterWhereClause>
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

  QueryBuilder<GlucoseReadingModel, GlucoseReadingModel, QAfterWhereClause>
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

  QueryBuilder<GlucoseReadingModel, GlucoseReadingModel, QAfterWhereClause>
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

  QueryBuilder<GlucoseReadingModel, GlucoseReadingModel, QAfterWhereClause>
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

extension GlucoseReadingModelQueryFilter
    on
        QueryBuilder<
          GlucoseReadingModel,
          GlucoseReadingModel,
          QFilterCondition
        > {
  QueryBuilder<GlucoseReadingModel, GlucoseReadingModel, QAfterFilterCondition>
  createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'createdAt', value: value),
      );
    });
  }

  QueryBuilder<GlucoseReadingModel, GlucoseReadingModel, QAfterFilterCondition>
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

  QueryBuilder<GlucoseReadingModel, GlucoseReadingModel, QAfterFilterCondition>
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

  QueryBuilder<GlucoseReadingModel, GlucoseReadingModel, QAfterFilterCondition>
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

  QueryBuilder<GlucoseReadingModel, GlucoseReadingModel, QAfterFilterCondition>
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<GlucoseReadingModel, GlucoseReadingModel, QAfterFilterCondition>
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

  QueryBuilder<GlucoseReadingModel, GlucoseReadingModel, QAfterFilterCondition>
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

  QueryBuilder<GlucoseReadingModel, GlucoseReadingModel, QAfterFilterCondition>
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

  QueryBuilder<GlucoseReadingModel, GlucoseReadingModel, QAfterFilterCondition>
  mealContextEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'mealContext',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<GlucoseReadingModel, GlucoseReadingModel, QAfterFilterCondition>
  mealContextGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'mealContext',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<GlucoseReadingModel, GlucoseReadingModel, QAfterFilterCondition>
  mealContextLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'mealContext',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<GlucoseReadingModel, GlucoseReadingModel, QAfterFilterCondition>
  mealContextBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'mealContext',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<GlucoseReadingModel, GlucoseReadingModel, QAfterFilterCondition>
  mealContextStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'mealContext',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<GlucoseReadingModel, GlucoseReadingModel, QAfterFilterCondition>
  mealContextEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'mealContext',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<GlucoseReadingModel, GlucoseReadingModel, QAfterFilterCondition>
  mealContextContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'mealContext',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<GlucoseReadingModel, GlucoseReadingModel, QAfterFilterCondition>
  mealContextMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'mealContext',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<GlucoseReadingModel, GlucoseReadingModel, QAfterFilterCondition>
  mealContextIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'mealContext', value: ''),
      );
    });
  }

  QueryBuilder<GlucoseReadingModel, GlucoseReadingModel, QAfterFilterCondition>
  mealContextIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'mealContext', value: ''),
      );
    });
  }

  QueryBuilder<GlucoseReadingModel, GlucoseReadingModel, QAfterFilterCondition>
  notesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'notes'),
      );
    });
  }

  QueryBuilder<GlucoseReadingModel, GlucoseReadingModel, QAfterFilterCondition>
  notesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'notes'),
      );
    });
  }

  QueryBuilder<GlucoseReadingModel, GlucoseReadingModel, QAfterFilterCondition>
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

  QueryBuilder<GlucoseReadingModel, GlucoseReadingModel, QAfterFilterCondition>
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

  QueryBuilder<GlucoseReadingModel, GlucoseReadingModel, QAfterFilterCondition>
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

  QueryBuilder<GlucoseReadingModel, GlucoseReadingModel, QAfterFilterCondition>
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

  QueryBuilder<GlucoseReadingModel, GlucoseReadingModel, QAfterFilterCondition>
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

  QueryBuilder<GlucoseReadingModel, GlucoseReadingModel, QAfterFilterCondition>
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

  QueryBuilder<GlucoseReadingModel, GlucoseReadingModel, QAfterFilterCondition>
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

  QueryBuilder<GlucoseReadingModel, GlucoseReadingModel, QAfterFilterCondition>
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

  QueryBuilder<GlucoseReadingModel, GlucoseReadingModel, QAfterFilterCondition>
  notesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'notes', value: ''),
      );
    });
  }

  QueryBuilder<GlucoseReadingModel, GlucoseReadingModel, QAfterFilterCondition>
  notesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'notes', value: ''),
      );
    });
  }

  QueryBuilder<GlucoseReadingModel, GlucoseReadingModel, QAfterFilterCondition>
  readingMgDlEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'readingMgDl', value: value),
      );
    });
  }

  QueryBuilder<GlucoseReadingModel, GlucoseReadingModel, QAfterFilterCondition>
  readingMgDlGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'readingMgDl',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<GlucoseReadingModel, GlucoseReadingModel, QAfterFilterCondition>
  readingMgDlLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'readingMgDl',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<GlucoseReadingModel, GlucoseReadingModel, QAfterFilterCondition>
  readingMgDlBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'readingMgDl',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension GlucoseReadingModelQueryObject
    on
        QueryBuilder<
          GlucoseReadingModel,
          GlucoseReadingModel,
          QFilterCondition
        > {}

extension GlucoseReadingModelQueryLinks
    on
        QueryBuilder<
          GlucoseReadingModel,
          GlucoseReadingModel,
          QFilterCondition
        > {}

extension GlucoseReadingModelQuerySortBy
    on QueryBuilder<GlucoseReadingModel, GlucoseReadingModel, QSortBy> {
  QueryBuilder<GlucoseReadingModel, GlucoseReadingModel, QAfterSortBy>
  sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<GlucoseReadingModel, GlucoseReadingModel, QAfterSortBy>
  sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<GlucoseReadingModel, GlucoseReadingModel, QAfterSortBy>
  sortByMealContext() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mealContext', Sort.asc);
    });
  }

  QueryBuilder<GlucoseReadingModel, GlucoseReadingModel, QAfterSortBy>
  sortByMealContextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mealContext', Sort.desc);
    });
  }

  QueryBuilder<GlucoseReadingModel, GlucoseReadingModel, QAfterSortBy>
  sortByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<GlucoseReadingModel, GlucoseReadingModel, QAfterSortBy>
  sortByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<GlucoseReadingModel, GlucoseReadingModel, QAfterSortBy>
  sortByReadingMgDl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'readingMgDl', Sort.asc);
    });
  }

  QueryBuilder<GlucoseReadingModel, GlucoseReadingModel, QAfterSortBy>
  sortByReadingMgDlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'readingMgDl', Sort.desc);
    });
  }
}

extension GlucoseReadingModelQuerySortThenBy
    on QueryBuilder<GlucoseReadingModel, GlucoseReadingModel, QSortThenBy> {
  QueryBuilder<GlucoseReadingModel, GlucoseReadingModel, QAfterSortBy>
  thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<GlucoseReadingModel, GlucoseReadingModel, QAfterSortBy>
  thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<GlucoseReadingModel, GlucoseReadingModel, QAfterSortBy>
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<GlucoseReadingModel, GlucoseReadingModel, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<GlucoseReadingModel, GlucoseReadingModel, QAfterSortBy>
  thenByMealContext() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mealContext', Sort.asc);
    });
  }

  QueryBuilder<GlucoseReadingModel, GlucoseReadingModel, QAfterSortBy>
  thenByMealContextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mealContext', Sort.desc);
    });
  }

  QueryBuilder<GlucoseReadingModel, GlucoseReadingModel, QAfterSortBy>
  thenByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<GlucoseReadingModel, GlucoseReadingModel, QAfterSortBy>
  thenByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<GlucoseReadingModel, GlucoseReadingModel, QAfterSortBy>
  thenByReadingMgDl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'readingMgDl', Sort.asc);
    });
  }

  QueryBuilder<GlucoseReadingModel, GlucoseReadingModel, QAfterSortBy>
  thenByReadingMgDlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'readingMgDl', Sort.desc);
    });
  }
}

extension GlucoseReadingModelQueryWhereDistinct
    on QueryBuilder<GlucoseReadingModel, GlucoseReadingModel, QDistinct> {
  QueryBuilder<GlucoseReadingModel, GlucoseReadingModel, QDistinct>
  distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<GlucoseReadingModel, GlucoseReadingModel, QDistinct>
  distinctByMealContext({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mealContext', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<GlucoseReadingModel, GlucoseReadingModel, QDistinct>
  distinctByNotes({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notes', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<GlucoseReadingModel, GlucoseReadingModel, QDistinct>
  distinctByReadingMgDl() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'readingMgDl');
    });
  }
}

extension GlucoseReadingModelQueryProperty
    on QueryBuilder<GlucoseReadingModel, GlucoseReadingModel, QQueryProperty> {
  QueryBuilder<GlucoseReadingModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<GlucoseReadingModel, DateTime, QQueryOperations>
  createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<GlucoseReadingModel, String, QQueryOperations>
  mealContextProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mealContext');
    });
  }

  QueryBuilder<GlucoseReadingModel, String?, QQueryOperations> notesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notes');
    });
  }

  QueryBuilder<GlucoseReadingModel, int, QQueryOperations>
  readingMgDlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'readingMgDl');
    });
  }
}
