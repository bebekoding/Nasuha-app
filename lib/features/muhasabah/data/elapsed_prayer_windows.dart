import 'package:adhan/adhan.dart' as adhan;

import '../../../services/database/app_database.dart';

/// Nama tag yang dianggap "tidak sholat fardhu" auto.
const _prayerCount = 5;

/// Menghitung berapa jendela waktu sholat fardhu di [dateKey] yang SUDAH
/// tertutup relatif [now]. Range 0..5.
///
/// Aturan window (Syafi'i-friendly, ringkas):
///   - Subuh   → tertutup saat sunrise
///   - Dzuhur  → tertutup saat asr
///   - Ashar   → tertutup saat maghrib
///   - Maghrib → tertutup saat isya
///   - Isya    → tertutup di pergantian hari (mulai dateKey berikutnya)
///
/// Kalau [dateKey] < today → return 5 (semua window sudah lewat).
/// Kalau [dateKey] > today → return 0.
/// Kalau [dateKey] == today tapi lat/lng belum tersimpan → return 0
/// (konservatif: jangan hukum user selama posisi belum diketahui).
Future<int> elapsedPrayerWindows(
  AppDatabase db,
  String dateKey,
  DateTime now,
) async {
  final today = _isoDate(now);
  final cmp = dateKey.compareTo(today);
  if (cmp < 0) return _prayerCount;
  if (cmp > 0) return 0;

  final settings =
      await (db.select(db.userSettingsTable)..limit(1)).getSingleOrNull();
  final lat = settings?.lastLatitude;
  final lng = settings?.lastLongitude;
  if (lat == null || lng == null) return 0;

  final method = _methodFromName(settings?.calculationMethod);
  final params = method.getParameters();
  params.madhab = adhan.Madhab.shafi;

  final parts = dateKey.split('-');
  final dateComps = adhan.DateComponents(
    int.parse(parts[0]),
    int.parse(parts[1]),
    int.parse(parts[2]),
  );
  final coords = adhan.Coordinates(lat, lng);
  final times = adhan.PrayerTimes(coords, dateComps, params);

  var count = 0;
  if (!now.isBefore(times.sunrise)) count++; // Subuh window closed
  if (!now.isBefore(times.asr)) count++;      // Dzuhur closed
  if (!now.isBefore(times.maghrib)) count++;  // Ashar closed
  if (!now.isBefore(times.isha)) count++;     // Maghrib closed
  // Isya closes at end of day — hanya kalau dateKey < today (sudah dihandle).
  return count;
}

// Duplicate of prayer_repository's private mapper — kept local to avoid
// pulling PrayerRepository (which touches GPS + geocoding + writes settings).
adhan.CalculationMethod _methodFromName(String? name) {
  return switch (name) {
    'muslimWorldLeague' => adhan.CalculationMethod.muslim_world_league,
    'egyptian' => adhan.CalculationMethod.egyptian,
    'karachi' => adhan.CalculationMethod.karachi,
    'ummAlQura' => adhan.CalculationMethod.umm_al_qura,
    'dubai' => adhan.CalculationMethod.dubai,
    'qatar' => adhan.CalculationMethod.qatar,
    'kuwait' => adhan.CalculationMethod.kuwait,
    'singapore' => adhan.CalculationMethod.singapore,
    'turkey' => adhan.CalculationMethod.turkey,
    'tehran' => adhan.CalculationMethod.tehran,
    'northAmerica' => adhan.CalculationMethod.north_america,
    _ => adhan.CalculationMethod.muslim_world_league,
  };
}

String _isoDate(DateTime d) =>
    '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
