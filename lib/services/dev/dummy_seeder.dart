import 'dart:math';

import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/extensions/date_extensions.dart';
import '../../models/muhasabah_tag.dart';
import '../database/app_database.dart';

/// DEV-ONLY: fills the database with ~45 days of plausible muhasabah/sedekah
/// data. Semua tulis ke Drift (Isar tak lagi menyimpan tags/entries/scores).
class DummySeeder {
  DummySeeder(this._db);
  final AppDatabase _db;

  static const _days = 45;

  Future<void> seed() async {
    // Load tags dari Drift
    final tagRows = await _db.select(_db.muhasabahTagsTable).get();
    if (tagRows.isEmpty) return;
    final positive = tagRows
        .where((t) => t.kind == TagKind.positive.name)
        .toList();
    final negative = tagRows
        .where((t) => t.kind == TagKind.negative.name)
        .toList();
    if (positive.isEmpty) return;

    final rng = Random(42);
    final now = DateTime.now();

    // Clear existing journal data via Drift
    await _db.delete(_db.muhasabahEntriesTable).go();
    await _db.delete(_db.dailyScoresTable).go();
    await _db.delete(_db.streaksTable).go();
    await _db.delete(_db.charityRecordsTable).go();

    MuhasabahTagRow bySlug(String s) =>
        positive.firstWhere((t) => t.slug == s, orElse: () => positive.first);

    await _db.transaction(() async {
      for (var d = _days - 1; d >= 0; d--) {
        final day = now.subtract(Duration(days: d));
        final dateKey = day.isoDate;

        final progress = (_days - d) / _days;
        final goodChance = 0.45 + 0.45 * progress;

        final chosen = <MuhasabahTagRow>[];
        for (final slug in const [
          'sholat_subuh',
          'sholat_dzuhur',
          'sholat_ashar',
          'sholat_maghrib',
          'sholat_isya',
        ]) {
          if (rng.nextDouble() < goodChance) chosen.add(bySlug(slug));
        }
        for (final slug in const [
          'baca_quran',
          'dzikir_pagi',
          'dzikir_petang',
          'tahajud',
          'sedekah',
          'belajar',
          'olahraga',
        ]) {
          if (rng.nextDouble() < goodChance * 0.7) {
            final match = positive.where((t) => t.slug == slug);
            if (match.isNotEmpty) chosen.add(match.first);
          }
        }

        final negChosen = <MuhasabahTagRow>[];
        for (final t in negative) {
          if (t.slug == 'tidak_sholat_fardu') continue;
          if (rng.nextDouble() < (1 - goodChance) * 0.25) {
            negChosen.add(t);
          }
        }

        final prayersDone = chosen
            .where((t) => t.slug.startsWith('sholat_'))
            .map((t) => t.slug)
            .toSet()
            .length;
        final missed = 5 - prayersDone;
        final missedTag = negative.where((t) => t.slug == 'tidak_sholat_fardu');

        int total = 0;
        int posCount = 0;
        int negCount = 0;

        DateTime stamp(int hour) =>
            DateTime(day.year, day.month, day.day, hour, rng.nextInt(59));

        for (final t in chosen) {
          await _db.into(_db.muhasabahEntriesTable).insert(
                MuhasabahEntriesTableCompanion.insert(
                  dateKey: dateKey,
                  createdAt: stamp(5 + rng.nextInt(17)),
                  tagSlug: t.slug,
                  tagName: t.name,
                  tagScore: t.score,
                  kind: TagKind.positive.name,
                ),
              );
          total += t.score;
          posCount++;
        }
        for (final t in negChosen) {
          await _db.into(_db.muhasabahEntriesTable).insert(
                MuhasabahEntriesTableCompanion.insert(
                  dateKey: dateKey,
                  createdAt: stamp(8 + rng.nextInt(14)),
                  tagSlug: t.slug,
                  tagName: t.name,
                  tagScore: t.score,
                  kind: TagKind.negative.name,
                ),
              );
          total += t.score;
          negCount++;
        }
        if (missedTag.isNotEmpty && missed > 0) {
          final mt = missedTag.first;
          for (var i = 0; i < missed; i++) {
            await _db.into(_db.muhasabahEntriesTable).insert(
                  MuhasabahEntriesTableCompanion.insert(
                    dateKey: dateKey,
                    createdAt: stamp(22),
                    tagSlug: mt.slug,
                    tagName: mt.name,
                    tagScore: mt.score,
                    kind: TagKind.negative.name,
                    note: const Value('__auto__'),
                  ),
                );
            total += mt.score;
            negCount++;
          }
        }

        await _db.into(_db.dailyScoresTable).insertOnConflictUpdate(
              DailyScoresTableCompanion.insert(
                dateKey: dateKey,
                total: total,
                positiveCount: posCount,
                negativeCount: negCount,
                updatedAt: day,
              ),
            );

        // Sedekah on ~40% of days
        if (rng.nextDouble() < 0.4) {
          final amount = (rng.nextInt(20) + 1) * 5000.0;
          await _db.into(_db.charityRecordsTable).insert(
                CharityRecordsTableCompanion.insert(
                  dateKey: dateKey,
                  createdAt: stamp(12),
                  amount: amount,
                  note: Value(rng.nextBool() ? 'Infaq masjid' : null),
                ),
              );
        }
      }

      // Streak — count consecutive days up to today with any entry
      var streakCount = 0;
      for (var d = 0; d < _days; d++) {
        final day = now.subtract(Duration(days: d));
        final has = await (_db.select(_db.dailyScoresTable)
              ..where((t) => t.dateKey.equals(day.isoDate))
              ..limit(1))
            .getSingleOrNull();
        if (has == null) break;
        streakCount++;
      }
      await _db.into(_db.streaksTable).insertOnConflictUpdate(
            StreaksTableCompanion.insert(
              key: 'muhasabah',
              current: streakCount,
              longest: max(streakCount, 30),
              lastDateKey: now.isoDate,
            ),
          );
    });
  }
}

final dummySeederProvider = Provider<DummySeeder>((ref) {
  return DummySeeder(ref.watch(appDatabaseProvider));
});
