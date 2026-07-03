import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path_provider/path_provider.dart';

/// Preferensi key: sudah pernah ditangani (dialog ditampilkan / user dismiss).
const String kLegacyIsarHandledPref = 'legacy_isar_handled_v1_2_2';

/// Preferensi key: file legacy terdeteksi (untuk trigger dialog di UI).
const String kLegacyIsarDetectedPref = 'legacy_isar_detected';

/// Nama file backup — kita rename `default.isar` ke ini agar (a) Drift tidak
/// terbentur nama, (b) tetap tersimpan buat exporter migrator masa depan.
const String kLegacyIsarBackupName = 'legacy-isar-backup.bin';

/// Cek keberadaan `default.isar` peninggalan v1.1.3.
///
/// - Kalau ada: rename ke [kLegacyIsarBackupName] supaya aman, return `true`.
/// - Kalau file backup sudah ada dari pengecekan sebelumnya: return `true`.
/// - Kalau tidak ada apa-apa: return `false`.
///
/// Web selalu return `false` (Isar tidak pernah jalan di web).
Future<bool> detectAndPreserveLegacyIsar() async {
  if (kIsWeb) return false;
  try {
    final dir = await getApplicationDocumentsDirectory();
    final backup = File('${dir.path}/$kLegacyIsarBackupName');
    if (backup.existsSync()) return true;

    final legacy = File('${dir.path}/default.isar');
    if (!legacy.existsSync()) return false;

    await legacy.rename(backup.path);
    return true;
  } catch (_) {
    // Best-effort. Kalau gagal (permission, dsb) jangan crash bootstrap.
    return false;
  }
}
