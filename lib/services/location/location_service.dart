import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  /// Returns the device position, or null if unavailable.
  ///
  /// Strategy (each step guarded so the UI never hangs):
  /// 1. Ensure location service is on and permission granted.
  /// 2. Try a fresh fix with a hard [timeout].
  /// 3. On timeout/error, fall back to the last known position (instant,
  ///    works on emulators and indoors where a fresh fix may never arrive).
  Future<Position?> getCurrent({
    Duration timeout = const Duration(seconds: 12),
  }) async {
    // Hard-timeout membungkus SELURUH alur — bukan cuma getCurrentPosition.
    // Di web, requestPermission() bisa menggantung selamanya bila prompt
    // izin diabaikan/ditahan browser; tanpa outer timeout, UI (Kiblat,
    // Jadwal Sholat) ikut menggantung di state loading.
    try {
      return await _getCurrentInner().timeout(timeout);
    } on TimeoutException {
      return _lastKnown();
    } catch (_) {
      return _lastKnown();
    }
  }

  Future<Position?> _getCurrentInner() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return _lastKnown();
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return null;
    }

    try {
      return await Geolocator.getCurrentPosition(
        locationSettings:
            const LocationSettings(accuracy: LocationAccuracy.medium),
      );
    } catch (_) {
      return _lastKnown();
    }
  }

  Future<Position?> _lastKnown() async {
    try {
      return await Geolocator.getLastKnownPosition();
    } catch (_) {
      return null;
    }
  }
}

final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationService();
});
