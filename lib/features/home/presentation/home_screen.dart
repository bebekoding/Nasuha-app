import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../config/theme/app_colors.dart';
import '../../../config/theme/neo_style.dart';
import '../../../config/theme/theme_controller.dart' show sharedPrefsProvider;
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/desktop_page_shell.dart'
    show DesktopSunburstBackdrop;
import '../../../services/database/legacy_isar_check.dart';
import '../../muhasabah/presentation/providers/muhasabah_enabled_provider.dart';
import '../../muhasabah/presentation/providers/muhasabah_providers.dart';
import '../../muhasabah/presentation/widgets/score_card.dart';
import '../../rank/presentation/providers/rank_provider.dart';
import '../../prayer_time/data/repositories/prayer_repository.dart';
import '../../prayer_time/domain/entities/prayer_schedule.dart';
import '../../settings/presentation/providers/settings_providers.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entrance;

  @override
  void initState() {
    super.initState();
    _entrance = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 950),
    );
    // Play the staggered reveal once after the first frame. The controller
    // lives in State, so provider-driven rebuilds (score, prayer) don't restart it.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _entrance.forward();
      _maybeShowLegacyIsarPrompt();
    });
  }

  Future<void> _maybeShowLegacyIsarPrompt() async {
    final prefs = ref.read(sharedPrefsProvider);
    final detected = prefs.getBool(kLegacyIsarDetectedPref) ?? false;
    final handled = prefs.getBool(kLegacyIsarHandledPref) ?? false;
    if (!detected || handled) return;
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.upgrade),
        title: const Text('Data versi lama terdeteksi'),
        content: const Text(
          'Kamu upgrade Nasuha dari versi lama (v1.1.x atau sebelumnya). '
          'Karena mesin database berganti, data lama tidak otomatis '
          'dipindah.\n\n'
          'Kalau ada backup (file .mhsb atau di Google Drive), silakan '
          'pulihkan lewat Pengaturan → Akun & Pemulihan. Data lama tetap '
          'disimpan aman di HP sebagai legacy-isar-backup.bin.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Fire-and-forget; UI tak menunggu I/O sync.
              prefs.setBool(kLegacyIsarHandledPref, true);
              Navigator.pop(ctx);
            },
            child: const Text('Nanti saja'),
          ),
          FilledButton(
            onPressed: () {
              prefs.setBool(kLegacyIsarHandledPref, true);
              Navigator.pop(ctx);
              context.push('/backup');
            },
            child: const Text('Ke halaman pemulihan'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _entrance.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scoreAsync = ref.watch(todayScoreProvider);
    final streakAsync = ref.watch(muhasabahStreakProvider);
    final prayerAsync = ref.watch(todayPrayerScheduleProvider);
    final rankAsync = ref.watch(rankProgressProvider);
    final settings = ref.watch(settingsControllerProvider);
    final muhasabahOn = ref.watch(muhasabahEnabledProvider);
    final muhasabahRoute = muhasabahOn ? '/muhasabah' : '/muhasabah/intro';

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Stack(
        children: [
          // Sunburst rays halus di belakang header — signature visual
          // desktop dibawa ke mobile (light only, subtle).
          if (!isDark)
            const Positioned.fill(
              child: IgnorePointer(child: DesktopSunburstBackdrop()),
            ),
          SafeArea(
            child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Eyebrow tanggal uppercase tracked — port dari
                          // hero desktop.
                          Text(
                            DateFormat('EEEE, d MMMM y', 'id_ID')
                                .format(DateTime.now())
                                .toUpperCase(),
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.8,
                              color: scheme.primary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _greeting(settings.displayName),
                            style: TextStyle(
                              fontFamily: 'Space Grotesk',
                              fontSize: 26,
                              height: 1.1,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                              color: scheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton.filledTonal(
                      icon: const Icon(Icons.person_outline),
                      onPressed: () => context.push('/profile'),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: _Reveal(
                  controller: _entrance,
                  order: 0,
                  child: muhasabahOn
                      ? _Pressable(
                          onTap: () => context.push('/muhasabah'),
                          child: ScoreCard(
                            score: scoreAsync.valueOrNull,
                            streak: streakAsync.valueOrNull?.current ?? 0,
                            rank: rankAsync.valueOrNull,
                            onRankTap: () => context.push('/rank'),
                          ),
                        )
                      : _MuhasabahPromptCard(
                          onTap: () => context.push('/muhasabah/intro'),
                        ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: _Reveal(
                  controller: _entrance,
                  order: 1,
                  child: prayerAsync.when(
                    loading: () => const _NextPrayerSkeleton(),
                    error: (_, __) => const SizedBox.shrink(),
                    data: (schedule) {
                      if (schedule == null) {
                        return _LocationPromptCard(
                          onTap: () => context.push('/prayer'),
                        );
                      }
                      return _NextPrayerCard(schedule: schedule);
                    },
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                child: _Reveal(
                  controller: _entrance,
                  order: 2,
                  child: Text(
                    'Menu',
                    style: TextStyle(
                      fontFamily: 'Space Grotesk',
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.4,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              sliver: SliverGrid(
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.5,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                ),
                delegate: SliverChildListDelegate(_reveal([
                  _MenuTile(
                    icon: Icons.self_improvement,
                    label: AppStrings.muhasabah,
                    subtitle: 'Evaluasi diri',
                    color: Theme.of(context).colorScheme.primary,
                    onTap: () => context.push(muhasabahRoute),
                  ),
                  _MenuTile(
                    icon: Icons.access_time_filled,
                    label: AppStrings.jadwalSholat,
                    subtitle: '5 waktu',
                    color: const Color(0xFFC17A53),
                    onTap: () => context.push('/prayer'),
                  ),
                  _MenuTile(
                    icon: Icons.explore,
                    label: AppStrings.arahKiblat,
                    subtitle: 'Kompas',
                    color: const Color(0xFFC1923C),
                    onTap: () => context.push('/qibla'),
                  ),
                  _MenuTile(
                    icon: Icons.menu_book,
                    label: AppStrings.alquran,
                    subtitle: '114 surah',
                    color: const Color(0xFFA6785F),
                    onTap: () => context.push('/quran'),
                  ),
                  _MenuTile(
                    icon: Icons.fingerprint,
                    label: 'Dzikir',
                    subtitle: 'Pagi · Petang · dll',
                    color: const Color(0xFFA77B43),
                    onTap: () => context.push('/dzikir'),
                  ),
                  _MenuTile(
                    icon: Icons.mosque,
                    label: 'Sholat Sunnah',
                    subtitle: 'Tata cara',
                    color: const Color(0xFFC28455),
                    onTap: () => context.push('/sholat-sunnah'),
                  ),
                  _MenuTile(
                    icon: Icons.volunteer_activism,
                    label: AppStrings.sedekah,
                    subtitle: 'Tracker',
                    color: const Color(0xFFB5613F),
                    onTap: () => context.push('/sedekah'),
                  ),
                  _MenuTile(
                    icon: Icons.paid,
                    label: 'Zakat',
                    subtitle: 'Mal · Fitrah',
                    color: const Color(0xFFC1923C),
                    onTap: () => context.push('/zakat'),
                  ),
                  _MenuTile(
                    icon: Icons.bar_chart,
                    label: AppStrings.analytics,
                    subtitle: 'Statistik',
                    color: const Color(0xFFC17A53),
                    onTap: () => context.push('/analytics'),
                  ),
                ])),
              ),
            ),
          ],
            ),
          ),
        ],
      ),
    );
  }

  /// Wraps each menu tile in a staggered reveal, continuing the order after
  /// the cards above the grid (which use orders 0–2).
  List<Widget> _reveal(List<Widget> tiles) {
    return [
      for (var i = 0; i < tiles.length; i++)
        _Reveal(controller: _entrance, order: 3 + i, child: tiles[i]),
    ];
  }

  String _greeting(String? name) {
    final h = DateTime.now().hour;
    final base = switch (h) {
      < 4 => 'Tahajud yang berkah',
      < 11 => 'Selamat pagi',
      < 15 => 'Selamat siang',
      < 18 => 'Selamat sore',
      _ => 'Selamat malam',
    };
    if (name != null && name.trim().isNotEmpty) {
      return '$base, ${name.split(' ').first}';
    }
    return base;
  }
}

class _MuhasabahPromptCard extends StatelessWidget {
  const _MuhasabahPromptCard({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                NeoStyle.tint(context, scheme.primary, 0.16),
                NeoStyle.tint(context, scheme.tertiary, 0.10),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: NeoStyle.border(context),
            boxShadow: NeoStyle.shadow(context),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: scheme.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(Icons.self_improvement,
                    color: scheme.primary, size: 26),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Mulai Muhasabah',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.w800)),
                    const SizedBox(height: 2),
                    Text(
                      'Evaluasi diri harian untuk hidup lebih sadar. Ketuk untuk mulai.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant, height: 1.3),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward, color: scheme.primary, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

/// Bubble jadwal sholat live — port dari desktop _JadwalNextHero:
/// countdown per detik (tabular figures), state "sudah masuk waktu"
/// dengan window 15 menit, aksen terracotta firm.
class _NextPrayerCard extends StatefulWidget {
  const _NextPrayerCard({required this.schedule});

  final PrayerSchedule schedule;

  @override
  State<_NextPrayerCard> createState() => _NextPrayerCardState();
}

class _NextPrayerCardState extends State<_NextPrayerCard> {
  static const Duration _activeWindow = Duration(minutes: 15);
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    final reduceMotion =
        WidgetsBinding.instance.platformDispatcher.accessibilityFeatures
            .disableAnimations;
    // Detik live bikin kartu terasa hidup; kalau reduce-motion aktif,
    // cukup refresh per menit.
    _ticker = Timer.periodic(
      Duration(seconds: reduceMotion ? 60 : 1),
      (_) {
        if (mounted) setState(() {});
      },
    );
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  ({String name, DateTime time, String icon})? _activePrayer(DateTime now) {
    for (final t in widget.schedule.allTimes.reversed) {
      final since = now.difference(t.time);
      if (!since.isNegative && since < _activeWindow) return t;
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
    if (h > 0) return '${h}j ${mm}m';
    return '${d.inMinutes}m ${ss}d';
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final now = DateTime.now();
    final active = _activePrayer(now);
    final isActive = active != null;
    final prayer = isActive ? active : widget.schedule.next;
    final color = isActive ? AppColors.caramel : AppColors.terracotta;

    return _Pressable(
      onTap: () => context.push('/prayer'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              scheme.surface,
              NeoStyle.tint(context, color, isDark ? 0.18 : 0.12),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: NeoStyle.border(context),
          boxShadow: NeoStyle.shadow(context),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(Icons.mosque, color: color, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isActive ? 'WAKTU SHOLAT SEKARANG' : 'ADZAN BERIKUTNYA',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.4,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${prayer.name} · ${DateFormat('HH:mm').format(prayer.time)}',
                    style: TextStyle(
                      fontFamily: 'Space Grotesk',
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3,
                      color: scheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            if (isActive)
              Icon(Icons.notifications_active, color: color, size: 22)
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _fmtCountdown(prayer.time.difference(now)),
                    style: TextStyle(
                      fontFamily: 'Space Grotesk',
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      height: 1.0,
                      color: color,
                      letterSpacing: -0.4,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'lagi',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.0,
                      color: scheme.onSurface.withValues(alpha: 0.55),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _LocationPromptCard extends StatelessWidget {
  const _LocationPromptCard({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: NeoStyle.tint(
                context, scheme.surfaceContainerHighest, 0.5),
            borderRadius: BorderRadius.circular(20),
            border: NeoStyle.border(context),
            boxShadow: NeoStyle.shadow(context),
          ),
          child: Row(
            children: [
              Icon(Icons.location_off, color: scheme.outline),
              const SizedBox(width: 12),
              const Expanded(
                child: Text('Ketuk untuk mengaktifkan jadwal sholat'),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}

class _NextPrayerSkeleton extends StatelessWidget {
  const _NextPrayerSkeleton();
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2)),
          const SizedBox(width: 12),
          Text('Memuat jadwal sholat…',
              style: TextStyle(color: scheme.outline)),
        ],
      ),
    );
  }
}

class _MenuTile extends StatefulWidget {
  const _MenuTile({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  @override
  State<_MenuTile> createState() => _MenuTileState();
}

class _MenuTileState extends State<_MenuTile> {
  bool _pressed = false;

  void _setPressed(bool v) {
    if (mounted && _pressed != v) setState(() => _pressed = v);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = widget.color;

    return GestureDetector(
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      onTap: widget.onTap,
      child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          // Neo-brutal press: kartu "masuk" ke halaman — geser ke arah
          // bayangan sambil bayangannya mengecil.
          transform: _pressed
              ? Matrix4.translationValues(3, 3, 0)
              : Matrix4.identity(),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            // Fill gradient tint per-accent (identitas fitur) + garis ink
            // + hard shadow (vocabulary jurnal-in) supaya box tegas.
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                NeoStyle.tint(context, color, 0.26),
                NeoStyle.tint(context, color, 0.12),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: NeoStyle.border(context),
            boxShadow:
                NeoStyle.shadow(context, offset: _pressed ? 1 : 4),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(9),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.30),
                      borderRadius: BorderRadius.circular(14),
                      border:
                          Border.all(color: color.withValues(alpha: 0.45)),
                    ),
                    child: Icon(widget.icon, color: color, size: 21),
                  ),
                  // Arrow bubble mini — terisi saat ditekan (affordance
                  // CTA konsisten dengan kartu desktop).
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 140),
                    curve: Curves.easeOut,
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _pressed ? color : Colors.transparent,
                      border: Border.all(
                          color: color.withValues(alpha: 0.7), width: 1.3),
                    ),
                    child: Icon(
                      Icons.arrow_forward,
                      size: 12,
                      color: _pressed ? Colors.white : color,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.label,
                      style: TextStyle(
                          fontFamily: 'Space Grotesk',
                          color: scheme.onSurface,
                          fontSize: 15,
                          letterSpacing: -0.2,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 1),
                  Text(widget.subtitle,
                      style: TextStyle(
                          color: scheme.onSurfaceVariant,
                          fontSize: 12,
                          fontWeight: FontWeight.w500)),
                ],
              ),
            ],
          ),
      ),
    );
  }
}

/// Staggered entrance: fade + upward slide driven by a shared controller,
/// offset by [order] so items reveal one after another.
class _Reveal extends StatelessWidget {
  const _Reveal({
    required this.controller,
    required this.order,
    required this.child,
  });

  final Animation<double> controller;
  final int order;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    // Reduce-motion: langsung tampil tanpa animasi entrance.
    if (MediaQuery.of(context).disableAnimations) return child;
    final start = (order * 0.07).clamp(0.0, 0.45);
    final anim = CurvedAnimation(
      parent: controller,
      curve: Interval(start, (start + 0.55).clamp(0.0, 1.0),
          curve: Curves.easeOutQuart),
    );
    return AnimatedBuilder(
      animation: anim,
      builder: (context, child) {
        final t = anim.value;
        // Pop-in: fade + rise + scale halus (0.96→1) — playful tanpa
        // bounce/elastic.
        return Opacity(
          opacity: t,
          child: Transform.translate(
            offset: Offset(0, (1 - t) * 20),
            child: Transform.scale(
              scale: 0.96 + 0.04 * t,
              child: child,
            ),
          ),
        );
      },
      child: child,
    );
  }
}

/// Wraps a tappable card with a subtle press-in scale for a tactile feel.
class _Pressable extends StatefulWidget {
  const _Pressable({required this.onTap, required this.child});
  final VoidCallback onTap;
  final Widget child;

  @override
  State<_Pressable> createState() => _PressableState();
}

class _PressableState extends State<_Pressable> {
  bool _pressed = false;
  void _set(bool v) {
    if (mounted && _pressed != v) setState(() => _pressed = v);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _set(true),
      onTapUp: (_) => _set(false),
      onTapCancel: () => _set(false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}
