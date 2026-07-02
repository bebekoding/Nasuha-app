import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../config/theme/theme_controller.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_strings.dart';
import '../../../models/user_settings.dart';
import '../../../services/isar/isar_service.dart';
import '../../../services/notification/notification_service.dart';
import '../../prayer_time/data/prayer_notification_scheduler.dart';
import '../../settings/presentation/providers/backup_providers.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _next());
  }

  Future<void> _next() async {
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    final prefs = ref.read(sharedPrefsProvider);
    final done = prefs.getBool(AppConstants.prefsOnboardingDone) ?? false;

    // Fire-and-forget side jobs.
    unawaited(
      ref.read(backupControllerProvider.notifier).maybeRunDailyBackup(),
    );
    unawaited(_scheduleAdhanIfEnabled());

    if (!mounted) return;

    if (!done) {
      context.go('/onboarding');
      return;
    }

    final settings = ref.read(isarServiceProvider).isar.userSettings.getSync(0);
    final lockOn = settings?.biometricLock ?? false;
    context.go(lockOn ? '/lock' : '/');
  }

  Future<void> _scheduleAdhanIfEnabled() async {
    try {
      await ref.read(notificationServiceProvider).requestPermissions();
      await ref
          .read(prayerNotificationSchedulerProvider)
          .scheduleNext48h();
    } catch (_) {
      // Silent — surfaced next time the user opens the prayer screen.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: Image.asset(
                'assets/icon/nasuha_icon.png',
                width: 132,
                height: 132,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 24),
            Text(AppStrings.appName,
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Text(AppStrings.tagline,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    )),
          ],
        ),
      ),
    );
  }
}
