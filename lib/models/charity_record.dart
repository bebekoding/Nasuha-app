import 'package:isar/isar.dart';

part 'charity_record.g.dart';

@collection
class CharityRecord {
  Id id = Isar.autoIncrement;

  @Index()
  late String dateKey;

  late DateTime createdAt;
  late double amount;
  String? note;
  String? category;

  CharityRecord();
}
