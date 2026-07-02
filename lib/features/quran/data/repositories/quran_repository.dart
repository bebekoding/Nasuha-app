import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/surah.dart';

// Pilih implementasi berdasar platform: native (Isar) untuk mobile/desktop,
// stub untuk web. Web build tidak akan pernah menyentuh Isar.
import 'quran_repository_isar.dart'
    if (dart.library.js_interop) 'quran_repository_web.dart' as impl;

/// Posisi bacaan terakhir — data class web-safe (bukan model Isar).
/// UI hanya butuh 3 field ini untuk kartu "Lanjutkan membaca".
class LastReadPosition {
  const LastReadPosition({
    required this.surahNumber,
    required this.verseNumber,
    required this.surahName,
  });

  final int surahNumber;
  final int verseNumber;
  final String surahName;
}

/// Kontrak repository Quran — dipakai UI. Implementasi dipilih via
/// conditional import: Isar untuk mobile, stub untuk web (v1.2.1 akan
/// mengganti stub dengan backend web nyata: Drift/IndexedDB).
abstract class QuranRepository {
  Future<List<SurahSummary>> getAllSurah();
  Future<SurahDetail> getSurah(int number);

  Future<LastReadPosition?> getLastRead();
  Future<void> setLastRead({
    required int surahNumber,
    required int verseNumber,
    required String surahName,
  });
  Future<void> toggleFavorite({
    required int surahNumber,
    required int verseNumber,
    required String surahName,
  });
}

final quranRepositoryProvider = Provider<QuranRepository>((ref) {
  return impl.createQuranRepository(ref);
});

final allSurahProvider = FutureProvider<List<SurahSummary>>((ref) {
  return ref.watch(quranRepositoryProvider).getAllSurah();
});

final surahDetailProvider =
    FutureProvider.family<SurahDetail, int>((ref, number) {
  return ref.watch(quranRepositoryProvider).getSurah(number);
});

final lastReadProvider = FutureProvider<LastReadPosition?>((ref) {
  return ref.watch(quranRepositoryProvider).getLastRead();
});
