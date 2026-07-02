import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'app_database.g.dart';
part 'tables/quran_bookmarks.dart';
part 'tables/user_settings_table.dart';

/// Database utama Nasuha (Drift) — menggantikan Isar bertahap untuk mendukung
/// PWA (jalan di mobile via native sqlite dan di browser via sqlite-wasm).
///
/// Setiap collection Isar akan dipindahkan satu per satu ke tabel di sini.
/// Tabel yang sudah dimigrasi (per Jul 2 2026):
///   - QuranBookmarks
///   - UserSettingsTable (singleton, id=1)
/// Belum dimigrasi (masih Isar):
///   - MuhasabahTag, MuhasabahEntry, DailyScore, Streak,
///     Achievement, CharityRecord, CachedSurah
@DriftDatabase(tables: [QuranBookmarks, UserSettingsTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_open());

  /// Untuk testing — memungkinkan inject QueryExecutor kustom (mis. in-memory).
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 2;

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
