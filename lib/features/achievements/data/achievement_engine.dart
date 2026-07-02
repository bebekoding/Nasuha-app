import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import '../../../core/extensions/date_extensions.dart';
import '../../../models/achievement.dart';
import '../../../services/database/app_database.dart';
import '../../../services/isar/isar_service.dart';

/// Recomputes progress for every seeded achievement from current data.
///
/// Cheap enough to call on every entry/sedekah write — Isar queries on the
/// indexed `dateKey` and `tagSlug` columns return instantly for the data
/// volumes a personal journal will ever produce.
class AchievementEngine {
  AchievementEngine(this._service, this._db);
  final IsarService _service;
  final AppDatabase _db;
  Isar get _isar => _service.isar;

  static const _fivePrayers = {
    'sholat_subuh',
    'sholat_dzuhur',
    'sholat_ashar',
    'sholat_maghrib',
    'sholat_isya',
  };

  Future<void> recomputeAll() async {
    final achievements = await _isar.achievements.where().findAll();
    if (achievements.isEmpty) return;

    // Pre-fetch everything once; cheaper than 7 separate queries.
    final entries = await _db.select(_db.muhasabahEntriesTable).get();
    final charityCount = await _db
        .customSelect('SELECT COUNT(*) AS c FROM charity_records')
        .map((row) => row.read<int>('c'))
        .getSingle();

    // Group entries by date for fast lookup.
    final entriesByDate = <String, List<String>>{};
    for (final e in entries) {
      entriesByDate.putIfAbsent(e.dateKey, () => []).add(e.tagSlug);
    }

    final muhasabahDays = entriesByDate.length;
    final quranStreak = _consecutiveDayStreak(
        entriesByDate, (slugs) => slugs.contains('baca_quran'));
    final tahajudStreak = _consecutiveDayStreak(
        entriesByDate, (slugs) => slugs.contains('tahajud'));
    final fivePrayerStreak = _consecutiveDayStreak(entriesByDate,
        (slugs) => slugs.toSet().containsAll(_fivePrayers));
    final noSmokingStreak = _consecutiveDayStreakAbsence(
        entriesByDate, 'merokok');

    for (final a in achievements) {
      final newValue = switch (a.code) {
        'prayer_7' => fivePrayerStreak,
        'quran_30' => quranStreak,
        'muhasabah_100' => muhasabahDays,
        'muhasabah_365' => muhasabahDays,
        'no_smoking_30' => noSmokingStreak,
        'tahajud_7' => tahajudStreak,
        'charity_100' => charityCount,
        _ => a.currentValue,
      };
      if (newValue == a.currentValue && a.unlockedAt != null) continue;

      a.currentValue = newValue;
      if (a.unlockedAt == null && newValue >= a.targetValue) {
        a.unlockedAt = DateTime.now();
      }
      await _isar.writeTxn(() => _isar.achievements.put(a));
    }
  }

  /// Counts consecutive days **ending today** where [predicate] holds.
  int _consecutiveDayStreak(
    Map<String, List<String>> entriesByDate,
    bool Function(List<String> slugs) predicate,
  ) {
    var day = DateTime.now();
    var streak = 0;
    while (true) {
      final slugs = entriesByDate[day.isoDate];
      if (slugs == null || !predicate(slugs)) break;
      streak++;
      day = day.subtract(const Duration(days: 1));
    }
    return streak;
  }

  /// Consecutive days where the user has **at least one** entry recorded and
  /// none of those entries match [slug]. (Used for "no smoking" — a day with
  /// zero entries does not count as success, to avoid free progress from
  /// silence.)
  int _consecutiveDayStreakAbsence(
    Map<String, List<String>> entriesByDate,
    String slug,
  ) {
    var day = DateTime.now();
    var streak = 0;
    while (true) {
      final slugs = entriesByDate[day.isoDate];
      if (slugs == null || slugs.isEmpty) break;
      if (slugs.contains(slug)) break;
      streak++;
      day = day.subtract(const Duration(days: 1));
    }
    return streak;
  }
}

final achievementEngineProvider = Provider<AchievementEngine>((ref) {
  return AchievementEngine(
    ref.watch(isarServiceProvider),
    ref.watch(appDatabaseProvider),
  );
});
