import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../services/compass/compass_service.dart';
import '../../../../services/database/app_database.dart';
import '../../../../services/location/location_service.dart';

/// Koordinat untuk perhitungan kiblat + asal datanya.
typedef QiblaCoords = ({
  double lat,
  double lng,
  bool fromSaved,
  String? city,
});

/// Koordinat pengguna dengan fallback berlapis:
/// 1. GPS/geolocation segar (timeout 8 detik — jangan biarkan UI
///    menggantung menunggu prompt izin yang diabaikan).
/// 2. Koordinat tersimpan dari fitur Jadwal Sholat (`lastLatitude/
///    lastLongitude` di UserSettings) — kiblat tetap bisa dihitung
///    walau izin lokasi ditolak, selama user pernah buka Jadwal Sholat.
/// 3. null → UI tampilkan panduan + tombol coba lagi.
final qiblaCoordsProvider = FutureProvider<QiblaCoords?>((ref) async {
  final pos = await ref
      .watch(locationServiceProvider)
      .getCurrent(timeout: const Duration(seconds: 8));
  if (pos != null) {
    return (
      lat: pos.latitude,
      lng: pos.longitude,
      fromSaved: false,
      city: null,
    );
  }

  final db = ref.watch(appDatabaseProvider);
  final settings =
      await (db.select(db.userSettingsTable)..limit(1)).getSingleOrNull();
  final lat = settings?.lastLatitude;
  final lng = settings?.lastLongitude;
  if (lat == null || lng == null) return null;
  return (lat: lat, lng: lng, fromSaved: true, city: settings?.city);
});

final qiblaBearingProvider = FutureProvider<double?>((ref) async {
  final coords = await ref.watch(qiblaCoordsProvider.future);
  if (coords == null) return null;
  return _bearingTo(
    coords.lat,
    coords.lng,
    AppConstants.kaabaLat,
    AppConstants.kaabaLng,
  );
});

/// Heading kompas — TIDAK pernah error (service memetakan kegagalan
/// platform jadi null), jadi UI cukup menangani "null = tak ada sensor".
final compassHeadingProvider = StreamProvider<double?>((ref) {
  return ref.watch(compassServiceProvider).headings();
});

double _bearingTo(double lat1, double lon1, double lat2, double lon2) {
  final dLon = _toRad(lon2 - lon1);
  final y = math.sin(dLon) * math.cos(_toRad(lat2));
  final x = math.cos(_toRad(lat1)) * math.sin(_toRad(lat2)) -
      math.sin(_toRad(lat1)) *
          math.cos(_toRad(lat2)) *
          math.cos(dLon);
  final bearing = math.atan2(y, x);
  return (bearing * 180 / math.pi + 360) % 360;
}

double _toRad(double deg) => deg * math.pi / 180;
