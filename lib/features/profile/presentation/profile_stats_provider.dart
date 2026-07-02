import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../achievements/data/achievement_repository.dart';
import '../../muhasabah/data/repositories/muhasabah_repository.dart';
import '../../muhasabah/presentation/providers/muhasabah_providers.dart';
import '../../sedekah/data/repositories/sedekah_repository.dart';

class ProfileStats {
  final int currentStreak;
  final int longestStreak;
  final int totalDays;
  final int lifetimeScore;
  final double totalCharity;
  final int charityCount;
  final int achievementsUnlocked;
  final int achievementsTotal;

  const ProfileStats({
    required this.currentStreak,
    required this.longestStreak,
    required this.totalDays,
    required this.lifetimeScore,
    required this.totalCharity,
    required this.charityCount,
    required this.achievementsUnlocked,
    required this.achievementsTotal,
  });
}

final profileStatsProvider = FutureProvider<ProfileStats>((ref) async {
  // Re-evaluate when entries change.
  ref.watch(entriesForSelectedDateProvider);

  final muhasabahRepo = ref.watch(muhasabahRepositoryProvider);
  final sedekahRepo = ref.watch(sedekahRepositoryProvider);

  final streak = await muhasabahRepo.getMuhasabahStreak();
  final totalDays = await muhasabahRepo.totalMuhasabahDays();
  final lifetime = await muhasabahRepo.lifetimeScore();
  final charity = await sedekahRepo.totalAll();
  final achievements = await ref.watch(achievementsProvider.future);

  return ProfileStats(
    currentStreak: streak.current,
    longestStreak: streak.longest,
    totalDays: totalDays,
    lifetimeScore: lifetime,
    totalCharity: charity.total,
    charityCount: charity.count,
    achievementsUnlocked: achievements.where((a) => a.isUnlocked).length,
    achievementsTotal: achievements.length,
  );
});
