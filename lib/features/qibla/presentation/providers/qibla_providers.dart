import 'dart:async';
import 'dart:math' as math;

import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../services/location/location_service.dart';

final qiblaPositionProvider = FutureProvider<Position?>((ref) async {
  return ref.watch(locationServiceProvider).getCurrent();
});

final qiblaBearingProvider = FutureProvider<double?>((ref) async {
  final pos = await ref.watch(qiblaPositionProvider.future);
  if (pos == null) return null;
  return _bearingTo(
    pos.latitude,
    pos.longitude,
    AppConstants.kaabaLat,
    AppConstants.kaabaLng,
  );
});

final compassHeadingProvider = StreamProvider<double?>((ref) {
  final stream = FlutterCompass.events;
  if (stream == null) return Stream.value(null);
  return stream.map((event) => event.heading);
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
