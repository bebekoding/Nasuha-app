import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/widgets/desktop_page_shell.dart';
import '../../core/widgets/web_frame.dart';
import '../../features/achievements/presentation/screens/achievements_desktop_screen.dart';
import '../../features/achievements/presentation/screens/achievements_screen.dart';
import '../../features/analytics/presentation/screens/analytics_desktop_screen.dart';
import '../../features/analytics/presentation/screens/analytics_screen.dart';
import '../../features/dzikir/presentation/screens/dzikir_desktop_screen.dart';
import '../../features/dzikir/presentation/screens/dzikir_detail_screen.dart';
import '../../features/dzikir/presentation/screens/dzikir_screen.dart';
import '../../features/home/presentation/desktop_home_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/muhasabah/presentation/screens/muhasabah_desktop_screen.dart';
import '../../features/muhasabah/presentation/screens/muhasabah_history_screen.dart';
import '../../features/muhasabah/presentation/screens/muhasabah_intro_screen.dart';
import '../../features/muhasabah/presentation/screens/muhasabah_screen.dart';
import '../../features/sholat_sunnah/presentation/screens/sholat_sunnah_desktop_screen.dart';
import '../../features/sholat_sunnah/presentation/screens/sholat_sunnah_detail_screen.dart';
import '../../features/sholat_sunnah/presentation/screens/sholat_sunnah_screen.dart';
import '../../features/onboarding/presentation/lock_screen.dart';
import '../../features/onboarding/presentation/splash_screen.dart';
import '../../features/prayer_time/presentation/screens/prayer_time_desktop_screen.dart';
import '../../features/prayer_time/presentation/screens/prayer_time_screen.dart';
import '../../features/profile/presentation/profile_desktop_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/qibla/presentation/screens/qibla_desktop_screen.dart';
import '../../features/qibla/presentation/screens/qibla_screen.dart';
import '../../features/rank/presentation/screens/rank_desktop_screen.dart';
import '../../features/rank/presentation/screens/rank_screen.dart';
import '../../features/quran/presentation/screens/quran_desktop_screen.dart';
import '../../features/quran/presentation/screens/quran_screen.dart';
import '../../features/quran/presentation/screens/surah_detail_screen.dart';
import '../../features/sedekah/presentation/screens/sedekah_desktop_screen.dart';
import '../../features/sedekah/presentation/screens/sedekah_history_screen.dart';
import '../../features/sedekah/presentation/screens/sedekah_recap_screen.dart';
import '../../features/sedekah/presentation/screens/sedekah_screen.dart';
import '../../features/zakat/presentation/zakat_fitrah_screen.dart';
import '../../features/zakat/presentation/zakat_mal_screen.dart';
import '../../features/zakat/presentation/zakat_screen.dart';
import '../../features/settings/presentation/screens/backup_desktop_screen.dart';
import '../../features/settings/presentation/screens/backup_screen.dart';
import '../../features/settings/presentation/screens/settings_desktop_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';

/// Bungkus layar app-shell dengan [WebFrame] supaya di web desktop tidak melar.
Widget _framed(Widget screen) => WebFrame(child: screen);

/// Pilih layar berdasarkan viewport web. Di desktop lebar (>=800) render
/// [desktop], selain itu (mobile / narrow / native) render [mobile] via
/// WebFrame.
Widget _desktopOr(BuildContext ctx, Widget desktop, Widget mobile) {
  final width = MediaQuery.of(ctx).size.width;
  if (kIsWeb && width >= 800) return desktop;
  return _framed(mobile);
}

