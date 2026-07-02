import 'package:isar/isar.dart';

part 'cached_surah.g.dart';

/// Stored surah metadata + verses (JSON-encoded for simplicity).
@collection
class CachedSurah {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late int number;

  late String nameArabic;
  late String nameLatin;
  late String nameTranslation;
  late int verseCount;
  late String revelation;

  /// JSON-encoded list of verses (so we don't need a separate collection).
  late String versesJson;

  CachedSurah();
}
