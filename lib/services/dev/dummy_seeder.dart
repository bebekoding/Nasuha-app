import 'dart:math';

import 'package:drift/drift.dart' show Value;
import 'package:isar/isar.dart';

import '../../core/extensions/date_extensions.dart';
import '../../models/daily_score.dart';
import '../../models/muhasabah_entry.dart';
import '../../models/muhasabah_tag.dart';
import '../../models/streak.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/app_database.dart';
import '../isar/isar_service.dart';

/// DEV-ONLY: fills the database with ~45 days of plausible muhasabah/sedekah
/// data so analytics, streaks, heatmap, and achievements look populated for
/// review. Safe to run multiple times — it wipes prior generated data first.
///
/// Remove the call site (and ideally this file) before shipping.
class DummySeeder {
  DummySeeder(this._service, this._db);
  final IsarService _service;
  final AppDatabase _db;
  Isar get _isar => _service.isar;

  static const _days = 45;

  Future<void> seed() async {
    final tags = await _isar.muhasabahTags.where().findAll();
    final positive =
        tags.where((t) => t.kind == TagKind.positive).toList();
    final negative =
        tags.where((t) => t.kind == TagKind.negative).toList();
    if (positive.isEmpty) return;

    final rng = Random(42); // deterministic
    final now = DateTime.now();

    // Buffer sedekah — Drift & Isar tak bisa share transaction; flush setelah.
    final pendingCharity =
        <({String dateKey, DateTime createdAt, double amount, String? note})>[];

    await _isar.writeTxn(() async {
      // Clear existing journal data (keep tags & achievements definitions)
      await _isar.muhasabahEntrys.clear();
      await _isar.dailyScores.clear();
      // charity_records dipindah ke Drift — clear di luar tx Isar (di bawah)
      await _isar.streaks.clear();

      MuhasabahTag bySlug(String s) =>
          positive.firstWhere((t) => t.slug == s, orElse: () => positive.first);

      for (var d = _days - 1; d >= 0; d--) {
        final day = now.subtract(Duration(days: d));
        final dateKey = day.isoDate;

        // "Quality" of the day rises over time to create an upward trend.
        final progress = (_days - d) / _days; // 0..1
        final goodChance = 0.45 + 0.45 * progress;

        final chosen = <MuhasabahTag>[];

        // Prayers — more consistent on better days
        for (final slug in const [
          'sholat_subuh',
          'sholat_dzuhur',
          'sholat_ashar',
          'sholat_maghrib',
          'sholat_isya',
        ]) {
          if (rng.nextDouble() < goodChance) chosen.add(bySlug(slug));
        }

        // Sunnah / habits
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

        // Occasional negatives (less likely on better days)
        final negChosen = <MuhasabahTag>[];
        for (final t in negative) {
          if (t.slug == 'tidak_sholat_fardu') continue; // auto-derived
          if (rng.nextDouble() < (1 - goodChance) * 0.25) {
            negChosen.add(t);
          }
        }

        // Auto missed-prayer entries
        final prayersDone = chosen
            .where((t) => t.slug.startsWith('sholat_'))
            .map((t) => t.slug)
            .toSet()
            .length;
        final missed = 5 - prayersDone;
        final missedTag =
            negative.where((t) => t.slug == 'tidak_sholat_fardu');

        int total = 0;
        int posCount = 0;
        int negCount = 0;

        DateTime stamp(int hour) => DateTime(
            day.year, day.month, day.day, hour, rng.nextInt(59));

        for (final t in chosen) {
          await _isar.muhasabahEntrys.put(MuhasabahEntry()
            ..dateKey = dateKey
            ..createdAt = stamp(5 + rng.nextInt(17))
            ..tagSlug = t.slug
            ..tagName = t.name
            ..tagScore = t.score
            ..kind = TagKind.positive);
          total += t.score;
          posCount++;
        }
        for (final t in negChosen) {
          await _isar.muhasabahEntrys.put(MuhasabahEntry()
            ..dateKey = dateKey
            ..createdAt = stamp(8 + rng.nextInt(14))
            ..tagSlug = t.slug
            ..tagName = t.name
            ..tagScore = t.score
            ..kind = TagKind.negative);
          total += t.score;
          negCount++;
        }
        if (missedTag.isNotEmpty && missed > 0) {
          final mt = missedTag.first;
          for (var i = 0; i < missed; i++) {
            await _isar.muhasabahEntrys.put(MuhasabahEntry()
              ..dateKey = dateKey
              ..createdAt = stamp(22)
              ..tagSlug = mt.slug
              ..tagName = mt.name
              ..tagScore = mt.score
              ..kind = TagKind.negative
              ..note = '__auto__');
            total += mt.score;
            negCount++;
          }
        }

        await _isar.dailyScores.put(DailyScore()
          ..dateKey = dateKey
          ..total = total
          ..positiveCount = posCount
          ..negativeCount = negCount
          ..updatedAt = day);

        // Sedekah on ~40% of days (di-buffer, di-flush ke Drift setelah tx)
        if (rng.nextDouble() < 0.4) {
          final amount = (rng.nextInt(20) + 1) * 5000.0; // 5k..100k
          pendingCharity.add((
            dateKey: dateKey,
            createdAt: stamp(12),
            amount: amount,
            note: rng.nextBool() ? 'Infaq masjid' : null,
          ));
        }
      }

      // Streak — count consecutive days up to today with any entry
      var streakCount = 0;
      for (var d = 0; d < _days; d++) {
        final day = now.subtract(Duration(days: d));
        final has = await _isar.dailyScores
            .filter()
            .dateKeyEqualTo(day.isoDate)
            .findFirst();
        if (has == null) break;
        streakCount++;
      }
      await _isar.streaks.put(Streak()
        ..key = 'muhasabah'
        ..current = streakCount
        ..longest = max(streakCount, 30)
        ..lastDateKey = now.isoDate);
    });

    // Flush charity ke Drift (di luar tx Isar).
    await _db.delete(_db.charityRecordsTable).go();
    for (final c in pendingCharity) {
      await _db.into(_db.charityRecordsTable).insert(
            CharityRecordsTableCompanion.insert(
              dateKey: c.dateKey,
              createdAt: c.createdAt,
              amount: c.amount,
              note: Value(c.note),
            ),
          );
    }
  }
}

final dummySeederProvider = Provider<DummySeeder>((ref) {
  return DummySeeder(
    ref.watch(isarServiceProvider),
    ref.watch(appDatabaseProvider),
  );
});
