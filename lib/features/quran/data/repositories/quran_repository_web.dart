import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/surah.dart';
import '../datasources/quran_local_datasource.dart';
import 'quran_repository.dart';

/// Stub web sementara — v1.2.1 akan mengganti bagian bookmark/favorit dengan
/// backend nyata (Drift + sqlite-wasm / IndexedDB). Konten Quran (list surah +
/// detail) tetap jalan karena datanya JSON di `assets/data/quran.json`.
class WebQuranRepository implements QuranRepository {
  WebQuranRepository(this._local);

  final QuranLocalDataSource _local;

  @override
  Future<List<SurahSummary>> getAllSurah() => _local.getAllSurah();

  @override
  Future<SurahDetail> getSurah(int number) => _local.getSurah(number);

  // TODO(v1.2.1): implementasikan pakai IndexedDB via drift_web supaya
  // bookmark/marker & favorit persist antar sesi di browser.
  @override
  Future<LastReadPosition?> getLastRead() async => null;

  @override
  Future<void> setLastRead({
    required int surahNumber,
    required int verseNumber,
    required String surahName,
  }) async {
    // no-op sampai backend web tersedia
  }

  @override
  Future<void> toggleFavorite({
    required int surahNumber,
    required int verseNumber,
    required String surahName,
  }) async {
    // no-op sampai backend web tersedia
  }
}

QuranRepository createQuranRepository(Ref ref) {
  return WebQuranRepository(ref.watch(quranLocalProvider));
}
