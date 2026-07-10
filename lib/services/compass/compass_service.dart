import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'compass_service_io.dart'
    if (dart.library.js_interop) 'compass_service_web.dart' as impl;

/// Sumber heading kompas lintas platform.
///
/// - Mobile/desktop native: `flutter_compass` (magnetometer).
/// - Web: DeviceOrientation API (`deviceorientationabsolute` di
///   Android/Chrome, `webkitCompassHeading` di iOS Safari). Desktop
///   browser umumnya tanpa sensor → stream emit `null` → UI fallback
///   mode statis.
///
/// Kontrak penting: stream TIDAK pernah error — kegagalan platform
/// (MissingPluginException dsb) dipetakan jadi `null` supaya UI cukup
/// menangani satu kasus: "heading tidak tersedia".
abstract class CompassService {
  /// Heading derajat searah jarum jam dari utara (0–360), atau `null`
  /// bila sensor tidak tersedia. Emit `null` lebih dulu sebagai seed
  /// supaya consumer tidak menggantung di state loading.
  Stream<double?> headings();

  /// iOS Safari 13+ mewajibkan `DeviceOrientationEvent.requestPermission()`
  /// dari user gesture sebelum event mengalir.
  bool get needsPermissionGesture;

  /// Minta izin sensor (harus dipanggil dari tap handler di web-iOS).
  /// Platform lain langsung `true`.
  Future<bool> requestPermission();
}

CompassService createCompassService() => impl.create();

final compassServiceProvider =
    Provider<CompassService>((ref) => createCompassService());
