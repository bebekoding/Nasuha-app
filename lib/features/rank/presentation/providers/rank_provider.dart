import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../muhasabah/data/repositories/muhasabah_repository.dart';
import '../../../muhasabah/presentation/providers/muhasabah_providers.dart';
import '../../data/rank_tiers.dart';

/// Net lifetime XP — the sum of every day's muhasabah score. Re-evaluates when
/// entries change.
final lifetimeXpProvider = FutureProvider<int>((ref) async {
  ref.watch(entriesForSelectedDateProvider);
  return ref.watch(muhasabahRepositoryProvider).lifetimeScore();
});

/// The user's current rank position, derived from [lifetimeXpProvider].
final rankProgressProvider = FutureProvider<RankProgress>((ref) async {
  final xp = await ref.watch(lifetimeXpProvider.future);
  return rankForXp(xp);
});
