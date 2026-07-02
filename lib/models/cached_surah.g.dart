// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cached_surah.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCachedSurahCollection on Isar {
  IsarCollection<CachedSurah> get cachedSurahs => this.collection();
}

const CachedSurahSchema = CollectionSchema(
  name: r'CachedSurah',
  id: 2673127845435961211,
  properties: {
    r'nameArabic': PropertySchema(
      id: 0,
      name: r'nameArabic',
      type: IsarType.string,
    ),
    r'nameLatin': PropertySchema(
      id: 1,
      name: r'nameLatin',
      type: IsarType.string,
    ),
    r'nameTranslation': PropertySchema(
      id: 2,
      name: r'nameTranslation',
      type: IsarType.string,
    ),
    r'number': PropertySchema(
      id: 3,
      name: r'number',
      type: IsarType.long,
    ),
    r'revelation': PropertySchema(
      id: 4,
      name: r'revelation',
      type: IsarType.string,
    ),
    r'verseCount': PropertySchema(
      id: 5,
      name: r'verseCount',
      type: IsarType.long,
    ),
    r'versesJson': PropertySchema(
      id: 6,
      name: r'versesJson',
      type: IsarType.string,
    )
  },
  estimateSize: _cachedSurahEstimateSize,
  serialize: _cachedSurahSerialize,
  deserialize: _cachedSurahDeserialize,
  deserializeProp: _cachedSurahDeserializeProp,
  idName: r'id',
  indexes: {
    r'number': IndexSchema(
      id: 5012388430481709372,
      name: r'number',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'number',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _cachedSurahGetId,
  getLinks: _cachedSurahGetLinks,
  attach: _cachedSurahAttach,
  version: '3.1.0+1',
);

int _cachedSurahEstimateSize(
  CachedSurah object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.nameArabic.length * 3;
  bytesCount += 3 + object.nameLatin.length * 3;
  bytesCount += 3 + object.nameTranslation.length * 3;
  bytesCount += 3 + object.revelation.length * 3;
  bytesCount += 3 + object.versesJson.length * 3;
  return bytesCount;
}

void _cachedSurahSerialize(
  CachedSurah object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.nameArabic);
  writer.writeString(offsets[1], object.nameLatin);
  writer.writeString(offsets[2], object.nameTranslation);
  writer.writeLong(offsets[3], object.number);
  writer.writeString(offsets[4], object.revelation);
  writer.writeLong(offsets[5], object.verseCount);
  writer.writeString(offsets[6], object.versesJson);
}

CachedSurah _cachedSurahDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CachedSurah();
  object.id = id;
  object.nameArabic = reader.readString(offsets[0]);
  object.nameLatin = reader.readString(offsets[1]);
  object.nameTranslation = reader.readString(offsets[2]);
  object.number = reader.readLong(offsets[3]);
  object.revelation = reader.readString(offsets[4]);
  object.verseCount = reader.readLong(offsets[5]);
  object.versesJson = reader.readString(offsets[6]);
  return object;
}

P _cachedSurahDeserializeProp<P>(
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
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
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

Id _cachedSurahGetId(CachedSurah object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _cachedSurahGetLinks(CachedSurah object) {
  return [];
}

void _cachedSurahAttach(
    IsarCollection<dynamic> col, Id id, CachedSurah object) {
  object.id = id;
}

extension CachedSurahByIndex on IsarCollection<CachedSurah> {
  Future<CachedSurah?> getByNumber(int number) {
    return getByIndex(r'number', [number]);
  }

  CachedSurah? getByNumberSync(int number) {
    return getByIndexSync(r'number', [number]);
  }

  Future<bool> deleteByNumber(int number) {
    return deleteByIndex(r'number', [number]);
  }

  bool deleteByNumberSync(int number) {
    return deleteByIndexSync(r'number', [number]);
  }

  Future<List<CachedSurah?>> getAllByNumber(List<int> numberValues) {
    final values = numberValues.map((e) => [e]).toList();
    return getAllByIndex(r'number', values);
  }

  List<CachedSurah?> getAllByNumberSync(List<int> numberValues) {
    final values = numberValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'number', values);
  }

  Future<int> deleteAllByNumber(List<int> numberValues) {
    final values = numberValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'number', values);
  }

  int deleteAllByNumberSync(List<int> numberValues) {
    final values = numberValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'number', values);
  }

  Future<Id> putByNumber(CachedSurah object) {
    return putByIndex(r'number', object);
  }

  Id putByNumberSync(CachedSurah object, {bool saveLinks = true}) {
    return putByIndexSync(r'number', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByNumber(List<CachedSurah> objects) {
    return putAllByIndex(r'number', objects);
  }

  List<Id> putAllByNumberSync(List<CachedSurah> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'number', objects, saveLinks: saveLinks);
  }
}

