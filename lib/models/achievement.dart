import 'package:isar/isar.dart';

part 'achievement.g.dart';

@collection
class Achievement {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String code;

  late String title;
  late String description;
  late int targetValue;
  late int currentValue;
  DateTime? unlockedAt;

  Achievement();

  bool get isUnlocked => unlockedAt != null;
}
