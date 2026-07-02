part of '../app_database.dart';

/// Tabel singleton preferensi user (id selalu = 1).
///
/// Row class di-alias jadi `UserSettingsRow` supaya beda dari kelas domain
/// `UserSettings` yang dipakai UI di `lib/models/user_settings.dart`.
@DataClassName('UserSettingsRow')
class UserSettingsTable extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();

  TextColumn get displayName => text().nullable()();
  TextColumn get photoPath => text().nullable()();
  TextColumn get city => text().nullable()();
  RealColumn get lastLatitude => real().nullable()();
  RealColumn get lastLongitude => real().nullable()();
  TextColumn get calculationMethod =>
      text().withDefault(const Constant('muslimWorldLeague'))();
  BoolColumn get adhanNotifications =>
      boolean().withDefault(const Constant(true))();
  BoolColumn get reminderNotifications =>
      boolean().withDefault(const Constant(true))();
  BoolColumn get biometricLock =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get cloudSync => boolean().withDefault(const Constant(false))();
  DateTimeColumn get lastSyncAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  String get tableName => 'user_settings';
}
