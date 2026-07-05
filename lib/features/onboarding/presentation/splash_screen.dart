import 'dart:async';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../config/theme/app_colors.dart';
import '../../../config/theme/theme_controller.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_strings.dart';
import '../../settings/presentation/providers/settings_providers.dart';
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
    // Desktop web perlu waktu sedikit lebih lama supaya user lihat logo +
    // tagline dulu (bukan flash cepat) — sekaligus sisa tinggi sunburst
    // backdrop render dulu.
    final width = MediaQuery.of(context).size.width;
    final isDesktopWeb = kIsWeb && width >= 800;
    await Future.delayed(Duration(milliseconds: isDesktopWeb ? 1500 : 1200));
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
      // Di desktop web, skip onboarding walkthrough (portrait mobile flow
      // tidak cocok di viewport lebar). Mark done + langsung ke home.
      if (isDesktopWeb) {
        await prefs.setBool(AppConstants.prefsOnboardingDone, true);
        if (!mounted) return;
        context.go('/');
        return;
      }
      context.go('/onboarding');
      return;
    }

    final settings = ref.read(settingsControllerProvider);
    final lockOn = settings.biometricLock;
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
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.of(context).size.width;
    // Ukuran logo proporsional dengan viewport — kecil di mobile, besar di
    // desktop supaya tidak nampak nyempil.
    final isDesktopWeb = kIsWeb && width >= 800;
    final logoSize = isDesktopWeb ? 176.0 : 132.0;
    final titleSize = isDesktopWeb ? 40.0 : 32.0;
    final taglineSize = isDesktopWeb ? 16.0 : 14.0;
    final bg = isDark ? AppColors.dBg : AppColors.lBg;

    return Scaffold(
      backgroundColor: bg,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(isDesktopWeb ? 40 : 28),
              child: Image.asset(
                'assets/icon/nasuha_icon.png',
                width: logoSize,
                height: logoSize,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: isDesktopWeb ? 32 : 24),
            Text(
              AppStrings.appName,
              style: TextStyle(
                fontFamily: 'Space Grotesk',
                fontSize: titleSize,
                fontWeight: FontWeight.w800,
                color: scheme.onSurface,
                letterSpacing: -0.6,
              ),
            ),
            SizedBox(height: isDesktopWeb ? 12 : 8),
            Text(
              AppStrings.tagline,
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: taglineSize,
                fontWeight: FontWeight.w500,
                color: scheme.onSurface.withValues(alpha: 0.72),
                letterSpacing: 0.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
