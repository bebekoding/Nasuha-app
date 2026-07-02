import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/achievements/presentation/screens/achievements_screen.dart';
import '../../features/analytics/presentation/screens/analytics_screen.dart';
import '../../features/dzikir/presentation/screens/dzikir_detail_screen.dart';
import '../../features/dzikir/presentation/screens/dzikir_screen.dart';
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

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(path: '/splash', builder: (_, __) => const SplashScreen()),
      GoRoute(path: '/lock', builder: (_, __) => const LockScreen()),
      GoRoute(
          path: '/onboarding',
          builder: (_, __) => const OnboardingScreen()),
      GoRoute(path: '/', builder: (_, __) => const HomeScreen()),
      GoRoute(
          path: '/muhasabah',
          builder: (_, __) => const MuhasabahScreen()),
      GoRoute(
          path: '/muhasabah/intro',
          builder: (_, __) => const MuhasabahIntroScreen()),
      GoRoute(
          path: '/muhasabah/history',
          builder: (_, __) => const MuhasabahHistoryScreen()),
      GoRoute(path: '/dzikir', builder: (_, __) => const DzikirScreen()),
      GoRoute(
        path: '/dzikir/:idx',
        builder: (ctx, state) => DzikirDetailScreen(
            categoryIndex: int.parse(state.pathParameters['idx']!)),
      ),
      GoRoute(
          path: '/sholat-sunnah',
          builder: (_, __) => const SholatSunnahScreen()),
      GoRoute(
        path: '/sholat-sunnah/:idx',
        builder: (ctx, state) => SholatSunnahDetailScreen(
            index: int.parse(state.pathParameters['idx']!)),
      ),
      GoRoute(
          path: '/prayer', builder: (_, __) => const PrayerTimeScreen()),
      GoRoute(path: '/qibla', builder: (_, __) => const QiblaScreen()),
      GoRoute(path: '/rank', builder: (_, __) => const RankScreen()),
      GoRoute(path: '/quran', builder: (_, __) => const QuranScreen()),
      GoRoute(
        path: '/quran/:num',
        builder: (ctx, state) {
          final n = int.parse(state.pathParameters['num']!);
          final ayah = int.tryParse(state.uri.queryParameters['ayah'] ?? '');
          return SurahDetailScreen(surahNumber: n, initialAyah: ayah);
        },
      ),
      GoRoute(path: '/sedekah', builder: (_, __) => const SedekahScreen()),
      GoRoute(
          path: '/sedekah/history',
          builder: (_, __) => const SedekahHistoryScreen()),
      GoRoute(
          path: '/sedekah/recap',
          builder: (_, __) => const SedekahRecapScreen()),
      GoRoute(
          path: '/analytics',
          builder: (_, __) => const AnalyticsScreen()),
      GoRoute(
          path: '/achievements',
          builder: (_, __) => const AchievementsScreen()),
      GoRoute(path: '/profile', builder: (_, __) => const ProfileScreen()),
      GoRoute(path: '/settings', builder: (_, __) => const SettingsScreen()),
      GoRoute(path: '/backup', builder: (_, __) => const BackupScreen()),
    ],
  );
});
