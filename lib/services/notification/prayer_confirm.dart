import 'dart:math' as math;
import 'dart:ui' show DartPluginRegistrant;

import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:isar/isar.dart';

import '../../core/extensions/date_extensions.dart';
import '../../models/daily_score.dart';
import '../../models/muhasabah_entry.dart';
import '../../models/muhasabah_tag.dart';
import '../../models/streak.dart';
import '../isar/isar_service.dart';

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

/// Background isolate entry-point: fired when the user taps the confirm action
/// while the app is not in the foreground. Marks the prayer as done directly
/// in the database — no UI needed.
@pragma('vm:entry-point')
void prayerConfirmBackgroundHandler(NotificationResponse response) {
  if (response.actionId != kConfirmPrayerAction) return;
  handlePrayerConfirmPayload(response.payload);
}

/// Foreground handler — same logic when the app is open.
void prayerConfirmForegroundHandler(NotificationResponse response) {
  if (response.actionId != kConfirmPrayerAction) return;
  handlePrayerConfirmPayload(response.payload);
}

/// Parses a `slug|dateKey` payload and logs the prayer. Safe to call from the
/// foreground handler too.
Future<void> handlePrayerConfirmPayload(String? payload) async {
  if (payload == null || !payload.contains('|')) return;
  final parts = payload.split('|');
  if (parts.length != 2) return;
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  final isar = await IsarService.openForIsolate();
  await logPrayerConfirmed(isar, parts[0], parts[1]);
}

/// Adds the prayer entry for [dateKey] (once), then re-syncs the missed-prayer
/// auto entries, the daily score, and the streak — all in one transaction.
Future<void> logPrayerConfirmed(
    Isar isar, String slug, String dateKey) async {
  final todays =
      await isar.muhasabahEntrys.filter().dateKeyEqualTo(dateKey).findAll();
  if (todays.any((e) => e.tagSlug == slug)) return; // already done
  final tag =
      await isar.muhasabahTags.filter().slugEqualTo(slug).findFirst();
  if (tag == null) return;

  final now = DateTime.now();
  final entry = MuhasabahEntry()
    ..dateKey = dateKey
    ..createdAt = now
    ..tagSlug = tag.slug
    ..tagName = tag.name
    ..tagScore = tag.score
    ..kind = tag.kind
    ..note = 'reminder';

  await isar.writeTxn(() async {
    await isar.muhasabahEntrys.put(entry);
    await _syncMissedWithin(isar, dateKey);
    await _recalcWithin(isar, dateKey);
    await _updateStreakWithin(isar, now);
  });
}

// ── Within-transaction helpers (no nested writeTxn) ───────────────────────

Future<void> _syncMissedWithin(Isar isar, String dateKey) async {
  final all =
      await isar.muhasabahEntrys.filter().dateKeyEqualTo(dateKey).findAll();
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
      await isar.muhasabahEntrys.delete(autoMissed[i].id);
    }
  } else {
    final tag =
        await isar.muhasabahTags.filter().slugEqualTo(_missedSlug).findFirst();
    if (tag == null) return;
    for (var i = 0; i < target - autoMissed.length; i++) {
      final e = MuhasabahEntry()
        ..dateKey = dateKey
        ..createdAt = DateTime.now()
        ..tagSlug = tag.slug
        ..tagName = tag.name
        ..tagScore = tag.score
        ..kind = TagKind.negative
        ..note = _autoNote;
      await isar.muhasabahEntrys.put(e);
    }
  }
}

Future<void> _recalcWithin(Isar isar, String dateKey) async {
  final entries =
      await isar.muhasabahEntrys.filter().dateKeyEqualTo(dateKey).findAll();
  final existing =
      await isar.dailyScores.filter().dateKeyEqualTo(dateKey).findFirst();

  if (entries.isEmpty) {
    if (existing != null) await isar.dailyScores.delete(existing.id);
    return;
  }

  var total = 0, pos = 0, neg = 0;
  for (final e in entries) {
    total += e.tagScore;
    if (e.kind == TagKind.positive) {
      pos++;
    } else {
      neg++;
    }
  }
  final score = existing ?? DailyScore()
    ..dateKey = dateKey;
  score
    ..total = total
    ..positiveCount = pos
    ..negativeCount = neg;
  await isar.dailyScores.put(score);
}

Future<void> _updateStreakWithin(Isar isar, DateTime now) async {
  final today = now.isoDate;
  final streak = await isar.streaks.filter().keyEqualTo('muhasabah').findFirst() ??
      (Streak()
        ..key = 'muhasabah'
        ..current = 0
        ..longest = 0
        ..lastDateKey = '');
  if (streak.lastDateKey == today) return;
  final yesterday = now.subtract(const Duration(days: 1)).isoDate;
  streak.current = streak.lastDateKey == yesterday ? streak.current + 1 : 1;
  streak.longest = math.max(streak.longest, streak.current);
  streak.lastDateKey = today;
  await isar.streaks.put(streak);
}
