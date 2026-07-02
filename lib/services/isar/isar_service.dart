import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'package:flutter/material.dart';

import '../../core/constants/seed_achievements.dart';
import '../../core/constants/seed_tags.dart';
import '../../models/achievement.dart';
import '../../models/cached_surah.dart';
import '../../models/charity_record.dart';
import '../../models/daily_score.dart';
import '../../models/muhasabah_entry.dart';
import '../../models/muhasabah_tag.dart';
import '../../models/quran_bookmark.dart';
import '../../models/streak.dart';
import '../../models/user_settings.dart';

class IsarService {
  IsarService(this.isar);

  final Isar isar;

  static const isarName = 'muhasabah';

  /// Shared schema list — used by the main open() and by background isolates
  /// (e.g. the notification action handler) so they open the same DB.
  static final List<CollectionSchema<dynamic>> schemas = [
    MuhasabahTagSchema,
    MuhasabahEntrySchema,
    DailyScoreSchema,
    CharityRecordSchema,
    AchievementSchema,
    StreakSchema,
    QuranBookmarkSchema,
    CachedSurahSchema,
    UserSettingsSchema,
  ];

  static Future<IsarService> open() async {
    final dir = await getApplicationDocumentsDirectory();
    final isar = await Isar.open(schemas, directory: dir.path, name: isarName);
    final service = IsarService(isar);
    await service._seed();
    return service;
  }

  /// Opens the same DB from a background isolate (no seeding). Returns the
  /// already-open instance if present in this isolate.
  static Future<Isar> openForIsolate() async {
    final existing = Isar.getInstance(isarName);
    if (existing != null) return existing;
    final dir = await getApplicationDocumentsDirectory();
    return Isar.open(schemas, directory: dir.path, name: isarName);
  }

  Future<void> _seed() async {
    final tagCount = await isar.muhasabahTags.count();
    if (tagCount == 0) {
      await isar.writeTxn(() async {
        for (final t in kDefaultTags) {
          final tag = MuhasabahTag.create(
            slug: t.slug,
            name: t.name,
            score: t.score,
            kind: t.kind,
            iconCodePoint: t.icon.codePoint,
          );
          await isar.muhasabahTags.put(tag);
        }
      });
    } else {
      await _migrate();
    }

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

    final settings = await isar.userSettings.get(0);
    if (settings == null) {
      await isar.writeTxn(() async {
        await isar.userSettings.put(UserSettings());
      });
    }
  }

  /// Idempotent migration — safe to run on every app start.
  Future<void> _migrate() async {
    await isar.writeTxn(() async {
      // Rename tidak_subuh → tidak_sholat_fardu
      final old = await isar.muhasabahTags
          .filter()
          .slugEqualTo('tidak_subuh')
          .findFirst();
      if (old != null) {
        old
          ..slug = 'tidak_sholat_fardu'
          ..name = 'Tidak Sholat Fardhu';
        await isar.muhasabahTags.put(old);
      }

      // Add belajar if missing
      final hasBelajar = await isar.muhasabahTags
          .filter()
          .slugEqualTo('belajar')
          .findFirst();
      if (hasBelajar == null) {
        await isar.muhasabahTags.put(MuhasabahTag.create(
          slug: 'belajar',
          name: 'Belajar',
          score: 10,
          kind: TagKind.positive,
          iconCodePoint: Icons.auto_stories.codePoint,
        ));
      }

      // Add family_time if missing
      final hasFamilyTime = await isar.muhasabahTags
          .filter()
          .slugEqualTo('family_time')
          .findFirst();
      if (hasFamilyTime == null) {
        await isar.muhasabahTags.put(MuhasabahTag.create(
          slug: 'family_time',
          name: 'Family Time',
          score: 10,
          kind: TagKind.positive,
          iconCodePoint: Icons.family_restroom.codePoint,
        ));
      }

      // Add sholat_dhuha if missing
      final hasDhuha = await isar.muhasabahTags
          .filter()
          .slugEqualTo('sholat_dhuha')
          .findFirst();
      if (hasDhuha == null) {
        await isar.muhasabahTags.put(MuhasabahTag.create(
          slug: 'sholat_dhuha',
          name: 'Sholat Dhuha',
          score: 15,
          kind: TagKind.positive,
          iconCodePoint: Icons.light_mode.codePoint,
        ));
      }
    });
  }
}

final isarServiceProvider = Provider<IsarService>((ref) {
  throw UnimplementedError('Override in main()');
});
