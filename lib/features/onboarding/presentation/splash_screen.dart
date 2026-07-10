import 'dart:async';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../config/theme/app_colors.dart';
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

    // Fire-and-forget side jobs.
    unawaited(
      ref.read(backupControllerProvider.notifier).maybeRunDailyBackup(),
    );
    unawaited(_scheduleAdhanIfEnabled());

    if (!mounted) return;

    // Tak ada walkthrough onboarding — langsung ke home (atau lock screen
    // kalau biometric lock aktif).
    final settings = ref.read(settingsControllerProvider);
    final lockOn = settings.biometricLock;
    context.go(lockOn ? '/lock' : '/');
  }

  Future<void> _scheduleAdhanIfEnabled() async {
    try {
      // Mobile: minta izin di splash — user flow terbiasa dgn permission
      // dialog OS. Web: JANGAN minta di sini karena bukan user-gesture,
      // browser bakal reject; permission diminta saat user toggle di
      // Settings.
      if (!kIsWeb) {
        await ref.read(notificationServiceProvider).requestPermissions();
      }
      // Re-schedule prayers untuk 48h ke depan setiap app load — di web,
      // ini bikin timer setTimeout hidup lagi tiap user buka tab.
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
    final logoSize = isDesktopWeb ? 280.0 : 180.0;
    final titleSize = isDesktopWeb ? 56.0 : 36.0;
    final taglineSize = isDesktopWeb ? 20.0 : 15.0;
    final bg = isDark ? AppColors.dBg : AppColors.lBg;

    return Scaffold(
      backgroundColor: bg,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Pakai icon foreground (emblem only, tanpa background cream)
            // supaya menyatu dengan bg splash. Tak perlu ClipRRect.
            Image.asset(
              'assets/icon/nasuha_icon_fg.png',
              width: logoSize,
              height: logoSize,
              fit: BoxFit.contain,
            ),
            SizedBox(height: isDesktopWeb ? 28 : 20),
            Text(
              AppStrings.appName,
              style: TextStyle(
                fontFamily: 'Space Grotesk',
                fontSize: titleSize,
                fontWeight: FontWeight.w800,
                color: scheme.onSurface,
                letterSpacing: -1.0,
                height: 1.0,
              ),
            ),
            SizedBox(height: isDesktopWeb ? 16 : 10),
            Text(
              AppStrings.tagline,
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: taglineSize,
                fontWeight: FontWeight.w500,
                color: scheme.onSurface.withValues(alpha: 0.72),
                letterSpacing: 0.1,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
