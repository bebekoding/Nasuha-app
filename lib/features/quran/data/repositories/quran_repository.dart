import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import '../../../../models/quran_bookmark.dart';
import '../../../../services/isar/isar_service.dart';
import '../../domain/entities/surah.dart';
import '../datasources/quran_local_datasource.dart';

class QuranRepository {
  QuranRepository(this._local, this._isarService);

  final QuranLocalDataSource _local;
  final IsarService _isarService;
  Isar get _isar => _isarService.isar;

  Future<List<SurahSummary>> getAllSurah() => _local.getAllSurah();

  Future<SurahDetail> getSurah(int number) => _local.getSurah(number);

  // ---- Bookmarks ----
  Future<void> setLastRead({
    required int surahNumber,
    required int verseNumber,
    required String surahName,
  }) async {
    await _isar.writeTxn(() async {
      final existing = await _isar.quranBookmarks
          .filter()
          .isLastReadEqualTo(true)
          .findFirst();
      if (existing != null) {
        existing.isLastRead = false;
        await _isar.quranBookmarks.put(existing);
      }
      final b = QuranBookmark()
        ..surahNumber = surahNumber
        ..verseNumber = verseNumber
        ..surahName = surahName
        ..isLastRead = true
        ..createdAt = DateTime.now();
      await _isar.quranBookmarks.put(b);
    });
  }

  Future<QuranBookmark?> getLastRead() async {
    return _isar.quranBookmarks
        .filter()
        .isLastReadEqualTo(true)
        .findFirst();
  }

  Future<void> toggleFavorite({
    required int surahNumber,
    required int verseNumber,
    required String surahName,
  }) async {
    await _isar.writeTxn(() async {
      final existing = await _isar.quranBookmarks
          .filter()
          .surahNumberEqualTo(surahNumber)
          .verseNumberEqualTo(verseNumber)
          .isLastReadEqualTo(false)
          .findFirst();
      if (existing != null) {
        await _isar.quranBookmarks.delete(existing.id);
      } else {
        final b = QuranBookmark()
          ..surahNumber = surahNumber
          ..verseNumber = verseNumber
          ..surahName = surahName
          ..isLastRead = false
          ..createdAt = DateTime.now();
        await _isar.quranBookmarks.put(b);
      }
    });
  }
}

final quranRepositoryProvider = Provider<QuranRepository>((ref) {
  return QuranRepository(
    ref.watch(quranLocalProvider),
    ref.watch(isarServiceProvider),
  );
});

final allSurahProvider = FutureProvider<List<SurahSummary>>((ref) {
  return ref.watch(quranRepositoryProvider).getAllSurah();
});

final surahDetailProvider =
    FutureProvider.family<SurahDetail, int>((ref, number) {
  return ref.watch(quranRepositoryProvider).getSurah(number);
});

final lastReadProvider = FutureProvider<QuranBookmark?>((ref) {
  return ref.watch(quranRepositoryProvider).getLastRead();
});
