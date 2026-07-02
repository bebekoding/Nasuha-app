import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import '../../../core/extensions/date_extensions.dart';
import '../../../models/muhasabah_entry.dart';
import '../../../models/user_settings.dart';
import '../../../services/isar/isar_service.dart';
import '../../../services/notification/notification_service.dart';
import '../domain/entities/prayer_schedule.dart';
import 'repositories/prayer_repository.dart';

/// Notification id ranges (deterministic so re-scheduling overwrites):
///   adhan today:    100..199    adhan tomorrow:   200..299
///   confirm today:  300..399    confirm tomorrow: 400..499
class PrayerNotificationScheduler {
  PrayerNotificationScheduler(this._prayer, this._notif, this._isarService);

  final PrayerRepository _prayer;
  final NotificationService _notif;
  final IsarService _isarService;

  Future<void> scheduleNext48h() async {
    final settings = _isarService.isar.userSettings.getSync(0) ?? UserSettings();
    await _notif.cancelAll();

    final today = await _prayer.getTodaySchedule();
    if (today == null) return;
    final now = DateTime.now();

    // ── Adhan (waktu masuk sholat) ────────────────────────────
    if (settings.adhanNotifications) {
      var id = 100;
      for (final p in _scheduleEntries(today)) {
        if (p.time.isAfter(now)) {
          await _notif.scheduleAdhan(
            id: id,
            title: 'Waktu Sholat ${p.name}',
            body: 'Sudah masuk waktu ${p.name}. Segeralah menunaikan.',
            when: p.time,
          );
        }
        id++;
      }
      id = 200;
      for (final p in _scheduleEntries(today)) {
        await _notif.scheduleAdhan(
          id: id,
          title: 'Waktu Sholat ${p.name}',
          body: 'Sudah masuk waktu ${p.name}. Segeralah menunaikan.',
          when: p.time.add(const Duration(days: 1)),
        );
        id++;
      }
    }

    // ── Konfirmasi "sudah sholat?" sebelum waktunya habis ─────
    if (settings.reminderNotifications) {
      final todayKey = now.isoDate;
      final tomorrowKey = now.add(const Duration(days: 1)).isoDate;

      var id = 300;
      for (final c in _confirmEntries(today)) {
        if (c.time.isAfter(now) && !await _isLogged(todayKey, c.slug)) {
          await _notif.schedulePrayerConfirm(
            id: id,
            prayerName: c.name,
            slug: c.slug,
            dateKey: todayKey,
            when: c.time,
          );
        }
        id++;
      }
      id = 400;
      for (final c in _confirmEntries(today)) {
        await _notif.schedulePrayerConfirm(
          id: id,
          prayerName: c.name,
          slug: c.slug,
          dateKey: tomorrowKey,
          when: c.time.add(const Duration(days: 1)),
        );
        id++;
      }
    }
  }

  Future<bool> _isLogged(String dateKey, String slug) async {
    final entries = await _isarService.isar.muhasabahEntrys
        .filter()
        .dateKeyEqualTo(dateKey)
        .findAll();
    return entries.any((e) => e.tagSlug == slug);
  }

  /// Five mandatory prayers only — skip sunrise (it's a time, not a prayer).
  Iterable<({String name, DateTime time})> _scheduleEntries(
      PrayerSchedule s) sync* {
    yield (name: 'Subuh', time: s.fajr);
    yield (name: 'Dzuhur', time: s.dhuhr);
    yield (name: 'Ashar', time: s.asr);
    yield (name: 'Maghrib', time: s.maghrib);
    yield (name: 'Isya', time: s.isha);
  }

  /// Confirmation reminders fire ~20 min before each prayer's window closes
  /// (i.e. before the next prayer enters). Isya has no "next" today, so it
  /// fires ~90 min after Isya as a before-sleep check.
  Iterable<({String name, String slug, DateTime time})> _confirmEntries(
      PrayerSchedule s) sync* {
    const m20 = Duration(minutes: 20);
    yield (name: 'Subuh', slug: 'sholat_subuh', time: s.sunrise.subtract(m20));
    yield (name: 'Dzuhur', slug: 'sholat_dzuhur', time: s.asr.subtract(m20));
    yield (name: 'Ashar', slug: 'sholat_ashar', time: s.maghrib.subtract(m20));
    yield (name: 'Maghrib', slug: 'sholat_maghrib', time: s.isha.subtract(m20));
    yield (
      name: 'Isya',
      slug: 'sholat_isya',
      time: s.isha.add(const Duration(minutes: 90)),
    );
  }
}

final prayerNotificationSchedulerProvider =
    Provider<PrayerNotificationScheduler>((ref) {
  return PrayerNotificationScheduler(
    ref.watch(prayerRepositoryProvider),
    ref.watch(notificationServiceProvider),
    ref.watch(isarServiceProvider),
  );
});
