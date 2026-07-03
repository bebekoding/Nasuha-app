import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'app_database.g.dart';
part 'tables/quran_bookmarks.dart';
part 'tables/user_settings_table.dart';
part 'tables/charity_records_table.dart';
part 'tables/muhasabah_tags_table.dart';
part 'tables/muhasabah_entries_table.dart';
part 'tables/daily_scores_table.dart';
part 'tables/streaks_table.dart';
part 'tables/achievements_table.dart';

/// Database utama Nasuha (Drift) — menggantikan Isar bertahap untuk mendukung
/// PWA (jalan di mobile via native sqlite dan di browser via sqlite-wasm).
///
/// Setiap collection Isar akan dipindahkan satu per satu ke tabel di sini.
/// Semua tabel Nasuha (per Jul 2 2026) — migrasi Isar → Drift SELESAI.
/// Isar sudah tidak dipakai lagi; runtime DB tunggal via Drift.
///   - QuranBookmarks
///   - UserSettingsTable (singleton, id=1)
///   - CharityRecordsTable
///   - MuhasabahTagsTable, MuhasabahEntriesTable, DailyScoresTable, StreaksTable
///   - AchievementsTable
@DriftDatabase(tables: [
  QuranBookmarks,
  UserSettingsTable,
  CharityRecordsTable,
  MuhasabahTagsTable,
  MuhasabahEntriesTable,
  DailyScoresTable,
  StreaksTable,
  AchievementsTable,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_open());

  /// Untuk testing — memungkinkan inject QueryExecutor kustom (mis. in-memory).
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          // Seed baris singleton settings (id=1).
          await into(userSettingsTable).insert(
            UserSettingsTableCompanion.insert(),
          );
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.createTable(userSettingsTable);
            await into(userSettingsTable).insert(
              UserSettingsTableCompanion.insert(),
            );
          }
          if (from < 3) {
            await m.createTable(charityRecordsTable);
          }
          if (from < 4) {
            await m.createTable(muhasabahTagsTable);
            await m.createTable(muhasabahEntriesTable);
            await m.createTable(dailyScoresTable);
            await m.createTable(streaksTable);
          }
          if (from < 5) {
            await m.createTable(achievementsTable);
          }
          // Indeks dateKey akan dibuat otomatis via createAll saat instalasi
          // baru; untuk upgrade dilewati (query tetap jalan tanpa indeks —
          // trade-off yang bisa diterima).
        },
      );
}

/// Pilih executor sesuai platform. `drift_flutter` otomatis pakai:
///   - iOS/Android/macOS: sqlite3_flutter_libs (native)
///   - Web: sqlite3.wasm + IndexedDB (perlu setup `sqlite3.wasm` +
///     `drift_worker.js` di folder `web/` sebelum build web)
QueryExecutor _open() {
  return driftDatabase(name: 'nasuha_db');
}

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});
