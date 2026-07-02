import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../data/repositories/prayer_repository.dart';
import '../../domain/entities/prayer_schedule.dart';

class PrayerTimeScreen extends ConsumerStatefulWidget {
  const PrayerTimeScreen({super.key});

  @override
  ConsumerState<PrayerTimeScreen> createState() => _PrayerTimeScreenState();
}

class _PrayerTimeScreenState extends ConsumerState<PrayerTimeScreen> {
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    // Rebuild setiap 30 detik agar countdown tetap akurat.
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Jadwal Sholat'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Perbarui',
            onPressed: () => ref.invalidate(todayPrayerScheduleProvider),
          ),
        ],
      ),
      body: scheduleAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (schedule) {
          if (schedule == null) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.location_off, size: 64),
                  const SizedBox(height: 16),
                  Text('Lokasi tidak tersedia',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  const Text(
                    'Mohon aktifkan layanan lokasi dan berikan izin akses lokasi.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: () =>
                        ref.invalidate(todayPrayerScheduleProvider),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Coba lagi'),
                  ),
                ],
              ),
            );
          }

          return _PrayerBody(schedule: schedule, now: DateTime.now());
        },
      ),
    );
  }
}

class _PrayerBody extends StatelessWidget {
  const _PrayerBody({required this.schedule, required this.now});

  final PrayerSchedule schedule;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final next = schedule.next;
    final diff = next.time.difference(now);
    final h = diff.inHours;
    final m = diff.inMinutes % 60;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Lokasi card ──────────────────────────────────────────
          _LocationCard(schedule: schedule),
          const SizedBox(height: 12),

          // ── Next prayer hero ─────────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.primaryContainer,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sholat selanjutnya',
                        style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onPrimary
                              .withValues(alpha: 0.8),
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${next.icon} ${next.name}',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        DateFormat('HH:mm').format(next.time),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      h > 0 ? '${h}j ${m}m' : '${m}m',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      'lagi',
                      style: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .onPrimary
                            .withValues(alpha: 0.8),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // ── Prayer times table ────────────────────────────────────
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
              child: Column(
                children: [
                  for (final t in schedule.allTimes)
                    _PrayerRow(
                      icon: t.icon,
                      name: t.name,
                      time: t.time,
                      isNext: t.name == next.name,
                      isPast: t.time.isBefore(now),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LocationCard extends StatelessWidget {
  const _LocationCard({required this.schedule});

  final PrayerSchedule schedule;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final latStr =
        '${schedule.latitude.toStringAsFixed(4)}° ${schedule.latitude >= 0 ? 'N' : 'S'}';
    final lngStr =
        '${schedule.longitude.abs().toStringAsFixed(4)}° ${schedule.longitude >= 0 ? 'E' : 'W'}';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: scheme.primaryContainer,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.location_on,
                color: scheme.onPrimaryContainer, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Kota + Negara
                Text(
                  schedule.locationName ?? 'Lokasi terdeteksi',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                // Koordinat
                Text(
                  '$latStr  $lngStr',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: scheme.outline,
                        fontFamily: 'monospace',
                        fontSize: 11,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Metode kalkulasi
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: scheme.secondaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              _shortMethod(schedule.methodName),
              style: TextStyle(
                color: scheme.onSecondaryContainer,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _shortMethod(String m) {
    return switch (m) {
      'muslim_world_league' => 'MWL',
      'karachi' => 'Karachi',
      'umm_al_qura' => "Umm Al-Qura",
      'egyptian' => 'Egypt',
      'singapore' => 'MUIS',
      'dubai' => 'Dubai',
      'kuwait' => 'Kuwait',
      'qatar' => 'Qatar',
      'turkey' => 'Turkey',
      'tehran' => 'Tehran',
      'north_america' => 'ISNA',
      _ => m,
    };
  }
}

class _PrayerRow extends StatelessWidget {
  const _PrayerRow({
    required this.icon,
    required this.name,
    required this.time,
    required this.isNext,
    required this.isPast,
  });

  final String icon;
  final String name;
  final DateTime time;
  final bool isNext;
  final bool isPast;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final Color fg = isNext
        ? scheme.primary
        : isPast
            ? scheme.outline.withValues(alpha: 0.6)
            : scheme.onSurface;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
      decoration: isNext
          ? BoxDecoration(
              color: scheme.primaryContainer.withValues(alpha: 0.35),
              borderRadius: BorderRadius.circular(12),
            )
          : null,
      child: ListTile(
        dense: true,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
        leading: Text(icon, style: const TextStyle(fontSize: 22)),
        title: Text(
          name,
          style: TextStyle(
            color: fg,
            fontWeight: isNext ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              DateFormat('HH:mm').format(time),
              style: TextStyle(
                color: fg,
                fontSize: 18,
                fontWeight: isNext ? FontWeight.w800 : FontWeight.w600,
              ),
            ),
            if (isNext) ...[
              const SizedBox(width: 6),
              Icon(Icons.arrow_forward_ios_rounded,
                  size: 14, color: scheme.primary),
            ],
          ],
        ),
      ),
    );
  }
}
