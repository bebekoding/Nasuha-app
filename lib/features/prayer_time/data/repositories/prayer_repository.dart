import 'package:adhan/adhan.dart' as adhan;
import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart' as geo;

import '../../../../services/database/app_database.dart';
import '../../../../services/location/location_service.dart';
import '../../domain/entities/prayer_schedule.dart';

class PrayerRepository {
  PrayerRepository(this._location, this._db);

  final LocationService _location;
  final AppDatabase _db;

  Future<PrayerSchedule?> getTodaySchedule({String? methodOverride}) async {
    final settings = await _db.select(_db.userSettingsTable).getSingleOrNull();
    double? lat = settings?.lastLatitude;
    double? lng = settings?.lastLongitude;
    String? savedLocationName = settings?.city;

    final pos = await _location.getCurrent();
    if (pos != null) {
      final isNewPosition = lat != pos.latitude || lng != pos.longitude;
      lat = pos.latitude;
      lng = pos.longitude;

      // Only reverse-geocode if position actually changed (saves battery).
      if (isNewPosition) {
        savedLocationName = await _reverseGeocode(lat, lng);
      }

      await _db.into(_db.userSettingsTable).insertOnConflictUpdate(
            UserSettingsTableCompanion(
              id: const Value(1),
              lastLatitude: Value(lat),
              lastLongitude: Value(lng),
              city: Value(savedLocationName),
            ),
          );
    }

    if (lat == null || lng == null) return null;

    final method = _methodFromName(
        methodOverride ?? settings?.calculationMethod ?? 'muslimWorldLeague');
    final params = method.getParameters();
    params.madhab = adhan.Madhab.shafi;

    final coords = adhan.Coordinates(lat, lng);
    final times = adhan.PrayerTimes.today(coords, params);

    return PrayerSchedule(
      fajr: times.fajr,
      sunrise: times.sunrise,
      dhuhr: times.dhuhr,
      asr: times.asr,
      maghrib: times.maghrib,
      isha: times.isha,
      latitude: lat,
      longitude: lng,
      methodName: method.name,
      locationName: savedLocationName,
    );
  }

  /// Returns "Kota, Negara" or null if unavailable.
  Future<String?> _reverseGeocode(double lat, double lng) async {
    try {
      final placemarks = await geo.placemarkFromCoordinates(lat, lng);
      if (placemarks.isEmpty) return null;
      final p = placemarks.first;

      // Build a meaningful location string, using the most specific
      // available fields: subLocality → locality → subAdministrativeArea →
      // administrativeArea, then country.
      final city = p.subLocality?.isNotEmpty == true
          ? p.subLocality
          : p.locality?.isNotEmpty == true
              ? p.locality
              : p.subAdministrativeArea?.isNotEmpty == true
                  ? p.subAdministrativeArea
                  : p.administrativeArea;

      final country = p.country;

      if (city != null && country != null) return '$city, $country';
      if (city != null) return city;
      if (country != null) return country;
      return null;
    } catch (_) {
      return null;
    }
  }

  adhan.CalculationMethod _methodFromName(String name) {
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
}

final prayerRepositoryProvider = Provider<PrayerRepository>((ref) {
  return PrayerRepository(
    ref.watch(locationServiceProvider),
    ref.watch(appDatabaseProvider),
  );
});

final todayPrayerScheduleProvider =
    FutureProvider<PrayerSchedule?>((ref) async {
  return ref.watch(prayerRepositoryProvider).getTodaySchedule();
});
