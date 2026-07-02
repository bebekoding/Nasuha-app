// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $QuranBookmarksTable extends QuranBookmarks
    with TableInfo<$QuranBookmarksTable, QuranBookmarkRow> {
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
    Insertable<QuranBookmarkRow> instance, {
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
  QuranBookmarkRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuranBookmarkRow(
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

class QuranBookmarkRow extends DataClass
    implements Insertable<QuranBookmarkRow> {
  final int id;
  final int surahNumber;
  final int verseNumber;
  final String surahName;
  final String? note;
  final DateTime createdAt;
  final bool isLastRead;
  const QuranBookmarkRow({
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

  factory QuranBookmarkRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuranBookmarkRow(
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

  QuranBookmarkRow copyWith({
    int? id,
    int? surahNumber,
    int? verseNumber,
    String? surahName,
    Value<String?> note = const Value.absent(),
    DateTime? createdAt,
    bool? isLastRead,
  }) => QuranBookmarkRow(
    id: id ?? this.id,
    surahNumber: surahNumber ?? this.surahNumber,
    verseNumber: verseNumber ?? this.verseNumber,
    surahName: surahName ?? this.surahName,
    note: note.present ? note.value : this.note,
    createdAt: createdAt ?? this.createdAt,
    isLastRead: isLastRead ?? this.isLastRead,
  );
  QuranBookmarkRow copyWithCompanion(QuranBookmarksCompanion data) {
    return QuranBookmarkRow(
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
    return (StringBuffer('QuranBookmarkRow(')
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
      (other is QuranBookmarkRow &&
          other.id == this.id &&
          other.surahNumber == this.surahNumber &&
          other.verseNumber == this.verseNumber &&
          other.surahName == this.surahName &&
          other.note == this.note &&
          other.createdAt == this.createdAt &&
          other.isLastRead == this.isLastRead);
}

class QuranBookmarksCompanion extends UpdateCompanion<QuranBookmarkRow> {
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
  static Insertable<QuranBookmarkRow> custom({
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

class $UserSettingsTableTable extends UserSettingsTable
    with TableInfo<$UserSettingsTableTable, UserSettingsRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserSettingsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _photoPathMeta = const VerificationMeta(
    'photoPath',
  );
  @override
  late final GeneratedColumn<String> photoPath = GeneratedColumn<String>(
    'photo_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cityMeta = const VerificationMeta('city');
  @override
  late final GeneratedColumn<String> city = GeneratedColumn<String>(
    'city',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastLatitudeMeta = const VerificationMeta(
    'lastLatitude',
  );
  @override
  late final GeneratedColumn<double> lastLatitude = GeneratedColumn<double>(
    'last_latitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastLongitudeMeta = const VerificationMeta(
    'lastLongitude',
  );
  @override
  late final GeneratedColumn<double> lastLongitude = GeneratedColumn<double>(
    'last_longitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _calculationMethodMeta = const VerificationMeta(
    'calculationMethod',
  );
  @override
  late final GeneratedColumn<String> calculationMethod =
      GeneratedColumn<String>(
        'calculation_method',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('muslimWorldLeague'),
      );
  static const VerificationMeta _adhanNotificationsMeta =
      const VerificationMeta('adhanNotifications');
  @override
  late final GeneratedColumn<bool> adhanNotifications = GeneratedColumn<bool>(
    'adhan_notifications',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("adhan_notifications" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _reminderNotificationsMeta =
      const VerificationMeta('reminderNotifications');
  @override
  late final GeneratedColumn<bool> reminderNotifications =
      GeneratedColumn<bool>(
        'reminder_notifications',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("reminder_notifications" IN (0, 1))',
        ),
        defaultValue: const Constant(true),
      );
  static const VerificationMeta _biometricLockMeta = const VerificationMeta(
    'biometricLock',
  );
  @override
  late final GeneratedColumn<bool> biometricLock = GeneratedColumn<bool>(
    'biometric_lock',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("biometric_lock" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _cloudSyncMeta = const VerificationMeta(
    'cloudSync',
  );
  @override
  late final GeneratedColumn<bool> cloudSync = GeneratedColumn<bool>(
    'cloud_sync',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("cloud_sync" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _lastSyncAtMeta = const VerificationMeta(
    'lastSyncAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSyncAt = GeneratedColumn<DateTime>(
    'last_sync_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    displayName,
    photoPath,
    city,
    lastLatitude,
    lastLongitude,
    calculationMethod,
    adhanNotifications,
    reminderNotifications,
    biometricLock,
    cloudSync,
    lastSyncAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserSettingsRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    }
    if (data.containsKey('photo_path')) {
      context.handle(
        _photoPathMeta,
        photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta),
      );
    }
    if (data.containsKey('city')) {
      context.handle(
        _cityMeta,
        city.isAcceptableOrUnknown(data['city']!, _cityMeta),
      );
    }
    if (data.containsKey('last_latitude')) {
      context.handle(
        _lastLatitudeMeta,
        lastLatitude.isAcceptableOrUnknown(
          data['last_latitude']!,
          _lastLatitudeMeta,
        ),
      );
    }
    if (data.containsKey('last_longitude')) {
      context.handle(
        _lastLongitudeMeta,
        lastLongitude.isAcceptableOrUnknown(
          data['last_longitude']!,
          _lastLongitudeMeta,
        ),
      );
    }
    if (data.containsKey('calculation_method')) {
      context.handle(
        _calculationMethodMeta,
        calculationMethod.isAcceptableOrUnknown(
          data['calculation_method']!,
          _calculationMethodMeta,
        ),
      );
    }
    if (data.containsKey('adhan_notifications')) {
      context.handle(
        _adhanNotificationsMeta,
        adhanNotifications.isAcceptableOrUnknown(
          data['adhan_notifications']!,
          _adhanNotificationsMeta,
        ),
      );
    }
    if (data.containsKey('reminder_notifications')) {
      context.handle(
        _reminderNotificationsMeta,
        reminderNotifications.isAcceptableOrUnknown(
          data['reminder_notifications']!,
          _reminderNotificationsMeta,
        ),
      );
    }
    if (data.containsKey('biometric_lock')) {
      context.handle(
        _biometricLockMeta,
        biometricLock.isAcceptableOrUnknown(
          data['biometric_lock']!,
          _biometricLockMeta,
        ),
      );
    }
    if (data.containsKey('cloud_sync')) {
      context.handle(
        _cloudSyncMeta,
        cloudSync.isAcceptableOrUnknown(data['cloud_sync']!, _cloudSyncMeta),
      );
    }
    if (data.containsKey('last_sync_at')) {
      context.handle(
        _lastSyncAtMeta,
        lastSyncAt.isAcceptableOrUnknown(
          data['last_sync_at']!,
          _lastSyncAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserSettingsRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserSettingsRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      ),
      photoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_path'],
      ),
      city: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}city'],
      ),
      lastLatitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}last_latitude'],
      ),
      lastLongitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}last_longitude'],
      ),
      calculationMethod: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}calculation_method'],
      )!,
      adhanNotifications: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}adhan_notifications'],
      )!,
      reminderNotifications: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}reminder_notifications'],
      )!,
      biometricLock: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}biometric_lock'],
      )!,
      cloudSync: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}cloud_sync'],
      )!,
      lastSyncAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_sync_at'],
      ),
    );
  }

  @override
  $UserSettingsTableTable createAlias(String alias) {
    return $UserSettingsTableTable(attachedDatabase, alias);
  }
}

