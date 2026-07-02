import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import '../../../../core/extensions/date_extensions.dart';
import '../../../../models/daily_score.dart';
import '../../../../models/muhasabah_entry.dart';
import '../../../../models/muhasabah_tag.dart';
import '../../../../models/streak.dart';
import '../../../../services/isar/isar_service.dart';
import '../../../achievements/data/achievement_engine.dart';

class MuhasabahRepository {
  MuhasabahRepository(this._service, this._achievements);

  final IsarService _service;
  final AchievementEngine _achievements;
  Isar get _isar => _service.isar;

  // ---- Tags ----
  Future<List<MuhasabahTag>> allTags() =>
      _isar.muhasabahTags.where().sortByScoreDesc().findAll();

  Stream<List<MuhasabahTag>> watchTags() =>
      _isar.muhasabahTags.where().watch(fireImmediately: true);

  Future<void> addCustomTag({
    required String name,
    required int score,
    required TagKind kind,
  }) async {
    final tag = MuhasabahTag.create(
      slug: 'custom_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      score: score,
      kind: kind,
      isDefault: false,
    );
    await _isar.writeTxn(() => _isar.muhasabahTags.put(tag));
  }

  Future<void> deleteTag(int id) =>
      _isar.writeTxn(() => _isar.muhasabahTags.delete(id));

