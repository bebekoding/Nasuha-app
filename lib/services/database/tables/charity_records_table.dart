part of '../app_database.dart';

/// Tabel catatan sedekah — menggantikan model Isar `CharityRecord`.
@DataClassName('CharityRecordRow')
@TableIndex(name: 'idx_charity_records_date_key', columns: {#dateKey})
class CharityRecordsTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get dateKey => text()();
  DateTimeColumn get createdAt => dateTime()();
  RealColumn get amount => real()();
  TextColumn get note => text().nullable()();
  TextColumn get category => text().nullable()();

  @override
  String get tableName => 'charity_records';
}
