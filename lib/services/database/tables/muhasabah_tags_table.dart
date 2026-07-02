part of '../app_database.dart';

/// Tabel tag muhasabah (positif + negatif + custom user).
///
/// `slug` unik lewat @UniqueKey — kalau conflict saat insert, replace.
@DataClassName('MuhasabahTagRow')
class MuhasabahTagsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get slug => text().unique()();
  TextColumn get name => text()();
  IntColumn get score => integer()();
  TextColumn get kind =>
      text().withDefault(const Constant('positive'))(); // TagKind.name
  IntColumn get iconCodePoint => integer().nullable()();
  BoolColumn get isDefault =>
      boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  String get tableName => 'muhasabah_tags';
}