extension CachedSurahQueryWhereSort
    on QueryBuilder<CachedSurah, CachedSurah, QWhere> {
  QueryBuilder<CachedSurah, CachedSurah, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<CachedSurah, CachedSurah, QAfterWhere> anyNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'number'),
      );
    });
  }
}

extension CachedSurahQueryWhere
    on QueryBuilder<CachedSurah, CachedSurah, QWhereClause> {
  QueryBuilder<CachedSurah, CachedSurah, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<CachedSurah, CachedSurah, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<CachedSurah, CachedSurah, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<CachedSurah, CachedSurah, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<CachedSurah, CachedSurah, QAfterWhereClause> idBetween(
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

  QueryBuilder<CachedSurah, CachedSurah, QAfterWhereClause> numberEqualTo(
      int number) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'number',
        value: [number],
      ));
    });
  }

  QueryBuilder<CachedSurah, CachedSurah, QAfterWhereClause> numberNotEqualTo(
      int number) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'number',
              lower: [],
              upper: [number],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'number',
              lower: [number],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'number',
              lower: [number],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'number',
              lower: [],
              upper: [number],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<CachedSurah, CachedSurah, QAfterWhereClause> numberGreaterThan(
    int number, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'number',
        lower: [number],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<CachedSurah, CachedSurah, QAfterWhereClause> numberLessThan(
    int number, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'number',
        lower: [],
        upper: [number],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<CachedSurah, CachedSurah, QAfterWhereClause> numberBetween(
    int lowerNumber,
    int upperNumber, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'number',
        lower: [lowerNumber],
        includeLower: includeLower,
        upper: [upperNumber],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension CachedSurahQueryFilter
    on QueryBuilder<CachedSurah, CachedSurah, QFilterCondition> {
  QueryBuilder<CachedSurah, CachedSurah, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CachedSurah, CachedSurah, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<CachedSurah, CachedSurah, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<CachedSurah, CachedSurah, QAfterFilterCondition> idBetween(
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

  QueryBuilder<CachedSurah, CachedSurah, QAfterFilterCondition>
      nameArabicEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nameArabic',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSurah, CachedSurah, QAfterFilterCondition>
      nameArabicGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'nameArabic',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSurah, CachedSurah, QAfterFilterCondition>
      nameArabicLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'nameArabic',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSurah, CachedSurah, QAfterFilterCondition>
      nameArabicBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'nameArabic',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSurah, CachedSurah, QAfterFilterCondition>
      nameArabicStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'nameArabic',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSurah, CachedSurah, QAfterFilterCondition>
      nameArabicEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'nameArabic',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSurah, CachedSurah, QAfterFilterCondition>
      nameArabicContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'nameArabic',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSurah, CachedSurah, QAfterFilterCondition>
      nameArabicMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'nameArabic',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSurah, CachedSurah, QAfterFilterCondition>
      nameArabicIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nameArabic',
        value: '',
      ));
    });
  }

  QueryBuilder<CachedSurah, CachedSurah, QAfterFilterCondition>
      nameArabicIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'nameArabic',
        value: '',
      ));
    });
  }

  QueryBuilder<CachedSurah, CachedSurah, QAfterFilterCondition>
      nameLatinEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nameLatin',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSurah, CachedSurah, QAfterFilterCondition>
      nameLatinGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'nameLatin',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSurah, CachedSurah, QAfterFilterCondition>
      nameLatinLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'nameLatin',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSurah, CachedSurah, QAfterFilterCondition>
      nameLatinBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'nameLatin',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSurah, CachedSurah, QAfterFilterCondition>
      nameLatinStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'nameLatin',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSurah, CachedSurah, QAfterFilterCondition>
      nameLatinEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'nameLatin',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSurah, CachedSurah, QAfterFilterCondition>
      nameLatinContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'nameLatin',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSurah, CachedSurah, QAfterFilterCondition>
      nameLatinMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'nameLatin',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSurah, CachedSurah, QAfterFilterCondition>
      nameLatinIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nameLatin',
        value: '',
      ));
    });
  }

  QueryBuilder<CachedSurah, CachedSurah, QAfterFilterCondition>
      nameLatinIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'nameLatin',
        value: '',
      ));
    });
  }

  QueryBuilder<CachedSurah, CachedSurah, QAfterFilterCondition>
      nameTranslationEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nameTranslation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSurah, CachedSurah, QAfterFilterCondition>
      nameTranslationGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'nameTranslation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSurah, CachedSurah, QAfterFilterCondition>
      nameTranslationLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'nameTranslation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSurah, CachedSurah, QAfterFilterCondition>
      nameTranslationBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'nameTranslation',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSurah, CachedSurah, QAfterFilterCondition>
      nameTranslationStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'nameTranslation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSurah, CachedSurah, QAfterFilterCondition>
      nameTranslationEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'nameTranslation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSurah, CachedSurah, QAfterFilterCondition>
      nameTranslationContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'nameTranslation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSurah, CachedSurah, QAfterFilterCondition>
      nameTranslationMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'nameTranslation',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSurah, CachedSurah, QAfterFilterCondition>
      nameTranslationIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nameTranslation',
        value: '',
      ));
    });
  }

  QueryBuilder<CachedSurah, CachedSurah, QAfterFilterCondition>
      nameTranslationIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'nameTranslation',
        value: '',
      ));
    });
  }

  QueryBuilder<CachedSurah, CachedSurah, QAfterFilterCondition> numberEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'number',
        value: value,
      ));
    });
  }

  QueryBuilder<CachedSurah, CachedSurah, QAfterFilterCondition>
      numberGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'number',
        value: value,
      ));
    });
  }

  QueryBuilder<CachedSurah, CachedSurah, QAfterFilterCondition> numberLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'number',
        value: value,
      ));
    });
  }

  QueryBuilder<CachedSurah, CachedSurah, QAfterFilterCondition> numberBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'number',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CachedSurah, CachedSurah, QAfterFilterCondition>
      revelationEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'revelation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSurah, CachedSurah, QAfterFilterCondition>
      revelationGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'revelation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSurah, CachedSurah, QAfterFilterCondition>
      revelationLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'revelation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSurah, CachedSurah, QAfterFilterCondition>
      revelationBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'revelation',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSurah, CachedSurah, QAfterFilterCondition>
      revelationStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'revelation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSurah, CachedSurah, QAfterFilterCondition>
      revelationEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'revelation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSurah, CachedSurah, QAfterFilterCondition>
      revelationContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'revelation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSurah, CachedSurah, QAfterFilterCondition>
      revelationMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'revelation',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSurah, CachedSurah, QAfterFilterCondition>
      revelationIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'revelation',
        value: '',
      ));
    });
  }

  QueryBuilder<CachedSurah, CachedSurah, QAfterFilterCondition>
      revelationIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'revelation',
        value: '',
      ));
    });
  }

  QueryBuilder<CachedSurah, CachedSurah, QAfterFilterCondition>
      verseCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'verseCount',
        value: value,
      ));
    });
  }

  QueryBuilder<CachedSurah, CachedSurah, QAfterFilterCondition>
      verseCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'verseCount',
        value: value,
      ));
    });
  }

  QueryBuilder<CachedSurah, CachedSurah, QAfterFilterCondition>
      verseCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'verseCount',
        value: value,
      ));
    });
  }

  QueryBuilder<CachedSurah, CachedSurah, QAfterFilterCondition>
      verseCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'verseCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CachedSurah, CachedSurah, QAfterFilterCondition>
      versesJsonEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'versesJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSurah, CachedSurah, QAfterFilterCondition>
      versesJsonGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'versesJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSurah, CachedSurah, QAfterFilterCondition>
      versesJsonLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'versesJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSurah, CachedSurah, QAfterFilterCondition>
      versesJsonBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'versesJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSurah, CachedSurah, QAfterFilterCondition>
      versesJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'versesJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSurah, CachedSurah, QAfterFilterCondition>
      versesJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'versesJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSurah, CachedSurah, QAfterFilterCondition>
      versesJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'versesJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSurah, CachedSurah, QAfterFilterCondition>
      versesJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'versesJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CachedSurah, CachedSurah, QAfterFilterCondition>
      versesJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'versesJson',
        value: '',
      ));
    });
  }

  QueryBuilder<CachedSurah, CachedSurah, QAfterFilterCondition>
      versesJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'versesJson',
        value: '',
      ));
    });
  }
}

