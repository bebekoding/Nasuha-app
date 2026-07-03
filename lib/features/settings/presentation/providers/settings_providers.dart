import 'dart:async';

import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../models/user_settings.dart';
import '../../../../services/database/app_database.dart';

/// Controller preferensi user berbasis Drift (menggantikan versi Isar).
///
/// Sinkron dari luar (state = [UserSettings]) — kompatibel dengan pola
/// caller lama `state.field` dan `.update((s) => s..field = x)`. Di balik
/// layar bootstrap async: state default sebentar, lalu di-hydrate dari DB
/// begitu subscription `watchSingleOrNull()` menyala.
class SettingsController extends StateNotifier<UserSettings> {
  SettingsController(this._db) : super(UserSettings()) {
    _bootstrap();
  }

  final AppDatabase _db;
  StreamSubscription<List<UserSettingsRow>>? _sub;

  Future<void> _bootstrap() async {
    // Defensive: buang baris duplikat kalau ada (pernah kejadian di IndexedDB
    // web dari migrasi lawas). Pertahankan yg id terkecil sebagai singleton.
    await _ensureSingleton();

    // watch() + first-or-null biar aman kalau by any chance masih ada >1 row
    // (tak throw seperti watchSingleOrNull).
    _sub = _db.select(_db.userSettingsTable).watch().listen((rows) {
      if (rows.isEmpty) return;
      state = _rowToDomain(rows.first);
    });
  }

  Future<void> _ensureSingleton() async {
    final rows = await _db.select(_db.userSettingsTable).get();
    if (rows.length <= 1) return;
    // Sisakan baris pertama, hapus sisanya.
    final keepId = rows.first.id;
    await (_db.delete(_db.userSettingsTable)
          ..where((t) => t.id.isNotValue(keepId)))
        .go();
  }

  Future<void> update(UserSettings Function(UserSettings) mutate) async {
    final next = mutate(state);
    await _db.into(_db.userSettingsTable).insertOnConflictUpdate(
          UserSettingsTableCompanion.insert(
            id: const Value(1), // singleton — hindari default-implicit
            displayName: Value(next.displayName),
            photoPath: Value(next.photoPath),
            city: Value(next.city),
            lastLatitude: Value(next.lastLatitude),
            lastLongitude: Value(next.lastLongitude),
            calculationMethod: Value(next.calculationMethod),
            adhanNotifications: Value(next.adhanNotifications),
            reminderNotifications: Value(next.reminderNotifications),
            biometricLock: Value(next.biometricLock),
            cloudSync: Value(next.cloudSync),
            lastSyncAt: Value(next.lastSyncAt),
          ),
        );
    // Watch stream akan re-emit; tapi update state lokal segera biar UI
    // responsif.
    state = next;
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  static UserSettings _rowToDomain(UserSettingsRow r) => UserSettings(
        displayName: r.displayName,
        photoPath: r.photoPath,
        city: r.city,
        lastLatitude: r.lastLatitude,
        lastLongitude: r.lastLongitude,
        calculationMethod: r.calculationMethod,
        adhanNotifications: r.adhanNotifications,
        reminderNotifications: r.reminderNotifications,
        biometricLock: r.biometricLock,
        cloudSync: r.cloudSync,
        lastSyncAt: r.lastSyncAt,
      );
}

final settingsControllerProvider =
    StateNotifierProvider<SettingsController, UserSettings>((ref) {
  return SettingsController(ref.watch(appDatabaseProvider));
});
