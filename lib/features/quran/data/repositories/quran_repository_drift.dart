import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../services/database/app_database.dart';
import '../../domain/entities/surah.dart';
import '../datasources/quran_local_datasource.dart';
import 'quran_repository.dart';

/// Implementasi lintas platform pakai Drift (sqlite native di mobile,
/// sqlite-wasm di web). Menggantikan implementasi Isar & stub web sebelumnya.
class DriftQuranRepository implements QuranRepository {
  DriftQuranRepository(this._local, this._db);

  final QuranLocalDataSource _local;
  final AppDatabase _db;

  @override
  Future<List<SurahSummary>> getAllSurah() => _local.getAllSurah();

  @override
  Future<SurahDetail> getSurah(int number) => _local.getSurah(number);

  @override
  Future<LastReadPosition?> getLastRead() async {
    final row = await (_db.select(_db.quranBookmarks)
          ..where((t) => t.isLastRead.equals(true))
          ..limit(1))
        .getSingleOrNull();
    if (row == null) return null;
    return LastReadPosition(
      surahNumber: row.surahNumber,
      verseNumber: row.verseNumber,
      surahName: row.surahName,
    );
  }

  @override
  Future<void> setLastRead({
    required int surahNumber,
    required int verseNumber,
    required String surahName,
  }) async {
    await _db.transaction(() async {
      // Turunkan flag isLastRead pada baris yang sebelumnya = true.
      await (_db.update(_db.quranBookmarks)
            ..where((t) => t.isLastRead.equals(true)))
          .write(const QuranBookmarksCompanion(isLastRead: Value(false)));

      // Insert baris baru sebagai posisi terakhir dibaca.
      await _db.into(_db.quranBookmarks).insert(
            QuranBookmarksCompanion.insert(
              surahNumber: surahNumber,
              verseNumber: verseNumber,
              surahName: surahName,
              createdAt: DateTime.now(),
              isLastRead: const Value(true),
            ),
          );
    });
  }

  @override
  Future<void> toggleFavorite({
    required int surahNumber,
    required int verseNumber,
    required String surahName,
  }) async {
    await _db.transaction(() async {
      final existing = await (_db.select(_db.quranBookmarks)
            ..where((t) =>
                t.surahNumber.equals(surahNumber) &
                t.verseNumber.equals(verseNumber) &
                t.isLastRead.equals(false))
            ..limit(1))
          .getSingleOrNull();
      if (existing != null) {
        await (_db.delete(_db.quranBookmarks)
              ..where((t) => t.id.equals(existing.id)))
            .go();
      } else {
        await _db.into(_db.quranBookmarks).insert(
              QuranBookmarksCompanion.insert(
                surahNumber: surahNumber,
                verseNumber: verseNumber,
                surahName: surahName,
                createdAt: DateTime.now(),
                isLastRead: const Value(false),
              ),
            );
      }
    });
  }
}

/// Factory dipanggil provider di `quran_repository.dart`.
///
/// Sekarang **satu implementasi** untuk semua platform — tidak lagi butuh
/// conditional import Isar/web-stub. File `quran_repository_isar.dart` dan
/// `quran_repository_web.dart` sudah dihapus.
QuranRepository createQuranRepository(Ref ref) {
  return DriftQuranRepository(
    ref.watch(quranLocalProvider),
    ref.watch(appDatabaseProvider),
  );
}
