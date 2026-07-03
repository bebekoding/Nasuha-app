import 'dart:math' as math;
import 'dart:ui' show DartPluginRegistrant;

import 'package:drift/drift.dart' show Value;
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../core/extensions/date_extensions.dart';
import '../../models/muhasabah_tag.dart';
import '../database/app_database.dart';

/// Notification action id for the "✅ Sudah sholat" button.
const kConfirmPrayerAction = 'confirm_prayer';

const _missedSlug = 'tidak_sholat_fardu';
const _autoNote = '__auto__';
const _prayerSlugs = [
  'sholat_subuh',
  'sholat_dzuhur',
  'sholat_ashar',
  'sholat_maghrib',
  'sholat_isya',
];

/// Background isolate entry-point.
@pragma('vm:entry-point')
void prayerConfirmBackgroundHandler(NotificationResponse response) {
  if (response.actionId != kConfirmPrayerAction) return;
  handlePrayerConfirmPayload(response.payload);
}

void prayerConfirmForegroundHandler(NotificationResponse response) {
  if (response.actionId != kConfirmPrayerAction) return;
  handlePrayerConfirmPayload(response.payload);
}

/// Parses a `slug|dateKey` payload dan mencatat sholat ke DB (Drift).
Future<void> handlePrayerConfirmPayload(String? payload) async {
  if (payload == null || !payload.contains('|')) return;
  final parts = payload.split('|');
  if (parts.length != 2) return;
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  // Open AppDatabase di isolate — drift_flutter handles path lookup.
  final db = AppDatabase();
  try {
    await logPrayerConfirmed(db, parts[0], parts[1]);
  } finally {
    await db.close();
  }
}

Future<void> logPrayerConfirmed(
    AppDatabase db, String slug, String dateKey) async {
  final todays = await (db.select(db.muhasabahEntriesTable)
        ..where((t) => t.dateKey.equals(dateKey)))
      .get();
  if (todays.any((e) => e.tagSlug == slug)) return; // already logged
  final tag = await (db.select(db.muhasabahTagsTable)
        ..where((t) => t.slug.equals(slug))
        ..limit(1))
      .getSingleOrNull();
  if (tag == null) return;

  final now = DateTime.now();
  await db.transaction(() async {
    await db.into(db.muhasabahEntriesTable).insert(
          MuhasabahEntriesTableCompanion.insert(
            dateKey: dateKey,
            createdAt: now,
            tagSlug: tag.slug,
            tagName: tag.name,
            tagScore: tag.score,
            kind: tag.kind,
            note: const Value('reminder'),
          ),
        );
    await _syncMissedWithin(db, dateKey);
    await _recalcWithin(db, dateKey);
    await _updateStreakWithin(db, now);
  });
}

// ── Within-transaction helpers ───────────────────────

Future<void> _syncMissedWithin(AppDatabase db, String dateKey) async {
  final all = await (db.select(db.muhasabahEntriesTable)
        ..where((t) => t.dateKey.equals(dateKey)))
      .get();
  final prayersDone = all
      .where((e) => _prayerSlugs.contains(e.tagSlug))
      .map((e) => e.tagSlug)
      .toSet()
      .length;
  final target = math.max(0, 5 - prayersDone);

  final autoMissed = all
      .where((e) => e.tagSlug == _missedSlug && e.note == _autoNote)
      .toList();
  if (autoMissed.length == target) return;

  if (autoMissed.length > target) {
    for (var i = 0; i < autoMissed.length - target; i++) {
      await (db.delete(db.muhasabahEntriesTable)
            ..where((t) => t.id.equals(autoMissed[i].id)))
          .go();
    }
  } else {
    final tag = await (db.select(db.muhasabahTagsTable)
          ..where((t) => t.slug.equals(_missedSlug))
          ..limit(1))
        .getSingleOrNull();
    if (tag == null) return;
    for (var i = 0; i < target - autoMissed.length; i++) {
      await db.into(db.muhasabahEntriesTable).insert(
            MuhasabahEntriesTableCompanion.insert(
              dateKey: dateKey,
              createdAt: DateTime.now(),
              tagSlug: tag.slug,
              tagName: tag.name,
              tagScore: tag.score,
              kind: TagKind.negative.name,
              note: const Value(_autoNote),
            ),
          );
    }
  }
}

Future<void> _recalcWithin(AppDatabase db, String dateKey) async {
  final entries = await (db.select(db.muhasabahEntriesTable)
        ..where((t) => t.dateKey.equals(dateKey)))
      .get();

  if (entries.isEmpty) {
    await (db.delete(db.dailyScoresTable)
          ..where((t) => t.dateKey.equals(dateKey)))
        .go();
    return;
  }

  var total = 0, pos = 0, neg = 0;
  for (final e in entries) {
    total += e.tagScore;
    if (e.kind == TagKind.positive.name) {
      pos++;
    } else {
      neg++;
    }
  }
  // Upsert manual di dateKey (unique, bukan PK).
  final existing = await (db.select(db.dailyScoresTable)
        ..where((t) => t.dateKey.equals(dateKey))
        ..limit(1))
      .getSingleOrNull();
  if (existing != null) {
    await (db.update(db.dailyScoresTable)
          ..where((t) => t.id.equals(existing.id)))
        .write(DailyScoresTableCompanion(
      total: Value(total),
      positiveCount: Value(pos),
      negativeCount: Value(neg),
      updatedAt: Value(DateTime.now()),
    ));
  } else {
    await db.into(db.dailyScoresTable).insert(
          DailyScoresTableCompanion.insert(
            dateKey: dateKey,
            total: total,
            positiveCount: pos,
            negativeCount: neg,
            updatedAt: DateTime.now(),
          ),
        );
  }
}

Future<void> _updateStreakWithin(AppDatabase db, DateTime now) async {
  final today = now.isoDate;
  final row = await (db.select(db.streaksTable)
        ..where((t) => t.key.equals('muhasabah'))
        ..limit(1))
      .getSingleOrNull();
  var current = row?.current ?? 0;
  var longest = row?.longest ?? 0;
  final lastDateKey = row?.lastDateKey ?? '';
  if (lastDateKey == today) return;
  final yesterday = now.subtract(const Duration(days: 1)).isoDate;
  current = lastDateKey == yesterday ? current + 1 : 1;
  longest = math.max(longest, current);

  // Upsert manual di key (unique).
  if (row != null) {
    await (db.update(db.streaksTable)
          ..where((t) => t.id.equals(row.id)))
        .write(StreaksTableCompanion(
      current: Value(current),
      longest: Value(longest),
      lastDateKey: Value(today),
    ));
  } else {
    await db.into(db.streaksTable).insert(
          StreaksTableCompanion.insert(
            key: 'muhasabah',
            current: current,
            longest: longest,
            lastDateKey: today,
          ),
        );
  }
}
