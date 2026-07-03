import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/achievement.dart';
import '../../../services/database/app_database.dart';

class AchievementRepository {
  AchievementRepository(this._db);
  final AppDatabase _db;

  Stream<List<Achievement>> watch() {
    return _db
        .select(_db.achievementsTable)
        .watch()
        .map((rows) => rows.map(_fromRow).toList());
  }

  Achievement _fromRow(AchievementRow r) => Achievement(
        id: r.id,
        code: r.code,
        title: r.title,
        description: r.description,
        targetValue: r.targetValue,
        currentValue: r.currentValue,
        unlockedAt: r.unlockedAt,
      );
}

final achievementRepositoryProvider =
    Provider<AchievementRepository>((ref) {
  return AchievementRepository(ref.watch(appDatabaseProvider));
});

final achievementsProvider = StreamProvider<List<Achievement>>((ref) {
  return ref.watch(achievementRepositoryProvider).watch();
});