class UserSettingsRow extends DataClass implements Insertable<UserSettingsRow> {
  final int id;
  final String? displayName;
  final String? photoPath;
  final String? city;
  final double? lastLatitude;
  final double? lastLongitude;
  final String calculationMethod;
  final bool adhanNotifications;
  final bool reminderNotifications;
  final bool biometricLock;
  final bool cloudSync;
  final DateTime? lastSyncAt;
  const UserSettingsRow({
    required this.id,
    this.displayName,
    this.photoPath,
    this.city,
    this.lastLatitude,
    this.lastLongitude,
    required this.calculationMethod,
    required this.adhanNotifications,
    required this.reminderNotifications,
    required this.biometricLock,
    required this.cloudSync,
    this.lastSyncAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || displayName != null) {
      map['display_name'] = Variable<String>(displayName);
    }
    if (!nullToAbsent || photoPath != null) {
      map['photo_path'] = Variable<String>(photoPath);
    }
    if (!nullToAbsent || city != null) {
      map['city'] = Variable<String>(city);
    }
    if (!nullToAbsent || lastLatitude != null) {
      map['last_latitude'] = Variable<double>(lastLatitude);
    }
    if (!nullToAbsent || lastLongitude != null) {
      map['last_longitude'] = Variable<double>(lastLongitude);
    }
    map['calculation_method'] = Variable<String>(calculationMethod);
    map['adhan_notifications'] = Variable<bool>(adhanNotifications);
    map['reminder_notifications'] = Variable<bool>(reminderNotifications);
    map['biometric_lock'] = Variable<bool>(biometricLock);
    map['cloud_sync'] = Variable<bool>(cloudSync);
    if (!nullToAbsent || lastSyncAt != null) {
      map['last_sync_at'] = Variable<DateTime>(lastSyncAt);
    }
    return map;
  }

