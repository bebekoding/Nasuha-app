import 'dart:math';

import 'package:drift/drift.dart'
    show OrderingMode, OrderingTerm, Value, countAll;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/date_extensions.dart';
import '../../../../models/daily_score.dart';
import '../../../../models/muhasabah_entry.dart';
import '../../../../models/muhasabah_tag.dart';
import '../../../../models/streak.dart';
import '../../../../services/database/app_database.dart';
import '../../../achievements/data/achievement_engine.dart';

class MuhasabahRepository {
  MuhasabahRepository(this._db, this._achievements);

  final AppDatabase _db;
  final AchievementEngine _achievements;

  // ---- Tags ----

  Future<List<MuhasabahTag>> allTags() async {
    final rows = await (_db.select(_db.muhasabahTagsTable)
          ..orderBy([
            (t) => OrderingTerm(expression: t.score, mode: OrderingMode.desc)
          ]))
        .get();
    return rows.map(_tagFromRow).toList();
  }

  Stream<List<MuhasabahTag>> watchTags() {
    return _db
        .select(_db.muhasabahTagsTable)
        .watch()
        .map((rows) => rows.map(_tagFromRow).toList());
  }

  Future<void> addCustomTag({
    required String name,
    required int score,
    required TagKind kind,
  }) async {
    await _db.into(_db.muhasabahTagsTable).insert(
          MuhasabahTagsTableCompanion.insert(
            slug: 'custom_${DateTime.now().millisecondsSinceEpoch}',
            name: name,
            score: score,
            kind: Value(kind.name),
            isDefault: const Value(false),
            createdAt: DateTime.now(),
          ),
        );
  }

  Future<void> deleteTag(int id) async {
    await (_db.delete(_db.muhasabahTagsTable)
          ..where((t) => t.id.equals(id)))
        .go();
  }

  Future<MuhasabahTag?> tagBySlug(String slug) async {
    final row = await (_db.select(_db.muhasabahTagsTable)
          ..where((t) => t.slug.equals(slug))
          ..limit(1))
        .getSingleOrNull();
    return row == null ? null : _tagFromRow(row);
  }

  // ---- Entries ----

  Future<void> addEntry(MuhasabahTag tag, {String? note}) async {
    final now = DateTime.now();
    final dateKey = now.isoDate;

    await _db.transaction(() async {
      await _db.into(_db.muhasabahEntriesTable).insert(
            MuhasabahEntriesTableCompanion.insert(
              dateKey: dateKey,
              createdAt: now,
              tagSlug: tag.slug,
              tagName: tag.name,
              tagScore: tag.score,
              kind: tag.kind.name,
              note: Value(note),
            ),
          );
      await _recalcDailyScore(dateKey);
      await _updateStreak(now);
    });
    if (_prayerSlugs.contains(tag.slug)) {
      await autoSyncMissedPrayers(dateKey);
    }
    await _achievements.recomputeAll();
  }

  /// Marker note for entries created automatically when the user actually
  /// uses a related feature (reads Quran, records sedekah, opens dzikir).
  /// Unlike [_autoNote] (missed-prayer sync), these stay visible in the list.
  static const autoFeatureNote = 'auto_feature';

  /// Records [slug] once for today if it isn't already logged (manual or auto),
  /// so using a feature rewards the matching amalan without duplicating points.
  Future<void> autoLogOncePerDay(String slug) async {
    final dateKey = DateTime.now().isoDate;
    final todays = await (_db.select(_db.muhasabahEntriesTable)
          ..where((t) => t.dateKey.equals(dateKey)))
        .get();
    if (todays.any((e) => e.tagSlug == slug)) return;
    final tag = await tagBySlug(slug);
    if (tag == null) return;
    await addEntry(tag, note: autoFeatureNote);
  }

  Future<void> resetAllData() async {
    await _db.transaction(() async {
      await _db.delete(_db.muhasabahEntriesTable).go();
      await _db.delete(_db.dailyScoresTable).go();
      await _db.delete(_db.streaksTable).go();
    });
  }

