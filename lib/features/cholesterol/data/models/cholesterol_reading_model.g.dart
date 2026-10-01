// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cholesterol_reading_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCholesterolReadingModelCollection on Isar {
  IsarCollection<CholesterolReadingModel> get cholesterolReadingModels =>
      this.collection();
}

const CholesterolReadingModelSchema = CollectionSchema(
  name: r'CholesterolReadingModel',
  id: -4337268413125351979,
  properties: {
    r'createdAt': PropertySchema(
      id: 0,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'hdlMgDl': PropertySchema(id: 1, name: r'hdlMgDl', type: IsarType.long),
    r'ldlMgDl': PropertySchema(id: 2, name: r'ldlMgDl', type: IsarType.long),
    r'notes': PropertySchema(id: 3, name: r'notes', type: IsarType.string),
    r'totalMgDl': PropertySchema(
      id: 4,
      name: r'totalMgDl',
      type: IsarType.long,
    ),
  },

  estimateSize: _cholesterolReadingModelEstimateSize,
  serialize: _cholesterolReadingModelSerialize,
  deserialize: _cholesterolReadingModelDeserialize,
  deserializeProp: _cholesterolReadingModelDeserializeProp,
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

  getId: _cholesterolReadingModelGetId,
  getLinks: _cholesterolReadingModelGetLinks,
  attach: _cholesterolReadingModelAttach,
  version: '3.3.2',
);

int _cholesterolReadingModelEstimateSize(
  CholesterolReadingModel object,
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

void _cholesterolReadingModelSerialize(
  CholesterolReadingModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeLong(offsets[1], object.hdlMgDl);
  writer.writeLong(offsets[2], object.ldlMgDl);
  writer.writeString(offsets[3], object.notes);
  writer.writeLong(offsets[4], object.totalMgDl);
}

CholesterolReadingModel _cholesterolReadingModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CholesterolReadingModel();
  object.createdAt = reader.readDateTime(offsets[0]);
  object.hdlMgDl = reader.readLong(offsets[1]);
  object.id = id;
  object.ldlMgDl = reader.readLong(offsets[2]);
  object.notes = reader.readStringOrNull(offsets[3]);
  object.totalMgDl = reader.readLong(offsets[4]);
  return object;
}

P _cholesterolReadingModelDeserializeProp<P>(
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
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _cholesterolReadingModelGetId(CholesterolReadingModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _cholesterolReadingModelGetLinks(
  CholesterolReadingModel object,
) {
  return [];
}

void _cholesterolReadingModelAttach(
  IsarCollection<dynamic> col,
  Id id,
  CholesterolReadingModel object,
) {
  object.id = id;
}

extension CholesterolReadingModelQueryWhereSort
    on QueryBuilder<CholesterolReadingModel, CholesterolReadingModel, QWhere> {
  QueryBuilder<CholesterolReadingModel, CholesterolReadingModel, QAfterWhere>
  anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<CholesterolReadingModel, CholesterolReadingModel, QAfterWhere>
  anyCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'createdAt'),
      );
    });
  }
}

