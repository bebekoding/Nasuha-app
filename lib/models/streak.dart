import 'package:isar/isar.dart';

part 'streak.g.dart';

@collection
class Streak {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String key; // 'muhasabah', 'prayer', etc.

  late int current;
  late int longest;
  late String lastDateKey;

  Streak();
}