  Future<void> deleteEntry(int id) async {
    final entry = await (_db.select(_db.muhasabahEntriesTable)
          ..where((t) => t.id.equals(id))
          ..limit(1))
        .getSingleOrNull();
    if (entry == null) return;
    final dateKey = entry.dateKey;
    final isPrayer = _prayerSlugs.contains(entry.tagSlug);
    await _db.transaction(() async {
      await (_db.delete(_db.muhasabahEntriesTable)
            ..where((t) => t.id.equals(id)))
          .go();
      await _recalcDailyScore(dateKey);
    });
    if (isPrayer) {
      await autoSyncMissedPrayers(dateKey);
    }
    await _achievements.recomputeAll();
  }

  Stream<List<MuhasabahEntry>> watchEntriesForDate(DateTime date) {
    return (_db.select(_db.muhasabahEntriesTable)
          ..where((t) => t.dateKey.equals(date.isoDate))
          ..orderBy([
            (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)
          ]))
        .watch()
        .map((rows) => rows.map(_entryFromRow).toList());
  }

  Stream<List<MuhasabahEntry>> watchAllEntries() {
    return (_db.select(_db.muhasabahEntriesTable)
          ..orderBy([
            (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc)
          ]))
        .watch()
        .map((rows) => rows.map(_entryFromRow).toList());
  }

  // ---- Daily score ----

  Stream<DailyScore?> watchDailyScore(DateTime date) {
    return (_db.select(_db.dailyScoresTable)
          ..where((t) => t.dateKey.equals(date.isoDate))
          ..limit(1))
        .watch()
        .map((rows) => rows.isEmpty ? null : _scoreFromRow(rows.first));
  }

  Future<DailyScore?> getDailyScore(DateTime date) async {
    final row = await (_db.select(_db.dailyScoresTable)
          ..where((t) => t.dateKey.equals(date.isoDate))
          ..limit(1))
        .getSingleOrNull();
    return row == null ? null : _scoreFromRow(row);
  }

  Future<List<DailyScore>> scoresInRange(DateTime from, DateTime to) async {
    final fromKey = from.isoDate;
    final toKey = to.isoDate;
    final rows = await (_db.select(_db.dailyScoresTable)
          ..orderBy([(t) => OrderingTerm(expression: t.dateKey)]))
        .get();
    // Filter di Dart — kunci lexicographic ordering aman untuk yyyy-MM-dd;
    // dataset tak besar sehingga acceptable.
    return rows
        .where((r) => r.dateKey.compareTo(fromKey) >= 0 &&
            r.dateKey.compareTo(toKey) <= 0)
        .map(_scoreFromRow)
        .toList();
  }

  /// For each given tagSlug, the set of dateKeys (yyyy-MM-dd) it was logged on.
  Future<Map<String, Set<String>>> habitDatesBySlug(Set<String> slugs) async {
    final entries = await _db.select(_db.muhasabahEntriesTable).get();
    final map = {for (final s in slugs) s: <String>{}};
    for (final e in entries) {
      map[e.tagSlug]?.add(e.dateKey);
    }
    return map;
  }

  Future<int> totalMuhasabahDays() async {
    final query = _db.selectOnly(_db.dailyScoresTable)..addColumns([countAll()]);
    return (await query.map((r) => r.read(countAll())).getSingle()) ?? 0;
  }

  Future<int> lifetimeScore() async {
    final rows = await _db.select(_db.dailyScoresTable).get();
    return rows.fold<int>(0, (s, d) => s + d.total);
  }

  Future<void> _recalcDailyScore(String dateKey) async {
    final entries = await (_db.select(_db.muhasabahEntriesTable)
          ..where((t) => t.dateKey.equals(dateKey)))
        .get();

    if (entries.isEmpty) {
      await (_db.delete(_db.dailyScoresTable)
            ..where((t) => t.dateKey.equals(dateKey)))
          .go();
      return;
    }

    int total = 0;
    int pos = 0;
    int neg = 0;
    for (final e in entries) {
      total += e.tagScore;
      if (e.kind == TagKind.positive.name) {
        pos++;
      } else {
        neg++;
      }
    }

    await _db.into(_db.dailyScoresTable).insertOnConflictUpdate(
          DailyScoresTableCompanion.insert(
            dateKey: dateKey,
            total: total,
            positiveCount: pos,
            negativeCount: neg,
            updatedAt: DateTime.now(),
          ),
        );
  }

  // ---- Missed-prayer auto-sync ----

  static const _prayerSlugs = {
    'sholat_subuh',
    'sholat_dzuhur',
    'sholat_ashar',
    'sholat_maghrib',
    'sholat_isya',
  };
  static const _missedSlug = 'tidak_sholat_fardu';
  static const _autoNote = '__auto__';

