import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../core/constants/app_constants.dart';
import 'prayer_confirm.dart';
import 'web_notifier.dart' if (dart.library.io) 'web_notifier_stub.dart';

/// iOS/macOS notification category that carries the "✅ Sudah sholat" action.
const String kPrayerConfirmCategory = 'prayer_confirm';

class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    if (kIsWeb) {
      // Browser Notification API tidak butuh init; WebNotifier siap dipanggil.
      _initialized = true;
      return;
    }
    tz.initializeTimeZones();

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final darwin = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      notificationCategories: [
        DarwinNotificationCategory(
          kPrayerConfirmCategory,
          actions: [
            DarwinNotificationAction.plain(
              kConfirmPrayerAction,
              '✅ Sudah sholat',
            ),
          ],
        ),
      ],
    );
    await _plugin.initialize(
      // iOS WAJIB diisi saat target iOS — tanpa ini app crash sebelum runApp.
      InitializationSettings(android: android, iOS: darwin, macOS: darwin),
      onDidReceiveNotificationResponse: prayerConfirmForegroundHandler,
      onDidReceiveBackgroundNotificationResponse:
          prayerConfirmBackgroundHandler,
    );
    _initialized = true;
  }

  /// Best-effort permission prompt — Android 13+ and macOS show a system
  /// dialog the first time. Result is ignored; user can re-grant later in
  /// system settings.
  Future<void> requestPermissions() async {
    if (kIsWeb) {
      await WebNotifier.instance.requestPermission();
      return;
    }
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    await _plugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);
    await _plugin
        .resolvePlatformSpecificImplementation<
            MacOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  Future<void> scheduleAdhan({
    required int id,
    required String title,
    required String body,
    required DateTime when,
  }) async {
    if (kIsWeb) {
      WebNotifier.instance.schedule(
        id: id,
        title: title,
        body: body,
        when: when,
        tag: 'adhan-$id',
      );
      return;
    }
    final scheduled = tz.TZDateTime.from(when, tz.local);
    if (scheduled.isBefore(tz.TZDateTime.now(tz.local))) return;

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      scheduled,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          AppConstants.adhanChannelId,
          AppConstants.adhanChannelName,
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
        macOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  /// A reminder, [when], asking the user to confirm a time-bound prayer with
  /// a "✅ Sudah sholat" action button. Tapping it logs the prayer in the
  /// background (see [prayerConfirmBackgroundHandler]) without opening the app.
  Future<void> schedulePrayerConfirm({
    required int id,
    required String prayerName,
    required String slug,
    required String dateKey,
    required DateTime when,
  }) async {
    if (kIsWeb) {
      // Web tidak mendukung notification action button reliably; jadikan
      // reminder polos. Klik notif akan bawa user ke app (default).
      WebNotifier.instance.schedule(
        id: id,
        title: 'Sudah sholat $prayerName? 🤲',
        body: 'Waktu $prayerName hampir habis. Buka Nasuha untuk menandai.',
        when: when,
        tag: 'prayer-confirm-$id',
      );
      return;
    }
    final scheduled = tz.TZDateTime.from(when, tz.local);
    if (scheduled.isBefore(tz.TZDateTime.now(tz.local))) return;

    await _plugin.zonedSchedule(
      id,
      'Sudah sholat $prayerName? 🤲',
      'Waktu $prayerName hampir habis. Ketuk "Sudah sholat" jika sudah '
          'menunaikan — otomatis tercentang.',
      scheduled,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          AppConstants.reminderChannelId,
          AppConstants.reminderChannelName,
          importance: Importance.max,
          priority: Priority.high,
          actions: [
            AndroidNotificationAction(
              kConfirmPrayerAction,
              '✅ Sudah sholat',
              showsUserInterface: false,
              cancelNotification: true,
            ),
          ],
        ),
        iOS: DarwinNotificationDetails(
            categoryIdentifier: kPrayerConfirmCategory),
        macOS: DarwinNotificationDetails(
            categoryIdentifier: kPrayerConfirmCategory),
      ),
      payload: '$slug|$dateKey',
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  /// DEV-ONLY: show a confirm notification immediately (for testing the
  /// background-confirm action without waiting for a scheduled time).
  Future<void> showPrayerConfirmNow({
    required String prayerName,
    required String slug,
    required String dateKey,
  }) async {
    await _plugin.show(
      999,
      'Sudah sholat $prayerName? 🤲',
      'Ketuk "Sudah sholat" jika sudah menunaikan — otomatis tercentang.',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          AppConstants.reminderChannelId,
          AppConstants.reminderChannelName,
          importance: Importance.max,
          priority: Priority.high,
          actions: [
            AndroidNotificationAction(
              kConfirmPrayerAction,
              '✅ Sudah sholat',
              showsUserInterface: false,
              cancelNotification: true,
            ),
          ],
        ),
        iOS: DarwinNotificationDetails(
            categoryIdentifier: kPrayerConfirmCategory),
      ),
      payload: '$slug|$dateKey',
    );
  }

  Future<void> cancelAll() {
    if (kIsWeb) {
      WebNotifier.instance.cancelAll();
      return Future.value();
    }
    return _plugin.cancelAll();
  }
}

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});
