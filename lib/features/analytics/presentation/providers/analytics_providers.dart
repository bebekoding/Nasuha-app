import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/date_extensions.dart';
import '../../../../models/daily_score.dart';
import '../../../muhasabah/data/repositories/muhasabah_repository.dart';

class AnalyticsSummary {
  final List<DailyScore> scores;
  final int total;
  final double average;
  final DailyScore? bestDay;
  final DailyScore? worstDay;

  const AnalyticsSummary({
    required this.scores,
    required this.total,
    required this.average,
    required this.bestDay,
    required this.worstDay,
  });
}

final analyticsRangeProvider = StateProvider<Duration>(
    (ref) => const Duration(days: 30));

final analyticsSummaryProvider =
    FutureProvider<AnalyticsSummary>((ref) async {
  final range = ref.watch(analyticsRangeProvider);
  final repo = ref.watch(muhasabahRepositoryProvider);
  final now = DateTime.now();
  final from = now.subtract(range);
  final scores = await repo.scoresInRange(from, now);
  if (scores.isEmpty) {
    return const AnalyticsSummary(
      scores: [],
      total: 0,
      average: 0,
      bestDay: null,
      worstDay: null,
    );
  }
  final total = scores.fold<int>(0, (s, x) => s + x.total);
  final avg = total / scores.length;
  scores.sort((a, b) => b.total.compareTo(a.total));
  final best = scores.first;
  final worst = scores.last;
  scores.sort((a, b) => a.dateKey.compareTo(b.dateKey));
  return AnalyticsSummary(
    scores: scores,
    total: total,
    average: avg,
    bestDay: best,
    worstDay: worst,
  );
});

final heatmapScoresProvider =
    FutureProvider<Map<String, int>>((ref) async {
  final repo = ref.watch(muhasabahRepositoryProvider);
  final now = DateTime.now();
  final from = now.subtract(const Duration(days: 365));
  final scores = await repo.scoresInRange(from, now);
  return {for (final s in scores) s.dateKey: s.total};
});

// ─────────────────────────── Streak ibadah ───────────────────────────

class HabitStreak {
  final String slug;
  final String label;
  final IconData icon;
  final int current; // streak berjalan (hari/pekan beruntun)
  final int longest;
  final int total; // total hari ber-ibadah
  final String? lastDate; // dateKey terakhir
  final bool doneToday;
  final bool weekly; // true = pola Senin-Kamis (bukan harian)

  const HabitStreak({
    required this.slug,
    required this.label,
    required this.icon,
    required this.current,
    required this.longest,
    required this.total,
    required this.lastDate,
    required this.doneToday,
    required this.weekly,
  });
}

const _habitDefs = <({String slug, String label, IconData icon, bool weekly})>[
  (slug: 'baca_quran', label: 'Baca Al-Quran', icon: Icons.menu_book, weekly: false),
  (slug: 'dzikir_pagi', label: 'Dzikir Pagi', icon: Icons.wb_sunny_outlined, weekly: false),
  (slug: 'dzikir_petang', label: 'Dzikir Petang', icon: Icons.wb_twilight, weekly: false),
  (slug: 'sholat_dhuha', label: 'Sholat Dhuha', icon: Icons.light_mode, weekly: false),
  (slug: 'tahajud', label: 'Sholat Tahajud', icon: Icons.bedtime, weekly: false),
  (slug: 'puasa_sunnah', label: 'Puasa Senin-Kamis', icon: Icons.no_food, weekly: true),
];

final habitStreaksProvider = FutureProvider<List<HabitStreak>>((ref) async {
  final repo = ref.watch(muhasabahRepositoryProvider);
  final datesBySlug =
      await repo.habitDatesBySlug({for (final h in _habitDefs) h.slug});
  final today = _dateOnly(DateTime.now());

  return [
    for (final h in _habitDefs)
      _computeStreak(h, datesBySlug[h.slug] ?? <String>{}, today),
  ];
});

DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

HabitStreak _computeStreak(
  ({String slug, String label, IconData icon, bool weekly}) h,
  Set<String> dateKeys,
  DateTime today,
) {
  final dates = dateKeys.map(DateTime.parse).map(_dateOnly).toSet();
  final last = dates.isEmpty
      ? null
      : dates.reduce((a, b) => a.isAfter(b) ? a : b).isoDate;

  int current;
  int longest;
  if (h.weekly) {
    (current, longest) = _weeklyMonThuStreak(dates, today);
  } else {
    (current, longest) = _dailyStreak(dates, today);
  }

  return HabitStreak(
    slug: h.slug,
    label: h.label,
    icon: h.icon,
    current: current,
    longest: longest,
    total: dates.length,
    lastDate: last,
    doneToday: dates.contains(today),
    weekly: h.weekly,
  );
}

/// Streak harian: hari beruntun s/d hari ini (atau kemarin bila belum
/// dikerjakan hari ini, agar streak tak putus sebelum hari berakhir).
(int, int) _dailyStreak(Set<DateTime> dates, DateTime today) {
  if (dates.isEmpty) return (0, 0);

  var cursor = today;
  if (!dates.contains(cursor)) {
    cursor = today.subtract(const Duration(days: 1));
    if (!dates.contains(cursor)) return (0, _longestRun(dates, 1));
  }
  var current = 0;
  while (dates.contains(cursor)) {
    current++;
    cursor = cursor.subtract(const Duration(days: 1));
  }
  return (current, _longestRun(dates, 1));
}

/// Run terpanjang dengan jeda [stepDays] hari antar elemen berurutan.
int _longestRun(Set<DateTime> dates, int stepDays) {
  if (dates.isEmpty) return 0;
  final sorted = dates.toList()..sort();
  var longest = 1;
  var run = 1;
  for (var i = 1; i < sorted.length; i++) {
    if (sorted[i].difference(sorted[i - 1]).inDays == stepDays) {
      run++;
    } else {
      run = 1;
    }
    if (run > longest) longest = run;
  }
  return longest;
}

/// Streak pola Senin-Kamis: hari Senin/Kamis berurutan yang terisi puasa.
(int, int) _weeklyMonThuStreak(Set<DateTime> dates, DateTime today) {
  if (dates.isEmpty) return (0, 0);

  // Daftar hari Senin/Kamis dari hari ini mundur (cukup ~1.5 tahun).
  final eligibleDesc = <DateTime>[];
  var d = today;
  for (var i = 0; i < 540; i++) {
    if (d.weekday == DateTime.monday || d.weekday == DateTime.thursday) {
      eligibleDesc.add(d);
    }
    d = d.subtract(const Duration(days: 1));
  }

  // Streak berjalan: lewati hari ini bila hari Senin/Kamis tapi belum puasa
  // (hari belum berakhir), lalu hitung yang beruntun terisi.
  var idx = 0;
  if (eligibleDesc.isNotEmpty &&
      eligibleDesc.first == today &&
      !dates.contains(today)) {
    idx = 1;
  }
  var current = 0;
  for (; idx < eligibleDesc.length; idx++) {
    if (dates.contains(eligibleDesc[idx])) {
      current++;
    } else {
      break;
    }
  }

  // Terpanjang: telusuri seluruh hari Senin/Kamis (kronologis) dalam rentang.
  final asc = eligibleDesc.reversed.toList();
  var longest = 0;
  var run = 0;
  for (final day in asc) {
    if (dates.contains(day)) {
      run++;
      if (run > longest) longest = run;
    } else {
      run = 0;
    }
  }
  return (current, longest);
}
