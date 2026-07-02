/// Preferensi pengguna (singleton).
///
/// **Plain Dart** (bukan lagi Isar model) — jalan di web. Data disimpan lewat
/// tabel Drift `UserSettingsTable`; controller di
/// `features/settings/presentation/providers/settings_providers.dart` yang
/// menjembatani DB ↔ state.
///
/// Kelas dibuat **mutable** biar drop-in dengan pola caller lama:
///   ref.read(settingsControllerProvider.notifier)
///      .update((s) => s..displayName = 'X');
class UserSettings {
  UserSettings({
    this.displayName,
    this.photoPath,
    this.city,
    this.lastLatitude,
    this.lastLongitude,
    this.calculationMethod = 'muslimWorldLeague',
    this.adhanNotifications = true,
    this.reminderNotifications = true,
    this.biometricLock = false,
    this.cloudSync = false,
    this.lastSyncAt,
  });

  String? displayName;
  String? photoPath;
  String? city;
  double? lastLatitude;
  double? lastLongitude;
  String calculationMethod;
  bool adhanNotifications;
  bool reminderNotifications;
  bool biometricLock;
  bool cloudSync;
  DateTime? lastSyncAt;
}
