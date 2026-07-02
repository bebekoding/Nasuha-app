import 'package:isar/isar.dart';

part 'quran_bookmark.g.dart';

@collection
class QuranBookmark {
  Id id = Isar.autoIncrement;

  @Index()
  late int surahNumber;
  late int verseNumber;
  late String surahName;
  String? note;
  late DateTime createdAt;
  late bool isLastRead;

  QuranBookmark();
}
