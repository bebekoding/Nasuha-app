// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'muhasabah_entry.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetMuhasabahEntryCollection on Isar {
  IsarCollection<MuhasabahEntry> get muhasabahEntrys => this.collection();
}

const MuhasabahEntrySchema = CollectionSchema(
  name: r'MuhasabahEntry',
  id: 8542025936871803352,
  properties: {
    r'createdAt': PropertySchema(
      id: 0,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'dateKey': PropertySchema(
      id: 1,
      name: r'dateKey',
      type: IsarType.string,
    ),
    r'kind': PropertySchema(
      id: 2,
      name: r'kind',
      type: IsarType.string,
      enumMap: _MuhasabahEntrykindEnumValueMap,
    ),
    r'note': PropertySchema(
      id: 3,
      name: r'note',
      type: IsarType.string,
    ),
    r'tagName': PropertySchema(
      id: 4,
      name: r'tagName',
      type: IsarType.string,
    ),
    r'tagScore': PropertySchema(
      id: 5,
      name: r'tagScore',
      type: IsarType.long,
    ),
    r'tagSlug': PropertySchema(
      id: 6,
      name: r'tagSlug',
      type: IsarType.string,
    )
  },
  estimateSize: _muhasabahEntryEstimateSize,
  serialize: _muhasabahEntrySerialize,
  deserialize: _muhasabahEntryDeserialize,
  deserializeProp: _muhasabahEntryDeserializeProp,
  idName: r'id',
  indexes: {
    r'dateKey': IndexSchema(
      id: 7975223786082927131,
      name: r'dateKey',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'dateKey',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _muhasabahEntryGetId,
  getLinks: _muhasabahEntryGetLinks,
  attach: _muhasabahEntryAttach,
  version: '3.1.0+1',
);

int _muhasabahEntryEstimateSize(
  MuhasabahEntry object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.dateKey.length * 3;
  bytesCount += 3 + object.kind.name.length * 3;
  {
    final value = object.note;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.tagName.length * 3;
  bytesCount += 3 + object.tagSlug.length * 3;
  return bytesCount;
}

void _muhasabahEntrySerialize(
  MuhasabahEntry object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeString(offsets[1], object.dateKey);
  writer.writeString(offsets[2], object.kind.name);
  writer.writeString(offsets[3], object.note);
  writer.writeString(offsets[4], object.tagName);
  writer.writeLong(offsets[5], object.tagScore);
  writer.writeString(offsets[6], object.tagSlug);
}

MuhasabahEntry _muhasabahEntryDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MuhasabahEntry();
  object.createdAt = reader.readDateTime(offsets[0]);
  object.dateKey = reader.readString(offsets[1]);
  object.id = id;
  object.kind =
      _MuhasabahEntrykindValueEnumMap[reader.readStringOrNull(offsets[2])] ??
          TagKind.positive;
  object.note = reader.readStringOrNull(offsets[3]);
  object.tagName = reader.readString(offsets[4]);
  object.tagScore = reader.readLong(offsets[5]);
  object.tagSlug = reader.readString(offsets[6]);
  return object;
}

P _muhasabahEntryDeserializeProp<P>(
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
      return (_MuhasabahEntrykindValueEnumMap[
              reader.readStringOrNull(offset)] ??
          TagKind.positive) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _MuhasabahEntrykindEnumValueMap = {
  r'positive': r'positive',
  r'negative': r'negative',
};
const _MuhasabahEntrykindValueEnumMap = {
  r'positive': TagKind.positive,
  r'negative': TagKind.negative,
};

Id _muhasabahEntryGetId(MuhasabahEntry object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _muhasabahEntryGetLinks(MuhasabahEntry object) {
  return [];
}

void _muhasabahEntryAttach(
    IsarCollection<dynamic> col, Id id, MuhasabahEntry object) {
  object.id = id;
}

extension MuhasabahEntryQueryWhereSort
    on QueryBuilder<MuhasabahEntry, MuhasabahEntry, QWhere> {
  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension MuhasabahEntryQueryWhere
    on QueryBuilder<MuhasabahEntry, MuhasabahEntry, QWhereClause> {
  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterWhereClause> idNotEqualTo(
      Id id) {
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

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterWhereClause>
      dateKeyEqualTo(String dateKey) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'dateKey',
        value: [dateKey],
      ));
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterWhereClause>
      dateKeyNotEqualTo(String dateKey) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'dateKey',
              lower: [],
              upper: [dateKey],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'dateKey',
              lower: [dateKey],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'dateKey',
              lower: [dateKey],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'dateKey',
              lower: [],
              upper: [dateKey],
              includeUpper: false,
            ));
      }
    });
  }
}

