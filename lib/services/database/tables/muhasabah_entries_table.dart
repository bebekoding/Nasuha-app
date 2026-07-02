part of '../app_database.dart';

/// Tabel entri muhasabah harian.
@DataClassName('MuhasabahEntryRow')
@TableIndex(name: 'idx_muhasabah_entries_date_key', columns: {#dateKey})
class MuhasabahEntriesTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get dateKey => text()();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get tagSlug => text()();
  TextColumn get tagName => text()();
  IntColumn get tagScore => integer()();
  TextColumn get kind => text()(); // TagKind.name
  TextColumn get note => text().nullable()();

  @override
  String get tableName => 'muhasabah_entries';
}