extension CachedSurahQueryObject
    on QueryBuilder<CachedSurah, CachedSurah, QFilterCondition> {}

extension CachedSurahQueryLinks
    on QueryBuilder<CachedSurah, CachedSurah, QFilterCondition> {}

extension CachedSurahQuerySortBy
    on QueryBuilder<CachedSurah, CachedSurah, QSortBy> {
  QueryBuilder<CachedSurah, CachedSurah, QAfterSortBy> sortByNameArabic() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameArabic', Sort.asc);
    });
  }

  QueryBuilder<CachedSurah, CachedSurah, QAfterSortBy> sortByNameArabicDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameArabic', Sort.desc);
    });
  }

  QueryBuilder<CachedSurah, CachedSurah, QAfterSortBy> sortByNameLatin() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameLatin', Sort.asc);
    });
  }

  QueryBuilder<CachedSurah, CachedSurah, QAfterSortBy> sortByNameLatinDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameLatin', Sort.desc);
    });
  }

  QueryBuilder<CachedSurah, CachedSurah, QAfterSortBy> sortByNameTranslation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameTranslation', Sort.asc);
    });
  }

  QueryBuilder<CachedSurah, CachedSurah, QAfterSortBy>
      sortByNameTranslationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameTranslation', Sort.desc);
    });
  }

  QueryBuilder<CachedSurah, CachedSurah, QAfterSortBy> sortByNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'number', Sort.asc);
    });
  }

  QueryBuilder<CachedSurah, CachedSurah, QAfterSortBy> sortByNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'number', Sort.desc);
    });
  }

  QueryBuilder<CachedSurah, CachedSurah, QAfterSortBy> sortByRevelation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'revelation', Sort.asc);
    });
  }

  QueryBuilder<CachedSurah, CachedSurah, QAfterSortBy> sortByRevelationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'revelation', Sort.desc);
    });
  }

  QueryBuilder<CachedSurah, CachedSurah, QAfterSortBy> sortByVerseCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verseCount', Sort.asc);
    });
  }

  QueryBuilder<CachedSurah, CachedSurah, QAfterSortBy> sortByVerseCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verseCount', Sort.desc);
    });
  }

  QueryBuilder<CachedSurah, CachedSurah, QAfterSortBy> sortByVersesJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'versesJson', Sort.asc);
    });
  }

  QueryBuilder<CachedSurah, CachedSurah, QAfterSortBy> sortByVersesJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'versesJson', Sort.desc);
    });
  }
}

