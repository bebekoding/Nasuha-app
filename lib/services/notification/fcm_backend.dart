import 'dart:convert';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;

/// Endpoint backend Vercel yang handle FCM subscription + cron push.
/// Ganti kalau kamu deploy backend di URL lain.
const String kNasuhaBackendBase = 'https://nasuha-app.vercel.app';

/// Timezone user (IANA, mis. 'Asia/Jakarta'). Diambil dari browser via
/// `Intl.DateTimeFormat().resolvedOptions().timeZone`.
String _detectTimezone() {
  if (!kIsWeb) return DateTime.now().timeZoneName;
  try {
    // Menggunakan intl DateFormat fallback — safe default.
    final offset = DateTime.now().timeZoneOffset;
    final h = offset.inHours;
    final m = offset.inMinutes % 60;
    final sign = h >= 0 ? '+' : '-';
    return 'UTC$sign${h.abs().toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
  } catch (_) {
    return 'UTC';
  }
}

/// POST subscribe FCM token + jadwal user ke backend Vercel.
///
/// Backend akan simpan token + lat/lng/calcMethod, lalu cron akan hitung
/// jadwal per menit dan kirim FCM push saat waktu adzan.
///
/// Return true bila subscribe berhasil.
Future<bool> subscribeToBackendPush({
  required String fcmToken,
  required double lat,
  required double lng,
  required String calcMethod,
}) async {
  try {
    final resp = await http.post(
      Uri.parse('$kNasuhaBackendBase/api/subscribe'),
      headers: {'content-type': 'application/json'},
      body: jsonEncode({
        'fcmToken': fcmToken,
        'lat': lat,
        'lng': lng,
        'calcMethod': calcMethod,
        'timezone': _detectTimezone(),
        'subscribedAt': DateTime.now().toIso8601String(),
      }),
    );
    return resp.statusCode >= 200 && resp.statusCode < 300;
  } catch (_) {
    return false;
  }
}

/// Unsubscribe FCM token dari backend (dipanggil saat user matikan notif).
Future<bool> unsubscribeFromBackendPush(String fcmToken) async {
  try {
    final resp = await http.post(
      Uri.parse('$kNasuhaBackendBase/api/unsubscribe'),
      headers: {'content-type': 'application/json'},
      body: jsonEncode({'fcmToken': fcmToken}),
    );
    return resp.statusCode >= 200 && resp.statusCode < 300;
  } catch (_) {
    return false;
  }
}
