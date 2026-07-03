part of '../app_database.dart';

/// Tabel pencapaian — `code` unik.
@DataClassName('AchievementRow')
class AchievementsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get code => text().unique()();
  TextColumn get title => text()();
  TextColumn get description => text()();
  IntColumn get targetValue => integer()();
  IntColumn get currentValue =>
      integer().withDefault(const Constant(0))();
  DateTimeColumn get unlockedAt => dateTime().nullable()();

  @override
  String get tableName => 'achievements';
}
