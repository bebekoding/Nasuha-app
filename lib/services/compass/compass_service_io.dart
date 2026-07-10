import 'dart:async';

import 'package:flutter_compass/flutter_compass.dart';

import 'compass_service.dart';

CompassService create() => _IoCompassService();

class _IoCompassService implements CompassService {
  @override
  bool get needsPermissionGesture => false;

  @override
  Future<bool> requestPermission() async => true;

  @override
  Stream<double?> headings() {
    final source = FlutterCompass.events;
    if (source == null) return Stream<double?>.value(null);
    // Error platform (device tanpa magnetometer dsb) → null, bukan error.
    return source.map<double?>((e) => e.heading).transform(
          StreamTransformer.fromHandlers(
            handleError: (_, __, sink) => sink.add(null),
          ),
        );
  }
}
