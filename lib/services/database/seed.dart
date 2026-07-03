import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';

import '../../core/constants/seed_achievements.dart';
import '../../core/constants/seed_tags.dart';
import '../../models/muhasabah_tag.dart';
import 'app_database.dart';

/// Seed data awal Drift — dipanggil dari `main()` setelah AppDatabase siap.
///
/// - Muhasabah tags: bila kosong → seed dari [kDefaultTags]. Bila sudah
///   ada → jalankan migrasi idempoten (rename slug lama, tambah tag baru).
/// - Achievements: bila kosong → seed dari [kSeedAchievements].
Future<void> seedDrift(AppDatabase db) async {
  // Muhasabah tags
  final tagCountRow = await db
      .customSelect('SELECT COUNT(*) AS c FROM muhasabah_tags')
      .getSingle();
  if (tagCountRow.read<int>('c') == 0) {
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
    await _migrateTags(db);
  }

  // Achievements
  final achCountRow = await db
      .customSelect('SELECT COUNT(*) AS c FROM achievements')
      .getSingle();
  if (achCountRow.read<int>('c') == 0) {
    for (final a in kSeedAchievements) {
      await db.into(db.achievementsTable).insertOnConflictUpdate(
            AchievementsTableCompanion.insert(
              code: a.code,
              title: a.title,
              description: a.description,
              targetValue: a.target,
            ),
          );
    }
  }
}

Future<void> _migrateTags(AppDatabase db) async {
  // 1. Rename tidak_subuh → tidak_sholat_fardu (kalau masih ada).
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
