import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../providers/analytics_providers.dart';
import '../widgets/heatmap_calendar.dart';
import '../widgets/spiritual_curve.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(analyticsSummaryProvider);
    final heatmapAsync = ref.watch(heatmapScoresProvider);
    final habitsAsync = ref.watch(habitStreaksProvider);
    final range = ref.watch(analyticsRangeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Analitik')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SegmentedButton<Duration>(
            segments: const [
              ButtonSegment(
                  value: Duration(days: 7), label: Text('7H')),
              ButtonSegment(
                  value: Duration(days: 30), label: Text('30H')),
              ButtonSegment(
                  value: Duration(days: 90), label: Text('90H')),
              ButtonSegment(
                  value: Duration(days: 365), label: Text('1T')),
            ],
            selected: {range},
            onSelectionChanged: (s) =>
                ref.read(analyticsRangeProvider.notifier).state = s.first,
          ),
          const SizedBox(height: 16),
          summaryAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text('Error: $e'),
            data: (s) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        label: 'Total XP',
                        value: '${s.total}',
                        icon: Icons.score,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        label: 'Rata-rata',
                        value: s.average.toStringAsFixed(1),
                        icon: Icons.trending_up,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        label: 'Hari terbaik',
                        value: s.bestDay == null
                            ? '-'
                            : '${s.bestDay!.total}',
                        sub: s.bestDay == null
                            ? null
                            : DateFormat('d MMM').format(
                                DateTime.parse(s.bestDay!.dateKey)),
                        icon: Icons.star,
                        color: const Color(0xFFA77B43),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        label: 'Hari terburuk',
                        value: s.worstDay == null
                            ? '-'
                            : '${s.worstDay!.total}',
                        sub: s.worstDay == null
                            ? null
                            : DateFormat('d MMM').format(
                                DateTime.parse(s.worstDay!.dateKey)),
                        icon: Icons.warning_amber,
                        color: const Color(0xFFB5613F),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text('Kurva Spiritual',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: SpiritualCurve(scores: s.scores),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text('Konsistensi Ibadah',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(
            'Hari beruntun kamu menjaga tiap amalan. Streak terisi otomatis '
            'saat amalan tercatat hari itu.',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Theme.of(context).colorScheme.outline),
          ),
          const SizedBox(height: 10),
          habitsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text('Error: $e'),
            data: (habits) => Column(
              children: [
                for (final h in habits) _HabitStreakTile(habit: h),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text('Heatmap Aktivitas',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(
            'Tiap kotak = satu hari (±4 bulan terakhir). Makin pekat warnanya, '
            'makin tinggi XP hari itu. Pakai ini untuk melihat ritme harianmu.',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Theme.of(context).colorScheme.outline),
          ),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: heatmapAsync.when(
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (e, _) => Text('Error: $e'),
                data: (data) => HeatmapCalendar(scores: data),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HabitStreakTile extends StatelessWidget {
  const _HabitStreakTile({required this.habit});
  final HabitStreak habit;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final active = habit.current > 0;
    const flame = Color(0xFFC1923C);
    final unit = habit.weekly ? '×' : ' hari';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: scheme.primaryContainer.withValues(alpha: 0.6),
              shape: BoxShape.circle,
            ),
            child: Icon(habit.icon,
                size: 20, color: scheme.onPrimaryContainer),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(habit.label,
                    style:
                        const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(
                  'Terpanjang ${habit.longest}$unit · Total ${habit.total} hari',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: scheme.outline),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.local_fire_department,
                      size: 18,
                      color: active ? flame : scheme.outlineVariant),
                  const SizedBox(width: 2),
                  Text('${habit.current}$unit',
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                          color: active ? flame : scheme.outline)),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                habit.weekly
                    ? 'Senin & Kamis'
                    : (habit.doneToday ? '✓ hari ini' : 'belum hari ini'),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 10,
                      color: habit.doneToday && !habit.weekly
                          ? const Color(0xFF7A8450)
                          : scheme.outline,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    this.sub,
    required this.icon,
    this.color,
  });

  final String label;
  final String value;
  final String? sub;
  final IconData icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = color ?? Theme.of(context).colorScheme.primary;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: c.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: c, size: 18),
          const SizedBox(height: 8),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 2),
          Text(value,
              style: TextStyle(
                color: c,
                fontWeight: FontWeight.w800,
                fontSize: 22,
              )),
          if (sub != null)
            Text(sub!,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: c)),
        ],
      ),
    );
  }
}
