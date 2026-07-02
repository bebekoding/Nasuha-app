part of '../app_database.dart';

/// Ringkasan skor harian — 1 baris per hari, `dateKey` unik.
@DataClassName('DailyScoreRow')
class DailyScoresTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get dateKey => text().unique()();
  IntColumn get total => integer()();
  IntColumn get positiveCount => integer()();
  IntColumn get negativeCount => integer()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  String get tableName => 'daily_scores';
}
