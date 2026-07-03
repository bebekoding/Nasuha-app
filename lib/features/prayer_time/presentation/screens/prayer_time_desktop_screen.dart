import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../core/widgets/desktop_page_shell.dart';
import '../../data/repositories/prayer_repository.dart';
import '../../domain/entities/prayer_schedule.dart';

/// Jadwal Sholat desktop (width >= 800). Layout wide:
/// - Header: greeting + city + date + method
/// - Next-prayer hero: countdown besar + waktu adzan berikut
/// - Horizontal 6-card jadwal (Subuh/Terbit/Dzuhur/Ashar/Maghrib/Isya)
///   dengan status now/next/passed color coded.
class PrayerTimeDesktopScreen extends ConsumerStatefulWidget {
  const PrayerTimeDesktopScreen({super.key});

  @override
  ConsumerState<PrayerTimeDesktopScreen> createState() =>
      _PrayerTimeDesktopScreenState();
}

class _PrayerTimeDesktopScreenState
    extends ConsumerState<PrayerTimeDesktopScreen> {
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheduleAsync = ref.watch(todayPrayerScheduleProvider);
    return DesktopPageShell(
      currentRoute: '/prayer',
      eyebrow: 'JADWAL SHOLAT',
      child: scheduleAsync.when(
        loading: () => const Padding(
          padding: EdgeInsets.symmetric(vertical: 100),
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (e, _) => _ErrorState(
            message: '$e',
            onRetry: () => ref.invalidate(todayPrayerScheduleProvider)),
        data: (schedule) {
          if (schedule == null) {
            return _LocationOff(
                onRetry: () =>
                    ref.invalidate(todayPrayerScheduleProvider));
          }
          return _Body(schedule: schedule, now: DateTime.now());
        },
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.schedule, required this.now});
  final PrayerSchedule schedule;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Header(schedule: schedule),
        const SizedBox(height: 28),
        _NextHero(schedule: schedule, now: now),
        const SizedBox(height: 28),
        _ScheduleRow(schedule: schedule, now: now),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// HEADER
// ═══════════════════════════════════════════════════════════════════════════

class _Header extends StatelessWidget {
  const _Header({required this.schedule});
  final PrayerSchedule schedule;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text(
          schedule.locationName ?? 'Jadwal sholat hari ini',
          style: TextStyle(
            fontFamily: 'Space Grotesk',
            fontSize: 44,
            fontWeight: FontWeight.w800,
            height: 1.05,
            color: scheme.onSurface,
            letterSpacing: -0.9,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Icon(Icons.calendar_today,
                size: 15,
                color: scheme.onSurface.withValues(alpha: 0.7)),
            const SizedBox(width: 8),
            Text(
              DateFormat('EEEE, d MMMM y', 'id_ID').format(DateTime.now()),
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: scheme.onSurface.withValues(alpha: 0.78),
              ),
            ),
            const SizedBox(width: 16),
            Icon(Icons.tune,
                size: 15,
                color: scheme.onSurface.withValues(alpha: 0.7)),
            const SizedBox(width: 6),
            Text(
              'Metode: ${schedule.methodName}',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: scheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// NEXT HERO — countdown besar
// ═══════════════════════════════════════════════════════════════════════════

class _NextHero extends StatelessWidget {
  const _NextHero({required this.schedule, required this.now});
  final PrayerSchedule schedule;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final next = schedule.next;
    final diff = next.time.difference(now);
    final h = diff.inHours;
    final m = diff.inMinutes % 60;
    final hhmm = DateFormat.Hm().format(next.time);
    final accent = AppColors.coffee;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            scheme.surface,
            accent.withValues(alpha: 0.10),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: accent.withValues(alpha: 0.28), width: 1.4),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: 0.14),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(Icons.mosque, color: accent, size: 32),
          ),
          const SizedBox(width: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ADZAN BERIKUTNYA',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2.0,
                  color: accent,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                next.name,
                style: TextStyle(
                  fontFamily: 'Space Grotesk',
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  height: 1.0,
                  color: scheme.onSurface,
                  letterSpacing: -0.6,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'pukul $hhmm',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: scheme.onSurface.withValues(alpha: 0.72),
                ),
              ),
            ],
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'HITUNG MUNDUR',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2.0,
                  color: scheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 6),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    diff.isNegative
                        ? '—'
                        : (h > 0
                            ? '${h}j ${m.toString().padLeft(2, '0')}m'
                            : '${diff.inMinutes}m'),
                    style: TextStyle(
                      fontFamily: 'Space Grotesk',
                      fontSize: 48,
                      fontWeight: FontWeight.w800,
                      height: 1.0,
                      color: accent,
                      letterSpacing: -1.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'lagi',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 13,
                  color: scheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// SCHEDULE ROW — 6 cards horizontal
// ═══════════════════════════════════════════════════════════════════════════

class _ScheduleRow extends StatelessWidget {
  const _ScheduleRow({required this.schedule, required this.now});
  final PrayerSchedule schedule;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final times = schedule.allTimes;
    final nextName = schedule.next.name;

    return LayoutBuilder(builder: (context, constraints) {
      const gap = 14.0;
      final cols = times.length;
      final w = (constraints.maxWidth - gap * (cols - 1)) / cols;
      return Row(
        children: [
          for (int i = 0; i < times.length; i++) ...[
            if (i > 0) const SizedBox(width: gap),
            SizedBox(
              width: w,
              child: _PrayerCard(
                name: times[i].name,
                time: times[i].time,
                isNext: times[i].name == nextName,
                isPassed: times[i].time.isBefore(now),
                index: i,
              ),
            ),
          ],
        ],
      );
    });
  }
}

class _PrayerCard extends StatefulWidget {
  const _PrayerCard({
    required this.name,
    required this.time,
    required this.isNext,
    required this.isPassed,
    required this.index,
  });
  final String name;
  final DateTime time;
  final bool isNext;
  final bool isPassed;
  final int index;

  @override
  State<_PrayerCard> createState() => _PrayerCardState();
}

class _PrayerCardState extends State<_PrayerCard> {
  bool _hover = false;

  static const _accents = [
    AppColors.caramel,
    AppColors.goldLight,
    AppColors.ochre,
    AppColors.terracotta,
    AppColors.clay,
    AppColors.coffee,
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    final accent = _accents[widget.index % _accents.length];
    final hhmm = DateFormat.Hm().format(widget.time);

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        transform: (_hover && !reduceMotion)
            ? (Matrix4.identity()..translateByDouble(0.0, -3.0, 0.0, 1.0))
            : Matrix4.identity(),
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 22),
        decoration: BoxDecoration(
          color: widget.isNext
              ? accent.withValues(alpha: 0.10)
              : scheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: widget.isNext
                ? accent
                : (widget.isPassed
                    ? scheme.outline.withValues(alpha: 0.12)
                    : scheme.outline.withValues(alpha: 0.22)),
            width: widget.isNext ? 1.6 : 1.2,
          ),
          boxShadow: _hover
              ? [
                  BoxShadow(
                    color: accent.withValues(alpha: 0.22),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ]
              : [
                  BoxShadow(
                    color: scheme.onSurface.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (widget.isNext)
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: accent,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text(
                  'BERIKUTNYA',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                    color: Colors.white,
                  ),
                ),
              )
            else if (widget.isPassed)
              const _PassedPill()
            else
              const SizedBox(height: 18),
            const SizedBox(height: 10),
            Text(
              widget.name,
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 13,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.6,
                color: widget.isPassed
                    ? scheme.onSurface.withValues(alpha: 0.55)
                    : scheme.onSurface.withValues(alpha: 0.85),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              hhmm,
              style: TextStyle(
                fontFamily: 'Space Grotesk',
                fontSize: 26,
                fontWeight: FontWeight.w800,
                height: 1.0,
                color: widget.isPassed
                    ? scheme.onSurface.withValues(alpha: 0.5)
                    : (widget.isNext ? accent : scheme.onSurface),
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PassedPill extends StatelessWidget {
  const _PassedPill();
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: scheme.onSurface.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        'lewat',
        style: TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          fontSize: 9,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.0,
          color: scheme.onSurface.withValues(alpha: 0.55),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// EMPTY / ERROR STATES
// ═══════════════════════════════════════════════════════════════════════════

class _LocationOff extends StatelessWidget {
  const _LocationOff({required this.onRetry});
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 80),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.location_off,
                size: 56, color: scheme.onSurface.withValues(alpha: 0.4)),
            const SizedBox(height: 20),
            Text(
              'Lokasi tidak tersedia',
              style: TextStyle(
                fontFamily: 'Space Grotesk',
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: scheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Aktifkan izin lokasi di browser supaya Nasuha bisa\nhitung jadwal sholat kota kamu.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 14,
                height: 1.5,
                color: scheme.onSurface.withValues(alpha: 0.72),
              ),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Coba lagi'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 80),
      child: Column(
        children: [
          Text('Error: $message'),
          const SizedBox(height: 12),
          FilledButton(onPressed: onRetry, child: const Text('Coba lagi')),
        ],
      ),
    );
  }
}
