import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../config/theme/app_colors.dart';
import '../../../core/widgets/desktop_page_shell.dart';
import '../../../models/daily_score.dart';
import '../../muhasabah/presentation/providers/muhasabah_enabled_provider.dart';
import '../../muhasabah/presentation/providers/muhasabah_providers.dart';
import '../../prayer_time/data/repositories/prayer_repository.dart';
import '../../prayer_time/domain/entities/prayer_schedule.dart';
import '../../rank/data/rank_tiers.dart';
import '../../rank/presentation/providers/rank_provider.dart';
import '../../settings/presentation/providers/settings_providers.dart';

/// Dashboard khusus PWA desktop (width ≥ 800px). Layout wide-optimized,
/// beda dari HomeScreen mobile — inspired by fore.coffee marketing feel +
/// apple.com hover interactions.
///
/// Data provider dishare dengan HomeScreen mobile.
class DesktopHomeScreen extends ConsumerStatefulWidget {
  const DesktopHomeScreen({super.key});

  @override
  ConsumerState<DesktopHomeScreen> createState() => _DesktopHomeScreenState();
}

class _DesktopHomeScreenState extends ConsumerState<DesktopHomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entrance;

  @override
  void initState() {
    super.initState();
    _entrance = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => _entrance.forward());
  }

  @override
  void dispose() {
    _entrance.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsControllerProvider);
    final scoreAsync = ref.watch(todayScoreProvider);
    final streakAsync = ref.watch(muhasabahStreakProvider);
    final rankAsync = ref.watch(rankProgressProvider);
    final prayerAsync = ref.watch(todayPrayerScheduleProvider);
    final muhasabahOn = ref.watch(muhasabahEnabledProvider);
    final muhasabahRoute = muhasabahOn ? '/muhasabah' : '/muhasabah/intro';

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.dBg : AppColors.lBg;

    return Scaffold(
      backgroundColor: bg,
      body: Stack(
        children: [
          // Sunburst rays halus (fore.coffee vibe) — hanya di light.
          if (!isDark)
            const Positioned.fill(
              child: IgnorePointer(child: DesktopSunburstBackdrop()),
            ),
          SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1240),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 48),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const DesktopTopNav(currentRoute: '/'),
                      const SizedBox(height: 56),
                      _Reveal(
                        controller: _entrance,
                        order: 0,
                        child: _HeroGreeting(
                            displayName: settings.displayName ?? '',
                            date: DateTime.now()),
                      ),
                      const SizedBox(height: 40),
                      _Reveal(
                        controller: _entrance,
                        order: 1,
                        child: _HudStrip(
                          streak: streakAsync.valueOrNull?.current ?? 0,
                          score: scoreAsync.valueOrNull,
                          rank: rankAsync.valueOrNull,
                          onRankTap: () => context.push('/rank'),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _Reveal(
                        controller: _entrance,
                        order: 2,
                        child: _JadwalNextHero(
                          prayerAsync: prayerAsync,
                          onTap: () => context.push('/prayer'),
                        ),
                      ),
                      const SizedBox(height: 64),
                      _Reveal(
                        controller: _entrance,
                        order: 3,
                        child: _SectionHeader(
                          title: 'Prioritas hari ini',
                          subtitle:
                              'Amalan yang paling menggerakkan XP kamu.',
                        ),
                      ),
                      const SizedBox(height: 28),
                      _FeaturedRow(
                        entrance: _entrance,
                        muhasabahRoute: muhasabahRoute,
                        prayerAsync: prayerAsync,
                      ),
                      const SizedBox(height: 64),
                      _Reveal(
                        controller: _entrance,
                        order: 4,
                        child: _SectionHeader(
                          title: 'Fitur lainnya',
                          subtitle:
                              'Ibadah harian, kompas, dan progress kamu.',
                        ),
                      ),
                      const SizedBox(height: 28),
                      _BentoSecondary(entrance: _entrance),
                      const SizedBox(height: 80),
                      const _Footer(),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// HERO GREETING
// ═══════════════════════════════════════════════════════════════════════════

class _HeroGreeting extends StatelessWidget {
  const _HeroGreeting({required this.displayName, required this.date});
  final String displayName;
  final DateTime date;

  String get _greeting {
    final h = date.hour;
    final name = displayName.isEmpty ? 'sahabat' : displayName;
    if (h < 4) return 'Selamat malam, $name';
    if (h < 11) return 'Selamat pagi, $name';
    if (h < 15) return 'Selamat siang, $name';
    if (h < 19) return 'Selamat sore, $name';
    return 'Selamat malam, $name';
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          DateFormat('EEEE, d MMMM y', 'id_ID').format(date).toUpperCase(),
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 2.4,
            color: scheme.primary,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          _greeting,
          style: TextStyle(
            fontFamily: 'Space Grotesk',
            fontSize: 56,
            height: 1.05,
            fontWeight: FontWeight.w800,
            color: scheme.onSurface,
            letterSpacing: -1.2,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          'Level up your soul · Level up your amal.',
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 18,
            fontWeight: FontWeight.w500,
            height: 1.5,
            color: scheme.onSurface.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// HUD STRIP
// ═══════════════════════════════════════════════════════════════════════════

class _HudStrip extends StatelessWidget {
  const _HudStrip({
    required this.streak,
    required this.score,
    required this.rank,
    required this.onRankTap,
  });

  final int streak;
  final DailyScore? score;
  final RankProgress? rank;
  final VoidCallback onRankTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final line = isDark ? AppColors.dLine : AppColors.lLine;
    final xp = score?.total ?? 0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 28),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: line, width: 1),
        boxShadow: [
          BoxShadow(
            color: scheme.onSurface.withValues(alpha: 0.04),
            blurRadius: 22,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _HudMetric(
              icon: Icons.local_fire_department,
              iconColor: AppColors.goldLight,
              label: 'Streak',
              value: '$streak',
              unit: 'hari',
            ),
          ),
          _HudDivider(color: line),
          Expanded(
            child: _HudMetric(
              icon: Icons.bolt,
              iconColor: scheme.primary,
              label: 'XP hari ini',
              value: xp >= 0 ? '+$xp' : '$xp',
              unit: '',
              valueColor: xp < 0 ? AppColors.negativeLight : null,
            ),
          ),
          _HudDivider(color: line),
          Expanded(
            child: _HudRankTile(rank: rank, onTap: onRankTap),
          ),
        ],
      ),
    );
  }
}

class _HudMetric extends StatelessWidget {
  const _HudMetric({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.unit,
    this.valueColor,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final String unit;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: iconColor, size: 26),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.8,
                color: scheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontFamily: 'Space Grotesk',
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    height: 1.0,
                    color: valueColor ?? scheme.onSurface,
                  ),
                ),
                if (unit.isNotEmpty) ...[
                  const SizedBox(width: 6),
                  Text(
                    unit,
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 13,
                      color: scheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _HudDivider extends StatelessWidget {
  const _HudDivider({required this.color});
  final Color color;
  @override
  Widget build(BuildContext context) => Container(
        width: 1,
        height: 44,
        color: color,
        margin: const EdgeInsets.symmetric(horizontal: 16),
      );
}

class _HudRankTile extends StatefulWidget {
  const _HudRankTile({required this.rank, required this.onTap});
  final RankProgress? rank;
  final VoidCallback onTap;

  @override
  State<_HudRankTile> createState() => _HudRankTileState();
}

class _HudRankTileState extends State<_HudRankTile> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tier = widget.rank?.tier;
    final label = tier?.title ?? 'Mubtadi';
    final level = tier?.level ?? 1;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          transform: Matrix4.translationValues(0, _hover ? -2 : 0, 0),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.goldLight.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(tier?.icon ?? Icons.emoji_events,
                    color: AppColors.goldLight, size: 26),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Rank · Level $level',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.8,
                        color: scheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      label,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Space Grotesk',
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        height: 1.0,
                        color: scheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOut,
                transform: Matrix4.translationValues(_hover ? 4 : 0, 0, 0),
                child: Icon(
                  Icons.arrow_forward,
                  size: 18,
                  color: scheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// JADWAL NEXT HERO — live next-prayer card di bawah HUD strip
// ═══════════════════════════════════════════════════════════════════════════

class _JadwalNextHero extends StatefulWidget {
  const _JadwalNextHero({required this.prayerAsync, required this.onTap});
  final AsyncValue<PrayerSchedule?> prayerAsync;
  final VoidCallback onTap;

  @override
  State<_JadwalNextHero> createState() => _JadwalNextHeroState();
}

class _JadwalNextHeroState extends State<_JadwalNextHero> {
  /// Berapa lama bubble tetap tampilkan "Sudah Masuk Waktu [X]" setelah
  /// waktu adzan lewat sebelum roll ke prayer berikutnya.
  static const Duration _activeWindow = Duration(minutes: 15);

  Timer? _ticker;
  bool _hover = false;

  @override
  void initState() {
    super.initState();
    // Rebuild tiap detik supaya countdown detik akurat.
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  /// Cari prayer yang jam-nya baru lewat dalam window 15 menit — kalau
  /// ada, itu prayer "sekarang". Kalau tidak ada, return null → pakai
  /// PrayerSchedule.next (upcoming).
  ///
  /// Return type sama dengan `schedule.next` (Record 3 fields) supaya
  /// consumer bisa perlakukan sama tanpa pattern-match.
  ({String name, DateTime time, String icon})? _activePrayer(
      PrayerSchedule schedule, DateTime now) {
    // Iterate reverse (mulai Isya turun) supaya prayer TERBARU yang match.
    for (final t in schedule.allTimes.reversed) {
      final since = now.difference(t.time);
      if (!since.isNegative && since < _activeWindow) {
        return t;
      }
    }
    return null;
  }

  String _fmtCountdown(Duration d) {
    if (d.isNegative) return '—';
    final h = d.inHours;
    final m = d.inMinutes % 60;
    final s = d.inSeconds % 60;
    final mm = m.toString().padLeft(2, '0');
    final ss = s.toString().padLeft(2, '0');
    if (h > 0) return '${h}j ${mm}m ${ss}d';
    return '${d.inMinutes}m ${ss}d';
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final line = isDark ? AppColors.dLine : AppColors.lLine;
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    const accent = AppColors.terracotta;
    const accentActive = AppColors.caramel;

    return widget.prayerAsync.when(
      loading: () => _shell(scheme, line, const _JadwalSkeleton()),
      error: (_, __) => _shell(
        scheme,
        line,
        _JadwalPrompt(
          message: 'Belum bisa hitung — cek koneksi/lokasi.',
          cta: 'Coba lagi',
          onTap: widget.onTap,
        ),
      ),
      data: (schedule) {
        if (schedule == null) {
          return _shell(
            scheme,
            line,
            _JadwalPrompt(
              message:
                  'Aktifkan izin lokasi supaya Nasuha bisa hitung adzan.',
              cta: 'Atur lokasi',
              onTap: widget.onTap,
            ),
          );
        }

        final now = DateTime.now();
        final active = _activePrayer(schedule, now);
        final isActive = active != null;
        final prayer = isActive ? active : schedule.next;
        final hhmm = DateFormat.Hm().format(prayer.time);

        // Warna & label state berbeda antara "sudah masuk" vs "berikutnya".
        final color = isActive ? accentActive : accent;
        final eyebrow =
            isActive ? 'WAKTU SHOLAT SEKARANG' : 'ADZAN BERIKUTNYA';

        Widget trailing;
        if (isActive) {
          trailing = Flexible(
            child: Text(
              'Sudah masuk waktu ${prayer.name}',
              textAlign: TextAlign.right,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'Space Grotesk',
                fontSize: 22,
                fontWeight: FontWeight.w800,
                height: 1.15,
                color: color,
                letterSpacing: -0.4,
              ),
            ),
          );
        } else {
          final diff = prayer.time.difference(now);
          trailing = Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _fmtCountdown(diff),
                style: TextStyle(
                  fontFamily: 'Space Grotesk',
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  height: 1.0,
                  color: color,
                  letterSpacing: -0.6,
                  fontFeatures: const [
                    // Tabular figures — supaya angka detik gak geser layout.
                    FontFeature.tabularFigures(),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'lagi',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                  color: scheme.onSurface.withValues(alpha: 0.55),
                ),
              ),
            ],
          );
        }

        return MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => _hover = true),
          onExit: (_) => setState(() => _hover = false),
          child: GestureDetector(
            onTap: widget.onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOut,
              transform: (_hover && !reduceMotion)
                  ? (Matrix4.identity()
                    ..translateByDouble(0.0, -3.0, 0.0, 1.0))
                  : Matrix4.identity(),
              padding: const EdgeInsets.symmetric(
                  horizontal: 28, vertical: 22),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    scheme.surface,
                    color.withValues(alpha: isActive ? 0.14 : 0.10),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: color.withValues(alpha: _hover ? 0.68 : 0.5),
                    width: 1.5),
                boxShadow: _hover
                    ? [
                        BoxShadow(
                          color: color.withValues(alpha: 0.20),
                          blurRadius: 22,
                          offset: const Offset(0, 12),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: scheme.onSurface.withValues(alpha: 0.04),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(Icons.mosque, color: color, size: 28),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          eyebrow,
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.8,
                            color: color,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              prayer.name,
                              style: TextStyle(
                                fontFamily: 'Space Grotesk',
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                                height: 1.0,
                                color: scheme.onSurface,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'pukul $hhmm',
                              style: TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: scheme.onSurface
                                    .withValues(alpha: 0.72),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  trailing,
                  const SizedBox(width: 20),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    curve: Curves.easeOut,
                    transform: Matrix4.translationValues(
                        _hover && !reduceMotion ? 4 : 0, 0, 0),
                    child: Icon(
                      Icons.arrow_forward,
                      size: 18,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _shell(ColorScheme scheme, Color line, Widget child) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 22),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: line, width: 1),
      ),
      child: child,
    );
  }
}

class _JadwalSkeleton extends StatelessWidget {
  const _JadwalSkeleton();
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: scheme.onSurface.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        const SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 120,
              height: 12,
              color: scheme.onSurface.withValues(alpha: 0.06),
            ),
            const SizedBox(height: 8),
            Container(
              width: 200,
              height: 22,
              color: scheme.onSurface.withValues(alpha: 0.06),
            ),
          ],
        ),
      ],
    );
  }
}

