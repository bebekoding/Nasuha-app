import 'package:isar/isar.dart';

part 'daily_score.g.dart';

@collection
class DailyScore {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String dateKey; // yyyy-MM-dd

  late int total;
  late int positiveCount;
  late int negativeCount;
  late DateTime updatedAt;

  DailyScore();
}
