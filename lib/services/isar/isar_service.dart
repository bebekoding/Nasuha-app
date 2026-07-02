import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../../core/constants/seed_achievements.dart';
import '../../core/constants/seed_tags.dart';
import '../../models/achievement.dart';
import '../../models/cached_surah.dart';
import '../../models/muhasabah_tag.dart';
import '../../models/quran_bookmark.dart';
import '../database/app_database.dart';

/// Isar service — sekarang hanya menampung 2 koleksi yang belum bermigrasi:
///   - Achievement
///   - CachedSurah
///   - QuranBookmark **(masih di-list demi kompatibilitas Isar; data-nya
///     sudah diakses via Drift; tabel Isar-nya jadi orphan)**
///
/// Seed & migrasi tag/settings/dsb sekarang dilakukan lewat [AppDatabase]
/// (Drift). Method [seedDrift] menaruh default tags & achievements bila
/// tabel Drift muhasabah_tags kosong (dipanggil dari `main()` setelah
/// AppDatabase siap).
class IsarService {
  IsarService(this.isar);

  final Isar isar;

  static const isarName = 'muhasabah';

  static final List<CollectionSchema<dynamic>> schemas = [
    AchievementSchema,
    QuranBookmarkSchema,
    CachedSurahSchema,
  ];

  static Future<IsarService> open() async {
    final dir = await getApplicationDocumentsDirectory();
    final isar = await Isar.open(schemas, directory: dir.path, name: isarName);
    return IsarService(isar);
  }

  /// Opens the same DB from a background isolate.
  static Future<Isar> openForIsolate() async {
    final existing = Isar.getInstance(isarName);
    if (existing != null) return existing;
    final dir = await getApplicationDocumentsDirectory();
    return Isar.open(schemas, directory: dir.path, name: isarName);
  }

  /// Seed data awal di Drift (dipanggil dari main setelah AppDatabase siap).
  ///
  /// - Muhasabah tags: bila kosong → seed dari [kDefaultTags]. Bila sudah
  ///   ada → jalankan migrasi idempoten (rename slug lama, tambah tag baru).
  /// - Achievements: bila kosong → seed dari [kSeedAchievements] (masih Isar).
  Future<void> seedDrift(AppDatabase db) async {
    // Muhasabah tags via Drift
    final tagCountRow = await db
        .customSelect('SELECT COUNT(*) AS c FROM muhasabah_tags')
        .getSingle();
    final tagCount = tagCountRow.read<int>('c');

    if (tagCount == 0) {
      for (final t in kDefaultTags) {
        await db.into(db.muhasabahTagsTable).insertOnConflictUpdate(
              MuhasabahTagsTableCompanion.insert(
                slug: t.slug,
                name: t.name,
                score: t.score,
                kind: Value(t.kind.name),
                iconCodePoint: Value(t.icon.codePoint),
                createdAt: DateTime.now(),
              ),
            );
      }
    } else {
      await _migrateTagsDrift(db);
    }

    // Achievements masih di Isar.
    final achCount = await isar.achievements.count();
    if (achCount == 0) {
      await isar.writeTxn(() async {
        for (final a in kSeedAchievements) {
          final ach = Achievement()
            ..code = a.code
            ..title = a.title
            ..description = a.description
            ..targetValue = a.target
            ..currentValue = 0;
          await isar.achievements.put(ach);
        }
      });
    }
  }

  /// Migrasi idempoten tag Drift — safe dijalankan tiap startup.
  Future<void> _migrateTagsDrift(AppDatabase db) async {
    // 1. Rename tidak_subuh → tidak_sholat_fardu
    final oldSubuh = await (db.select(db.muhasabahTagsTable)
          ..where((t) => t.slug.equals('tidak_subuh'))
          ..limit(1))
        .getSingleOrNull();
    if (oldSubuh != null) {
      await (db.update(db.muhasabahTagsTable)
            ..where((t) => t.id.equals(oldSubuh.id)))
          .write(const MuhasabahTagsTableCompanion(
        slug: Value('tidak_sholat_fardu'),
        name: Value('Tidak Sholat Fardhu'),
      ));
    }

    Future<void> ensureTag(String slug, MuhasabahTag Function() build) async {
      final existing = await (db.select(db.muhasabahTagsTable)
            ..where((t) => t.slug.equals(slug))
            ..limit(1))
          .getSingleOrNull();
      if (existing != null) return;
      final t = build();
      await db.into(db.muhasabahTagsTable).insertOnConflictUpdate(
            MuhasabahTagsTableCompanion.insert(
              slug: t.slug,
              name: t.name,
              score: t.score,
              kind: Value(t.kind.name),
              iconCodePoint: Value(t.iconCodePoint),
              createdAt: DateTime.now(),
            ),
          );
    }

    await ensureTag(
        'belajar',
        () => MuhasabahTag.create(
              slug: 'belajar',
              name: 'Belajar',
              score: 10,
              kind: TagKind.positive,
              iconCodePoint: Icons.auto_stories.codePoint,
            ));
    await ensureTag(
        'family_time',
        () => MuhasabahTag.create(
              slug: 'family_time',
              name: 'Family Time',
              score: 10,
              kind: TagKind.positive,
              iconCodePoint: Icons.family_restroom.codePoint,
            ));
    await ensureTag(
        'sholat_dhuha',
        () => MuhasabahTag.create(
              slug: 'sholat_dhuha',
              name: 'Sholat Dhuha',
              score: 15,
              kind: TagKind.positive,
              iconCodePoint: Icons.light_mode.codePoint,
            ));
  }
}

final isarServiceProvider = Provider<IsarService>((ref) {
  throw UnimplementedError('Override in main()');
});
