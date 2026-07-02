import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import '../../../../models/quran_bookmark.dart';
import '../../../../services/isar/isar_service.dart';
import '../../domain/entities/surah.dart';
import '../datasources/quran_local_datasource.dart';
import 'quran_repository.dart';

/// Implementasi mobile/desktop pakai Isar. Web tidak pernah meng-import file
/// ini (conditional import di `quran_repository.dart`).
class IsarQuranRepository implements QuranRepository {
  IsarQuranRepository(this._local, this._isarService);

  final QuranLocalDataSource _local;
  final IsarService _isarService;
  Isar get _isar => _isarService.isar;

  @override
  Future<List<SurahSummary>> getAllSurah() => _local.getAllSurah();

  @override
  Future<SurahDetail> getSurah(int number) => _local.getSurah(number);

  @override
  Future<LastReadPosition?> getLastRead() async {
    final b = await _isar.quranBookmarks
        .filter()
        .isLastReadEqualTo(true)
        .findFirst();
    if (b == null) return null;
    return LastReadPosition(
      surahNumber: b.surahNumber,
      verseNumber: b.verseNumber,
      surahName: b.surahName,
    );
  }

  @override
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

  @override
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

/// Factory yang dipanggil provider via conditional import.
QuranRepository createQuranRepository(Ref ref) {
  return IsarQuranRepository(
    ref.watch(quranLocalProvider),
    ref.watch(isarServiceProvider),
  );
}
