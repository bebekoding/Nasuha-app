// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $QuranBookmarksTable extends QuranBookmarks
    with TableInfo<$QuranBookmarksTable, QuranBookmark> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuranBookmarksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _surahNumberMeta = const VerificationMeta(
    'surahNumber',
  );
  @override
  late final GeneratedColumn<int> surahNumber = GeneratedColumn<int>(
    'surah_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _verseNumberMeta = const VerificationMeta(
    'verseNumber',
  );
  @override
  late final GeneratedColumn<int> verseNumber = GeneratedColumn<int>(
    'verse_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _surahNameMeta = const VerificationMeta(
    'surahName',
  );
  @override
  late final GeneratedColumn<String> surahName = GeneratedColumn<String>(
    'surah_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isLastReadMeta = const VerificationMeta(
    'isLastRead',
  );
  @override
  late final GeneratedColumn<bool> isLastRead = GeneratedColumn<bool>(
    'is_last_read',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_last_read" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    surahNumber,
    verseNumber,
    surahName,
    note,
    createdAt,
    isLastRead,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'quran_bookmarks';
  @override
  VerificationContext validateIntegrity(
    Insertable<QuranBookmark> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('surah_number')) {
      context.handle(
        _surahNumberMeta,
        surahNumber.isAcceptableOrUnknown(
          data['surah_number']!,
          _surahNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_surahNumberMeta);
    }
    if (data.containsKey('verse_number')) {
      context.handle(
        _verseNumberMeta,
        verseNumber.isAcceptableOrUnknown(
          data['verse_number']!,
          _verseNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_verseNumberMeta);
    }
    if (data.containsKey('surah_name')) {
      context.handle(
        _surahNameMeta,
        surahName.isAcceptableOrUnknown(data['surah_name']!, _surahNameMeta),
      );
    } else if (isInserting) {
      context.missing(_surahNameMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('is_last_read')) {
      context.handle(
        _isLastReadMeta,
        isLastRead.isAcceptableOrUnknown(
          data['is_last_read']!,
          _isLastReadMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  QuranBookmark map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuranBookmark(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      surahNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}surah_number'],
      )!,
      verseNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}verse_number'],
      )!,
      surahName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}surah_name'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      isLastRead: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_last_read'],
      )!,
    );
  }

  @override
  $QuranBookmarksTable createAlias(String alias) {
    return $QuranBookmarksTable(attachedDatabase, alias);
  }
}

