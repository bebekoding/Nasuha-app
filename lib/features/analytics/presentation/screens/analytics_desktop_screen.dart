import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../core/widgets/desktop_page_shell.dart';
import '../providers/analytics_providers.dart';
import '../widgets/heatmap_calendar.dart';
import '../widgets/spiritual_curve.dart';

/// Analitik dashboard desktop (width >= 800). 12-col grid feel:
/// - Row 1: 4 stat metric tile
/// - Row 2: Kurva Spiritual (span 2/3) + Konsistensi Ibadah panel (span 1/3)
/// - Row 3: Heatmap Aktivitas full-width dengan legend visible
class AnalyticsDesktopScreen extends ConsumerWidget {
  const AnalyticsDesktopScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(analyticsSummaryProvider);
    final heatmapAsync = ref.watch(heatmapScoresProvider);
    final habitsAsync = ref.watch(habitStreaksProvider);
    final range = ref.watch(analyticsRangeProvider);

    return DesktopPageShell(
      currentRoute: '/analytics',
      eyebrow: 'ANALITIK',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Header(range: range, onRange: (d) {
            ref.read(analyticsRangeProvider.notifier).state = d;
          }),
          const SizedBox(height: 28),
          summaryAsync.when(
            loading: () => const _RowSkeleton(),
            error: (e, _) => Text('Error: $e'),
            data: (s) => _MetricRow(summary: s),
          ),
          const SizedBox(height: 24),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 3,
                  child: _CurvePanel(summaryAsync: summaryAsync),
                ),
                const SizedBox(width: 20),
                Expanded(
                  flex: 2,
                  child: _HabitsPanel(habitsAsync: habitsAsync),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _HeatmapPanel(heatmapAsync: heatmapAsync),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// HEADER + range switcher
// ═══════════════════════════════════════════════════════════════════════════

class _Header extends StatelessWidget {
  const _Header({required this.range, required this.onRange});
  final Duration range;
  final ValueChanged<Duration> onRange;

  static const _ranges = [
    (Duration(days: 7), '7 hari'),
    (Duration(days: 30), '30 hari'),
    (Duration(days: 90), '90 hari'),
    (Duration(days: 365), '1 tahun'),
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(
                'Bagaimana ritme ibadahmu?',
                style: TextStyle(
                  fontFamily: 'Space Grotesk',
                  fontSize: 42,
                  fontWeight: FontWeight.w800,
                  height: 1.05,
                  color: scheme.onSurface,
                  letterSpacing: -0.9,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Lihat pola, kenali momen produktif, perbaiki di titik lemah.',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 16,
                  height: 1.5,
                  fontWeight: FontWeight.w500,
                  color: scheme.onSurface.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        _RangeSwitcher(
            range: range, ranges: _ranges, onSelect: onRange),
      ],
    );
  }
}

class _RangeSwitcher extends StatelessWidget {
  const _RangeSwitcher({
    required this.range,
    required this.ranges,
    required this.onSelect,
  });

  final Duration range;
  final List<(Duration, String)> ranges;
  final ValueChanged<Duration> onSelect;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
            color: scheme.outline.withValues(alpha: 0.22), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final r in ranges)
            _RangeChip(
              label: r.$2,
              active: range == r.$1,
              onTap: () => onSelect(r.$1),
            ),
        ],
      ),
    );
  }
}

class _RangeChip extends StatefulWidget {
  const _RangeChip(
      {required this.label, required this.active, required this.onTap});
  final String label;
  final bool active;
  final VoidCallback onTap;
  @override
  State<_RangeChip> createState() => _RangeChipState();
}

class _RangeChipState extends State<_RangeChip> {
  bool _hover = false;
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: widget.active
                ? scheme.primary
                : (_hover
                    ? scheme.onSurface.withValues(alpha: 0.05)
                    : Colors.transparent),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            widget.label,
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 13,
              fontWeight:
                  widget.active ? FontWeight.w700 : FontWeight.w600,
              color: widget.active
                  ? Colors.white
                  : scheme.onSurface.withValues(alpha: 0.78),
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// METRIC ROW — 4 stat tiles
// ═══════════════════════════════════════════════════════════════════════════

class _MetricRow extends StatelessWidget {
  const _MetricRow({required this.summary});
  final dynamic summary;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatTile(
            accent: AppColors.coffee,
            icon: Icons.bolt,
            label: 'TOTAL XP',
            value: '${summary.total}',
            sub: 'Sepanjang periode',
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _StatTile(
            accent: AppColors.caramel,
            icon: Icons.trending_up,
            label: 'RATA-RATA / HARI',
            value: summary.average.toStringAsFixed(1),
            sub: 'XP per hari aktif',
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _StatTile(
            accent: AppColors.goldLight,
            icon: Icons.star,
            label: 'HARI TERBAIK',
            value: summary.bestDay == null ? '—' : '${summary.bestDay!.total}',
            sub: summary.bestDay == null
                ? ' '
                : DateFormat('d MMM y', 'id_ID')
                    .format(DateTime.parse(summary.bestDay!.dateKey)),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _StatTile(
            accent: AppColors.clay,
            icon: Icons.warning_amber_rounded,
            label: 'HARI TERBERAT',
            value: summary.worstDay == null
                ? '—'
                : '${summary.worstDay!.total}',
            sub: summary.worstDay == null
                ? ' '
                : DateFormat('d MMM y', 'id_ID')
                    .format(DateTime.parse(summary.worstDay!.dateKey)),
          ),
        ),
      ],
    );
  }
}

