import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../models/daily_score.dart';

class SpiritualCurve extends StatelessWidget {
  const SpiritualCurve({super.key, required this.scores});

  final List<DailyScore> scores;

  @override
  Widget build(BuildContext context) {
    if (scores.isEmpty) {
      return SizedBox(
        height: 220,
        child: Center(
          child: Text('Belum ada data',
              style: TextStyle(color: Theme.of(context).colorScheme.outline)),
        ),
      );
    }
    final spots = <FlSpot>[];
    for (var i = 0; i < scores.length; i++) {
      spots.add(FlSpot(i.toDouble(), scores[i].total.toDouble()));
    }
    final primary = Theme.of(context).colorScheme.primary;

    // Dengan hanya 1–2 hari data, garis kurva tak terbentuk; tampilkan titik
    // agar grafik tidak terlihat kosong. Saat data padat, sembunyikan titik
    // supaya kurva tetap bersih.
    final showDots = spots.length <= 2;

    return SizedBox(
      height: 220,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          // Beri sedikit ruang horizontal saat titiknya tunggal agar tampak
          // di tengah, bukan menempel di tepi.
          minX: spots.length == 1 ? -0.5 : null,
          maxX: spots.length == 1 ? 0.5 : null,
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: primary,
              barWidth: 3,
              dotData: FlDotData(
                show: showDots,
                getDotPainter: (spot, _, __, ___) => FlDotCirclePainter(
                  radius: 4,
                  color: primary,
                  strokeWidth: 0,
                ),
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    primary.withValues(alpha: 0.3),
                    primary.withValues(alpha: 0.0),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
