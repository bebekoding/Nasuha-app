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

class $MuhasabahTagsTableTable extends MuhasabahTagsTable
    with TableInfo<$MuhasabahTagsTableTable, MuhasabahTagRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MuhasabahTagsTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _slugMeta = const VerificationMeta('slug');
  @override
  late final GeneratedColumn<String> slug = GeneratedColumn<String>(
    'slug',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scoreMeta = const VerificationMeta('score');
  @override
  late final GeneratedColumn<int> score = GeneratedColumn<int>(
    'score',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('positive'),
  );
  static const VerificationMeta _iconCodePointMeta = const VerificationMeta(
    'iconCodePoint',
  );
  @override
  late final GeneratedColumn<int> iconCodePoint = GeneratedColumn<int>(
    'icon_code_point',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isDefaultMeta = const VerificationMeta(
    'isDefault',
  );
  @override
  late final GeneratedColumn<bool> isDefault = GeneratedColumn<bool>(
    'is_default',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_default" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    slug,
    name,
    score,
    kind,
    iconCodePoint,
    isDefault,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'muhasabah_tags';
  @override
  VerificationContext validateIntegrity(
    Insertable<MuhasabahTagRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('slug')) {
      context.handle(
        _slugMeta,
        slug.isAcceptableOrUnknown(data['slug']!, _slugMeta),
      );
    } else if (isInserting) {
      context.missing(_slugMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('score')) {
      context.handle(
        _scoreMeta,
        score.isAcceptableOrUnknown(data['score']!, _scoreMeta),
      );
    } else if (isInserting) {
      context.missing(_scoreMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    }
    if (data.containsKey('icon_code_point')) {
      context.handle(
        _iconCodePointMeta,
        iconCodePoint.isAcceptableOrUnknown(
          data['icon_code_point']!,
          _iconCodePointMeta,
        ),
      );
    }
    if (data.containsKey('is_default')) {
      context.handle(
        _isDefaultMeta,
        isDefault.isAcceptableOrUnknown(data['is_default']!, _isDefaultMeta),
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MuhasabahTagRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MuhasabahTagRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      slug: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}slug'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      score: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}score'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      iconCodePoint: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}icon_code_point'],
      ),
      isDefault: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_default'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $MuhasabahTagsTableTable createAlias(String alias) {
    return $MuhasabahTagsTableTable(attachedDatabase, alias);
  }
}

class MuhasabahTagRow extends DataClass implements Insertable<MuhasabahTagRow> {
  final int id;
  final String slug;
  final String name;
  final int score;
  final String kind;
  final int? iconCodePoint;
  final bool isDefault;
  final DateTime createdAt;
  const MuhasabahTagRow({
    required this.id,
    required this.slug,
    required this.name,
    required this.score,
    required this.kind,
    this.iconCodePoint,
    required this.isDefault,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['slug'] = Variable<String>(slug);
    map['name'] = Variable<String>(name);
    map['score'] = Variable<int>(score);
    map['kind'] = Variable<String>(kind);
    if (!nullToAbsent || iconCodePoint != null) {
      map['icon_code_point'] = Variable<int>(iconCodePoint);
    }
    map['is_default'] = Variable<bool>(isDefault);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  MuhasabahTagsTableCompanion toCompanion(bool nullToAbsent) {
    return MuhasabahTagsTableCompanion(
      id: Value(id),
      slug: Value(slug),
      name: Value(name),
      score: Value(score),
      kind: Value(kind),
      iconCodePoint: iconCodePoint == null && nullToAbsent
          ? const Value.absent()
          : Value(iconCodePoint),
      isDefault: Value(isDefault),
      createdAt: Value(createdAt),
    );
  }

  factory MuhasabahTagRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MuhasabahTagRow(
      id: serializer.fromJson<int>(json['id']),
      slug: serializer.fromJson<String>(json['slug']),
      name: serializer.fromJson<String>(json['name']),
      score: serializer.fromJson<int>(json['score']),
      kind: serializer.fromJson<String>(json['kind']),
      iconCodePoint: serializer.fromJson<int?>(json['iconCodePoint']),
      isDefault: serializer.fromJson<bool>(json['isDefault']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'slug': serializer.toJson<String>(slug),
      'name': serializer.toJson<String>(name),
      'score': serializer.toJson<int>(score),
      'kind': serializer.toJson<String>(kind),
      'iconCodePoint': serializer.toJson<int?>(iconCodePoint),
      'isDefault': serializer.toJson<bool>(isDefault),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  MuhasabahTagRow copyWith({
    int? id,
    String? slug,
    String? name,
    int? score,
    String? kind,
    Value<int?> iconCodePoint = const Value.absent(),
    bool? isDefault,
    DateTime? createdAt,
  }) => MuhasabahTagRow(
    id: id ?? this.id,
    slug: slug ?? this.slug,
    name: name ?? this.name,
    score: score ?? this.score,
    kind: kind ?? this.kind,
    iconCodePoint: iconCodePoint.present
        ? iconCodePoint.value
        : this.iconCodePoint,
    isDefault: isDefault ?? this.isDefault,
    createdAt: createdAt ?? this.createdAt,
  );
  MuhasabahTagRow copyWithCompanion(MuhasabahTagsTableCompanion data) {
    return MuhasabahTagRow(
      id: data.id.present ? data.id.value : this.id,
      slug: data.slug.present ? data.slug.value : this.slug,
      name: data.name.present ? data.name.value : this.name,
      score: data.score.present ? data.score.value : this.score,
      kind: data.kind.present ? data.kind.value : this.kind,
      iconCodePoint: data.iconCodePoint.present
          ? data.iconCodePoint.value
          : this.iconCodePoint,
      isDefault: data.isDefault.present ? data.isDefault.value : this.isDefault,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MuhasabahTagRow(')
          ..write('id: $id, ')
          ..write('slug: $slug, ')
          ..write('name: $name, ')
          ..write('score: $score, ')
          ..write('kind: $kind, ')
          ..write('iconCodePoint: $iconCodePoint, ')
          ..write('isDefault: $isDefault, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    slug,
    name,
    score,
    kind,
    iconCodePoint,
    isDefault,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MuhasabahTagRow &&
          other.id == this.id &&
          other.slug == this.slug &&
          other.name == this.name &&
          other.score == this.score &&
          other.kind == this.kind &&
          other.iconCodePoint == this.iconCodePoint &&
          other.isDefault == this.isDefault &&
          other.createdAt == this.createdAt);
}

class MuhasabahTagsTableCompanion extends UpdateCompanion<MuhasabahTagRow> {
  final Value<int> id;
  final Value<String> slug;
  final Value<String> name;
  final Value<int> score;
  final Value<String> kind;
  final Value<int?> iconCodePoint;
  final Value<bool> isDefault;
  final Value<DateTime> createdAt;
  const MuhasabahTagsTableCompanion({
    this.id = const Value.absent(),
    this.slug = const Value.absent(),
    this.name = const Value.absent(),
    this.score = const Value.absent(),
    this.kind = const Value.absent(),
    this.iconCodePoint = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  MuhasabahTagsTableCompanion.insert({
    this.id = const Value.absent(),
    required String slug,
    required String name,
    required int score,
    this.kind = const Value.absent(),
    this.iconCodePoint = const Value.absent(),
    this.isDefault = const Value.absent(),
    required DateTime createdAt,
  }) : slug = Value(slug),
       name = Value(name),
       score = Value(score),
       createdAt = Value(createdAt);
  static Insertable<MuhasabahTagRow> custom({
    Expression<int>? id,
    Expression<String>? slug,
    Expression<String>? name,
    Expression<int>? score,
    Expression<String>? kind,
    Expression<int>? iconCodePoint,
    Expression<bool>? isDefault,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (slug != null) 'slug': slug,
      if (name != null) 'name': name,
      if (score != null) 'score': score,
      if (kind != null) 'kind': kind,
      if (iconCodePoint != null) 'icon_code_point': iconCodePoint,
      if (isDefault != null) 'is_default': isDefault,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  MuhasabahTagsTableCompanion copyWith({
    Value<int>? id,
    Value<String>? slug,
    Value<String>? name,
    Value<int>? score,
    Value<String>? kind,
    Value<int?>? iconCodePoint,
    Value<bool>? isDefault,
    Value<DateTime>? createdAt,
  }) {
    return MuhasabahTagsTableCompanion(
      id: id ?? this.id,
      slug: slug ?? this.slug,
      name: name ?? this.name,
      score: score ?? this.score,
      kind: kind ?? this.kind,
      iconCodePoint: iconCodePoint ?? this.iconCodePoint,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (slug.present) {
      map['slug'] = Variable<String>(slug.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (score.present) {
      map['score'] = Variable<int>(score.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (iconCodePoint.present) {
      map['icon_code_point'] = Variable<int>(iconCodePoint.value);
    }
    if (isDefault.present) {
      map['is_default'] = Variable<bool>(isDefault.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MuhasabahTagsTableCompanion(')
          ..write('id: $id, ')
          ..write('slug: $slug, ')
          ..write('name: $name, ')
          ..write('score: $score, ')
          ..write('kind: $kind, ')
          ..write('iconCodePoint: $iconCodePoint, ')
          ..write('isDefault: $isDefault, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $MuhasabahEntriesTableTable extends MuhasabahEntriesTable
    with TableInfo<$MuhasabahEntriesTableTable, MuhasabahEntryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MuhasabahEntriesTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _tagSlugMeta = const VerificationMeta(
    'tagSlug',
  );
  @override
  late final GeneratedColumn<String> tagSlug = GeneratedColumn<String>(
    'tag_slug',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tagNameMeta = const VerificationMeta(
    'tagName',
  );
  @override
  late final GeneratedColumn<String> tagName = GeneratedColumn<String>(
    'tag_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tagScoreMeta = const VerificationMeta(
    'tagScore',
  );
  @override
  late final GeneratedColumn<int> tagScore = GeneratedColumn<int>(
    'tag_score',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    dateKey,
    createdAt,
    tagSlug,
    tagName,
    tagScore,
    kind,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'muhasabah_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<MuhasabahEntryRow> instance, {
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
    if (data.containsKey('tag_slug')) {
      context.handle(
        _tagSlugMeta,
        tagSlug.isAcceptableOrUnknown(data['tag_slug']!, _tagSlugMeta),
      );
    } else if (isInserting) {
      context.missing(_tagSlugMeta);
    }
    if (data.containsKey('tag_name')) {
      context.handle(
        _tagNameMeta,
        tagName.isAcceptableOrUnknown(data['tag_name']!, _tagNameMeta),
      );
    } else if (isInserting) {
      context.missing(_tagNameMeta);
    }
    if (data.containsKey('tag_score')) {
      context.handle(
        _tagScoreMeta,
        tagScore.isAcceptableOrUnknown(data['tag_score']!, _tagScoreMeta),
      );
    } else if (isInserting) {
      context.missing(_tagScoreMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MuhasabahEntryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MuhasabahEntryRow(
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
      tagSlug: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tag_slug'],
      )!,
      tagName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tag_name'],
      )!,
      tagScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tag_score'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $MuhasabahEntriesTableTable createAlias(String alias) {
    return $MuhasabahEntriesTableTable(attachedDatabase, alias);
  }
}

class MuhasabahEntryRow extends DataClass
    implements Insertable<MuhasabahEntryRow> {
  final int id;
  final String dateKey;
  final DateTime createdAt;
  final String tagSlug;
  final String tagName;
  final int tagScore;
  final String kind;
  final String? note;
  const MuhasabahEntryRow({
    required this.id,
    required this.dateKey,
    required this.createdAt,
    required this.tagSlug,
    required this.tagName,
    required this.tagScore,
    required this.kind,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date_key'] = Variable<String>(dateKey);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['tag_slug'] = Variable<String>(tagSlug);
    map['tag_name'] = Variable<String>(tagName);
    map['tag_score'] = Variable<int>(tagScore);
    map['kind'] = Variable<String>(kind);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  MuhasabahEntriesTableCompanion toCompanion(bool nullToAbsent) {
    return MuhasabahEntriesTableCompanion(
      id: Value(id),
      dateKey: Value(dateKey),
      createdAt: Value(createdAt),
      tagSlug: Value(tagSlug),
      tagName: Value(tagName),
      tagScore: Value(tagScore),
      kind: Value(kind),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory MuhasabahEntryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MuhasabahEntryRow(
      id: serializer.fromJson<int>(json['id']),
      dateKey: serializer.fromJson<String>(json['dateKey']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      tagSlug: serializer.fromJson<String>(json['tagSlug']),
      tagName: serializer.fromJson<String>(json['tagName']),
      tagScore: serializer.fromJson<int>(json['tagScore']),
      kind: serializer.fromJson<String>(json['kind']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'dateKey': serializer.toJson<String>(dateKey),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'tagSlug': serializer.toJson<String>(tagSlug),
      'tagName': serializer.toJson<String>(tagName),
      'tagScore': serializer.toJson<int>(tagScore),
      'kind': serializer.toJson<String>(kind),
      'note': serializer.toJson<String?>(note),
    };
  }

  MuhasabahEntryRow copyWith({
    int? id,
    String? dateKey,
    DateTime? createdAt,
    String? tagSlug,
    String? tagName,
    int? tagScore,
    String? kind,
    Value<String?> note = const Value.absent(),
  }) => MuhasabahEntryRow(
    id: id ?? this.id,
    dateKey: dateKey ?? this.dateKey,
    createdAt: createdAt ?? this.createdAt,
    tagSlug: tagSlug ?? this.tagSlug,
    tagName: tagName ?? this.tagName,
    tagScore: tagScore ?? this.tagScore,
    kind: kind ?? this.kind,
    note: note.present ? note.value : this.note,
  );
  MuhasabahEntryRow copyWithCompanion(MuhasabahEntriesTableCompanion data) {
    return MuhasabahEntryRow(
      id: data.id.present ? data.id.value : this.id,
      dateKey: data.dateKey.present ? data.dateKey.value : this.dateKey,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      tagSlug: data.tagSlug.present ? data.tagSlug.value : this.tagSlug,
      tagName: data.tagName.present ? data.tagName.value : this.tagName,
      tagScore: data.tagScore.present ? data.tagScore.value : this.tagScore,
      kind: data.kind.present ? data.kind.value : this.kind,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MuhasabahEntryRow(')
          ..write('id: $id, ')
          ..write('dateKey: $dateKey, ')
          ..write('createdAt: $createdAt, ')
          ..write('tagSlug: $tagSlug, ')
          ..write('tagName: $tagName, ')
          ..write('tagScore: $tagScore, ')
          ..write('kind: $kind, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    dateKey,
    createdAt,
    tagSlug,
    tagName,
    tagScore,
    kind,
    note,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MuhasabahEntryRow &&
          other.id == this.id &&
          other.dateKey == this.dateKey &&
          other.createdAt == this.createdAt &&
          other.tagSlug == this.tagSlug &&
          other.tagName == this.tagName &&
          other.tagScore == this.tagScore &&
          other.kind == this.kind &&
          other.note == this.note);
}

class MuhasabahEntriesTableCompanion
    extends UpdateCompanion<MuhasabahEntryRow> {
  final Value<int> id;
  final Value<String> dateKey;
  final Value<DateTime> createdAt;
  final Value<String> tagSlug;
  final Value<String> tagName;
  final Value<int> tagScore;
  final Value<String> kind;
  final Value<String?> note;
  const MuhasabahEntriesTableCompanion({
    this.id = const Value.absent(),
    this.dateKey = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.tagSlug = const Value.absent(),
    this.tagName = const Value.absent(),
    this.tagScore = const Value.absent(),
    this.kind = const Value.absent(),
    this.note = const Value.absent(),
  });
  MuhasabahEntriesTableCompanion.insert({
    this.id = const Value.absent(),
    required String dateKey,
    required DateTime createdAt,
    required String tagSlug,
    required String tagName,
    required int tagScore,
    required String kind,
    this.note = const Value.absent(),
  }) : dateKey = Value(dateKey),
       createdAt = Value(createdAt),
       tagSlug = Value(tagSlug),
       tagName = Value(tagName),
       tagScore = Value(tagScore),
       kind = Value(kind);
  static Insertable<MuhasabahEntryRow> custom({
    Expression<int>? id,
    Expression<String>? dateKey,
    Expression<DateTime>? createdAt,
    Expression<String>? tagSlug,
    Expression<String>? tagName,
    Expression<int>? tagScore,
    Expression<String>? kind,
    Expression<String>? note,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (dateKey != null) 'date_key': dateKey,
      if (createdAt != null) 'created_at': createdAt,
      if (tagSlug != null) 'tag_slug': tagSlug,
      if (tagName != null) 'tag_name': tagName,
      if (tagScore != null) 'tag_score': tagScore,
      if (kind != null) 'kind': kind,
      if (note != null) 'note': note,
    });
  }

  MuhasabahEntriesTableCompanion copyWith({
    Value<int>? id,
    Value<String>? dateKey,
    Value<DateTime>? createdAt,
    Value<String>? tagSlug,
    Value<String>? tagName,
    Value<int>? tagScore,
    Value<String>? kind,
    Value<String?>? note,
  }) {
    return MuhasabahEntriesTableCompanion(
      id: id ?? this.id,
      dateKey: dateKey ?? this.dateKey,
      createdAt: createdAt ?? this.createdAt,
      tagSlug: tagSlug ?? this.tagSlug,
      tagName: tagName ?? this.tagName,
      tagScore: tagScore ?? this.tagScore,
      kind: kind ?? this.kind,
      note: note ?? this.note,
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
    if (tagSlug.present) {
      map['tag_slug'] = Variable<String>(tagSlug.value);
    }
    if (tagName.present) {
      map['tag_name'] = Variable<String>(tagName.value);
    }
    if (tagScore.present) {
      map['tag_score'] = Variable<int>(tagScore.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MuhasabahEntriesTableCompanion(')
          ..write('id: $id, ')
          ..write('dateKey: $dateKey, ')
          ..write('createdAt: $createdAt, ')
          ..write('tagSlug: $tagSlug, ')
          ..write('tagName: $tagName, ')
          ..write('tagScore: $tagScore, ')
          ..write('kind: $kind, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }
}

class $DailyScoresTableTable extends DailyScoresTable
    with TableInfo<$DailyScoresTableTable, DailyScoreRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyScoresTableTable(this.attachedDatabase, [this._alias]);
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
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _totalMeta = const VerificationMeta('total');
  @override
  late final GeneratedColumn<int> total = GeneratedColumn<int>(
    'total',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _positiveCountMeta = const VerificationMeta(
    'positiveCount',
  );
  @override
  late final GeneratedColumn<int> positiveCount = GeneratedColumn<int>(
    'positive_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _negativeCountMeta = const VerificationMeta(
    'negativeCount',
  );
  @override
  late final GeneratedColumn<int> negativeCount = GeneratedColumn<int>(
    'negative_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    dateKey,
    total,
    positiveCount,
    negativeCount,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_scores';
  @override
  VerificationContext validateIntegrity(
    Insertable<DailyScoreRow> instance, {
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
    if (data.containsKey('total')) {
      context.handle(
        _totalMeta,
        total.isAcceptableOrUnknown(data['total']!, _totalMeta),
      );
    } else if (isInserting) {
      context.missing(_totalMeta);
    }
    if (data.containsKey('positive_count')) {
      context.handle(
        _positiveCountMeta,
        positiveCount.isAcceptableOrUnknown(
          data['positive_count']!,
          _positiveCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_positiveCountMeta);
    }
    if (data.containsKey('negative_count')) {
      context.handle(
        _negativeCountMeta,
        negativeCount.isAcceptableOrUnknown(
          data['negative_count']!,
          _negativeCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_negativeCountMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DailyScoreRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyScoreRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      dateKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date_key'],
      )!,
      total: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total'],
      )!,
      positiveCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}positive_count'],
      )!,
      negativeCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}negative_count'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $DailyScoresTableTable createAlias(String alias) {
    return $DailyScoresTableTable(attachedDatabase, alias);
  }
}

class DailyScoreRow extends DataClass implements Insertable<DailyScoreRow> {
  final int id;
  final String dateKey;
  final int total;
  final int positiveCount;
  final int negativeCount;
  final DateTime updatedAt;
  const DailyScoreRow({
    required this.id,
    required this.dateKey,
    required this.total,
    required this.positiveCount,
    required this.negativeCount,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date_key'] = Variable<String>(dateKey);
    map['total'] = Variable<int>(total);
    map['positive_count'] = Variable<int>(positiveCount);
    map['negative_count'] = Variable<int>(negativeCount);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  DailyScoresTableCompanion toCompanion(bool nullToAbsent) {
    return DailyScoresTableCompanion(
      id: Value(id),
      dateKey: Value(dateKey),
      total: Value(total),
      positiveCount: Value(positiveCount),
      negativeCount: Value(negativeCount),
      updatedAt: Value(updatedAt),
    );
  }

  factory DailyScoreRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyScoreRow(
      id: serializer.fromJson<int>(json['id']),
      dateKey: serializer.fromJson<String>(json['dateKey']),
      total: serializer.fromJson<int>(json['total']),
      positiveCount: serializer.fromJson<int>(json['positiveCount']),
      negativeCount: serializer.fromJson<int>(json['negativeCount']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'dateKey': serializer.toJson<String>(dateKey),
      'total': serializer.toJson<int>(total),
      'positiveCount': serializer.toJson<int>(positiveCount),
      'negativeCount': serializer.toJson<int>(negativeCount),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  DailyScoreRow copyWith({
    int? id,
    String? dateKey,
    int? total,
    int? positiveCount,
    int? negativeCount,
    DateTime? updatedAt,
  }) => DailyScoreRow(
    id: id ?? this.id,
    dateKey: dateKey ?? this.dateKey,
    total: total ?? this.total,
    positiveCount: positiveCount ?? this.positiveCount,
    negativeCount: negativeCount ?? this.negativeCount,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  DailyScoreRow copyWithCompanion(DailyScoresTableCompanion data) {
    return DailyScoreRow(
      id: data.id.present ? data.id.value : this.id,
      dateKey: data.dateKey.present ? data.dateKey.value : this.dateKey,
      total: data.total.present ? data.total.value : this.total,
      positiveCount: data.positiveCount.present
          ? data.positiveCount.value
          : this.positiveCount,
      negativeCount: data.negativeCount.present
          ? data.negativeCount.value
          : this.negativeCount,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyScoreRow(')
          ..write('id: $id, ')
          ..write('dateKey: $dateKey, ')
          ..write('total: $total, ')
          ..write('positiveCount: $positiveCount, ')
          ..write('negativeCount: $negativeCount, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, dateKey, total, positiveCount, negativeCount, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyScoreRow &&
          other.id == this.id &&
          other.dateKey == this.dateKey &&
          other.total == this.total &&
          other.positiveCount == this.positiveCount &&
          other.negativeCount == this.negativeCount &&
          other.updatedAt == this.updatedAt);
}

class DailyScoresTableCompanion extends UpdateCompanion<DailyScoreRow> {
  final Value<int> id;
  final Value<String> dateKey;
  final Value<int> total;
  final Value<int> positiveCount;
  final Value<int> negativeCount;
  final Value<DateTime> updatedAt;
  const DailyScoresTableCompanion({
    this.id = const Value.absent(),
    this.dateKey = const Value.absent(),
    this.total = const Value.absent(),
    this.positiveCount = const Value.absent(),
    this.negativeCount = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  DailyScoresTableCompanion.insert({
    this.id = const Value.absent(),
    required String dateKey,
    required int total,
    required int positiveCount,
    required int negativeCount,
    required DateTime updatedAt,
  }) : dateKey = Value(dateKey),
       total = Value(total),
       positiveCount = Value(positiveCount),
       negativeCount = Value(negativeCount),
       updatedAt = Value(updatedAt);
  static Insertable<DailyScoreRow> custom({
    Expression<int>? id,
    Expression<String>? dateKey,
    Expression<int>? total,
    Expression<int>? positiveCount,
    Expression<int>? negativeCount,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (dateKey != null) 'date_key': dateKey,
      if (total != null) 'total': total,
      if (positiveCount != null) 'positive_count': positiveCount,
      if (negativeCount != null) 'negative_count': negativeCount,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  DailyScoresTableCompanion copyWith({
    Value<int>? id,
    Value<String>? dateKey,
    Value<int>? total,
    Value<int>? positiveCount,
    Value<int>? negativeCount,
    Value<DateTime>? updatedAt,
  }) {
    return DailyScoresTableCompanion(
      id: id ?? this.id,
      dateKey: dateKey ?? this.dateKey,
      total: total ?? this.total,
      positiveCount: positiveCount ?? this.positiveCount,
      negativeCount: negativeCount ?? this.negativeCount,
      updatedAt: updatedAt ?? this.updatedAt,
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
    if (total.present) {
      map['total'] = Variable<int>(total.value);
    }
    if (positiveCount.present) {
      map['positive_count'] = Variable<int>(positiveCount.value);
    }
    if (negativeCount.present) {
      map['negative_count'] = Variable<int>(negativeCount.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyScoresTableCompanion(')
          ..write('id: $id, ')
          ..write('dateKey: $dateKey, ')
          ..write('total: $total, ')
          ..write('positiveCount: $positiveCount, ')
          ..write('negativeCount: $negativeCount, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $StreaksTableTable extends StreaksTable
    with TableInfo<$StreaksTableTable, StreakRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StreaksTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _currentMeta = const VerificationMeta(
    'current',
  );
  @override
  late final GeneratedColumn<int> current = GeneratedColumn<int>(
    'current',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _longestMeta = const VerificationMeta(
    'longest',
  );
  @override
  late final GeneratedColumn<int> longest = GeneratedColumn<int>(
    'longest',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastDateKeyMeta = const VerificationMeta(
    'lastDateKey',
  );
  @override
  late final GeneratedColumn<String> lastDateKey = GeneratedColumn<String>(
    'last_date_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    key,
    current,
    longest,
    lastDateKey,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'streaks';
  @override
  VerificationContext validateIntegrity(
    Insertable<StreakRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('current')) {
      context.handle(
        _currentMeta,
        current.isAcceptableOrUnknown(data['current']!, _currentMeta),
      );
    } else if (isInserting) {
      context.missing(_currentMeta);
    }
    if (data.containsKey('longest')) {
      context.handle(
        _longestMeta,
        longest.isAcceptableOrUnknown(data['longest']!, _longestMeta),
      );
    } else if (isInserting) {
      context.missing(_longestMeta);
    }
    if (data.containsKey('last_date_key')) {
      context.handle(
        _lastDateKeyMeta,
        lastDateKey.isAcceptableOrUnknown(
          data['last_date_key']!,
          _lastDateKeyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastDateKeyMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StreakRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StreakRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      current: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current'],
      )!,
      longest: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}longest'],
      )!,
      lastDateKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_date_key'],
      )!,
    );
  }

  @override
  $StreaksTableTable createAlias(String alias) {
    return $StreaksTableTable(attachedDatabase, alias);
  }
}

class StreakRow extends DataClass implements Insertable<StreakRow> {
  final int id;
  final String key;
  final int current;
  final int longest;
  final String lastDateKey;
  const StreakRow({
    required this.id,
    required this.key,
    required this.current,
    required this.longest,
    required this.lastDateKey,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['key'] = Variable<String>(key);
    map['current'] = Variable<int>(current);
    map['longest'] = Variable<int>(longest);
    map['last_date_key'] = Variable<String>(lastDateKey);
    return map;
  }

  StreaksTableCompanion toCompanion(bool nullToAbsent) {
    return StreaksTableCompanion(
      id: Value(id),
      key: Value(key),
      current: Value(current),
      longest: Value(longest),
      lastDateKey: Value(lastDateKey),
    );
  }

  factory StreakRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StreakRow(
      id: serializer.fromJson<int>(json['id']),
      key: serializer.fromJson<String>(json['key']),
      current: serializer.fromJson<int>(json['current']),
      longest: serializer.fromJson<int>(json['longest']),
      lastDateKey: serializer.fromJson<String>(json['lastDateKey']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'key': serializer.toJson<String>(key),
      'current': serializer.toJson<int>(current),
      'longest': serializer.toJson<int>(longest),
      'lastDateKey': serializer.toJson<String>(lastDateKey),
    };
  }

  StreakRow copyWith({
    int? id,
    String? key,
    int? current,
    int? longest,
    String? lastDateKey,
  }) => StreakRow(
    id: id ?? this.id,
    key: key ?? this.key,
    current: current ?? this.current,
    longest: longest ?? this.longest,
    lastDateKey: lastDateKey ?? this.lastDateKey,
  );
  StreakRow copyWithCompanion(StreaksTableCompanion data) {
    return StreakRow(
      id: data.id.present ? data.id.value : this.id,
      key: data.key.present ? data.key.value : this.key,
      current: data.current.present ? data.current.value : this.current,
      longest: data.longest.present ? data.longest.value : this.longest,
      lastDateKey: data.lastDateKey.present
          ? data.lastDateKey.value
          : this.lastDateKey,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StreakRow(')
          ..write('id: $id, ')
          ..write('key: $key, ')
          ..write('current: $current, ')
          ..write('longest: $longest, ')
          ..write('lastDateKey: $lastDateKey')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, key, current, longest, lastDateKey);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StreakRow &&
          other.id == this.id &&
          other.key == this.key &&
          other.current == this.current &&
          other.longest == this.longest &&
          other.lastDateKey == this.lastDateKey);
}

class StreaksTableCompanion extends UpdateCompanion<StreakRow> {
  final Value<int> id;
  final Value<String> key;
  final Value<int> current;
  final Value<int> longest;
  final Value<String> lastDateKey;
  const StreaksTableCompanion({
    this.id = const Value.absent(),
    this.key = const Value.absent(),
    this.current = const Value.absent(),
    this.longest = const Value.absent(),
    this.lastDateKey = const Value.absent(),
  });
  StreaksTableCompanion.insert({
    this.id = const Value.absent(),
    required String key,
    required int current,
    required int longest,
    required String lastDateKey,
  }) : key = Value(key),
       current = Value(current),
       longest = Value(longest),
       lastDateKey = Value(lastDateKey);
  static Insertable<StreakRow> custom({
    Expression<int>? id,
    Expression<String>? key,
    Expression<int>? current,
    Expression<int>? longest,
    Expression<String>? lastDateKey,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (key != null) 'key': key,
      if (current != null) 'current': current,
      if (longest != null) 'longest': longest,
      if (lastDateKey != null) 'last_date_key': lastDateKey,
    });
  }

  StreaksTableCompanion copyWith({
    Value<int>? id,
    Value<String>? key,
    Value<int>? current,
    Value<int>? longest,
    Value<String>? lastDateKey,
  }) {
    return StreaksTableCompanion(
      id: id ?? this.id,
      key: key ?? this.key,
      current: current ?? this.current,
      longest: longest ?? this.longest,
      lastDateKey: lastDateKey ?? this.lastDateKey,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (current.present) {
      map['current'] = Variable<int>(current.value);
    }
    if (longest.present) {
      map['longest'] = Variable<int>(longest.value);
    }
    if (lastDateKey.present) {
      map['last_date_key'] = Variable<String>(lastDateKey.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StreaksTableCompanion(')
          ..write('id: $id, ')
          ..write('key: $key, ')
          ..write('current: $current, ')
          ..write('longest: $longest, ')
          ..write('lastDateKey: $lastDateKey')
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
  late final $MuhasabahTagsTableTable muhasabahTagsTable =
      $MuhasabahTagsTableTable(this);
  late final $MuhasabahEntriesTableTable muhasabahEntriesTable =
      $MuhasabahEntriesTableTable(this);
  late final $DailyScoresTableTable dailyScoresTable = $DailyScoresTableTable(
    this,
  );
  late final $StreaksTableTable streaksTable = $StreaksTableTable(this);
  late final Index idxCharityRecordsDateKey = Index(
    'idx_charity_records_date_key',
    'CREATE INDEX idx_charity_records_date_key ON charity_records (date_key)',
  );
  late final Index idxMuhasabahEntriesDateKey = Index(
    'idx_muhasabah_entries_date_key',
    'CREATE INDEX idx_muhasabah_entries_date_key ON muhasabah_entries (date_key)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    quranBookmarks,
    userSettingsTable,
    charityRecordsTable,
    muhasabahTagsTable,
    muhasabahEntriesTable,
    dailyScoresTable,
    streaksTable,
    idxCharityRecordsDateKey,
    idxMuhasabahEntriesDateKey,
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
typedef $$MuhasabahTagsTableTableCreateCompanionBuilder =
    MuhasabahTagsTableCompanion Function({
      Value<int> id,
      required String slug,
      required String name,
      required int score,
      Value<String> kind,
      Value<int?> iconCodePoint,
      Value<bool> isDefault,
      required DateTime createdAt,
    });
typedef $$MuhasabahTagsTableTableUpdateCompanionBuilder =
    MuhasabahTagsTableCompanion Function({
      Value<int> id,
      Value<String> slug,
      Value<String> name,
      Value<int> score,
      Value<String> kind,
      Value<int?> iconCodePoint,
      Value<bool> isDefault,
      Value<DateTime> createdAt,
    });

class $$MuhasabahTagsTableTableFilterComposer
    extends Composer<_$AppDatabase, $MuhasabahTagsTableTable> {
  $$MuhasabahTagsTableTableFilterComposer({
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

  ColumnFilters<String> get slug => $composableBuilder(
    column: $table.slug,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get iconCodePoint => $composableBuilder(
    column: $table.iconCodePoint,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MuhasabahTagsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $MuhasabahTagsTableTable> {
  $$MuhasabahTagsTableTableOrderingComposer({
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

  ColumnOrderings<String> get slug => $composableBuilder(
    column: $table.slug,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get iconCodePoint => $composableBuilder(
    column: $table.iconCodePoint,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MuhasabahTagsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $MuhasabahTagsTableTable> {
  $$MuhasabahTagsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get slug =>
      $composableBuilder(column: $table.slug, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get score =>
      $composableBuilder(column: $table.score, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<int> get iconCodePoint => $composableBuilder(
    column: $table.iconCodePoint,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isDefault =>
      $composableBuilder(column: $table.isDefault, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$MuhasabahTagsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MuhasabahTagsTableTable,
          MuhasabahTagRow,
          $$MuhasabahTagsTableTableFilterComposer,
          $$MuhasabahTagsTableTableOrderingComposer,
          $$MuhasabahTagsTableTableAnnotationComposer,
          $$MuhasabahTagsTableTableCreateCompanionBuilder,
          $$MuhasabahTagsTableTableUpdateCompanionBuilder,
          (
            MuhasabahTagRow,
            BaseReferences<
              _$AppDatabase,
              $MuhasabahTagsTableTable,
              MuhasabahTagRow
            >,
          ),
          MuhasabahTagRow,
          PrefetchHooks Function()
        > {
  $$MuhasabahTagsTableTableTableManager(
    _$AppDatabase db,
    $MuhasabahTagsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MuhasabahTagsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MuhasabahTagsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MuhasabahTagsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> slug = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> score = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<int?> iconCodePoint = const Value.absent(),
                Value<bool> isDefault = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => MuhasabahTagsTableCompanion(
                id: id,
                slug: slug,
                name: name,
                score: score,
                kind: kind,
                iconCodePoint: iconCodePoint,
                isDefault: isDefault,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String slug,
                required String name,
                required int score,
                Value<String> kind = const Value.absent(),
                Value<int?> iconCodePoint = const Value.absent(),
                Value<bool> isDefault = const Value.absent(),
                required DateTime createdAt,
              }) => MuhasabahTagsTableCompanion.insert(
                id: id,
                slug: slug,
                name: name,
                score: score,
                kind: kind,
                iconCodePoint: iconCodePoint,
                isDefault: isDefault,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MuhasabahTagsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MuhasabahTagsTableTable,
      MuhasabahTagRow,
      $$MuhasabahTagsTableTableFilterComposer,
      $$MuhasabahTagsTableTableOrderingComposer,
      $$MuhasabahTagsTableTableAnnotationComposer,
      $$MuhasabahTagsTableTableCreateCompanionBuilder,
      $$MuhasabahTagsTableTableUpdateCompanionBuilder,
      (
        MuhasabahTagRow,
        BaseReferences<
          _$AppDatabase,
          $MuhasabahTagsTableTable,
          MuhasabahTagRow
        >,
      ),
      MuhasabahTagRow,
      PrefetchHooks Function()
    >;
typedef $$MuhasabahEntriesTableTableCreateCompanionBuilder =
    MuhasabahEntriesTableCompanion Function({
      Value<int> id,
      required String dateKey,
      required DateTime createdAt,
      required String tagSlug,
      required String tagName,
      required int tagScore,
      required String kind,
      Value<String?> note,
    });
typedef $$MuhasabahEntriesTableTableUpdateCompanionBuilder =
    MuhasabahEntriesTableCompanion Function({
      Value<int> id,
      Value<String> dateKey,
      Value<DateTime> createdAt,
      Value<String> tagSlug,
      Value<String> tagName,
      Value<int> tagScore,
      Value<String> kind,
      Value<String?> note,
    });

class $$MuhasabahEntriesTableTableFilterComposer
    extends Composer<_$AppDatabase, $MuhasabahEntriesTableTable> {
  $$MuhasabahEntriesTableTableFilterComposer({
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

  ColumnFilters<String> get tagSlug => $composableBuilder(
    column: $table.tagSlug,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tagName => $composableBuilder(
    column: $table.tagName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get tagScore => $composableBuilder(
    column: $table.tagScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MuhasabahEntriesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $MuhasabahEntriesTableTable> {
  $$MuhasabahEntriesTableTableOrderingComposer({
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

  ColumnOrderings<String> get tagSlug => $composableBuilder(
    column: $table.tagSlug,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tagName => $composableBuilder(
    column: $table.tagName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tagScore => $composableBuilder(
    column: $table.tagScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MuhasabahEntriesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $MuhasabahEntriesTableTable> {
  $$MuhasabahEntriesTableTableAnnotationComposer({
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

  GeneratedColumn<String> get tagSlug =>
      $composableBuilder(column: $table.tagSlug, builder: (column) => column);

  GeneratedColumn<String> get tagName =>
      $composableBuilder(column: $table.tagName, builder: (column) => column);

  GeneratedColumn<int> get tagScore =>
      $composableBuilder(column: $table.tagScore, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);
}

class $$MuhasabahEntriesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MuhasabahEntriesTableTable,
          MuhasabahEntryRow,
          $$MuhasabahEntriesTableTableFilterComposer,
          $$MuhasabahEntriesTableTableOrderingComposer,
          $$MuhasabahEntriesTableTableAnnotationComposer,
          $$MuhasabahEntriesTableTableCreateCompanionBuilder,
          $$MuhasabahEntriesTableTableUpdateCompanionBuilder,
          (
            MuhasabahEntryRow,
            BaseReferences<
              _$AppDatabase,
              $MuhasabahEntriesTableTable,
              MuhasabahEntryRow
            >,
          ),
          MuhasabahEntryRow,
          PrefetchHooks Function()
        > {
  $$MuhasabahEntriesTableTableTableManager(
    _$AppDatabase db,
    $MuhasabahEntriesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MuhasabahEntriesTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$MuhasabahEntriesTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$MuhasabahEntriesTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> dateKey = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> tagSlug = const Value.absent(),
                Value<String> tagName = const Value.absent(),
                Value<int> tagScore = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String?> note = const Value.absent(),
              }) => MuhasabahEntriesTableCompanion(
                id: id,
                dateKey: dateKey,
                createdAt: createdAt,
                tagSlug: tagSlug,
                tagName: tagName,
                tagScore: tagScore,
                kind: kind,
                note: note,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String dateKey,
                required DateTime createdAt,
                required String tagSlug,
                required String tagName,
                required int tagScore,
                required String kind,
                Value<String?> note = const Value.absent(),
              }) => MuhasabahEntriesTableCompanion.insert(
                id: id,
                dateKey: dateKey,
                createdAt: createdAt,
                tagSlug: tagSlug,
                tagName: tagName,
                tagScore: tagScore,
                kind: kind,
                note: note,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MuhasabahEntriesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MuhasabahEntriesTableTable,
      MuhasabahEntryRow,
      $$MuhasabahEntriesTableTableFilterComposer,
      $$MuhasabahEntriesTableTableOrderingComposer,
      $$MuhasabahEntriesTableTableAnnotationComposer,
      $$MuhasabahEntriesTableTableCreateCompanionBuilder,
      $$MuhasabahEntriesTableTableUpdateCompanionBuilder,
      (
        MuhasabahEntryRow,
        BaseReferences<
          _$AppDatabase,
          $MuhasabahEntriesTableTable,
          MuhasabahEntryRow
        >,
      ),
      MuhasabahEntryRow,
      PrefetchHooks Function()
    >;
typedef $$DailyScoresTableTableCreateCompanionBuilder =
    DailyScoresTableCompanion Function({
      Value<int> id,
      required String dateKey,
      required int total,
      required int positiveCount,
      required int negativeCount,
      required DateTime updatedAt,
    });
typedef $$DailyScoresTableTableUpdateCompanionBuilder =
    DailyScoresTableCompanion Function({
      Value<int> id,
      Value<String> dateKey,
      Value<int> total,
      Value<int> positiveCount,
      Value<int> negativeCount,
      Value<DateTime> updatedAt,
    });

class $$DailyScoresTableTableFilterComposer
    extends Composer<_$AppDatabase, $DailyScoresTableTable> {
  $$DailyScoresTableTableFilterComposer({
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

  ColumnFilters<int> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get positiveCount => $composableBuilder(
    column: $table.positiveCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get negativeCount => $composableBuilder(
    column: $table.negativeCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DailyScoresTableTableOrderingComposer
    extends Composer<_$AppDatabase, $DailyScoresTableTable> {
  $$DailyScoresTableTableOrderingComposer({
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

  ColumnOrderings<int> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get positiveCount => $composableBuilder(
    column: $table.positiveCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get negativeCount => $composableBuilder(
    column: $table.negativeCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DailyScoresTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailyScoresTableTable> {
  $$DailyScoresTableTableAnnotationComposer({
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

  GeneratedColumn<int> get total =>
      $composableBuilder(column: $table.total, builder: (column) => column);

  GeneratedColumn<int> get positiveCount => $composableBuilder(
    column: $table.positiveCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get negativeCount => $composableBuilder(
    column: $table.negativeCount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$DailyScoresTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DailyScoresTableTable,
          DailyScoreRow,
          $$DailyScoresTableTableFilterComposer,
          $$DailyScoresTableTableOrderingComposer,
          $$DailyScoresTableTableAnnotationComposer,
          $$DailyScoresTableTableCreateCompanionBuilder,
          $$DailyScoresTableTableUpdateCompanionBuilder,
          (
            DailyScoreRow,
            BaseReferences<
              _$AppDatabase,
              $DailyScoresTableTable,
              DailyScoreRow
            >,
          ),
          DailyScoreRow,
          PrefetchHooks Function()
        > {
  $$DailyScoresTableTableTableManager(
    _$AppDatabase db,
    $DailyScoresTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyScoresTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailyScoresTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DailyScoresTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> dateKey = const Value.absent(),
                Value<int> total = const Value.absent(),
                Value<int> positiveCount = const Value.absent(),
                Value<int> negativeCount = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => DailyScoresTableCompanion(
                id: id,
                dateKey: dateKey,
                total: total,
                positiveCount: positiveCount,
                negativeCount: negativeCount,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String dateKey,
                required int total,
                required int positiveCount,
                required int negativeCount,
                required DateTime updatedAt,
              }) => DailyScoresTableCompanion.insert(
                id: id,
                dateKey: dateKey,
                total: total,
                positiveCount: positiveCount,
                negativeCount: negativeCount,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DailyScoresTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DailyScoresTableTable,
      DailyScoreRow,
      $$DailyScoresTableTableFilterComposer,
      $$DailyScoresTableTableOrderingComposer,
      $$DailyScoresTableTableAnnotationComposer,
      $$DailyScoresTableTableCreateCompanionBuilder,
      $$DailyScoresTableTableUpdateCompanionBuilder,
      (
        DailyScoreRow,
        BaseReferences<_$AppDatabase, $DailyScoresTableTable, DailyScoreRow>,
      ),
      DailyScoreRow,
      PrefetchHooks Function()
    >;
typedef $$StreaksTableTableCreateCompanionBuilder =
    StreaksTableCompanion Function({
      Value<int> id,
      required String key,
      required int current,
      required int longest,
      required String lastDateKey,
    });
typedef $$StreaksTableTableUpdateCompanionBuilder =
    StreaksTableCompanion Function({
      Value<int> id,
      Value<String> key,
      Value<int> current,
      Value<int> longest,
      Value<String> lastDateKey,
    });

class $$StreaksTableTableFilterComposer
    extends Composer<_$AppDatabase, $StreaksTableTable> {
  $$StreaksTableTableFilterComposer({
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

  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get current => $composableBuilder(
    column: $table.current,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get longest => $composableBuilder(
    column: $table.longest,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastDateKey => $composableBuilder(
    column: $table.lastDateKey,
    builder: (column) => ColumnFilters(column),
  );
}

class $$StreaksTableTableOrderingComposer
    extends Composer<_$AppDatabase, $StreaksTableTable> {
  $$StreaksTableTableOrderingComposer({
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

  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get current => $composableBuilder(
    column: $table.current,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get longest => $composableBuilder(
    column: $table.longest,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastDateKey => $composableBuilder(
    column: $table.lastDateKey,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StreaksTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $StreaksTableTable> {
  $$StreaksTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<int> get current =>
      $composableBuilder(column: $table.current, builder: (column) => column);

  GeneratedColumn<int> get longest =>
      $composableBuilder(column: $table.longest, builder: (column) => column);

  GeneratedColumn<String> get lastDateKey => $composableBuilder(
    column: $table.lastDateKey,
    builder: (column) => column,
  );
}

class $$StreaksTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StreaksTableTable,
          StreakRow,
          $$StreaksTableTableFilterComposer,
          $$StreaksTableTableOrderingComposer,
          $$StreaksTableTableAnnotationComposer,
          $$StreaksTableTableCreateCompanionBuilder,
          $$StreaksTableTableUpdateCompanionBuilder,
          (
            StreakRow,
            BaseReferences<_$AppDatabase, $StreaksTableTable, StreakRow>,
          ),
          StreakRow,
          PrefetchHooks Function()
        > {
  $$StreaksTableTableTableManager(_$AppDatabase db, $StreaksTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StreaksTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StreaksTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StreaksTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> key = const Value.absent(),
                Value<int> current = const Value.absent(),
                Value<int> longest = const Value.absent(),
                Value<String> lastDateKey = const Value.absent(),
              }) => StreaksTableCompanion(
                id: id,
                key: key,
                current: current,
                longest: longest,
                lastDateKey: lastDateKey,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String key,
                required int current,
                required int longest,
                required String lastDateKey,
              }) => StreaksTableCompanion.insert(
                id: id,
                key: key,
                current: current,
                longest: longest,
                lastDateKey: lastDateKey,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StreaksTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StreaksTableTable,
      StreakRow,
      $$StreaksTableTableFilterComposer,
      $$StreaksTableTableOrderingComposer,
      $$StreaksTableTableAnnotationComposer,
      $$StreaksTableTableCreateCompanionBuilder,
      $$StreaksTableTableUpdateCompanionBuilder,
      (StreakRow, BaseReferences<_$AppDatabase, $StreaksTableTable, StreakRow>),
      StreakRow,
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
  $$MuhasabahTagsTableTableTableManager get muhasabahTagsTable =>
      $$MuhasabahTagsTableTableTableManager(_db, _db.muhasabahTagsTable);
  $$MuhasabahEntriesTableTableTableManager get muhasabahEntriesTable =>
      $$MuhasabahEntriesTableTableTableManager(_db, _db.muhasabahEntriesTable);
  $$DailyScoresTableTableTableManager get dailyScoresTable =>
      $$DailyScoresTableTableTableManager(_db, _db.dailyScoresTable);
  $$StreaksTableTableTableManager get streaksTable =>
      $$StreaksTableTableTableManager(_db, _db.streaksTable);
}