class QuranBookmark extends DataClass implements Insertable<QuranBookmark> {
  final int id;
  final int surahNumber;
  final int verseNumber;
  final String surahName;
  final String? note;
  final DateTime createdAt;
  final bool isLastRead;
  const QuranBookmark({
    required this.id,
    required this.surahNumber,
    required this.verseNumber,
    required this.surahName,
    this.note,
    required this.createdAt,
    required this.isLastRead,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['surah_number'] = Variable<int>(surahNumber);
    map['verse_number'] = Variable<int>(verseNumber);
    map['surah_name'] = Variable<String>(surahName);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['is_last_read'] = Variable<bool>(isLastRead);
    return map;
  }

  QuranBookmarksCompanion toCompanion(bool nullToAbsent) {
    return QuranBookmarksCompanion(
      id: Value(id),
      surahNumber: Value(surahNumber),
      verseNumber: Value(verseNumber),
      surahName: Value(surahName),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      createdAt: Value(createdAt),
      isLastRead: Value(isLastRead),
    );
  }

  factory QuranBookmark.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuranBookmark(
      id: serializer.fromJson<int>(json['id']),
      surahNumber: serializer.fromJson<int>(json['surahNumber']),
      verseNumber: serializer.fromJson<int>(json['verseNumber']),
      surahName: serializer.fromJson<String>(json['surahName']),
      note: serializer.fromJson<String?>(json['note']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      isLastRead: serializer.fromJson<bool>(json['isLastRead']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'surahNumber': serializer.toJson<int>(surahNumber),
      'verseNumber': serializer.toJson<int>(verseNumber),
      'surahName': serializer.toJson<String>(surahName),
      'note': serializer.toJson<String?>(note),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'isLastRead': serializer.toJson<bool>(isLastRead),
    };
  }

  QuranBookmark copyWith({
    int? id,
    int? surahNumber,
    int? verseNumber,
    String? surahName,
    Value<String?> note = const Value.absent(),
    DateTime? createdAt,
    bool? isLastRead,
  }) => QuranBookmark(
    id: id ?? this.id,
    surahNumber: surahNumber ?? this.surahNumber,
    verseNumber: verseNumber ?? this.verseNumber,
    surahName: surahName ?? this.surahName,
    note: note.present ? note.value : this.note,
    createdAt: createdAt ?? this.createdAt,
    isLastRead: isLastRead ?? this.isLastRead,
  );
  QuranBookmark copyWithCompanion(QuranBookmarksCompanion data) {
    return QuranBookmark(
      id: data.id.present ? data.id.value : this.id,
      surahNumber: data.surahNumber.present
          ? data.surahNumber.value
          : this.surahNumber,
      verseNumber: data.verseNumber.present
          ? data.verseNumber.value
          : this.verseNumber,
      surahName: data.surahName.present ? data.surahName.value : this.surahName,
      note: data.note.present ? data.note.value : this.note,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      isLastRead: data.isLastRead.present
          ? data.isLastRead.value
          : this.isLastRead,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QuranBookmark(')
          ..write('id: $id, ')
          ..write('surahNumber: $surahNumber, ')
          ..write('verseNumber: $verseNumber, ')
          ..write('surahName: $surahName, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt, ')
          ..write('isLastRead: $isLastRead')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    surahNumber,
    verseNumber,
    surahName,
    note,
    createdAt,
    isLastRead,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuranBookmark &&
          other.id == this.id &&
          other.surahNumber == this.surahNumber &&
          other.verseNumber == this.verseNumber &&
          other.surahName == this.surahName &&
          other.note == this.note &&
          other.createdAt == this.createdAt &&
          other.isLastRead == this.isLastRead);
}

class QuranBookmarksCompanion extends UpdateCompanion<QuranBookmark> {
  final Value<int> id;
  final Value<int> surahNumber;
  final Value<int> verseNumber;
  final Value<String> surahName;
  final Value<String?> note;
  final Value<DateTime> createdAt;
  final Value<bool> isLastRead;
  const QuranBookmarksCompanion({
    this.id = const Value.absent(),
    this.surahNumber = const Value.absent(),
    this.verseNumber = const Value.absent(),
    this.surahName = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isLastRead = const Value.absent(),
  });
  QuranBookmarksCompanion.insert({
    this.id = const Value.absent(),
    required int surahNumber,
    required int verseNumber,
    required String surahName,
    this.note = const Value.absent(),
    required DateTime createdAt,
    this.isLastRead = const Value.absent(),
  }) : surahNumber = Value(surahNumber),
       verseNumber = Value(verseNumber),
       surahName = Value(surahName),
       createdAt = Value(createdAt);
  static Insertable<QuranBookmark> custom({
    Expression<int>? id,
    Expression<int>? surahNumber,
    Expression<int>? verseNumber,
    Expression<String>? surahName,
    Expression<String>? note,
    Expression<DateTime>? createdAt,
    Expression<bool>? isLastRead,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (surahNumber != null) 'surah_number': surahNumber,
      if (verseNumber != null) 'verse_number': verseNumber,
      if (surahName != null) 'surah_name': surahName,
      if (note != null) 'note': note,
      if (createdAt != null) 'created_at': createdAt,
      if (isLastRead != null) 'is_last_read': isLastRead,
    });
  }

  QuranBookmarksCompanion copyWith({
    Value<int>? id,
    Value<int>? surahNumber,
    Value<int>? verseNumber,
    Value<String>? surahName,
    Value<String?>? note,
    Value<DateTime>? createdAt,
    Value<bool>? isLastRead,
  }) {
    return QuranBookmarksCompanion(
      id: id ?? this.id,
      surahNumber: surahNumber ?? this.surahNumber,
      verseNumber: verseNumber ?? this.verseNumber,
      surahName: surahName ?? this.surahName,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      isLastRead: isLastRead ?? this.isLastRead,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (surahNumber.present) {
      map['surah_number'] = Variable<int>(surahNumber.value);
    }
    if (verseNumber.present) {
      map['verse_number'] = Variable<int>(verseNumber.value);
    }
    if (surahName.present) {
      map['surah_name'] = Variable<String>(surahName.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (isLastRead.present) {
      map['is_last_read'] = Variable<bool>(isLastRead.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuranBookmarksCompanion(')
          ..write('id: $id, ')
          ..write('surahNumber: $surahNumber, ')
          ..write('verseNumber: $verseNumber, ')
          ..write('surahName: $surahName, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt, ')
          ..write('isLastRead: $isLastRead')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $QuranBookmarksTable quranBookmarks = $QuranBookmarksTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [quranBookmarks];
}

typedef $$QuranBookmarksTableCreateCompanionBuilder =
    QuranBookmarksCompanion Function({
      Value<int> id,
      required int surahNumber,
      required int verseNumber,
      required String surahName,
      Value<String?> note,
      required DateTime createdAt,
      Value<bool> isLastRead,
    });
typedef $$QuranBookmarksTableUpdateCompanionBuilder =
    QuranBookmarksCompanion Function({
      Value<int> id,
      Value<int> surahNumber,
      Value<int> verseNumber,
      Value<String> surahName,
      Value<String?> note,
      Value<DateTime> createdAt,
      Value<bool> isLastRead,
    });

class $$QuranBookmarksTableFilterComposer
    extends Composer<_$AppDatabase, $QuranBookmarksTable> {
  $$QuranBookmarksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get surahNumber => $composableBuilder(
    column: $table.surahNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get verseNumber => $composableBuilder(
    column: $table.verseNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get surahName => $composableBuilder(
    column: $table.surahName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isLastRead => $composableBuilder(
    column: $table.isLastRead,
    builder: (column) => ColumnFilters(column),
  );
}

class $$QuranBookmarksTableOrderingComposer
    extends Composer<_$AppDatabase, $QuranBookmarksTable> {
  $$QuranBookmarksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get surahNumber => $composableBuilder(
    column: $table.surahNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get verseNumber => $composableBuilder(
    column: $table.verseNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get surahName => $composableBuilder(
    column: $table.surahName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isLastRead => $composableBuilder(
    column: $table.isLastRead,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$QuranBookmarksTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuranBookmarksTable> {
  $$QuranBookmarksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get surahNumber => $composableBuilder(
    column: $table.surahNumber,
    builder: (column) => column,
  );

  GeneratedColumn<int> get verseNumber => $composableBuilder(
    column: $table.verseNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get surahName =>
      $composableBuilder(column: $table.surahName, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get isLastRead => $composableBuilder(
    column: $table.isLastRead,
    builder: (column) => column,
  );
}

class $$QuranBookmarksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $QuranBookmarksTable,
          QuranBookmark,
          $$QuranBookmarksTableFilterComposer,
          $$QuranBookmarksTableOrderingComposer,
          $$QuranBookmarksTableAnnotationComposer,
          $$QuranBookmarksTableCreateCompanionBuilder,
          $$QuranBookmarksTableUpdateCompanionBuilder,
          (
            QuranBookmark,
            BaseReferences<_$AppDatabase, $QuranBookmarksTable, QuranBookmark>,
          ),
          QuranBookmark,
          PrefetchHooks Function()
        > {
  $$QuranBookmarksTableTableManager(
    _$AppDatabase db,
    $QuranBookmarksTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuranBookmarksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuranBookmarksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuranBookmarksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> surahNumber = const Value.absent(),
                Value<int> verseNumber = const Value.absent(),
                Value<String> surahName = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> isLastRead = const Value.absent(),
              }) => QuranBookmarksCompanion(
                id: id,
                surahNumber: surahNumber,
                verseNumber: verseNumber,
                surahName: surahName,
                note: note,
                createdAt: createdAt,
                isLastRead: isLastRead,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int surahNumber,
                required int verseNumber,
                required String surahName,
                Value<String?> note = const Value.absent(),
                required DateTime createdAt,
                Value<bool> isLastRead = const Value.absent(),
              }) => QuranBookmarksCompanion.insert(
                id: id,
                surahNumber: surahNumber,
                verseNumber: verseNumber,
                surahName: surahName,
                note: note,
                createdAt: createdAt,
                isLastRead: isLastRead,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$QuranBookmarksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $QuranBookmarksTable,
      QuranBookmark,
      $$QuranBookmarksTableFilterComposer,
      $$QuranBookmarksTableOrderingComposer,
      $$QuranBookmarksTableAnnotationComposer,
      $$QuranBookmarksTableCreateCompanionBuilder,
      $$QuranBookmarksTableUpdateCompanionBuilder,
      (
        QuranBookmark,
        BaseReferences<_$AppDatabase, $QuranBookmarksTable, QuranBookmark>,
      ),
      QuranBookmark,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$QuranBookmarksTableTableManager get quranBookmarks =>
      $$QuranBookmarksTableTableManager(_db, _db.quranBookmarks);
}