extension CachedSurahQuerySortThenBy
    on QueryBuilder<CachedSurah, CachedSurah, QSortThenBy> {
  QueryBuilder<CachedSurah, CachedSurah, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<CachedSurah, CachedSurah, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<CachedSurah, CachedSurah, QAfterSortBy> thenByNameArabic() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameArabic', Sort.asc);
    });
  }

  QueryBuilder<CachedSurah, CachedSurah, QAfterSortBy> thenByNameArabicDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameArabic', Sort.desc);
    });
  }

  QueryBuilder<CachedSurah, CachedSurah, QAfterSortBy> thenByNameLatin() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameLatin', Sort.asc);
    });
  }

  QueryBuilder<CachedSurah, CachedSurah, QAfterSortBy> thenByNameLatinDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameLatin', Sort.desc);
    });
  }

  QueryBuilder<CachedSurah, CachedSurah, QAfterSortBy> thenByNameTranslation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameTranslation', Sort.asc);
    });
  }

  QueryBuilder<CachedSurah, CachedSurah, QAfterSortBy>
      thenByNameTranslationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nameTranslation', Sort.desc);
    });
  }

  QueryBuilder<CachedSurah, CachedSurah, QAfterSortBy> thenByNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'number', Sort.asc);
    });
  }

  QueryBuilder<CachedSurah, CachedSurah, QAfterSortBy> thenByNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'number', Sort.desc);
    });
  }

  QueryBuilder<CachedSurah, CachedSurah, QAfterSortBy> thenByRevelation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'revelation', Sort.asc);
    });
  }

  QueryBuilder<CachedSurah, CachedSurah, QAfterSortBy> thenByRevelationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'revelation', Sort.desc);
    });
  }

  QueryBuilder<CachedSurah, CachedSurah, QAfterSortBy> thenByVerseCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verseCount', Sort.asc);
    });
  }

  QueryBuilder<CachedSurah, CachedSurah, QAfterSortBy> thenByVerseCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verseCount', Sort.desc);
    });
  }

  QueryBuilder<CachedSurah, CachedSurah, QAfterSortBy> thenByVersesJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'versesJson', Sort.asc);
    });
  }

  QueryBuilder<CachedSurah, CachedSurah, QAfterSortBy> thenByVersesJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'versesJson', Sort.desc);
    });
  }
}