class _StatTile extends StatefulWidget {
  const _StatTile({
    required this.accent,
    required this.icon,
    required this.label,
    required this.value,
    required this.sub,
  });
  final Color accent;
  final IconData icon;
  final String label;
  final String value;
  final String sub;

  @override
  State<_StatTile> createState() => _StatTileState();
}

class _StatTileState extends State<_StatTile> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        transform: (_hover && !reduceMotion)
            ? (Matrix4.identity()..translateByDouble(0.0, -2.0, 0.0, 1.0))
            : Matrix4.identity(),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
              color: widget.accent.withValues(alpha: _hover ? 0.42 : 0.24),
              width: 1.2),
          boxShadow: _hover
              ? [
                  BoxShadow(
                    color: widget.accent.withValues(alpha: 0.18),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
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
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: widget.accent.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(widget.icon, color: widget.accent, size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    widget.label,
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.6,
                      color: widget.accent,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              widget.value,
              style: TextStyle(
                fontFamily: 'Space Grotesk',
                fontSize: 30,
                fontWeight: FontWeight.w800,
                color: scheme.onSurface,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.sub,
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 12,
                color: scheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// CURVE PANEL (Kurva Spiritual) — big card
// ═══════════════════════════════════════════════════════════════════════════

class _CurvePanel extends StatelessWidget {
  const _CurvePanel({required this.summaryAsync});
  final AsyncValue summaryAsync;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
            color: scheme.outline.withValues(alpha: 0.16), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Kurva Spiritual',
            style: TextStyle(
              fontFamily: 'Space Grotesk',
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: scheme.onSurface,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Naik-turun XP hari demi hari. Semakin banyak amalan, semakin tinggi kurvanya.',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 13,
              color: scheme.onSurface.withValues(alpha: 0.72),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 260,
            child: summaryAsync.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (s) => SpiritualCurve(scores: s.scores),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// HABITS PANEL — Konsistensi Ibadah
// ═══════════════════════════════════════════════════════════════════════════

class _HabitsPanel extends StatelessWidget {
  const _HabitsPanel({required this.habitsAsync});
  final AsyncValue habitsAsync;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
            color: scheme.outline.withValues(alpha: 0.16), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Konsistensi Ibadah',
            style: TextStyle(
              fontFamily: 'Space Grotesk',
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: scheme.onSurface,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Streak per amalan. Hari beruntun akan reset kalau lewat 1 hari.',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 13,
              color: scheme.onSurface.withValues(alpha: 0.72),
            ),
          ),
          const SizedBox(height: 16),
          habitsAsync.when(
            loading: () => const Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => Text('Error: $e'),
            data: (habits) => Column(
              children: [
                for (final h in habits) ...[
                  _HabitRow(habit: h),
                  const SizedBox(height: 8),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HabitRow extends StatelessWidget {
  const _HabitRow({required this.habit});
  final dynamic habit;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final active = habit.current > 0;
    final unit = habit.weekly ? '×' : ' hr';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: scheme.onSurface.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: active
                ? AppColors.goldLight.withValues(alpha: 0.32)
                : scheme.outline.withValues(alpha: 0.14),
            width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.caramel.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(habit.icon, size: 18, color: AppColors.caramel),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  habit.label,
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: scheme.onSurface,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  'Terpanjang ${habit.longest}$unit · Total ${habit.total}',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 11,
                    color: scheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Icon(Icons.local_fire_department,
                  size: 16,
                  color: active
                      ? AppColors.goldLight
                      : scheme.outline.withValues(alpha: 0.5)),
              const SizedBox(width: 2),
              Text(
                '${habit.current}$unit',
                style: TextStyle(
                  fontFamily: 'Space Grotesk',
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: active
                      ? AppColors.goldLight
                      : scheme.onSurface.withValues(alpha: 0.5),
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
// HEATMAP PANEL — full width
// ═══════════════════════════════════════════════════════════════════════════

class _HeatmapPanel extends StatelessWidget {
  const _HeatmapPanel({required this.heatmapAsync});
  final AsyncValue heatmapAsync;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
            color: scheme.outline.withValues(alpha: 0.16), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Heatmap Aktivitas',
            style: TextStyle(
              fontFamily: 'Space Grotesk',
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: scheme.onSurface,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Tiap kotak = satu hari. Warna makin pekat = XP lebih banyak. Cari ritmemu.',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 13,
              color: scheme.onSurface.withValues(alpha: 0.72),
            ),
          ),
          const SizedBox(height: 20),
          heatmapAsync.when(
            loading: () => const Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => Text('Error: $e'),
            data: (data) => HeatmapCalendar(scores: data),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// SKELETON
// ═══════════════════════════════════════════════════════════════════════════

class _RowSkeleton extends StatelessWidget {
  const _RowSkeleton();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      children: List.generate(4, (i) {
        return Padding(
          padding: EdgeInsets.only(left: i == 0 ? 0 : 16),
          child: Container(
            width: 220,
            height: 120,
            decoration: BoxDecoration(
              color: scheme.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                  color: scheme.outline.withValues(alpha: 0.12), width: 1),
            ),
          ),
        );
      }),
    );
  }
}
