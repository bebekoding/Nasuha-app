import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/surah.dart';

/// Reads the Quran payload bundled under `assets/data/quran.json`.
///
/// The bundled JSON is an array of 114 surah objects, each shaped like:
/// ```json
/// {
///   "nomor": 1,
///   "nama": "...", "namaLatin": "...", "arti": "...",
///   "jumlahAyat": 7, "tempatTurun": "Mekah",
///   "ayat": [
///     {"nomorAyat": 1, "teksArab": "...", "teksLatin": "...", "teksIndonesia": "..."}
///   ]
/// }
/// ```
class QuranLocalDataSource {
  static const String _assetPath = 'assets/data/quran.json';

  List<Map<String, dynamic>>? _cache;

  Future<List<Map<String, dynamic>>> _load() async {
    final cached = _cache;
    if (cached != null) return cached;
    final raw = await rootBundle.loadString(_assetPath);
    final decoded = (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
    _cache = decoded;
    return decoded;
  }

  Future<List<SurahSummary>> getAllSurah() async {
    final all = await _load();
    return all.map(SurahSummary.fromJson).toList();
  }

  Future<SurahDetail> getSurah(int number) async {
    final all = await _load();
    final m = all.firstWhere(
      (e) => e['nomor'] == number,
      orElse: () =>
          throw StateError('Surah nomor $number tidak ditemukan dalam aset.'),
    );
    final verses = (m['ayat'] as List)
        .cast<Map<String, dynamic>>()
        .map(Verse.fromJson)
        .toList();
    return SurahDetail(
      summary: SurahSummary.fromJson(m),
      verses: verses,
    );
  }
}

final quranLocalProvider = Provider<QuranLocalDataSource>((ref) {
  return QuranLocalDataSource();
});
