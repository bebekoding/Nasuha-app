import 'dart:convert';

import 'package:drift/drift.dart' show Value;
import 'package:isar/isar.dart';

import '../../models/achievement.dart';
import '../../models/charity_record.dart';
import '../../models/quran_bookmark.dart';
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
    final tagRows = await db.select(db.muhasabahTagsTable).get();
    final entryRows = await db.select(db.muhasabahEntriesTable).get();
    final scoreRows = await db.select(db.dailyScoresTable).get();
    final charityRows = await db.select(db.charityRecordsTable).get();
    final charity = charityRows.map(_charityFromRow).toList();
    final streakRows = await db.select(db.streaksTable).get();
    final achievements = await isar.achievements.where().findAll();
    final bookmarks = await isar.quranBookmarks.where().findAll();
    final settingsRow =
        await db.select(db.userSettingsTable).getSingleOrNull();
    final settings = settingsRow == null ? null : _settingsFromRow(settingsRow);

    final collections = <String, List<Map<String, dynamic>>>{
      'muhasabahTags': tagRows.map(_tagFromRowToJson).toList(),
      'muhasabahEntries': entryRows.map(_entryFromRowToJson).toList(),
      'dailyScores': scoreRows.map(_scoreFromRowToJson).toList(),
      'charityRecords': charity.map(_charityToJson).toList(),
      'achievements': achievements.map(_achievementToJson).toList(),
      'streaks': streakRows.map(_streakFromRowToJson).toList(),
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
      // Yang masih Isar: achievements + quranBookmarks (bookmark schema masih
      // orphan; data quran bookmark aktif di Drift, tapi legacy Isar tabel
      // ada untuk import backup lama).
      await isar.achievements.clear();
      await isar.quranBookmarks.clear();

      for (final m in payload.collections['achievements'] ?? const []) {
        await isar.achievements.put(_achievementFromJson(m));
      }
      for (final m in payload.collections['quranBookmarks'] ?? const []) {
        await isar.quranBookmarks.put(_bookmarkFromJson(m));
      }
    });

    // Muhasabah tags/entries/scores/streaks kini di Drift.
    await db.transaction(() async {
      await db.delete(db.muhasabahEntriesTable).go();
      await db.delete(db.dailyScoresTable).go();
      await db.delete(db.streaksTable).go();
      await db.delete(db.muhasabahTagsTable).go();

      for (final m in payload.collections['muhasabahTags'] ?? const []) {
        await db.into(db.muhasabahTagsTable).insertOnConflictUpdate(
              MuhasabahTagsTableCompanion.insert(
                slug: m['slug'] as String,
                name: m['name'] as String,
                score: m['score'] as int,
                kind: Value(m['kind'] as String? ?? 'positive'),
                iconCodePoint: Value(m['iconCodePoint'] as int?),
                isDefault: Value((m['isDefault'] as bool?) ?? false),
                createdAt: DateTime.parse(m['createdAt'] as String),
              ),
            );
      }
      for (final m in payload.collections['muhasabahEntries'] ?? const []) {
        await db.into(db.muhasabahEntriesTable).insert(
              MuhasabahEntriesTableCompanion.insert(
                dateKey: m['dateKey'] as String,
                createdAt: DateTime.parse(m['createdAt'] as String),
                tagSlug: m['tagSlug'] as String,
                tagName: m['tagName'] as String,
                tagScore: m['tagScore'] as int,
                kind: m['kind'] as String? ?? 'positive',
                note: Value(m['note'] as String?),
              ),
            );
      }
      for (final m in payload.collections['dailyScores'] ?? const []) {
        await db.into(db.dailyScoresTable).insertOnConflictUpdate(
              DailyScoresTableCompanion.insert(
                dateKey: m['dateKey'] as String,
                total: m['total'] as int,
                positiveCount: m['positiveCount'] as int,
                negativeCount: m['negativeCount'] as int,
                updatedAt: DateTime.parse(m['updatedAt'] as String),
              ),
            );
      }
      for (final m in payload.collections['streaks'] ?? const []) {
        await db.into(db.streaksTable).insertOnConflictUpdate(
              StreaksTableCompanion.insert(
                key: m['key'] as String,
                current: m['current'] as int,
                longest: m['longest'] as int,
                lastDateKey: m['lastDateKey'] as String,
              ),
            );
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

  // ----- mappers (Drift rows) -----

  Map<String, dynamic> _tagFromRowToJson(MuhasabahTagRow r) => {
        'slug': r.slug,
        'name': r.name,
        'score': r.score,
        'kind': r.kind,
        'iconCodePoint': r.iconCodePoint,
        'isDefault': r.isDefault,
        'createdAt': r.createdAt.toIso8601String(),
      };

  Map<String, dynamic> _entryFromRowToJson(MuhasabahEntryRow r) => {
        'dateKey': r.dateKey,
        'createdAt': r.createdAt.toIso8601String(),
        'tagSlug': r.tagSlug,
        'tagName': r.tagName,
        'tagScore': r.tagScore,
        'kind': r.kind,
        'note': r.note,
      };

  Map<String, dynamic> _scoreFromRowToJson(DailyScoreRow r) => {
        'dateKey': r.dateKey,
        'total': r.total,
        'positiveCount': r.positiveCount,
        'negativeCount': r.negativeCount,
        'updatedAt': r.updatedAt.toIso8601String(),
      };

  Map<String, dynamic> _streakFromRowToJson(StreakRow r) => {
        'key': r.key,
        'current': r.current,
        'longest': r.longest,
        'lastDateKey': r.lastDateKey,
      };

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
