part of '../app_database.dart';

/// Streak (hari beruntun) — key unik (mis. 'muhasabah').
@DataClassName('StreakRow')
class StreaksTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get key => text().unique()();
  IntColumn get current => integer()();
  IntColumn get longest => integer()();
  TextColumn get lastDateKey => text()();

  @override
  String get tableName => 'streaks';
}
