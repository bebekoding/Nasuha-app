import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/widgets/web_frame.dart';
import '../../features/achievements/presentation/screens/achievements_screen.dart';
import '../../features/analytics/presentation/screens/analytics_screen.dart';
import '../../features/dzikir/presentation/screens/dzikir_detail_screen.dart';
import '../../features/dzikir/presentation/screens/dzikir_screen.dart';
import '../../features/home/presentation/desktop_home_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/muhasabah/presentation/screens/muhasabah_history_screen.dart';
import '../../features/muhasabah/presentation/screens/muhasabah_intro_screen.dart';
import '../../features/muhasabah/presentation/screens/muhasabah_screen.dart';
import '../../features/sholat_sunnah/presentation/screens/sholat_sunnah_detail_screen.dart';
import '../../features/sholat_sunnah/presentation/screens/sholat_sunnah_screen.dart';
import '../../features/onboarding/presentation/lock_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/onboarding/presentation/splash_screen.dart';
import '../../features/prayer_time/presentation/screens/prayer_time_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/qibla/presentation/screens/qibla_screen.dart';
import '../../features/rank/presentation/screens/rank_screen.dart';
import '../../features/quran/presentation/screens/quran_screen.dart';
import '../../features/quran/presentation/screens/surah_detail_screen.dart';
import '../../features/sedekah/presentation/screens/sedekah_history_screen.dart';
import '../../features/sedekah/presentation/screens/sedekah_recap_screen.dart';
import '../../features/sedekah/presentation/screens/sedekah_screen.dart';
import '../../features/settings/presentation/screens/backup_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';

/// Bungkus layar app-shell dengan [WebFrame] supaya di web desktop tidak melar.
Widget _framed(Widget screen) => WebFrame(child: screen);

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(path: '/splash', builder: (_, __) => const SplashScreen()),
      GoRoute(path: '/lock', builder: (_, __) => _framed(const LockScreen())),
      GoRoute(
          path: '/onboarding',
          builder: (_, __) => _framed(const OnboardingScreen())),
      GoRoute(
        path: '/',
        builder: (ctx, __) {
          // Gate: web + viewport lebar → DesktopHomeScreen (wide-optimized,
          // tanpa phone-frame). Mobile / non-web / viewport sempit →
          // HomeScreen mobile (framed di web supaya tidak melar).
          final width = MediaQuery.of(ctx).size.width;
          if (kIsWeb && width >= 800) return const DesktopHomeScreen();
          return _framed(const HomeScreen());
        },
      ),
      GoRoute(path: '/home', builder: (_, __) => _framed(const HomeScreen())),
      GoRoute(
          path: '/muhasabah',
          builder: (_, __) => _framed(const MuhasabahScreen())),
      GoRoute(
          path: '/muhasabah/intro',
          builder: (_, __) => _framed(const MuhasabahIntroScreen())),
      GoRoute(
          path: '/muhasabah/history',
          builder: (_, __) => _framed(const MuhasabahHistoryScreen())),
      GoRoute(
          path: '/dzikir', builder: (_, __) => _framed(const DzikirScreen())),
      GoRoute(
        path: '/dzikir/:idx',
        builder: (ctx, state) => _framed(DzikirDetailScreen(
            categoryIndex: int.parse(state.pathParameters['idx']!))),
      ),
      GoRoute(
          path: '/sholat-sunnah',
          builder: (_, __) => _framed(const SholatSunnahScreen())),
      GoRoute(
        path: '/sholat-sunnah/:idx',
        builder: (ctx, state) => _framed(SholatSunnahDetailScreen(
            index: int.parse(state.pathParameters['idx']!))),
      ),
      GoRoute(
          path: '/prayer',
          builder: (_, __) => _framed(const PrayerTimeScreen())),
      GoRoute(
          path: '/qibla', builder: (_, __) => _framed(const QiblaScreen())),
      GoRoute(path: '/rank', builder: (_, __) => _framed(const RankScreen())),
      GoRoute(
          path: '/quran', builder: (_, __) => _framed(const QuranScreen())),
      GoRoute(
        path: '/quran/:num',
        builder: (ctx, state) {
          final n = int.parse(state.pathParameters['num']!);
          final ayah = int.tryParse(state.uri.queryParameters['ayah'] ?? '');
          return _framed(SurahDetailScreen(surahNumber: n, initialAyah: ayah));
        },
      ),
      GoRoute(
          path: '/sedekah',
          builder: (_, __) => _framed(const SedekahScreen())),
      GoRoute(
          path: '/sedekah/history',
          builder: (_, __) => _framed(const SedekahHistoryScreen())),
      GoRoute(
          path: '/sedekah/recap',
          builder: (_, __) => _framed(const SedekahRecapScreen())),
      GoRoute(
          path: '/analytics',
          builder: (_, __) => _framed(const AnalyticsScreen())),
      GoRoute(
          path: '/achievements',
          builder: (_, __) => _framed(const AchievementsScreen())),
      GoRoute(
          path: '/profile',
          builder: (_, __) => _framed(const ProfileScreen())),
      GoRoute(
          path: '/settings',
          builder: (_, __) => _framed(const SettingsScreen())),
      GoRoute(
          path: '/backup', builder: (_, __) => _framed(const BackupScreen())),
    ],
  );
});
