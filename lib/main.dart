import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'config/theme/theme_controller.dart';
import 'core/constants/app_constants.dart';
import 'core/extensions/date_extensions.dart';
import 'features/achievements/data/achievement_engine.dart';
import 'services/database/app_database.dart';
import 'services/dev/dummy_seeder.dart';
import 'services/isar/isar_service.dart';
import 'services/notification/notification_service.dart';
import 'services/notification/prayer_confirm.dart';

/// DEV-ONLY: set to true once to populate sample data for UI review,
/// then set back to false. Remove before release.
const bool kSeedDummyData = false;

/// DEV-ONLY: schedule a prayer-confirm notification ~15s after launch to test
/// the background-confirm flow on a device. Set back to false before release.
const bool kTestPrayerConfirm = false;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('id_ID');

  final prefs = await SharedPreferences.getInstance();
  final isarService = await IsarService.open();
  final appDb = AppDatabase();

  if (kSeedDummyData) {
    await DummySeeder(isarService, appDb).seed();
    await AchievementEngine(isarService, appDb).recomputeAll();
    // Demo needs Muhasabah opted-in so the home HUD/rank strip renders.
    await prefs.setBool(AppConstants.prefsMuhasabahEnabled, true);
  }

  final notif = NotificationService();
  await notif.init();
  // Jangan blokir startup menunggu jawaban dialog izin (khususnya iOS) —
  // biarkan UI tampil lebih dulu, dialog muncul di atasnya.
  unawaited(notif.requestPermissions());

  if (kTestPrayerConfirm) {
    await notif.showPrayerConfirmNow(
      prayerName: 'Dzuhur (TES)',
      slug: 'sholat_dzuhur',
      dateKey: DateTime.now().isoDate,
    );
    // Simulate the action tap after 8s to verify the background write path
    // (open Isar + log + recalc) and live UI update.
    Future.delayed(const Duration(seconds: 8), () {
      handlePrayerConfirmPayload('sholat_dzuhur|${DateTime.now().isoDate}');
    });
  }

  runApp(
    ProviderScope(
      overrides: [
        sharedPrefsProvider.overrideWithValue(prefs),
        isarServiceProvider.overrideWithValue(isarService),
        appDatabaseProvider.overrideWithValue(appDb),
        notificationServiceProvider.overrideWithValue(notif),
      ],
      child: const MuhasabahApp(),
    ),
  );
}
