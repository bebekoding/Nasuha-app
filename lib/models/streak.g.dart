// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'streak.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetStreakCollection on Isar {
  IsarCollection<Streak> get streaks => this.collection();
}

const StreakSchema = CollectionSchema(
  name: r'Streak',
  id: 2927724474768415338,
  properties: {
    r'current': PropertySchema(
      id: 0,
      name: r'current',
      type: IsarType.long,
    ),
    r'key': PropertySchema(
      id: 1,
      name: r'key',
      type: IsarType.string,
    ),
    r'lastDateKey': PropertySchema(
      id: 2,
      name: r'lastDateKey',
      type: IsarType.string,
    ),
    r'longest': PropertySchema(
      id: 3,
      name: r'longest',
      type: IsarType.long,
    )
  },
  estimateSize: _streakEstimateSize,
  serialize: _streakSerialize,
  deserialize: _streakDeserialize,
  deserializeProp: _streakDeserializeProp,
  idName: r'id',
  indexes: {
    r'key': IndexSchema(
      id: -4906094122524121629,
      name: r'key',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'key',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _streakGetId,
  getLinks: _streakGetLinks,
  attach: _streakAttach,
  version: '3.1.0+1',
);

int _streakEstimateSize(
  Streak object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.key.length * 3;
  bytesCount += 3 + object.lastDateKey.length * 3;
  return bytesCount;
}

void _streakSerialize(
  Streak object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.current);
  writer.writeString(offsets[1], object.key);
  writer.writeString(offsets[2], object.lastDateKey);
  writer.writeLong(offsets[3], object.longest);
}

Streak _streakDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Streak();
  object.current = reader.readLong(offsets[0]);
  object.id = id;
  object.key = reader.readString(offsets[1]);
  object.lastDateKey = reader.readString(offsets[2]);
  object.longest = reader.readLong(offsets[3]);
  return object;
}

P _streakDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _streakGetId(Streak object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _streakGetLinks(Streak object) {
  return [];
}

void _streakAttach(IsarCollection<dynamic> col, Id id, Streak object) {
  object.id = id;
}

extension StreakByIndex on IsarCollection<Streak> {
  Future<Streak?> getByKey(String key) {
    return getByIndex(r'key', [key]);
  }

  Streak? getByKeySync(String key) {
    return getByIndexSync(r'key', [key]);
  }

  Future<bool> deleteByKey(String key) {
    return deleteByIndex(r'key', [key]);
  }

  bool deleteByKeySync(String key) {
    return deleteByIndexSync(r'key', [key]);
  }

  Future<List<Streak?>> getAllByKey(List<String> keyValues) {
    final values = keyValues.map((e) => [e]).toList();
    return getAllByIndex(r'key', values);
  }

  List<Streak?> getAllByKeySync(List<String> keyValues) {
    final values = keyValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'key', values);
  }

  Future<int> deleteAllByKey(List<String> keyValues) {
    final values = keyValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'key', values);
  }

  int deleteAllByKeySync(List<String> keyValues) {
    final values = keyValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'key', values);
  }

  Future<Id> putByKey(Streak object) {
    return putByIndex(r'key', object);
  }

  Id putByKeySync(Streak object, {bool saveLinks = true}) {
    return putByIndexSync(r'key', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByKey(List<Streak> objects) {
    return putAllByIndex(r'key', objects);
  }

  List<Id> putAllByKeySync(List<Streak> objects, {bool saveLinks = true}) {
    return putAllByIndexSync(r'key', objects, saveLinks: saveLinks);
  }
}

extension StreakQueryWhereSort on QueryBuilder<Streak, Streak, QWhere> {
  QueryBuilder<Streak, Streak, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension StreakQueryWhere on QueryBuilder<Streak, Streak, QWhereClause> {
  QueryBuilder<Streak, Streak, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Streak, Streak, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Streak, Streak, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Streak, Streak, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Streak, Streak, QAfterWhereClause> idBetween(
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

  QueryBuilder<Streak, Streak, QAfterWhereClause> keyEqualTo(String key) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'key',
        value: [key],
      ));
    });
  }

  QueryBuilder<Streak, Streak, QAfterWhereClause> keyNotEqualTo(String key) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'key',
              lower: [],
              upper: [key],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'key',
              lower: [key],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'key',
              lower: [key],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'key',
              lower: [],
              upper: [key],
              includeUpper: false,
            ));
      }
    });
  }
}