  // ---- Entries ----
  Future<void> addEntry(MuhasabahTag tag, {String? note}) async {
    final now = DateTime.now();
    final entry = MuhasabahEntry()
      ..dateKey = now.isoDate
      ..createdAt = now
      ..tagSlug = tag.slug
      ..tagName = tag.name
      ..tagScore = tag.score
      ..kind = tag.kind
      ..note = note;

    await _isar.writeTxn(() async {
      await _isar.muhasabahEntrys.put(entry);
      await _recalcDailyScore(now.isoDate);
      await _updateStreak(now);
    });
    if (_prayerSlugs.contains(tag.slug)) {
      await autoSyncMissedPrayers(now.isoDate);
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
    final todays =
        await _isar.muhasabahEntrys.filter().dateKeyEqualTo(dateKey).findAll();
    if (todays.any((e) => e.tagSlug == slug)) return;
    final tag =
        await _isar.muhasabahTags.filter().slugEqualTo(slug).findFirst();
    if (tag == null) return;
    await addEntry(tag, note: autoFeatureNote);
  }

  Future<void> resetAllData() => _isar.writeTxn(() async {
        await _isar.muhasabahEntrys.clear();
        await _isar.dailyScores.clear();
        await _isar.streaks.clear();
      });

  Future<void> deleteEntry(int id) async {
    final entry = await _isar.muhasabahEntrys.get(id);
    if (entry == null) return;
    final dateKey = entry.dateKey;
    final isPrayer = _prayerSlugs.contains(entry.tagSlug);
    await _isar.writeTxn(() async {
      await _isar.muhasabahEntrys.delete(id);
      await _recalcDailyScore(dateKey);
    });
    if (isPrayer) {
      await autoSyncMissedPrayers(dateKey);
    }
    await _achievements.recomputeAll();
  }

  Stream<List<MuhasabahEntry>> watchEntriesForDate(DateTime date) {
    return _isar.muhasabahEntrys
        .filter()
        .dateKeyEqualTo(date.isoDate)
        .sortByCreatedAtDesc()
        .watch(fireImmediately: true);
  }

  Stream<List<MuhasabahEntry>> watchAllEntries() => _isar.muhasabahEntrys
      .where()
      .sortByCreatedAtDesc()
      .watch(fireImmediately: true);

  // ---- Daily score ----
  Stream<DailyScore?> watchDailyScore(DateTime date) {
    return _isar.dailyScores
        .filter()
        .dateKeyEqualTo(date.isoDate)
        .watch(fireImmediately: true)
        .map((list) => list.isEmpty ? null : list.first);
  }

  Future<DailyScore?> getDailyScore(DateTime date) async {
    final list = await _isar.dailyScores
        .filter()
        .dateKeyEqualTo(date.isoDate)
        .findAll();
    return list.isEmpty ? null : list.first;
  }

  Future<List<DailyScore>> scoresInRange(DateTime from, DateTime to) {
    return _isar.dailyScores
        .filter()
        .dateKeyBetween(from.isoDate, to.isoDate)
        .sortByDateKey()
        .findAll();
  }

  /// For each given tagSlug, the set of dateKeys (yyyy-MM-dd) it was logged on.
  /// Used by analytics to compute per-habit streaks.
  Future<Map<String, Set<String>>> habitDatesBySlug(Set<String> slugs) async {
    final entries = await _isar.muhasabahEntrys.where().findAll();
    final map = {for (final s in slugs) s: <String>{}};
    for (final e in entries) {
      map[e.tagSlug]?.add(e.dateKey);
    }
    return map;
  }

  /// Total number of distinct days the user has logged anything.
  Future<int> totalMuhasabahDays() => _isar.dailyScores.count();

  /// Lifetime sum of all daily scores.
  Future<int> lifetimeScore() async {
    final all = await _isar.dailyScores.where().findAll();
    return all.fold<int>(0, (s, d) => s + d.total);
  }

  Future<void> _recalcDailyScore(String dateKey) async {
    final entries = await _isar.muhasabahEntrys
        .filter()
        .dateKeyEqualTo(dateKey)
        .findAll();

    if (entries.isEmpty) {
      final existing = await _isar.dailyScores
          .filter()
          .dateKeyEqualTo(dateKey)
          .findFirst();
      if (existing != null) await _isar.dailyScores.delete(existing.id);
      return;
    }

    int total = 0;
    int pos = 0;
    int neg = 0;
    for (final e in entries) {
      total += e.tagScore;
      if (e.kind == TagKind.positive) {
        pos++;
      } else {
        neg++;
      }
    }

    final existing =
        await _isar.dailyScores.filter().dateKeyEqualTo(dateKey).findFirst();
    final score = existing ?? DailyScore()
      ..dateKey = dateKey;
    score
      ..total = total
      ..positiveCount = pos
      ..negativeCount = neg
      ..updatedAt = DateTime.now();
    await _isar.dailyScores.put(score);
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

  /// Ensures the number of auto-generated "tidak_sholat_fardu" entries for
  /// [dateKey] matches (5 − prayers completed that day).
  /// Manual entries (note ≠ __auto__) are never touched.
  Future<void> autoSyncMissedPrayers(String dateKey) async {
    final all = await _isar.muhasabahEntrys
        .filter()
        .dateKeyEqualTo(dateKey)
        .findAll();

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

    final tag = await _isar.muhasabahTags
        .filter()
        .slugEqualTo(_missedSlug)
        .findFirst();
    if (tag == null) return;

    await _isar.writeTxn(() async {
      if (autoEntries.length > target) {
        // Remove excess (oldest first)
        for (var i = 0; i < autoEntries.length - target; i++) {
          await _isar.muhasabahEntrys.delete(autoEntries[i].id);
        }
      } else {
        // Add missing
        for (var i = 0; i < target - autoEntries.length; i++) {
          final entry = MuhasabahEntry()
            ..dateKey = dateKey
            ..createdAt = DateTime.now()
            ..tagSlug = tag.slug
            ..tagName = tag.name
            ..tagScore = tag.score
            ..kind = TagKind.negative
            ..note = _autoNote;
          await _isar.muhasabahEntrys.put(entry);
        }
      }
      await _recalcDailyScore(dateKey);
    });
  }

  // ---- Streak ----
  Future<Streak> getMuhasabahStreak() async {
    final existing =
        await _isar.streaks.filter().keyEqualTo('muhasabah').findFirst();
    return existing ?? (Streak()
      ..key = 'muhasabah'
      ..current = 0
      ..longest = 0
      ..lastDateKey = '');
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
    await _isar.streaks.put(streak);
  }
}

final muhasabahRepositoryProvider = Provider<MuhasabahRepository>((ref) {
  return MuhasabahRepository(
    ref.watch(isarServiceProvider),
    ref.watch(achievementEngineProvider),
  );
});
