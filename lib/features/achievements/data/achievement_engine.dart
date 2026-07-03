import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extensions/date_extensions.dart';
import '../../../services/database/app_database.dart';

/// Recomputes progress for every seeded achievement from current data.
class AchievementEngine {
  AchievementEngine(this._db);
  final AppDatabase _db;

  static const _fivePrayers = {
    'sholat_subuh',
    'sholat_dzuhur',
    'sholat_ashar',
    'sholat_maghrib',
    'sholat_isya',
  };

  Future<void> recomputeAll() async {
    final achievements = await _db.select(_db.achievementsTable).get();
    if (achievements.isEmpty) return;

    final entries = await _db.select(_db.muhasabahEntriesTable).get();
    final charityCount = await _db
        .customSelect('SELECT COUNT(*) AS c FROM charity_records')
        .map((row) => row.read<int>('c'))
        .getSingle();

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

      final unlockedAt = a.unlockedAt ??
          (newValue >= a.targetValue ? DateTime.now() : null);
      await (_db.update(_db.achievementsTable)
            ..where((t) => t.id.equals(a.id)))
          .write(AchievementsTableCompanion(
        currentValue: Value(newValue),
        unlockedAt: Value(unlockedAt),
      ));
    }
  }

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
  return AchievementEngine(ref.watch(appDatabaseProvider));
});
