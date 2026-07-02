import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../models/daily_score.dart';
import '../../../../models/muhasabah_entry.dart';
import '../../../../models/muhasabah_tag.dart';
import '../../../../models/streak.dart';
import '../../data/repositories/muhasabah_repository.dart';

final tagsProvider = StreamProvider<List<MuhasabahTag>>((ref) {
  return ref.watch(muhasabahRepositoryProvider).watchTags();
});

final selectedDateProvider = StateProvider<DateTime>((ref) {
  final n = DateTime.now();
  return DateTime(n.year, n.month, n.day);
});

final entriesForSelectedDateProvider =
    StreamProvider<List<MuhasabahEntry>>((ref) {
  final date = ref.watch(selectedDateProvider);
  return ref
      .watch(muhasabahRepositoryProvider)
      .watchEntriesForDate(date);
});

final dailyScoreForSelectedDateProvider =
    StreamProvider<DailyScore?>((ref) {
  final date = ref.watch(selectedDateProvider);
  return ref.watch(muhasabahRepositoryProvider).watchDailyScore(date);
});

final todayScoreProvider = StreamProvider<DailyScore?>((ref) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  return ref.watch(muhasabahRepositoryProvider).watchDailyScore(today);
});

final muhasabahStreakProvider = FutureProvider<Streak>((ref) {
  // re-eval when entries change
  ref.watch(entriesForSelectedDateProvider);
  return ref.watch(muhasabahRepositoryProvider).getMuhasabahStreak();
});