/// Untuk sub-detail screens list-based yang tak butuh custom desktop
/// layout — cukup wrap dengan chrome DesktopPageShell + centered max-width.
/// Mobile route pakai [chromeless]=false, desktop pakai [chromeless]=true.
Widget _desktopWrapOr(
  BuildContext ctx, {
  required Widget Function(bool chromeless) build,
  required String eyebrow,
  String? currentRoute,
  double maxWidth = 780,
  bool bodyIsScrollable = false,
}) {
  final width = MediaQuery.of(ctx).size.width;
  if (kIsWeb && width >= 800) {
    final wrapped = Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(ctx).colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
                color: Theme.of(ctx)
                    .colorScheme
                    .outline
                    .withValues(alpha: 0.16),
                width: 1.2),
          ),
          clipBehavior: Clip.hardEdge,
          padding: bodyIsScrollable
              ? const EdgeInsets.symmetric(horizontal: 20, vertical: 12)
              : const EdgeInsets.all(20),
          child: build(true),
        ),
      ),
    );
    return DesktopPageShell(
      currentRoute: currentRoute,
      eyebrow: eyebrow,
      bodyIsScrollable: bodyIsScrollable,
      child: wrapped,
    );
  }
  return _framed(build(false));
}

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(path: '/splash', builder: (_, __) => const SplashScreen()),
      GoRoute(path: '/lock', builder: (_, __) => _framed(const LockScreen())),
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
        builder: (ctx, __) => _desktopOr(
          ctx,
          const MuhasabahDesktopScreen(),
          const MuhasabahScreen(),
        ),
      ),
      GoRoute(
        path: '/muhasabah/intro',
        builder: (ctx, __) => _desktopWrapOr(
          ctx,
          build: (c) => MuhasabahIntroScreen(chromeless: c),
          eyebrow: 'MULAI MUHASABAH',
          maxWidth: 640,
        ),
      ),
      GoRoute(
        path: '/muhasabah/history',
        builder: (ctx, __) => _desktopWrapOr(
          ctx,
          build: (c) => MuhasabahHistoryScreen(chromeless: c),
          eyebrow: 'RIWAYAT MUHASABAH',
        ),
      ),
      GoRoute(
        path: '/dzikir',
        builder: (ctx, __) => _desktopOr(
          ctx,
          const DzikirDesktopScreen(),
          const DzikirScreen(),
        ),
      ),
      GoRoute(
        path: '/dzikir/:idx',
        builder: (ctx, state) {
          final idx = int.parse(state.pathParameters['idx']!);
          return _desktopWrapOr(
            ctx,
            build: (c) =>
                DzikirDetailScreen(categoryIndex: idx, chromeless: c),
            eyebrow: 'DZIKIR',
            maxWidth: 780,
          );
        },
      ),
      GoRoute(
        path: '/sholat-sunnah',
        builder: (ctx, __) => _desktopOr(
          ctx,
          const SholatSunnahDesktopScreen(),
          const SholatSunnahScreen(),
        ),
      ),
      GoRoute(
        path: '/sholat-sunnah/:idx',
        builder: (ctx, state) {
          final idx = int.parse(state.pathParameters['idx']!);
          return _desktopWrapOr(
            ctx,
            build: (c) =>
                SholatSunnahDetailScreen(index: idx, chromeless: c),
            eyebrow: 'SHOLAT SUNNAH',
            maxWidth: 780,
          );
        },
      ),
      GoRoute(
        path: '/prayer',
        builder: (ctx, __) => _desktopOr(
          ctx,
          const PrayerTimeDesktopScreen(),
          const PrayerTimeScreen(),
        ),
      ),
      GoRoute(
        path: '/qibla',
        builder: (ctx, __) => _desktopOr(
          ctx,
          const QiblaDesktopScreen(),
          const QiblaScreen(),
        ),
      ),
      GoRoute(
        path: '/rank',
        builder: (ctx, __) => _desktopOr(
          ctx,
          const RankDesktopScreen(),
          const RankScreen(),
        ),
      ),
      GoRoute(
        path: '/quran',
        builder: (ctx, __) => _desktopOr(
          ctx,
          const QuranDesktopScreen(),
          const QuranScreen(),
        ),
      ),
      GoRoute(
        path: '/quran/:num',
        builder: (ctx, state) {
          final n = int.parse(state.pathParameters['num']!);
          final ayah = int.tryParse(state.uri.queryParameters['ayah'] ?? '');
          return _desktopWrapOr(
            ctx,
            build: (c) => SurahDetailScreen(
              surahNumber: n,
              initialAyah: ayah,
              chromeless: c,
            ),
            eyebrow: 'AL-QURAN',
            currentRoute: '/quran',
            maxWidth: 860,
            bodyIsScrollable: true,
          );
        },
      ),
      GoRoute(
        path: '/sedekah',
        builder: (ctx, __) => _desktopOr(
          ctx,
          const SedekahDesktopScreen(),
          const SedekahScreen(),
        ),
      ),
      GoRoute(
        path: '/sedekah/history',
        builder: (ctx, __) => _desktopWrapOr(
          ctx,
          build: (c) => SedekahHistoryScreen(chromeless: c),
          eyebrow: 'RIWAYAT SEDEKAH',
        ),
      ),
      GoRoute(
        path: '/sedekah/recap',
        builder: (ctx, __) => _desktopWrapOr(
          ctx,
          build: (c) => SedekahRecapScreen(chromeless: c),
          eyebrow: 'REKAP SEDEKAH',
          maxWidth: 960,
        ),
      ),
      GoRoute(
        path: '/zakat',
        builder: (ctx, __) => _desktopWrapOr(
          ctx,
          build: (c) => ZakatScreen(chromeless: c),
          eyebrow: 'ZAKAT',
          currentRoute: '/zakat',
          maxWidth: 720,
        ),
      ),
      GoRoute(
        path: '/zakat/mal',
        builder: (ctx, __) => _desktopWrapOr(
          ctx,
          build: (c) => ZakatMalScreen(chromeless: c),
          eyebrow: 'ZAKAT MAL',
          currentRoute: '/zakat',
          maxWidth: 720,
        ),
      ),
      GoRoute(
        path: '/zakat/fitrah',
        builder: (ctx, __) => _desktopWrapOr(
          ctx,
          build: (c) => ZakatFitrahScreen(chromeless: c),
          eyebrow: 'ZAKAT FITRAH',
          currentRoute: '/zakat',
          maxWidth: 720,
        ),
      ),
      GoRoute(
        path: '/analytics',
        builder: (ctx, __) => _desktopOr(
          ctx,
          const AnalyticsDesktopScreen(),
          const AnalyticsScreen(),
        ),
      ),
      GoRoute(
        path: '/achievements',
        builder: (ctx, __) => _desktopOr(
          ctx,
          const AchievementsDesktopScreen(),
          const AchievementsScreen(),
        ),
      ),
      GoRoute(
        path: '/profile',
        builder: (ctx, __) => _desktopOr(
          ctx,
          const ProfileDesktopScreen(),
          const ProfileScreen(),
        ),
      ),
      GoRoute(
        path: '/settings',
        builder: (ctx, __) => _desktopOr(
          ctx,
          const SettingsDesktopScreen(),
          const SettingsScreen(),
        ),
      ),
      GoRoute(
        path: '/backup',
        builder: (ctx, __) => _desktopOr(
          ctx,
          const BackupDesktopScreen(),
          const BackupScreen(),
        ),
      ),
    ],
  );
});