extension MuhasabahEntryQueryFilter
    on QueryBuilder<MuhasabahEntry, MuhasabahEntry, QFilterCondition> {
  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterFilterCondition>
      createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterFilterCondition>
      createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterFilterCondition>
      createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterFilterCondition>
      dateKeyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dateKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterFilterCondition>
      dateKeyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dateKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterFilterCondition>
      dateKeyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dateKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterFilterCondition>
      dateKeyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dateKey',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterFilterCondition>
      dateKeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'dateKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterFilterCondition>
      dateKeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'dateKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterFilterCondition>
      dateKeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'dateKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterFilterCondition>
      dateKeyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'dateKey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterFilterCondition>
      dateKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dateKey',
        value: '',
      ));
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterFilterCondition>
      dateKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'dateKey',
        value: '',
      ));
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterFilterCondition>
      kindEqualTo(
    TagKind value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'kind',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterFilterCondition>
      kindGreaterThan(
    TagKind value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'kind',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterFilterCondition>
      kindLessThan(
    TagKind value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'kind',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterFilterCondition>
      kindBetween(
    TagKind lower,
    TagKind upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'kind',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterFilterCondition>
      kindStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'kind',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterFilterCondition>
      kindEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'kind',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterFilterCondition>
      kindContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'kind',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterFilterCondition>
      kindMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'kind',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterFilterCondition>
      kindIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'kind',
        value: '',
      ));
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterFilterCondition>
      kindIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'kind',
        value: '',
      ));
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterFilterCondition>
      noteIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'note',
      ));
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterFilterCondition>
      noteIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'note',
      ));
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterFilterCondition>
      noteEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterFilterCondition>
      noteGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterFilterCondition>
      noteLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterFilterCondition>
      noteBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'note',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterFilterCondition>
      noteStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterFilterCondition>
      noteEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterFilterCondition>
      noteContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'note',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterFilterCondition>
      noteMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'note',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterFilterCondition>
      noteIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'note',
        value: '',
      ));
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterFilterCondition>
      noteIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'note',
        value: '',
      ));
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterFilterCondition>
      tagNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tagName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterFilterCondition>
      tagNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'tagName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterFilterCondition>
      tagNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'tagName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterFilterCondition>
      tagNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'tagName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterFilterCondition>
      tagNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'tagName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterFilterCondition>
      tagNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'tagName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterFilterCondition>
      tagNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'tagName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterFilterCondition>
      tagNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'tagName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterFilterCondition>
      tagNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tagName',
        value: '',
      ));
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterFilterCondition>
      tagNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'tagName',
        value: '',
      ));
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterFilterCondition>
      tagScoreEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tagScore',
        value: value,
      ));
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterFilterCondition>
      tagScoreGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'tagScore',
        value: value,
      ));
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterFilterCondition>
      tagScoreLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'tagScore',
        value: value,
      ));
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterFilterCondition>
      tagScoreBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'tagScore',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterFilterCondition>
      tagSlugEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tagSlug',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterFilterCondition>
      tagSlugGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'tagSlug',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterFilterCondition>
      tagSlugLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'tagSlug',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterFilterCondition>
      tagSlugBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'tagSlug',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterFilterCondition>
      tagSlugStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'tagSlug',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterFilterCondition>
      tagSlugEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'tagSlug',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterFilterCondition>
      tagSlugContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'tagSlug',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterFilterCondition>
      tagSlugMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'tagSlug',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterFilterCondition>
      tagSlugIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tagSlug',
        value: '',
      ));
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterFilterCondition>
      tagSlugIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'tagSlug',
        value: '',
      ));
    });
  }
}

