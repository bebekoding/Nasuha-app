import 'dart:convert';

import 'package:drift/drift.dart' show Value;
import 'package:isar/isar.dart';

import '../../models/achievement.dart';
import '../../models/charity_record.dart';
import '../../models/daily_score.dart';
import '../../models/muhasabah_entry.dart';
import '../../models/muhasabah_tag.dart';
import '../../models/quran_bookmark.dart';
import '../../models/streak.dart';
import '../../models/user_settings.dart';
import '../database/app_database.dart';

/// Schema version of the backup payload. Bump on breaking changes.
const int kBackupSchemaVersion = 1;

class BackupPayload {
  final int schemaVersion;
  final DateTime createdAt;
  final Map<String, List<Map<String, dynamic>>> collections;

  const BackupPayload({
    required this.schemaVersion,
    required this.createdAt,
    required this.collections,
  });

  Map<String, dynamic> toJson() => {
        'schemaVersion': schemaVersion,
        'createdAt': createdAt.toIso8601String(),
        'collections': collections,
      };

  factory BackupPayload.fromJson(Map<String, dynamic> json) => BackupPayload(
        schemaVersion: json['schemaVersion'] as int,
        createdAt: DateTime.parse(json['createdAt'] as String),
        collections: (json['collections'] as Map<String, dynamic>).map(
          (k, v) => MapEntry(
            k,
            (v as List).cast<Map<String, dynamic>>(),
          ),
        ),
      );
}

class BackupSerializer {
  BackupSerializer(this.isar, this.db);
  final Isar isar;
  final AppDatabase db;

  Future<String> exportToJsonString() async {
    final payload = await _buildPayload();
    return jsonEncode(payload.toJson());
  }

  Future<BackupPayload> _buildPayload() async {
    final tags = await isar.muhasabahTags.where().findAll();
    final entries = await isar.muhasabahEntrys.where().findAll();
    final scores = await isar.dailyScores.where().findAll();
    final charityRows = await db.select(db.charityRecordsTable).get();
    final charity = charityRows.map(_charityFromRow).toList();
    final achievements = await isar.achievements.where().findAll();
    final streaks = await isar.streaks.where().findAll();
    final bookmarks = await isar.quranBookmarks.where().findAll();
    final settingsRow =
        await db.select(db.userSettingsTable).getSingleOrNull();
    final settings = settingsRow == null ? null : _settingsFromRow(settingsRow);

    final collections = <String, List<Map<String, dynamic>>>{
      'muhasabahTags': tags.map(_tagToJson).toList(),
      'muhasabahEntries': entries.map(_entryToJson).toList(),
      'dailyScores': scores.map(_scoreToJson).toList(),
      'charityRecords': charity.map(_charityToJson).toList(),
      'achievements': achievements.map(_achievementToJson).toList(),
      'streaks': streaks.map(_streakToJson).toList(),
      'quranBookmarks': bookmarks.map(_bookmarkToJson).toList(),
    };
    if (settings != null) {
      collections['userSettings'] = [_settingsToJson(settings)];
    }
    return BackupPayload(
      schemaVersion: kBackupSchemaVersion,
      createdAt: DateTime.now(),
      collections: collections,
    );
  }

