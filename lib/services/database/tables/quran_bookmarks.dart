// Bagian dari [AppDatabase] — lihat `../app_database.dart`.
part of '../app_database.dart';

/// Tabel bookmark Al-Quran (menggantikan model Isar `QuranBookmark`).
///
/// Semantik:
/// - `isLastRead = true` maksimal untuk **satu** baris (posisi terakhir dibaca).
/// - Baris lain (isLastRead = false) berperan sebagai "favorit" pada
///   ayat tertentu.
///
/// Row class di-alias jadi `QuranBookmarkRow` supaya beda dari model Isar
/// lawas `QuranBookmark` di `lib/models/quran_bookmark.dart` (yang masih
/// dipakai backup_serializer selama masa transisi).
@DataClassName('QuranBookmarkRow')
class QuranBookmarks extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get surahNumber => integer()();
  IntColumn get verseNumber => integer()();
  TextColumn get surahName => text()();
  TextColumn get note => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  BoolColumn get isLastRead => boolean().withDefault(const Constant(false))();
}