extension StreakQueryFilter on QueryBuilder<Streak, Streak, QFilterCondition> {
  QueryBuilder<Streak, Streak, QAfterFilterCondition> currentEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'current',
        value: value,
      ));
    });
  }

  QueryBuilder<Streak, Streak, QAfterFilterCondition> currentGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'current',
        value: value,
      ));
    });
  }

  QueryBuilder<Streak, Streak, QAfterFilterCondition> currentLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'current',
        value: value,
      ));
    });
  }

  QueryBuilder<Streak, Streak, QAfterFilterCondition> currentBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'current',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Streak, Streak, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Streak, Streak, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Streak, Streak, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Streak, Streak, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Streak, Streak, QAfterFilterCondition> keyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'key',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Streak, Streak, QAfterFilterCondition> keyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'key',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Streak, Streak, QAfterFilterCondition> keyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'key',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Streak, Streak, QAfterFilterCondition> keyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'key',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Streak, Streak, QAfterFilterCondition> keyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'key',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Streak, Streak, QAfterFilterCondition> keyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'key',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Streak, Streak, QAfterFilterCondition> keyContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'key',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Streak, Streak, QAfterFilterCondition> keyMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'key',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Streak, Streak, QAfterFilterCondition> keyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'key',
        value: '',
      ));
    });
  }

  QueryBuilder<Streak, Streak, QAfterFilterCondition> keyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'key',
        value: '',
      ));
    });
  }

  QueryBuilder<Streak, Streak, QAfterFilterCondition> lastDateKeyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastDateKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Streak, Streak, QAfterFilterCondition> lastDateKeyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastDateKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Streak, Streak, QAfterFilterCondition> lastDateKeyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastDateKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Streak, Streak, QAfterFilterCondition> lastDateKeyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastDateKey',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Streak, Streak, QAfterFilterCondition> lastDateKeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'lastDateKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Streak, Streak, QAfterFilterCondition> lastDateKeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'lastDateKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Streak, Streak, QAfterFilterCondition> lastDateKeyContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lastDateKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Streak, Streak, QAfterFilterCondition> lastDateKeyMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lastDateKey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Streak, Streak, QAfterFilterCondition> lastDateKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastDateKey',
        value: '',
      ));
    });
  }

  QueryBuilder<Streak, Streak, QAfterFilterCondition> lastDateKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lastDateKey',
        value: '',
      ));
    });
  }

  QueryBuilder<Streak, Streak, QAfterFilterCondition> longestEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'longest',
        value: value,
      ));
    });
  }

  QueryBuilder<Streak, Streak, QAfterFilterCondition> longestGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'longest',
        value: value,
      ));
    });
  }

  QueryBuilder<Streak, Streak, QAfterFilterCondition> longestLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'longest',
        value: value,
      ));
    });
  }

  QueryBuilder<Streak, Streak, QAfterFilterCondition> longestBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'longest',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension StreakQueryObject on QueryBuilder<Streak, Streak, QFilterCondition> {}

extension StreakQueryLinks on QueryBuilder<Streak, Streak, QFilterCondition> {}

extension StreakQuerySortBy on QueryBuilder<Streak, Streak, QSortBy> {
  QueryBuilder<Streak, Streak, QAfterSortBy> sortByCurrent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'current', Sort.asc);
    });
  }

  QueryBuilder<Streak, Streak, QAfterSortBy> sortByCurrentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'current', Sort.desc);
    });
  }

  QueryBuilder<Streak, Streak, QAfterSortBy> sortByKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.asc);
    });
  }

  QueryBuilder<Streak, Streak, QAfterSortBy> sortByKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.desc);
    });
  }

  QueryBuilder<Streak, Streak, QAfterSortBy> sortByLastDateKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastDateKey', Sort.asc);
    });
  }

  QueryBuilder<Streak, Streak, QAfterSortBy> sortByLastDateKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastDateKey', Sort.desc);
    });
  }

  QueryBuilder<Streak, Streak, QAfterSortBy> sortByLongest() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longest', Sort.asc);
    });
  }

  QueryBuilder<Streak, Streak, QAfterSortBy> sortByLongestDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longest', Sort.desc);
    });
  }
}

extension StreakQuerySortThenBy on QueryBuilder<Streak, Streak, QSortThenBy> {
  QueryBuilder<Streak, Streak, QAfterSortBy> thenByCurrent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'current', Sort.asc);
    });
  }

  QueryBuilder<Streak, Streak, QAfterSortBy> thenByCurrentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'current', Sort.desc);
    });
  }

  QueryBuilder<Streak, Streak, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Streak, Streak, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Streak, Streak, QAfterSortBy> thenByKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.asc);
    });
  }

  QueryBuilder<Streak, Streak, QAfterSortBy> thenByKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.desc);
    });
  }

  QueryBuilder<Streak, Streak, QAfterSortBy> thenByLastDateKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastDateKey', Sort.asc);
    });
  }

  QueryBuilder<Streak, Streak, QAfterSortBy> thenByLastDateKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastDateKey', Sort.desc);
    });
  }

  QueryBuilder<Streak, Streak, QAfterSortBy> thenByLongest() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longest', Sort.asc);
    });
  }

  QueryBuilder<Streak, Streak, QAfterSortBy> thenByLongestDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longest', Sort.desc);
    });
  }
}

extension StreakQueryWhereDistinct on QueryBuilder<Streak, Streak, QDistinct> {
  QueryBuilder<Streak, Streak, QDistinct> distinctByCurrent() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'current');
    });
  }

  QueryBuilder<Streak, Streak, QDistinct> distinctByKey(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'key', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Streak, Streak, QDistinct> distinctByLastDateKey(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastDateKey', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Streak, Streak, QDistinct> distinctByLongest() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'longest');
    });
  }
}

extension StreakQueryProperty on QueryBuilder<Streak, Streak, QQueryProperty> {
  QueryBuilder<Streak, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Streak, int, QQueryOperations> currentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'current');
    });
  }

  QueryBuilder<Streak, String, QQueryOperations> keyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'key');
    });
  }

  QueryBuilder<Streak, String, QQueryOperations> lastDateKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastDateKey');
    });
  }

  QueryBuilder<Streak, int, QQueryOperations> longestProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'longest');
    });
  }
}