class _JadwalPrompt extends StatelessWidget {
  const _JadwalPrompt({
    required this.message,
    required this.cta,
    required this.onTap,
  });
  final String message;
  final String cta;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.terracotta.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(Icons.location_off_outlined,
              color: AppColors.terracotta, size: 22),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'JADWAL SHOLAT',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.8,
                  color: AppColors.terracotta,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                message,
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: scheme.onSurface.withValues(alpha: 0.78),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        NasuhaPillButton(
          label: cta.toUpperCase(),
          compact: true,
          showArrow: true,
          onTap: onTap,
        ),
      ],
    );
  }
}

/// Lingkaran panah outline yang terisi accent saat parent hover —
/// affordance CTA konsisten untuk semua kartu (CauseHouse cue).
/// Hover state dikendalikan parent (bukan MouseRegion sendiri) supaya
/// bubble ikut menyala saat seluruh kartu di-hover.
class _ArrowBubble extends StatelessWidget {
  const _ArrowBubble({
    required this.hover,
    required this.accent,
    this.size = 34,
  });

  final bool hover;
  final Color accent;
  final double size;

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutQuart,
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: hover ? accent : Colors.transparent,
        border: Border.all(color: accent, width: 1.5),
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutQuart,
        transform: Matrix4.translationValues(
            (hover && !reduceMotion) ? 1.5 : 0, 0, 0),
        child: Icon(
          Icons.arrow_forward,
          size: size * 0.5,
          color: hover ? Colors.white : accent,
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// SECTION HEADER
// ═══════════════════════════════════════════════════════════════════════════

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          title,
          style: TextStyle(
            fontFamily: 'Space Grotesk',
            fontSize: 40,
            fontWeight: FontWeight.w800,
            height: 1.05,
            color: scheme.onSurface,
            letterSpacing: -0.7,
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(
              subtitle,
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 15,
                height: 1.5,
                color: scheme.onSurface.withValues(alpha: 0.78),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// FEATURED ROW — 3 hero cards
// ═══════════════════════════════════════════════════════════════════════════

class _FeaturedRow extends StatelessWidget {
  const _FeaturedRow({
    required this.entrance,
    required this.muhasabahRoute,
    required this.prayerAsync,
  });

  final AnimationController entrance;
  final String muhasabahRoute;
  final AsyncValue<PrayerSchedule?> prayerAsync;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _Reveal(
            controller: entrance,
            order: 3,
            child: _FeaturedCard(
              accent: AppColors.coffee,
              tagline: 'CATAT NIAT',
              title: 'Muhasabah\nhari ini',
              body:
                  'Amal & khilaf hari ini — evaluasi diri singkat sebelum tidur.',
              icon: Icons.self_improvement,
              onTap: () => GoRouter.of(context).push(muhasabahRoute),
            ),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: _Reveal(
            controller: entrance,
            order: 4,
            child: _FeaturedCard(
              accent: AppColors.caramel,
              tagline: 'TILAWAH',
              title: 'Al-Quran\n114 surah',
              body:
                  'Lanjutkan bacaan atau mulai surah baru dengan mushaf naskh.',
              icon: Icons.menu_book,
              onTap: () => GoRouter.of(context).push('/quran'),
            ),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: _Reveal(
            controller: entrance,
            order: 5,
            child: _FeaturedCard(
              accent: AppColors.clay,
              tagline: 'SEDEKAH',
              title: 'Sedekah\nharian',
              body:
                  'Catat sedekah kecil hari ini. Grafik & rekap otomatis.',
              icon: Icons.volunteer_activism,
              onTap: () => GoRouter.of(context).push('/sedekah'),
            ),
          ),
        ),
      ],
    );
  }
}

class _FeaturedCard extends StatefulWidget {
  const _FeaturedCard({
    required this.accent,
    required this.tagline,
    required this.title,
    required this.body,
    required this.icon,
    required this.onTap,
  });

  final Color accent;
  final String tagline;
  final String title;
  final String body;
  final IconData icon;
  final VoidCallback onTap;

  @override
  State<_FeaturedCard> createState() => _FeaturedCardState();
}

class _FeaturedCardState extends State<_FeaturedCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final reduceMotion = MediaQuery.of(context).disableAnimations;

    final tint = widget.accent.withValues(alpha: isDark ? 0.16 : 0.10);
    // Outline firm same-hue (pattern "tegas" dari mobile) — kartu
    // interaktif harus tegas terpisah dari bg cream.
    final line = widget.accent.withValues(alpha: isDark ? 0.55 : 0.5);
    final shadow = _hover
        ? [
            BoxShadow(
              color: widget.accent.withValues(alpha: 0.28),
              blurRadius: 32,
              spreadRadius: 2,
              offset: const Offset(0, 14),
            ),
          ]
        : [
            BoxShadow(
              color: scheme.onSurface.withValues(alpha: 0.06),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ];

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          transform: (_hover && !reduceMotion)
              ? (Matrix4.identity()
                ..translateByDouble(0.0, -6.0, 0.0, 1.0)
                ..scaleByDouble(1.02, 1.02, 1.0, 1.0)
                ..rotateZ(-0.005))
              : Matrix4.identity(),
          transformAlignment: Alignment.center,
          height: 320,
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: scheme.surface,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [scheme.surface, tint],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: line, width: 1.5),
            boxShadow: shadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: widget.accent.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(widget.icon,
                        color: widget.accent, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    widget.tagline,
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2.0,
                      color: widget.accent,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                widget.title,
                style: TextStyle(
                  fontFamily: 'Space Grotesk',
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  height: 1.08,
                  color: scheme.onSurface,
                  letterSpacing: -0.6,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                widget.body,
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 14,
                  height: 1.55,
                  color: scheme.onSurface.withValues(alpha: 0.78),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    'Buka',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: widget.accent,
                    ),
                  ),
                  const SizedBox(width: 10),
                  _ArrowBubble(hover: _hover, accent: widget.accent),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// BENTO SECONDARY — 3x2 grid
// ═══════════════════════════════════════════════════════════════════════════

class _BentoSecondary extends StatelessWidget {
  const _BentoSecondary({required this.entrance});
  final AnimationController entrance;

  static const _tiles = <_BentoTileData>[
    _BentoTileData(
      icon: Icons.fingerprint,
      label: 'Dzikir',
      subtitle: 'Pagi · Petang · Wajib',
      accent: AppColors.caramel,
      route: '/dzikir',
    ),
    _BentoTileData(
      icon: Icons.access_time_filled,
      label: 'Jadwal Sholat',
      subtitle: 'Adzan + hitung mundur',
      accent: AppColors.terracotta,
      route: '/prayer',
    ),
    _BentoTileData(
      icon: Icons.mosque,
      label: 'Sholat Sunnah',
      subtitle: 'Niat + tata cara',
      accent: AppColors.coffee,
      route: '/sholat-sunnah',
    ),
    _BentoTileData(
      icon: Icons.explore,
      label: 'Arah Kiblat',
      subtitle: 'Kompas GPS',
      accent: AppColors.ochre,
      route: '/qibla',
    ),
    _BentoTileData(
      icon: Icons.bar_chart,
      label: 'Analitik',
      subtitle: 'Heatmap · streak ibadah',
      accent: AppColors.clay,
      route: '/analytics',
    ),
    _BentoTileData(
      icon: Icons.emoji_events,
      label: 'Rank & XP',
      subtitle: '27 level',
      accent: AppColors.goldLight,
      route: '/rank',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = 20.0;
        final tileWidth = (constraints.maxWidth - gap * 2) / 3;
        return Column(
          children: [
            for (int row = 0; row < 2; row++) ...[
              if (row > 0) const SizedBox(height: gap),
              Row(
                children: [
                  for (int col = 0; col < 3; col++) ...[
                    if (col > 0) const SizedBox(width: gap),
                    SizedBox(
                      width: tileWidth,
                      child: _Reveal(
                        controller: entrance,
                        order: 7 + row * 3 + col,
                        child: _BentoTile(data: _tiles[row * 3 + col]),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ],
        );
      },
    );
  }
}

class _BentoTileData {
  const _BentoTileData({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.accent,
    required this.route,
  });
  final IconData icon;
  final String label;
  final String subtitle;
  final Color accent;
  final String route;
}

class _BentoTile extends StatefulWidget {
  const _BentoTile({required this.data});
  final _BentoTileData data;

  @override
  State<_BentoTile> createState() => _BentoTileState();
}

class _BentoTileState extends State<_BentoTile> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    final line = widget.data.accent.withValues(alpha: isDark ? 0.55 : 0.5);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: () => GoRouter.of(context).push(widget.data.route),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          transform: (_hover && !reduceMotion)
              ? (Matrix4.identity()..translateByDouble(0.0, -4.0, 0.0, 1.0))
              : Matrix4.identity(),
          transformAlignment: Alignment.center,
          height: 168,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                scheme.surface,
                widget.data.accent
                    .withValues(alpha: isDark ? 0.10 : 0.06),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: line, width: 1.5),
            boxShadow: _hover
                ? [
                    BoxShadow(
                      color: widget.data.accent.withValues(alpha: 0.22),
                      blurRadius: 24,
                      offset: const Offset(0, 12),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: scheme.onSurface.withValues(alpha: 0.04),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: widget.data.accent.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(widget.data.icon,
                    color: widget.data.accent, size: 22),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.data.label,
                          style: TextStyle(
                            fontFamily: 'Space Grotesk',
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            height: 1.1,
                            color: scheme.onSurface,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.data.subtitle,
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 13,
                            color:
                                scheme.onSurface.withValues(alpha: 0.75),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _ArrowBubble(
                      hover: _hover,
                      accent: widget.data.accent,
                      size: 30),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// FOOTER
// ═══════════════════════════════════════════════════════════════════════════

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        children: [
          Text(
            'Nasuha',
            style: TextStyle(
              fontFamily: 'Space Grotesk',
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: scheme.onSurface.withValues(alpha: 0.72),
            ),
          ),
          const SizedBox(width: 12),
          Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                color: scheme.onSurface.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              )),
          const SizedBox(width: 12),
          Text(
            'Level up your soul · Level up your amal',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 13,
              color: scheme.onSurface.withValues(alpha: 0.55),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// REVEAL — staggered entrance util
// ═══════════════════════════════════════════════════════════════════════════

class _Reveal extends StatelessWidget {
  const _Reveal({
    required this.controller,
    required this.order,
    required this.child,
  });

  final AnimationController controller;
  final int order;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    if (reduceMotion) return child;
    // Stagger ~40ms per order, cap max delay ~200ms supaya dashboard load
    // ke task cepat (product register: no orchestrated page-load).
    final clampedOrder = order.clamp(0, 5);
    final start = clampedOrder * 0.04;
    final end = (start + 0.32).clamp(0.0, 1.0);
    final anim = CurvedAnimation(
      parent: controller,
      curve: Interval(start, end, curve: Curves.easeOutCubic),
    );
    return AnimatedBuilder(
      animation: anim,
      builder: (_, __) {
        final t = anim.value;
        return Opacity(
          opacity: t,
          child: Transform.translate(
            offset: Offset(0, (1 - t) * 16),
            child: child,
          ),
        );
      },
    );
  }
}
