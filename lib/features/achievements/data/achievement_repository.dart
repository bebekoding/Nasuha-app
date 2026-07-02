import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import '../../../models/achievement.dart';
import '../../../services/isar/isar_service.dart';

class AchievementRepository {
  AchievementRepository(this._service);
  final IsarService _service;
  Isar get _isar => _service.isar;

  Stream<List<Achievement>> watch() =>
      _isar.achievements.where().watch(fireImmediately: true);

  Future<void> updateProgress(String code, int value) async {
    final a = await _isar.achievements.filter().codeEqualTo(code).findFirst();
    if (a == null) return;
    await _isar.writeTxn(() async {
      a.currentValue = value;
      if (a.currentValue >= a.targetValue && a.unlockedAt == null) {
        a.unlockedAt = DateTime.now();
      }
      await _isar.achievements.put(a);
    });
  }
}

final achievementRepositoryProvider =
    Provider<AchievementRepository>((ref) {
  return AchievementRepository(ref.watch(isarServiceProvider));
});

final achievementsProvider = StreamProvider<List<Achievement>>((ref) {
  return ref.watch(achievementRepositoryProvider).watch();
});