extension MuhasabahEntryQueryObject
    on QueryBuilder<MuhasabahEntry, MuhasabahEntry, QFilterCondition> {}

extension MuhasabahEntryQueryLinks
    on QueryBuilder<MuhasabahEntry, MuhasabahEntry, QFilterCondition> {}

extension MuhasabahEntryQuerySortBy
    on QueryBuilder<MuhasabahEntry, MuhasabahEntry, QSortBy> {
  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterSortBy> sortByDateKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateKey', Sort.asc);
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterSortBy>
      sortByDateKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateKey', Sort.desc);
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterSortBy> sortByKind() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kind', Sort.asc);
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterSortBy> sortByKindDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kind', Sort.desc);
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterSortBy> sortByNote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.asc);
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterSortBy> sortByNoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.desc);
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterSortBy> sortByTagName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tagName', Sort.asc);
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterSortBy>
      sortByTagNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tagName', Sort.desc);
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterSortBy> sortByTagScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tagScore', Sort.asc);
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterSortBy>
      sortByTagScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tagScore', Sort.desc);
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterSortBy> sortByTagSlug() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tagSlug', Sort.asc);
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterSortBy>
      sortByTagSlugDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tagSlug', Sort.desc);
    });
  }
}

extension MuhasabahEntryQuerySortThenBy
    on QueryBuilder<MuhasabahEntry, MuhasabahEntry, QSortThenBy> {
  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterSortBy> thenByDateKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateKey', Sort.asc);
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterSortBy>
      thenByDateKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateKey', Sort.desc);
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterSortBy> thenByKind() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kind', Sort.asc);
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterSortBy> thenByKindDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'kind', Sort.desc);
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterSortBy> thenByNote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.asc);
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterSortBy> thenByNoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'note', Sort.desc);
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterSortBy> thenByTagName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tagName', Sort.asc);
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterSortBy>
      thenByTagNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tagName', Sort.desc);
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterSortBy> thenByTagScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tagScore', Sort.asc);
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterSortBy>
      thenByTagScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tagScore', Sort.desc);
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterSortBy> thenByTagSlug() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tagSlug', Sort.asc);
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QAfterSortBy>
      thenByTagSlugDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tagSlug', Sort.desc);
    });
  }
}

extension MuhasabahEntryQueryWhereDistinct
    on QueryBuilder<MuhasabahEntry, MuhasabahEntry, QDistinct> {
  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QDistinct> distinctByDateKey(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dateKey', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QDistinct> distinctByKind(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'kind', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QDistinct> distinctByNote(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'note', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QDistinct> distinctByTagName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tagName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QDistinct> distinctByTagScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tagScore');
    });
  }

  QueryBuilder<MuhasabahEntry, MuhasabahEntry, QDistinct> distinctByTagSlug(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tagSlug', caseSensitive: caseSensitive);
    });
  }
}

extension MuhasabahEntryQueryProperty
    on QueryBuilder<MuhasabahEntry, MuhasabahEntry, QQueryProperty> {
  QueryBuilder<MuhasabahEntry, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<MuhasabahEntry, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<MuhasabahEntry, String, QQueryOperations> dateKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dateKey');
    });
  }

  QueryBuilder<MuhasabahEntry, TagKind, QQueryOperations> kindProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'kind');
    });
  }

  QueryBuilder<MuhasabahEntry, String?, QQueryOperations> noteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'note');
    });
  }

  QueryBuilder<MuhasabahEntry, String, QQueryOperations> tagNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tagName');
    });
  }

  QueryBuilder<MuhasabahEntry, int, QQueryOperations> tagScoreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tagScore');
    });
  }

  QueryBuilder<MuhasabahEntry, String, QQueryOperations> tagSlugProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tagSlug');
    });
  }
}
