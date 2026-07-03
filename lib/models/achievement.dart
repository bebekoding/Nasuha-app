/// Pencapaian (achievement/badge) — plain Dart (menggantikan @collection Isar).
///
/// Persisted lewat tabel Drift `AchievementsTable`. Mutable biar drop-in
/// dengan pola caller lama.
class Achievement {
  Achievement({
    this.id = 0,
    this.code = '',
    this.title = '',
    this.description = '',
    this.targetValue = 0,
    this.currentValue = 0,
    this.unlockedAt,
  });

  int id;
  String code;
  String title;
  String description;
  int targetValue;
  int currentValue;
  DateTime? unlockedAt;

  bool get isUnlocked => unlockedAt != null;
}
