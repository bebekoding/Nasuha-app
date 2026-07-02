import 'package:isar/isar.dart';

part 'user_settings.g.dart';

@collection
class UserSettings {
  Id id = 0; // singleton

  String? displayName;
  String? photoPath; // path foto profil lokal (di folder app), null = pakai inisial
  String? city;
  double? lastLatitude;
  double? lastLongitude;
  String calculationMethod = 'muslimWorldLeague';
  bool adhanNotifications = true;
  bool reminderNotifications = true;
  bool biometricLock = false;
  bool cloudSync = false;
  DateTime? lastSyncAt;

  UserSettings();
}