  /// Restore from JSON. Replaces existing data — caller should confirm.
  /// Cached Quran surahs are deliberately NOT restored (they redownload).
  Future<void> importFromJsonString(String jsonString) async {
    final payload = BackupPayload.fromJson(
        jsonDecode(jsonString) as Map<String, dynamic>);
    if (payload.schemaVersion > kBackupSchemaVersion) {
      throw StateError(
          'Backup ini dibuat dengan versi aplikasi yang lebih baru. '
          'Mohon perbarui aplikasi terlebih dahulu.');
    }
    await isar.writeTxn(() async {
      // Wipe (but keep cached surahs to avoid redownload).
      await isar.muhasabahTags.clear();
      await isar.muhasabahEntrys.clear();
      await isar.dailyScores.clear();
      // charity_records dipindah ke Drift — dihapus di luar tx Isar.
      await isar.achievements.clear();
      await isar.streaks.clear();
      await isar.quranBookmarks.clear();

      for (final m in payload.collections['muhasabahTags'] ?? const []) {
        await isar.muhasabahTags.put(_tagFromJson(m));
      }
      for (final m in payload.collections['muhasabahEntries'] ?? const []) {
        await isar.muhasabahEntrys.put(_entryFromJson(m));
      }
      for (final m in payload.collections['dailyScores'] ?? const []) {
        await isar.dailyScores.put(_scoreFromJson(m));
      }
      // charity_records: dipindah ke Drift (proses di luar tx Isar).
      for (final m in payload.collections['achievements'] ?? const []) {
        await isar.achievements.put(_achievementFromJson(m));
      }
      for (final m in payload.collections['streaks'] ?? const []) {
        await isar.streaks.put(_streakFromJson(m));
      }
      for (final m in payload.collections['quranBookmarks'] ?? const []) {
        await isar.quranBookmarks.put(_bookmarkFromJson(m));
      }
    });

    // Charity records kini di Drift.
    await db.delete(db.charityRecordsTable).go();
    for (final m in payload.collections['charityRecords'] ?? const []) {
      final c = _charityFromJson(m);
      await db.into(db.charityRecordsTable).insert(
            CharityRecordsTableCompanion.insert(
              dateKey: c.dateKey,
              createdAt: c.createdAt,
              amount: c.amount,
              note: Value(c.note),
              category: Value(c.category),
            ),
          );
    }

    // Settings kini di Drift (di luar transaksi Isar).
    final settingsJson = payload.collections['userSettings'];
    if (settingsJson != null && settingsJson.isNotEmpty) {
      final s = _settingsFromJson(settingsJson.first);
      await db.into(db.userSettingsTable).insertOnConflictUpdate(
            UserSettingsTableCompanion.insert(
              displayName: Value(s.displayName),
              photoPath: Value(s.photoPath),
              city: Value(s.city),
              lastLatitude: Value(s.lastLatitude),
              lastLongitude: Value(s.lastLongitude),
              calculationMethod: Value(s.calculationMethod),
              adhanNotifications: Value(s.adhanNotifications),
              reminderNotifications: Value(s.reminderNotifications),
              biometricLock: Value(s.biometricLock),
              cloudSync: Value(s.cloudSync),
              lastSyncAt: Value(s.lastSyncAt),
            ),
          );
    }
  }

  UserSettings _settingsFromRow(UserSettingsRow r) => UserSettings(
        displayName: r.displayName,
        photoPath: r.photoPath,
        city: r.city,
        lastLatitude: r.lastLatitude,
        lastLongitude: r.lastLongitude,
        calculationMethod: r.calculationMethod,
        adhanNotifications: r.adhanNotifications,
        reminderNotifications: r.reminderNotifications,
        biometricLock: r.biometricLock,
        cloudSync: r.cloudSync,
        lastSyncAt: r.lastSyncAt,
      );

  // ----- mappers -----
  Map<String, dynamic> _tagToJson(MuhasabahTag t) => {
        'slug': t.slug,
        'name': t.name,
        'score': t.score,
        'kind': t.kind.name,
        'iconCodePoint': t.iconCodePoint,
        'isDefault': t.isDefault,
        'createdAt': t.createdAt.toIso8601String(),
      };

  MuhasabahTag _tagFromJson(Map<String, dynamic> j) => MuhasabahTag()
    ..slug = j['slug'] as String
    ..name = j['name'] as String
    ..score = j['score'] as int
    ..kind = TagKind.values.byName(j['kind'] as String)
    ..iconCodePoint = j['iconCodePoint'] as int?
    ..isDefault = (j['isDefault'] as bool?) ?? false
    ..createdAt = DateTime.parse(j['createdAt'] as String);

  Map<String, dynamic> _entryToJson(MuhasabahEntry e) => {
        'dateKey': e.dateKey,
        'createdAt': e.createdAt.toIso8601String(),
        'tagSlug': e.tagSlug,
        'tagName': e.tagName,
        'tagScore': e.tagScore,
        'kind': e.kind.name,
        'note': e.note,
      };

  MuhasabahEntry _entryFromJson(Map<String, dynamic> j) => MuhasabahEntry()
    ..dateKey = j['dateKey'] as String
    ..createdAt = DateTime.parse(j['createdAt'] as String)
    ..tagSlug = j['tagSlug'] as String
    ..tagName = j['tagName'] as String
    ..tagScore = j['tagScore'] as int
    ..kind = TagKind.values.byName(j['kind'] as String)
    ..note = j['note'] as String?;

  Map<String, dynamic> _scoreToJson(DailyScore s) => {
        'dateKey': s.dateKey,
        'total': s.total,
        'positiveCount': s.positiveCount,
        'negativeCount': s.negativeCount,
        'updatedAt': s.updatedAt.toIso8601String(),
      };