  Future<void> autoSyncMissedPrayers(String dateKey) async {
    final all = await (_db.select(_db.muhasabahEntriesTable)
          ..where((t) => t.dateKey.equals(dateKey)))
        .get();

    final prayersDone = all
        .where((e) => _prayerSlugs.contains(e.tagSlug))
        .map((e) => e.tagSlug)
        .toSet()
        .length;
    final target = max(0, 5 - prayersDone);

    final autoEntries = all
        .where((e) => e.tagSlug == _missedSlug && e.note == _autoNote)
        .toList();

    if (autoEntries.length == target) return;

    final tag = await tagBySlug(_missedSlug);
    if (tag == null) return;

    await _db.transaction(() async {
      if (autoEntries.length > target) {
        // Remove excess (oldest first — rows returned by select tanpa order
        // biasanya sesuai insert order; ini heuristik yang cukup baik).
        for (var i = 0; i < autoEntries.length - target; i++) {
          await (_db.delete(_db.muhasabahEntriesTable)
                ..where((t) => t.id.equals(autoEntries[i].id)))
              .go();
        }
      } else {
        for (var i = 0; i < target - autoEntries.length; i++) {
          await _db.into(_db.muhasabahEntriesTable).insert(
                MuhasabahEntriesTableCompanion.insert(
                  dateKey: dateKey,
                  createdAt: DateTime.now(),
                  tagSlug: tag.slug,
                  tagName: tag.name,
                  tagScore: tag.score,
                  kind: TagKind.negative.name,
                  note: const Value(_autoNote),
                ),
              );
        }
      }
      await _recalcDailyScore(dateKey);
    });
  }

  // ---- Streak ----

  Future<Streak> getMuhasabahStreak() async {
    final row = await (_db.select(_db.streaksTable)
          ..where((t) => t.key.equals('muhasabah'))
          ..limit(1))
        .getSingleOrNull();
    if (row != null) return _streakFromRow(row);
    return Streak(key: 'muhasabah');
  }

  Future<void> _updateStreak(DateTime now) async {
    final streak = await getMuhasabahStreak();
    final today = now.isoDate;
    if (streak.lastDateKey == today) return;

    final yesterday = now.subtract(const Duration(days: 1)).isoDate;
    if (streak.lastDateKey == yesterday) {
      streak.current += 1;
    } else {
      streak.current = 1;
    }
    if (streak.current > streak.longest) {
      streak.longest = streak.current;
    }
    streak.lastDateKey = today;

    await _db.into(_db.streaksTable).insertOnConflictUpdate(
          StreaksTableCompanion.insert(
            key: streak.key,
            current: streak.current,
            longest: streak.longest,
            lastDateKey: streak.lastDateKey,
          ),
        );
  }

  // ---- Row → domain mappers ----

  MuhasabahTag _tagFromRow(MuhasabahTagRow r) => MuhasabahTag(
        id: r.id,
        slug: r.slug,
        name: r.name,
        score: r.score,
        kind:
            r.kind == 'negative' ? TagKind.negative : TagKind.positive,
        iconCodePoint: r.iconCodePoint,
        isDefault: r.isDefault,
        createdAt: r.createdAt,
      );

  MuhasabahEntry _entryFromRow(MuhasabahEntryRow r) => MuhasabahEntry(
        id: r.id,
        dateKey: r.dateKey,
        createdAt: r.createdAt,
        tagSlug: r.tagSlug,
        tagName: r.tagName,
        tagScore: r.tagScore,
        kind:
            r.kind == 'negative' ? TagKind.negative : TagKind.positive,
        note: r.note,
      );

  DailyScore _scoreFromRow(DailyScoreRow r) => DailyScore(
        id: r.id,
        dateKey: r.dateKey,
        total: r.total,
        positiveCount: r.positiveCount,
        negativeCount: r.negativeCount,
        updatedAt: r.updatedAt,
      );

  Streak _streakFromRow(StreakRow r) => Streak(
        id: r.id,
        key: r.key,
        current: r.current,
        longest: r.longest,
        lastDateKey: r.lastDateKey,
      );
}

final muhasabahRepositoryProvider = Provider<MuhasabahRepository>((ref) {
  return MuhasabahRepository(
    ref.watch(appDatabaseProvider),
    ref.watch(achievementEngineProvider),
  );
});