extension CholesterolReadingModelQueryWhere
    on
        QueryBuilder<
          CholesterolReadingModel,
          CholesterolReadingModel,
          QWhereClause
        > {
  QueryBuilder<
    CholesterolReadingModel,
    CholesterolReadingModel,
    QAfterWhereClause
  >
  idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<
    CholesterolReadingModel,
    CholesterolReadingModel,
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
    CholesterolReadingModel,
    CholesterolReadingModel,
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
    CholesterolReadingModel,
    CholesterolReadingModel,
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
    CholesterolReadingModel,
    CholesterolReadingModel,
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
    CholesterolReadingModel,
    CholesterolReadingModel,
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
    CholesterolReadingModel,
    CholesterolReadingModel,
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
    CholesterolReadingModel,
    CholesterolReadingModel,
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
    CholesterolReadingModel,
    CholesterolReadingModel,
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
    CholesterolReadingModel,
    CholesterolReadingModel,
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

extension CholesterolReadingModelQueryFilter
    on
        QueryBuilder<
          CholesterolReadingModel,
          CholesterolReadingModel,
          QFilterCondition
        > {
  QueryBuilder<
    CholesterolReadingModel,
    CholesterolReadingModel,
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
    CholesterolReadingModel,
    CholesterolReadingModel,
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
    CholesterolReadingModel,
    CholesterolReadingModel,
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
    CholesterolReadingModel,
    CholesterolReadingModel,
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
    CholesterolReadingModel,
    CholesterolReadingModel,
    QAfterFilterCondition
  >
  hdlMgDlEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'hdlMgDl', value: value),
      );
    });
  }

  QueryBuilder<
    CholesterolReadingModel,
    CholesterolReadingModel,
    QAfterFilterCondition
  >
  hdlMgDlGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'hdlMgDl',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    CholesterolReadingModel,
    CholesterolReadingModel,
    QAfterFilterCondition
  >
  hdlMgDlLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'hdlMgDl',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    CholesterolReadingModel,
    CholesterolReadingModel,
    QAfterFilterCondition
  >
  hdlMgDlBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'hdlMgDl',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    CholesterolReadingModel,
    CholesterolReadingModel,
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
    CholesterolReadingModel,
    CholesterolReadingModel,
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
    CholesterolReadingModel,
    CholesterolReadingModel,
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
    CholesterolReadingModel,
    CholesterolReadingModel,
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
    CholesterolReadingModel,
    CholesterolReadingModel,
    QAfterFilterCondition
  >
  ldlMgDlEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'ldlMgDl', value: value),
      );
    });
  }

  QueryBuilder<
    CholesterolReadingModel,
    CholesterolReadingModel,
    QAfterFilterCondition
  >
  ldlMgDlGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'ldlMgDl',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    CholesterolReadingModel,
    CholesterolReadingModel,
    QAfterFilterCondition
  >
  ldlMgDlLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'ldlMgDl',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    CholesterolReadingModel,
    CholesterolReadingModel,
    QAfterFilterCondition
  >
  ldlMgDlBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'ldlMgDl',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    CholesterolReadingModel,
    CholesterolReadingModel,
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
    CholesterolReadingModel,
    CholesterolReadingModel,
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
    CholesterolReadingModel,
    CholesterolReadingModel,
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
    CholesterolReadingModel,
    CholesterolReadingModel,
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
    CholesterolReadingModel,
    CholesterolReadingModel,
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
    CholesterolReadingModel,
    CholesterolReadingModel,
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
    CholesterolReadingModel,
    CholesterolReadingModel,
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
    CholesterolReadingModel,
    CholesterolReadingModel,
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
    CholesterolReadingModel,
    CholesterolReadingModel,
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
    CholesterolReadingModel,
    CholesterolReadingModel,
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
    CholesterolReadingModel,
    CholesterolReadingModel,
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
    CholesterolReadingModel,
    CholesterolReadingModel,
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
    CholesterolReadingModel,
    CholesterolReadingModel,
    QAfterFilterCondition
  >
  totalMgDlEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'totalMgDl', value: value),
      );
    });
  }

  QueryBuilder<
    CholesterolReadingModel,
    CholesterolReadingModel,
    QAfterFilterCondition
  >
  totalMgDlGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'totalMgDl',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    CholesterolReadingModel,
    CholesterolReadingModel,
    QAfterFilterCondition
  >
  totalMgDlLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'totalMgDl',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    CholesterolReadingModel,
    CholesterolReadingModel,
    QAfterFilterCondition
  >
  totalMgDlBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'totalMgDl',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension CholesterolReadingModelQueryObject
    on
        QueryBuilder<
          CholesterolReadingModel,
          CholesterolReadingModel,
          QFilterCondition
        > {}

extension CholesterolReadingModelQueryLinks
    on
        QueryBuilder<
          CholesterolReadingModel,
          CholesterolReadingModel,
          QFilterCondition
        > {}

