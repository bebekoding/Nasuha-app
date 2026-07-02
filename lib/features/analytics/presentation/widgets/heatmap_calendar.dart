import 'package:flutter/material.dart';

import '../../../../core/extensions/date_extensions.dart';

/// Kalender heatmap ala GitHub: kolom = pekan, baris = hari (Senin–Minggu).
/// Warna kotak menunjukkan besar XP hari itu.
class HeatmapCalendar extends StatelessWidget {
  const HeatmapCalendar({super.key, required this.scores, this.weeks = 18});

  /// Map dateKey (yyyy-MM-dd) → skor XP harian.
  final Map<String, int> scores;
  final int weeks;

  static const _dayLabels = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
  static const _cell = 14.0;
  static const _vGap = 2.0;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    // Senin pekan ini, lalu mundur (weeks-1) pekan sebagai awal.
    final currentMonday =
        today.subtract(Duration(days: today.weekday - 1));
    final firstMonday =
        currentMonday.subtract(Duration(days: (weeks - 1) * 7));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Label hari (tampilkan Sen/Rab/Jum/Min agar tak penuh).
            Column(
              children: [
                for (var d = 0; d < 7; d++)
                  SizedBox(
                    height: _cell + _vGap * 2,
                    width: 26,
                    child: Center(
                      child: Text(
                        d.isEven ? _dayLabels[d] : '',
                        style:
                            TextStyle(fontSize: 9, color: scheme.outline),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 4),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                reverse: true,
                child: Row(
                  children: [
                    for (var w = 0; w < weeks; w++)
                      Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 1.5),
                        child: Column(
                          children: [
                            for (var d = 0; d < 7; d++)
                              _cellBox(
                                context,
                                firstMonday
                                    .add(Duration(days: w * 7 + d)),
                                today,
                              ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        _legend(context),
      ],
    );
  }

  Widget _cellBox(BuildContext context, DateTime day, DateTime today) {
    // Hari yang belum tiba: kotak transparan agar bentuk grid tetap.
    if (day.isAfter(today)) {
      return const SizedBox(
          width: _cell, height: _cell + _vGap * 2);
    }
    final score = scores[day.isoDate] ?? 0;
    return Container(
      width: _cell,
      height: _cell,
      margin: const EdgeInsets.symmetric(vertical: _vGap),
      decoration: BoxDecoration(
        color: _scoreColor(context, score),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }

  Color _scoreColor(BuildContext ctx, int score) {
    final scheme = Theme.of(ctx).colorScheme;
    if (score == 0) return scheme.surfaceContainerHighest;
    if (score < 0) return const Color(0xFFB5613F).withValues(alpha: 0.7);
    if (score < 20) return scheme.primary.withValues(alpha: 0.3);
    if (score < 50) return scheme.primary.withValues(alpha: 0.55);
    if (score < 100) return scheme.primary.withValues(alpha: 0.8);
    return scheme.primary;
  }

  Widget _swatch(Color c) => Container(
        width: 12,
        height: 12,
        margin: const EdgeInsets.symmetric(horizontal: 1.5),
        decoration:
            BoxDecoration(color: c, borderRadius: BorderRadius.circular(3)),
      );

  Widget _legend(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final labelStyle =
        TextStyle(fontSize: 10, color: scheme.onSurfaceVariant);
    return Wrap(
      spacing: 14,
      runSpacing: 6,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Sedikit', style: labelStyle),
            const SizedBox(width: 4),
            _swatch(scheme.surfaceContainerHighest),
            _swatch(scheme.primary.withValues(alpha: 0.3)),
            _swatch(scheme.primary.withValues(alpha: 0.55)),
            _swatch(scheme.primary.withValues(alpha: 0.8)),
            _swatch(scheme.primary),
            const SizedBox(width: 4),
            Text('Banyak XP', style: labelStyle),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _swatch(scheme.surfaceContainerHighest),
            const SizedBox(width: 4),
            Text('Kosong', style: labelStyle),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _swatch(const Color(0xFFB5613F).withValues(alpha: 0.7)),
            const SizedBox(width: 4),
            Text('XP minus', style: labelStyle),
          ],
        ),
      ],
    );
  }
}