  DailyScore _scoreFromJson(Map<String, dynamic> j) => DailyScore()
    ..dateKey = j['dateKey'] as String
    ..total = j['total'] as int
    ..positiveCount = j['positiveCount'] as int
    ..negativeCount = j['negativeCount'] as int
    ..updatedAt = DateTime.parse(j['updatedAt'] as String);

  Map<String, dynamic> _charityToJson(CharityRecord r) => {
        'dateKey': r.dateKey,
        'createdAt': r.createdAt.toIso8601String(),
        'amount': r.amount,
        'note': r.note,
        'category': r.category,
      };

  CharityRecord _charityFromJson(Map<String, dynamic> j) => CharityRecord(
        dateKey: j['dateKey'] as String,
        createdAt: DateTime.parse(j['createdAt'] as String),
        amount: (j['amount'] as num).toDouble(),
        note: j['note'] as String?,
        category: j['category'] as String?,
      );

  CharityRecord _charityFromRow(CharityRecordRow r) => CharityRecord(
        id: r.id,
        dateKey: r.dateKey,
        createdAt: r.createdAt,
        amount: r.amount,
        note: r.note,
        category: r.category,
      );

  Map<String, dynamic> _achievementToJson(Achievement a) => {
        'code': a.code,
        'title': a.title,
        'description': a.description,
        'targetValue': a.targetValue,
        'currentValue': a.currentValue,
        'unlockedAt': a.unlockedAt?.toIso8601String(),
      };

  Achievement _achievementFromJson(Map<String, dynamic> j) => Achievement()
    ..code = j['code'] as String
    ..title = j['title'] as String
    ..description = j['description'] as String
    ..targetValue = j['targetValue'] as int
    ..currentValue = j['currentValue'] as int
    ..unlockedAt = j['unlockedAt'] == null
        ? null
        : DateTime.parse(j['unlockedAt'] as String);

  Map<String, dynamic> _streakToJson(Streak s) => {
        'key': s.key,
        'current': s.current,
        'longest': s.longest,
        'lastDateKey': s.lastDateKey,
      };

  Streak _streakFromJson(Map<String, dynamic> j) => Streak()
    ..key = j['key'] as String
    ..current = j['current'] as int
    ..longest = j['longest'] as int
    ..lastDateKey = j['lastDateKey'] as String;

  Map<String, dynamic> _bookmarkToJson(QuranBookmark b) => {
        'surahNumber': b.surahNumber,
        'verseNumber': b.verseNumber,
        'surahName': b.surahName,
        'note': b.note,
        'isLastRead': b.isLastRead,
        'createdAt': b.createdAt.toIso8601String(),
      };

  QuranBookmark _bookmarkFromJson(Map<String, dynamic> j) => QuranBookmark()
    ..surahNumber = j['surahNumber'] as int
    ..verseNumber = j['verseNumber'] as int
    ..surahName = j['surahName'] as String
    ..note = j['note'] as String?
    ..isLastRead = (j['isLastRead'] as bool?) ?? false
    ..createdAt = DateTime.parse(j['createdAt'] as String);

  Map<String, dynamic> _settingsToJson(UserSettings s) => {
        'displayName': s.displayName,
        'city': s.city,
        'lastLatitude': s.lastLatitude,
        'lastLongitude': s.lastLongitude,
        'calculationMethod': s.calculationMethod,
        'adhanNotifications': s.adhanNotifications,
        'reminderNotifications': s.reminderNotifications,
        'biometricLock': s.biometricLock,
        'cloudSync': s.cloudSync,
        'lastSyncAt': s.lastSyncAt?.toIso8601String(),
      };

  UserSettings _settingsFromJson(Map<String, dynamic> j) => UserSettings()
    ..displayName = j['displayName'] as String?
    ..city = j['city'] as String?
    ..lastLatitude = (j['lastLatitude'] as num?)?.toDouble()
    ..lastLongitude = (j['lastLongitude'] as num?)?.toDouble()
    ..calculationMethod =
        (j['calculationMethod'] as String?) ?? 'muslimWorldLeague'
    ..adhanNotifications = (j['adhanNotifications'] as bool?) ?? true
    ..reminderNotifications = (j['reminderNotifications'] as bool?) ?? true
    ..biometricLock = (j['biometricLock'] as bool?) ?? false
    ..cloudSync = (j['cloudSync'] as bool?) ?? false
    ..lastSyncAt =
        j['lastSyncAt'] == null ? null : DateTime.parse(j['lastSyncAt'] as String);
}