extension CholesterolReadingModelQuerySortBy
    on QueryBuilder<CholesterolReadingModel, CholesterolReadingModel, QSortBy> {
  QueryBuilder<CholesterolReadingModel, CholesterolReadingModel, QAfterSortBy>
  sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<CholesterolReadingModel, CholesterolReadingModel, QAfterSortBy>
  sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<CholesterolReadingModel, CholesterolReadingModel, QAfterSortBy>
  sortByHdlMgDl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hdlMgDl', Sort.asc);
    });
  }

  QueryBuilder<CholesterolReadingModel, CholesterolReadingModel, QAfterSortBy>
  sortByHdlMgDlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hdlMgDl', Sort.desc);
    });
  }

  QueryBuilder<CholesterolReadingModel, CholesterolReadingModel, QAfterSortBy>
  sortByLdlMgDl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ldlMgDl', Sort.asc);
    });
  }

  QueryBuilder<CholesterolReadingModel, CholesterolReadingModel, QAfterSortBy>
  sortByLdlMgDlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ldlMgDl', Sort.desc);
    });
  }

  QueryBuilder<CholesterolReadingModel, CholesterolReadingModel, QAfterSortBy>
  sortByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<CholesterolReadingModel, CholesterolReadingModel, QAfterSortBy>
  sortByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<CholesterolReadingModel, CholesterolReadingModel, QAfterSortBy>
  sortByTotalMgDl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalMgDl', Sort.asc);
    });
  }

  QueryBuilder<CholesterolReadingModel, CholesterolReadingModel, QAfterSortBy>
  sortByTotalMgDlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalMgDl', Sort.desc);
    });
  }
}

extension CholesterolReadingModelQuerySortThenBy
    on
        QueryBuilder<
          CholesterolReadingModel,
          CholesterolReadingModel,
          QSortThenBy
        > {
  QueryBuilder<CholesterolReadingModel, CholesterolReadingModel, QAfterSortBy>
  thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<CholesterolReadingModel, CholesterolReadingModel, QAfterSortBy>
  thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<CholesterolReadingModel, CholesterolReadingModel, QAfterSortBy>
  thenByHdlMgDl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hdlMgDl', Sort.asc);
    });
  }

  QueryBuilder<CholesterolReadingModel, CholesterolReadingModel, QAfterSortBy>
  thenByHdlMgDlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hdlMgDl', Sort.desc);
    });
  }

  QueryBuilder<CholesterolReadingModel, CholesterolReadingModel, QAfterSortBy>
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<CholesterolReadingModel, CholesterolReadingModel, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<CholesterolReadingModel, CholesterolReadingModel, QAfterSortBy>
  thenByLdlMgDl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ldlMgDl', Sort.asc);
    });
  }

  QueryBuilder<CholesterolReadingModel, CholesterolReadingModel, QAfterSortBy>
  thenByLdlMgDlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ldlMgDl', Sort.desc);
    });
  }

  QueryBuilder<CholesterolReadingModel, CholesterolReadingModel, QAfterSortBy>
  thenByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<CholesterolReadingModel, CholesterolReadingModel, QAfterSortBy>
  thenByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<CholesterolReadingModel, CholesterolReadingModel, QAfterSortBy>
  thenByTotalMgDl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalMgDl', Sort.asc);
    });
  }

  QueryBuilder<CholesterolReadingModel, CholesterolReadingModel, QAfterSortBy>
  thenByTotalMgDlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalMgDl', Sort.desc);
    });
  }
}

extension CholesterolReadingModelQueryWhereDistinct
    on
        QueryBuilder<
          CholesterolReadingModel,
          CholesterolReadingModel,
          QDistinct
        > {
  QueryBuilder<CholesterolReadingModel, CholesterolReadingModel, QDistinct>
  distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<CholesterolReadingModel, CholesterolReadingModel, QDistinct>
  distinctByHdlMgDl() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hdlMgDl');
    });
  }

  QueryBuilder<CholesterolReadingModel, CholesterolReadingModel, QDistinct>
  distinctByLdlMgDl() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ldlMgDl');
    });
  }

  QueryBuilder<CholesterolReadingModel, CholesterolReadingModel, QDistinct>
  distinctByNotes({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notes', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CholesterolReadingModel, CholesterolReadingModel, QDistinct>
  distinctByTotalMgDl() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalMgDl');
    });
  }
}

extension CholesterolReadingModelQueryProperty
    on
        QueryBuilder<
          CholesterolReadingModel,
          CholesterolReadingModel,
          QQueryProperty
        > {
  QueryBuilder<CholesterolReadingModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<CholesterolReadingModel, DateTime, QQueryOperations>
  createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<CholesterolReadingModel, int, QQueryOperations>
  hdlMgDlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hdlMgDl');
    });
  }

  QueryBuilder<CholesterolReadingModel, int, QQueryOperations>
  ldlMgDlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ldlMgDl');
    });
  }

  QueryBuilder<CholesterolReadingModel, String?, QQueryOperations>
  notesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notes');
    });
  }

  QueryBuilder<CholesterolReadingModel, int, QQueryOperations>
  totalMgDlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalMgDl');
    });
  }
}