  UserSettingsTableCompanion toCompanion(bool nullToAbsent) {
    return UserSettingsTableCompanion(
      id: Value(id),
      displayName: displayName == null && nullToAbsent
          ? const Value.absent()
          : Value(displayName),
      photoPath: photoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(photoPath),
      city: city == null && nullToAbsent ? const Value.absent() : Value(city),
      lastLatitude: lastLatitude == null && nullToAbsent
          ? const Value.absent()
          : Value(lastLatitude),
      lastLongitude: lastLongitude == null && nullToAbsent
          ? const Value.absent()
          : Value(lastLongitude),
      calculationMethod: Value(calculationMethod),
      adhanNotifications: Value(adhanNotifications),
      reminderNotifications: Value(reminderNotifications),
      biometricLock: Value(biometricLock),
      cloudSync: Value(cloudSync),
      lastSyncAt: lastSyncAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncAt),
    );
  }

  factory UserSettingsRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserSettingsRow(
      id: serializer.fromJson<int>(json['id']),
      displayName: serializer.fromJson<String?>(json['displayName']),
      photoPath: serializer.fromJson<String?>(json['photoPath']),
      city: serializer.fromJson<String?>(json['city']),
      lastLatitude: serializer.fromJson<double?>(json['lastLatitude']),
      lastLongitude: serializer.fromJson<double?>(json['lastLongitude']),
      calculationMethod: serializer.fromJson<String>(json['calculationMethod']),
      adhanNotifications: serializer.fromJson<bool>(json['adhanNotifications']),
      reminderNotifications: serializer.fromJson<bool>(
        json['reminderNotifications'],
      ),
      biometricLock: serializer.fromJson<bool>(json['biometricLock']),
      cloudSync: serializer.fromJson<bool>(json['cloudSync']),
      lastSyncAt: serializer.fromJson<DateTime?>(json['lastSyncAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'displayName': serializer.toJson<String?>(displayName),
      'photoPath': serializer.toJson<String?>(photoPath),
      'city': serializer.toJson<String?>(city),
      'lastLatitude': serializer.toJson<double?>(lastLatitude),
      'lastLongitude': serializer.toJson<double?>(lastLongitude),
      'calculationMethod': serializer.toJson<String>(calculationMethod),
      'adhanNotifications': serializer.toJson<bool>(adhanNotifications),
      'reminderNotifications': serializer.toJson<bool>(reminderNotifications),
      'biometricLock': serializer.toJson<bool>(biometricLock),
      'cloudSync': serializer.toJson<bool>(cloudSync),
      'lastSyncAt': serializer.toJson<DateTime?>(lastSyncAt),
    };
  }

  UserSettingsRow copyWith({
    int? id,
    Value<String?> displayName = const Value.absent(),
    Value<String?> photoPath = const Value.absent(),
    Value<String?> city = const Value.absent(),
    Value<double?> lastLatitude = const Value.absent(),
    Value<double?> lastLongitude = const Value.absent(),
    String? calculationMethod,
    bool? adhanNotifications,
    bool? reminderNotifications,
    bool? biometricLock,
    bool? cloudSync,
    Value<DateTime?> lastSyncAt = const Value.absent(),
  }) => UserSettingsRow(
    id: id ?? this.id,
    displayName: displayName.present ? displayName.value : this.displayName,
    photoPath: photoPath.present ? photoPath.value : this.photoPath,
    city: city.present ? city.value : this.city,
    lastLatitude: lastLatitude.present ? lastLatitude.value : this.lastLatitude,
    lastLongitude: lastLongitude.present
        ? lastLongitude.value
        : this.lastLongitude,
    calculationMethod: calculationMethod ?? this.calculationMethod,
    adhanNotifications: adhanNotifications ?? this.adhanNotifications,
    reminderNotifications: reminderNotifications ?? this.reminderNotifications,
    biometricLock: biometricLock ?? this.biometricLock,
    cloudSync: cloudSync ?? this.cloudSync,
    lastSyncAt: lastSyncAt.present ? lastSyncAt.value : this.lastSyncAt,
  );
  UserSettingsRow copyWithCompanion(UserSettingsTableCompanion data) {
    return UserSettingsRow(
      id: data.id.present ? data.id.value : this.id,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      photoPath: data.photoPath.present ? data.photoPath.value : this.photoPath,
      city: data.city.present ? data.city.value : this.city,
      lastLatitude: data.lastLatitude.present
          ? data.lastLatitude.value
          : this.lastLatitude,
      lastLongitude: data.lastLongitude.present
          ? data.lastLongitude.value
          : this.lastLongitude,
      calculationMethod: data.calculationMethod.present
          ? data.calculationMethod.value
          : this.calculationMethod,
      adhanNotifications: data.adhanNotifications.present
          ? data.adhanNotifications.value
          : this.adhanNotifications,
      reminderNotifications: data.reminderNotifications.present
          ? data.reminderNotifications.value
          : this.reminderNotifications,
      biometricLock: data.biometricLock.present
          ? data.biometricLock.value
          : this.biometricLock,
      cloudSync: data.cloudSync.present ? data.cloudSync.value : this.cloudSync,
      lastSyncAt: data.lastSyncAt.present
          ? data.lastSyncAt.value
          : this.lastSyncAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserSettingsRow(')
          ..write('id: $id, ')
          ..write('displayName: $displayName, ')
          ..write('photoPath: $photoPath, ')
          ..write('city: $city, ')
          ..write('lastLatitude: $lastLatitude, ')
          ..write('lastLongitude: $lastLongitude, ')
          ..write('calculationMethod: $calculationMethod, ')
          ..write('adhanNotifications: $adhanNotifications, ')
          ..write('reminderNotifications: $reminderNotifications, ')
          ..write('biometricLock: $biometricLock, ')
          ..write('cloudSync: $cloudSync, ')
          ..write('lastSyncAt: $lastSyncAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    displayName,
    photoPath,
    city,
    lastLatitude,
    lastLongitude,
    calculationMethod,
    adhanNotifications,
    reminderNotifications,
    biometricLock,
    cloudSync,
    lastSyncAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserSettingsRow &&
          other.id == this.id &&
          other.displayName == this.displayName &&
          other.photoPath == this.photoPath &&
          other.city == this.city &&
          other.lastLatitude == this.lastLatitude &&
          other.lastLongitude == this.lastLongitude &&
          other.calculationMethod == this.calculationMethod &&
          other.adhanNotifications == this.adhanNotifications &&
          other.reminderNotifications == this.reminderNotifications &&
          other.biometricLock == this.biometricLock &&
          other.cloudSync == this.cloudSync &&
          other.lastSyncAt == this.lastSyncAt);
}

class UserSettingsTableCompanion extends UpdateCompanion<UserSettingsRow> {
  final Value<int> id;
  final Value<String?> displayName;
  final Value<String?> photoPath;
  final Value<String?> city;
  final Value<double?> lastLatitude;
  final Value<double?> lastLongitude;
  final Value<String> calculationMethod;
  final Value<bool> adhanNotifications;
  final Value<bool> reminderNotifications;
  final Value<bool> biometricLock;
  final Value<bool> cloudSync;
  final Value<DateTime?> lastSyncAt;
  const UserSettingsTableCompanion({
    this.id = const Value.absent(),
    this.displayName = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.city = const Value.absent(),
    this.lastLatitude = const Value.absent(),
    this.lastLongitude = const Value.absent(),
    this.calculationMethod = const Value.absent(),
    this.adhanNotifications = const Value.absent(),
    this.reminderNotifications = const Value.absent(),
    this.biometricLock = const Value.absent(),
    this.cloudSync = const Value.absent(),
    this.lastSyncAt = const Value.absent(),
  });
  UserSettingsTableCompanion.insert({
    this.id = const Value.absent(),
    this.displayName = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.city = const Value.absent(),
    this.lastLatitude = const Value.absent(),
    this.lastLongitude = const Value.absent(),
    this.calculationMethod = const Value.absent(),
    this.adhanNotifications = const Value.absent(),
    this.reminderNotifications = const Value.absent(),
    this.biometricLock = const Value.absent(),
    this.cloudSync = const Value.absent(),
    this.lastSyncAt = const Value.absent(),
  });
  static Insertable<UserSettingsRow> custom({
    Expression<int>? id,
    Expression<String>? displayName,
    Expression<String>? photoPath,
    Expression<String>? city,
    Expression<double>? lastLatitude,
    Expression<double>? lastLongitude,
    Expression<String>? calculationMethod,
    Expression<bool>? adhanNotifications,
    Expression<bool>? reminderNotifications,
    Expression<bool>? biometricLock,
    Expression<bool>? cloudSync,
    Expression<DateTime>? lastSyncAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (displayName != null) 'display_name': displayName,
      if (photoPath != null) 'photo_path': photoPath,
      if (city != null) 'city': city,
      if (lastLatitude != null) 'last_latitude': lastLatitude,
      if (lastLongitude != null) 'last_longitude': lastLongitude,
      if (calculationMethod != null) 'calculation_method': calculationMethod,
      if (adhanNotifications != null) 'adhan_notifications': adhanNotifications,
      if (reminderNotifications != null)
        'reminder_notifications': reminderNotifications,
      if (biometricLock != null) 'biometric_lock': biometricLock,
      if (cloudSync != null) 'cloud_sync': cloudSync,
      if (lastSyncAt != null) 'last_sync_at': lastSyncAt,
    });
  }

  UserSettingsTableCompanion copyWith({
    Value<int>? id,
    Value<String?>? displayName,
    Value<String?>? photoPath,
    Value<String?>? city,
    Value<double?>? lastLatitude,
    Value<double?>? lastLongitude,
    Value<String>? calculationMethod,
    Value<bool>? adhanNotifications,
    Value<bool>? reminderNotifications,
    Value<bool>? biometricLock,
    Value<bool>? cloudSync,
    Value<DateTime?>? lastSyncAt,
  }) {
    return UserSettingsTableCompanion(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      photoPath: photoPath ?? this.photoPath,
      city: city ?? this.city,
      lastLatitude: lastLatitude ?? this.lastLatitude,
      lastLongitude: lastLongitude ?? this.lastLongitude,
      calculationMethod: calculationMethod ?? this.calculationMethod,
      adhanNotifications: adhanNotifications ?? this.adhanNotifications,
      reminderNotifications:
          reminderNotifications ?? this.reminderNotifications,
      biometricLock: biometricLock ?? this.biometricLock,
      cloudSync: cloudSync ?? this.cloudSync,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
    }
    if (city.present) {
      map['city'] = Variable<String>(city.value);
    }
    if (lastLatitude.present) {
      map['last_latitude'] = Variable<double>(lastLatitude.value);
    }
    if (lastLongitude.present) {
      map['last_longitude'] = Variable<double>(lastLongitude.value);
    }
    if (calculationMethod.present) {
      map['calculation_method'] = Variable<String>(calculationMethod.value);
    }
    if (adhanNotifications.present) {
      map['adhan_notifications'] = Variable<bool>(adhanNotifications.value);
    }
    if (reminderNotifications.present) {
      map['reminder_notifications'] = Variable<bool>(
        reminderNotifications.value,
      );
    }
    if (biometricLock.present) {
      map['biometric_lock'] = Variable<bool>(biometricLock.value);
    }
    if (cloudSync.present) {
      map['cloud_sync'] = Variable<bool>(cloudSync.value);
    }
    if (lastSyncAt.present) {
      map['last_sync_at'] = Variable<DateTime>(lastSyncAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserSettingsTableCompanion(')
          ..write('id: $id, ')
          ..write('displayName: $displayName, ')
          ..write('photoPath: $photoPath, ')
          ..write('city: $city, ')
          ..write('lastLatitude: $lastLatitude, ')
          ..write('lastLongitude: $lastLongitude, ')
          ..write('calculationMethod: $calculationMethod, ')
          ..write('adhanNotifications: $adhanNotifications, ')
          ..write('reminderNotifications: $reminderNotifications, ')
          ..write('biometricLock: $biometricLock, ')
          ..write('cloudSync: $cloudSync, ')
          ..write('lastSyncAt: $lastSyncAt')
          ..write(')'))
        .toString();
  }
}

class $CharityRecordsTableTable extends CharityRecordsTable
    with TableInfo<$CharityRecordsTableTable, CharityRecordRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CharityRecordsTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _dateKeyMeta = const VerificationMeta(
    'dateKey',
  );
  @override
  late final GeneratedColumn<String> dateKey = GeneratedColumn<String>(
    'date_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
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
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    dateKey,
    createdAt,
    amount,
    note,
    category,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'charity_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<CharityRecordRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date_key')) {
      context.handle(
        _dateKeyMeta,
        dateKey.isAcceptableOrUnknown(data['date_key']!, _dateKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_dateKeyMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CharityRecordRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CharityRecordRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      dateKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date_key'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      ),
    );
  }

  @override
  $CharityRecordsTableTable createAlias(String alias) {
    return $CharityRecordsTableTable(attachedDatabase, alias);
  }
}

class CharityRecordRow extends DataClass
    implements Insertable<CharityRecordRow> {
  final int id;
  final String dateKey;
  final DateTime createdAt;
  final double amount;
  final String? note;
  final String? category;
  const CharityRecordRow({
    required this.id,
    required this.dateKey,
    required this.createdAt,
    required this.amount,
    this.note,
    this.category,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date_key'] = Variable<String>(dateKey);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['amount'] = Variable<double>(amount);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    return map;
  }

  CharityRecordsTableCompanion toCompanion(bool nullToAbsent) {
    return CharityRecordsTableCompanion(
      id: Value(id),
      dateKey: Value(dateKey),
      createdAt: Value(createdAt),
      amount: Value(amount),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
    );
  }

  factory CharityRecordRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CharityRecordRow(
      id: serializer.fromJson<int>(json['id']),
      dateKey: serializer.fromJson<String>(json['dateKey']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      amount: serializer.fromJson<double>(json['amount']),
      note: serializer.fromJson<String?>(json['note']),
      category: serializer.fromJson<String?>(json['category']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'dateKey': serializer.toJson<String>(dateKey),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'amount': serializer.toJson<double>(amount),
      'note': serializer.toJson<String?>(note),
      'category': serializer.toJson<String?>(category),
    };
  }

  CharityRecordRow copyWith({
    int? id,
    String? dateKey,
    DateTime? createdAt,
    double? amount,
    Value<String?> note = const Value.absent(),
    Value<String?> category = const Value.absent(),
  }) => CharityRecordRow(
    id: id ?? this.id,
    dateKey: dateKey ?? this.dateKey,
    createdAt: createdAt ?? this.createdAt,
    amount: amount ?? this.amount,
    note: note.present ? note.value : this.note,
    category: category.present ? category.value : this.category,
  );
  CharityRecordRow copyWithCompanion(CharityRecordsTableCompanion data) {
    return CharityRecordRow(
      id: data.id.present ? data.id.value : this.id,
      dateKey: data.dateKey.present ? data.dateKey.value : this.dateKey,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      amount: data.amount.present ? data.amount.value : this.amount,
      note: data.note.present ? data.note.value : this.note,
      category: data.category.present ? data.category.value : this.category,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CharityRecordRow(')
          ..write('id: $id, ')
          ..write('dateKey: $dateKey, ')
          ..write('createdAt: $createdAt, ')
          ..write('amount: $amount, ')
          ..write('note: $note, ')
          ..write('category: $category')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, dateKey, createdAt, amount, note, category);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CharityRecordRow &&
          other.id == this.id &&
          other.dateKey == this.dateKey &&
          other.createdAt == this.createdAt &&
          other.amount == this.amount &&
          other.note == this.note &&
          other.category == this.category);
}

class CharityRecordsTableCompanion extends UpdateCompanion<CharityRecordRow> {
  final Value<int> id;
  final Value<String> dateKey;
  final Value<DateTime> createdAt;
  final Value<double> amount;
  final Value<String?> note;
  final Value<String?> category;
  const CharityRecordsTableCompanion({
    this.id = const Value.absent(),
    this.dateKey = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.amount = const Value.absent(),
    this.note = const Value.absent(),
    this.category = const Value.absent(),
  });
  CharityRecordsTableCompanion.insert({
    this.id = const Value.absent(),
    required String dateKey,
    required DateTime createdAt,
    required double amount,
    this.note = const Value.absent(),
    this.category = const Value.absent(),
  }) : dateKey = Value(dateKey),
       createdAt = Value(createdAt),
       amount = Value(amount);
  static Insertable<CharityRecordRow> custom({
    Expression<int>? id,
    Expression<String>? dateKey,
    Expression<DateTime>? createdAt,
    Expression<double>? amount,
    Expression<String>? note,
    Expression<String>? category,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (dateKey != null) 'date_key': dateKey,
      if (createdAt != null) 'created_at': createdAt,
      if (amount != null) 'amount': amount,
      if (note != null) 'note': note,
      if (category != null) 'category': category,
    });
  }

  CharityRecordsTableCompanion copyWith({
    Value<int>? id,
    Value<String>? dateKey,
    Value<DateTime>? createdAt,
    Value<double>? amount,
    Value<String?>? note,
    Value<String?>? category,
  }) {
    return CharityRecordsTableCompanion(
      id: id ?? this.id,
      dateKey: dateKey ?? this.dateKey,
      createdAt: createdAt ?? this.createdAt,
      amount: amount ?? this.amount,
      note: note ?? this.note,
      category: category ?? this.category,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (dateKey.present) {
      map['date_key'] = Variable<String>(dateKey.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CharityRecordsTableCompanion(')
          ..write('id: $id, ')
          ..write('dateKey: $dateKey, ')
          ..write('createdAt: $createdAt, ')
          ..write('amount: $amount, ')
          ..write('note: $note, ')
          ..write('category: $category')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $QuranBookmarksTable quranBookmarks = $QuranBookmarksTable(this);
  late final $UserSettingsTableTable userSettingsTable =
      $UserSettingsTableTable(this);
  late final $CharityRecordsTableTable charityRecordsTable =
      $CharityRecordsTableTable(this);
  late final Index idxCharityRecordsDateKey = Index(
    'idx_charity_records_date_key',
    'CREATE INDEX idx_charity_records_date_key ON charity_records (date_key)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    quranBookmarks,
    userSettingsTable,
    charityRecordsTable,
    idxCharityRecordsDateKey,
  ];
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
          QuranBookmarkRow,
          $$QuranBookmarksTableFilterComposer,
          $$QuranBookmarksTableOrderingComposer,
          $$QuranBookmarksTableAnnotationComposer,
          $$QuranBookmarksTableCreateCompanionBuilder,
          $$QuranBookmarksTableUpdateCompanionBuilder,
          (
            QuranBookmarkRow,
            BaseReferences<
              _$AppDatabase,
              $QuranBookmarksTable,
              QuranBookmarkRow
            >,
          ),
          QuranBookmarkRow,
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
      QuranBookmarkRow,
      $$QuranBookmarksTableFilterComposer,
      $$QuranBookmarksTableOrderingComposer,
      $$QuranBookmarksTableAnnotationComposer,
      $$QuranBookmarksTableCreateCompanionBuilder,
      $$QuranBookmarksTableUpdateCompanionBuilder,
      (
        QuranBookmarkRow,
        BaseReferences<_$AppDatabase, $QuranBookmarksTable, QuranBookmarkRow>,
      ),
      QuranBookmarkRow,
      PrefetchHooks Function()
    >;
typedef $$UserSettingsTableTableCreateCompanionBuilder =
    UserSettingsTableCompanion Function({
      Value<int> id,
      Value<String?> displayName,
      Value<String?> photoPath,
      Value<String?> city,
      Value<double?> lastLatitude,
      Value<double?> lastLongitude,
      Value<String> calculationMethod,
      Value<bool> adhanNotifications,
      Value<bool> reminderNotifications,
      Value<bool> biometricLock,
      Value<bool> cloudSync,
      Value<DateTime?> lastSyncAt,
    });
typedef $$UserSettingsTableTableUpdateCompanionBuilder =
    UserSettingsTableCompanion Function({
      Value<int> id,
      Value<String?> displayName,
      Value<String?> photoPath,
      Value<String?> city,
      Value<double?> lastLatitude,
      Value<double?> lastLongitude,
      Value<String> calculationMethod,
      Value<bool> adhanNotifications,
      Value<bool> reminderNotifications,
      Value<bool> biometricLock,
      Value<bool> cloudSync,
      Value<DateTime?> lastSyncAt,
    });

class $$UserSettingsTableTableFilterComposer
    extends Composer<_$AppDatabase, $UserSettingsTableTable> {
  $$UserSettingsTableTableFilterComposer({
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

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get city => $composableBuilder(
    column: $table.city,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lastLatitude => $composableBuilder(
    column: $table.lastLatitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lastLongitude => $composableBuilder(
    column: $table.lastLongitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get calculationMethod => $composableBuilder(
    column: $table.calculationMethod,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get adhanNotifications => $composableBuilder(
    column: $table.adhanNotifications,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get reminderNotifications => $composableBuilder(
    column: $table.reminderNotifications,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get biometricLock => $composableBuilder(
    column: $table.biometricLock,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get cloudSync => $composableBuilder(
    column: $table.cloudSync,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserSettingsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $UserSettingsTableTable> {
  $$UserSettingsTableTableOrderingComposer({
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

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get city => $composableBuilder(
    column: $table.city,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lastLatitude => $composableBuilder(
    column: $table.lastLatitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lastLongitude => $composableBuilder(
    column: $table.lastLongitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get calculationMethod => $composableBuilder(
    column: $table.calculationMethod,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get adhanNotifications => $composableBuilder(
    column: $table.adhanNotifications,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get reminderNotifications => $composableBuilder(
    column: $table.reminderNotifications,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get biometricLock => $composableBuilder(
    column: $table.biometricLock,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get cloudSync => $composableBuilder(
    column: $table.cloudSync,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserSettingsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserSettingsTableTable> {
  $$UserSettingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get photoPath =>
      $composableBuilder(column: $table.photoPath, builder: (column) => column);

  GeneratedColumn<String> get city =>
      $composableBuilder(column: $table.city, builder: (column) => column);

  GeneratedColumn<double> get lastLatitude => $composableBuilder(
    column: $table.lastLatitude,
    builder: (column) => column,
  );

  GeneratedColumn<double> get lastLongitude => $composableBuilder(
    column: $table.lastLongitude,
    builder: (column) => column,
  );

  GeneratedColumn<String> get calculationMethod => $composableBuilder(
    column: $table.calculationMethod,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get adhanNotifications => $composableBuilder(
    column: $table.adhanNotifications,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get reminderNotifications => $composableBuilder(
    column: $table.reminderNotifications,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get biometricLock => $composableBuilder(
    column: $table.biometricLock,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get cloudSync =>
      $composableBuilder(column: $table.cloudSync, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => column,
  );
}

class $$UserSettingsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserSettingsTableTable,
          UserSettingsRow,
          $$UserSettingsTableTableFilterComposer,
          $$UserSettingsTableTableOrderingComposer,
          $$UserSettingsTableTableAnnotationComposer,
          $$UserSettingsTableTableCreateCompanionBuilder,
          $$UserSettingsTableTableUpdateCompanionBuilder,
          (
            UserSettingsRow,
            BaseReferences<
              _$AppDatabase,
              $UserSettingsTableTable,
              UserSettingsRow
            >,
          ),
          UserSettingsRow,
          PrefetchHooks Function()
        > {
  $$UserSettingsTableTableTableManager(
    _$AppDatabase db,
    $UserSettingsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserSettingsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserSettingsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserSettingsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> displayName = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                Value<String?> city = const Value.absent(),
                Value<double?> lastLatitude = const Value.absent(),
                Value<double?> lastLongitude = const Value.absent(),
                Value<String> calculationMethod = const Value.absent(),
                Value<bool> adhanNotifications = const Value.absent(),
                Value<bool> reminderNotifications = const Value.absent(),
                Value<bool> biometricLock = const Value.absent(),
                Value<bool> cloudSync = const Value.absent(),
                Value<DateTime?> lastSyncAt = const Value.absent(),
              }) => UserSettingsTableCompanion(
                id: id,
                displayName: displayName,
                photoPath: photoPath,
                city: city,
                lastLatitude: lastLatitude,
                lastLongitude: lastLongitude,
                calculationMethod: calculationMethod,
                adhanNotifications: adhanNotifications,
                reminderNotifications: reminderNotifications,
                biometricLock: biometricLock,
                cloudSync: cloudSync,
                lastSyncAt: lastSyncAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> displayName = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                Value<String?> city = const Value.absent(),
                Value<double?> lastLatitude = const Value.absent(),
                Value<double?> lastLongitude = const Value.absent(),
                Value<String> calculationMethod = const Value.absent(),
                Value<bool> adhanNotifications = const Value.absent(),
                Value<bool> reminderNotifications = const Value.absent(),
                Value<bool> biometricLock = const Value.absent(),
                Value<bool> cloudSync = const Value.absent(),
                Value<DateTime?> lastSyncAt = const Value.absent(),
              }) => UserSettingsTableCompanion.insert(
                id: id,
                displayName: displayName,
                photoPath: photoPath,
                city: city,
                lastLatitude: lastLatitude,
                lastLongitude: lastLongitude,
                calculationMethod: calculationMethod,
                adhanNotifications: adhanNotifications,
                reminderNotifications: reminderNotifications,
                biometricLock: biometricLock,
                cloudSync: cloudSync,
                lastSyncAt: lastSyncAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserSettingsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserSettingsTableTable,
      UserSettingsRow,
      $$UserSettingsTableTableFilterComposer,
      $$UserSettingsTableTableOrderingComposer,
      $$UserSettingsTableTableAnnotationComposer,
      $$UserSettingsTableTableCreateCompanionBuilder,
      $$UserSettingsTableTableUpdateCompanionBuilder,
      (
        UserSettingsRow,
        BaseReferences<_$AppDatabase, $UserSettingsTableTable, UserSettingsRow>,
      ),
      UserSettingsRow,
      PrefetchHooks Function()
    >;
typedef $$CharityRecordsTableTableCreateCompanionBuilder =
    CharityRecordsTableCompanion Function({
      Value<int> id,
      required String dateKey,
      required DateTime createdAt,
      required double amount,
      Value<String?> note,
      Value<String?> category,
    });
typedef $$CharityRecordsTableTableUpdateCompanionBuilder =
    CharityRecordsTableCompanion Function({
      Value<int> id,
      Value<String> dateKey,
      Value<DateTime> createdAt,
      Value<double> amount,
      Value<String?> note,
      Value<String?> category,
    });

class $$CharityRecordsTableTableFilterComposer
    extends Composer<_$AppDatabase, $CharityRecordsTableTable> {
  $$CharityRecordsTableTableFilterComposer({
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

  ColumnFilters<String> get dateKey => $composableBuilder(
    column: $table.dateKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CharityRecordsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CharityRecordsTableTable> {
  $$CharityRecordsTableTableOrderingComposer({
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

  ColumnOrderings<String> get dateKey => $composableBuilder(
    column: $table.dateKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CharityRecordsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CharityRecordsTableTable> {
  $$CharityRecordsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get dateKey =>
      $composableBuilder(column: $table.dateKey, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);
}

class $$CharityRecordsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CharityRecordsTableTable,
          CharityRecordRow,
          $$CharityRecordsTableTableFilterComposer,
          $$CharityRecordsTableTableOrderingComposer,
          $$CharityRecordsTableTableAnnotationComposer,
          $$CharityRecordsTableTableCreateCompanionBuilder,
          $$CharityRecordsTableTableUpdateCompanionBuilder,
          (
            CharityRecordRow,
            BaseReferences<
              _$AppDatabase,
              $CharityRecordsTableTable,
              CharityRecordRow
            >,
          ),
          CharityRecordRow,
          PrefetchHooks Function()
        > {
  $$CharityRecordsTableTableTableManager(
    _$AppDatabase db,
    $CharityRecordsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CharityRecordsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CharityRecordsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$CharityRecordsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> dateKey = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String?> category = const Value.absent(),
              }) => CharityRecordsTableCompanion(
                id: id,
                dateKey: dateKey,
                createdAt: createdAt,
                amount: amount,
                note: note,
                category: category,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String dateKey,
                required DateTime createdAt,
                required double amount,
                Value<String?> note = const Value.absent(),
                Value<String?> category = const Value.absent(),
              }) => CharityRecordsTableCompanion.insert(
                id: id,
                dateKey: dateKey,
                createdAt: createdAt,
                amount: amount,
                note: note,
                category: category,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CharityRecordsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CharityRecordsTableTable,
      CharityRecordRow,
      $$CharityRecordsTableTableFilterComposer,
      $$CharityRecordsTableTableOrderingComposer,
      $$CharityRecordsTableTableAnnotationComposer,
      $$CharityRecordsTableTableCreateCompanionBuilder,
      $$CharityRecordsTableTableUpdateCompanionBuilder,
      (
        CharityRecordRow,
        BaseReferences<
          _$AppDatabase,
          $CharityRecordsTableTable,
          CharityRecordRow
        >,
      ),
      CharityRecordRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$QuranBookmarksTableTableManager get quranBookmarks =>
      $$QuranBookmarksTableTableManager(_db, _db.quranBookmarks);
  $$UserSettingsTableTableTableManager get userSettingsTable =>
      $$UserSettingsTableTableTableManager(_db, _db.userSettingsTable);
  $$CharityRecordsTableTableTableManager get charityRecordsTable =>
      $$CharityRecordsTableTableTableManager(_db, _db.charityRecordsTable);
}
