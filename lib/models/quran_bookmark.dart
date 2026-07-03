/// Bookmark Al-Quran (plain Dart, backup-only) — data aktif ada di tabel
/// Drift `QuranBookmarks`. Kelas ini dipertahankan hanya untuk pola
/// serialize backup lama.
class QuranBookmark {
  QuranBookmark({
    this.id = 0,
    this.surahNumber = 0,
    this.verseNumber = 0,
    this.surahName = '',
    this.note,
    DateTime? createdAt,
    this.isLastRead = false,
  }) : createdAt = createdAt ?? DateTime.now();

  int id;
  int surahNumber;
  int verseNumber;
  String surahName;
  String? note;
  DateTime createdAt;
  bool isLastRead;
}
