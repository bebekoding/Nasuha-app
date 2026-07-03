import 'dart:async';

import 'package:flutter/foundation.dart' show kIsWeb;
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
import 'services/database/seed.dart';
import 'services/dev/dummy_seeder.dart';
import 'services/notification/notification_service.dart';
import 'services/notification/prayer_confirm.dart';

/// DEV-ONLY: set to true once to populate sample data for UI review,
/// then set back to false. Remove before release.
const bool kSeedDummyData = false;

/// DEV-ONLY: schedule a prayer-confirm notification ~15s after launch to test
/// the background-confirm flow on a device. Set back to false before release.
const bool kTestPrayerConfirm = false;

Future<void> main() async {
  runZonedGuarded(_bootstrap, (error, stack) {
    // ignore: avoid_print
    print('❌ Uncaught in main: $error\n$stack');
    runApp(_FatalErrorApp(error: error, stack: stack));
  });
}

Future<void> _bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  _log('step: ensureInitialized OK');

  await initializeDateFormatting('id_ID');
  _log('step: initializeDateFormatting OK');

  final prefs = await SharedPreferences.getInstance();
  _log('step: SharedPreferences OK');

  final appDb = AppDatabase();
  _log('step: AppDatabase created');

  try {
    await seedDrift(appDb);
    _log('step: seedDrift OK');
  } catch (e, s) {
    _log('⚠️ seedDrift failed (non-fatal): $e\n$s');
  }

  if (kSeedDummyData) {
    await DummySeeder(appDb).seed();
    await AchievementEngine(appDb).recomputeAll();
    // Demo needs Muhasabah opted-in so the home HUD/rank strip renders.
    await prefs.setBool(AppConstants.prefsMuhasabahEnabled, true);
  }

  final notif = NotificationService();
  if (!kIsWeb) {
    try {
      await notif.init();
      unawaited(notif.requestPermissions());
      _log('step: NotificationService OK');
    } catch (e, s) {
      _log('⚠️ Notification init failed (non-fatal): $e\n$s');
    }
  } else {
    _log('step: Notification skipped (web)');
  }

  if (kTestPrayerConfirm) {
    await notif.showPrayerConfirmNow(
      prayerName: 'Dzuhur (TES)',
      slug: 'sholat_dzuhur',
      dateKey: DateTime.now().isoDate,
    );
    Future.delayed(const Duration(seconds: 8), () {
      handlePrayerConfirmPayload('sholat_dzuhur|${DateTime.now().isoDate}');
    });
  }

  _log('step: runApp');
  runApp(
    ProviderScope(
      overrides: [
        sharedPrefsProvider.overrideWithValue(prefs),
        appDatabaseProvider.overrideWithValue(appDb),
        notificationServiceProvider.overrideWithValue(notif),
      ],
      child: const MuhasabahApp(),
    ),
  );
}

void _log(String msg) {
  // ignore: avoid_print
  print('[Nasuha bootstrap] $msg');
}

/// UI minimal yang dirender kalau [main] crash — supaya tidak blank screen.
class _FatalErrorApp extends StatelessWidget {
  const _FatalErrorApp({required this.error, required this.stack});
  final Object error;
  final StackTrace stack;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xFFF4ECDD),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Gagal memuat Nasuha',
                    style: TextStyle(
                      color: Color(0xFF3B2E22),
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SelectableText(
                    error.toString(),
                    style: const TextStyle(
                      color: Color(0xFFB5613F),
                      fontFamily: 'monospace',
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SelectableText(
                    stack.toString(),
                    style: const TextStyle(
                      color: Color(0xFF8A5A3A),
                      fontFamily: 'monospace',
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