extension CachedSurahQueryWhereDistinct
    on QueryBuilder<CachedSurah, CachedSurah, QDistinct> {
  QueryBuilder<CachedSurah, CachedSurah, QDistinct> distinctByNameArabic(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nameArabic', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CachedSurah, CachedSurah, QDistinct> distinctByNameLatin(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nameLatin', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CachedSurah, CachedSurah, QDistinct> distinctByNameTranslation(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nameTranslation',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CachedSurah, CachedSurah, QDistinct> distinctByNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'number');
    });
  }

  QueryBuilder<CachedSurah, CachedSurah, QDistinct> distinctByRevelation(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'revelation', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CachedSurah, CachedSurah, QDistinct> distinctByVerseCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'verseCount');
    });
  }

  QueryBuilder<CachedSurah, CachedSurah, QDistinct> distinctByVersesJson(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'versesJson', caseSensitive: caseSensitive);
    });
  }
}

extension CachedSurahQueryProperty
    on QueryBuilder<CachedSurah, CachedSurah, QQueryProperty> {
  QueryBuilder<CachedSurah, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<CachedSurah, String, QQueryOperations> nameArabicProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nameArabic');
    });
  }

  QueryBuilder<CachedSurah, String, QQueryOperations> nameLatinProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nameLatin');
    });
  }

  QueryBuilder<CachedSurah, String, QQueryOperations>
      nameTranslationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nameTranslation');
    });
  }

  QueryBuilder<CachedSurah, int, QQueryOperations> numberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'number');
    });
  }

  QueryBuilder<CachedSurah, String, QQueryOperations> revelationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'revelation');
    });
  }

  QueryBuilder<CachedSurah, int, QQueryOperations> verseCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'verseCount');
    });
  }

  QueryBuilder<CachedSurah, String, QQueryOperations> versesJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'versesJson');
    });
  }
}
