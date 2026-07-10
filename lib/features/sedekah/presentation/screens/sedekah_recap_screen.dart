import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/extensions/date_extensions.dart';
import '../../../../models/charity_record.dart';
import '../../data/repositories/sedekah_repository.dart';
import '../providers/sedekah_hide_provider.dart';

enum _Period { harian, mingguan, bulanan }

const _green = Color(0xFFA77B43);

class SedekahRecapScreen extends ConsumerStatefulWidget {
  const SedekahRecapScreen({super.key, this.chromeless = false});

  /// Kalau true, jangan render Scaffold+AppBar sendiri — assume dipakai di
  /// dalam parent shell (DesktopPageShell).
  final bool chromeless;

  @override
  ConsumerState<SedekahRecapScreen> createState() => _SedekahRecapScreenState();
}

class _SedekahRecapScreenState extends ConsumerState<SedekahRecapScreen> {
  _Period _period = _Period.harian;
  final _currency =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  String _money(double v, bool hidden) =>
      hidden ? 'Rp ••••' : _currency.format(v);

  double _sum(Iterable<CharityRecord> rs) =>
      rs.fold<double>(0, (s, r) => s + r.amount);

  @override
  Widget build(BuildContext context) {
    final allAsync = ref.watch(sedekahAllProvider);
    final hidden = ref.watch(sedekahHiddenProvider);

    final body = allAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (all) => _content(all, hidden),
    );
    if (widget.chromeless) return body;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rekap & Grafik'),
        actions: [
          IconButton(
            tooltip: hidden ? 'Tampilkan nominal' : 'Sembunyikan nominal',
            icon: Icon(hidden ? Icons.visibility_off : Icons.visibility),
            onPressed: () => ref.read(sedekahHiddenProvider.notifier).toggle(),
          ),
        ],
      ),
      body: body,
    );
  }

  Widget _content(List<CharityRecord> all, bool hidden) {
    final now = DateTime.now();
    final (series, labels, periodTotal, periodCount, caption) =
        _seriesFor(all, _period, now);
    final allTotal = _sum(all);
    final records = _periodRecords(all, _period, now);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SegmentedButton<_Period>(
          segments: const [
            ButtonSegment(value: _Period.harian, label: Text('Harian')),
            ButtonSegment(value: _Period.mingguan, label: Text('Mingguan')),
            ButtonSegment(value: _Period.bulanan, label: Text('Bulanan')),
          ],
          selected: {_period},
          showSelectedIcon: false,
          onSelectionChanged: (s) => setState(() => _period = s.first),
        ),
        const SizedBox(height: 20),

        // Current-period summary
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              _green.withValues(alpha: 0.9),
              _green.withValues(alpha: 0.6),
            ]),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: _green.withValues(alpha: 0.3),
                blurRadius: 20,
                spreadRadius: -4,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(caption,
                  style: const TextStyle(color: Colors.white70)),
              const SizedBox(height: 8),
              Text(_money(periodTotal, hidden),
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w800)),
              const SizedBox(height: 4),
              Text('$periodCount kali sedekah',
                  style: const TextStyle(color: Colors.white70)),
            ],
          ),
        ),
        const SizedBox(height: 20),

        Text('Grafik', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        _chartCard(series, labels, hidden),
        const SizedBox(height: 20),

        // All-time total
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _green.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _green.withValues(alpha: 0.18)),
          ),
          child: Row(
            children: [
              const Icon(Icons.paid_outlined, color: _green),
              const SizedBox(width: 12),
              const Expanded(
                  child: Text('Total sepanjang waktu',
                      style: TextStyle(fontWeight: FontWeight.w600))),
              Text(_money(allTotal, hidden),
                  style: const TextStyle(
                      color: _green, fontWeight: FontWeight.w800)),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Records for the selected period (editable)
        Text('Catatan ${caption.toLowerCase()}',
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 10),
        if (records.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: Text('Belum ada sedekah pada periode ini',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.outline)),
            ),
          )
        else
          for (final r in records) _recordTile(r, hidden),
      ],
    );
  }

  List<CharityRecord> _periodRecords(
      List<CharityRecord> all, _Period p, DateTime now) {
    Iterable<CharityRecord> r;
    switch (p) {
      case _Period.harian:
        r = all.where((e) => e.createdAt.isSameDay(now));
      case _Period.mingguan:
        final start = now.dateOnly.subtract(Duration(days: now.weekday - 1));
        final end = start.add(const Duration(days: 7));
        r = all.where((e) =>
            !e.createdAt.isBefore(start) && e.createdAt.isBefore(end));
      case _Period.bulanan:
        r = all.where((e) =>
            e.createdAt.year == now.year && e.createdAt.month == now.month);
    }
    final list = r.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  Widget _recordTile(CharityRecord r, bool hidden) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      color: Theme.of(context)
          .colorScheme
          .surfaceContainerHighest
          .withValues(alpha: 0.4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Color(0x332E7D5B),
          child: Icon(Icons.volunteer_activism, color: _green),
        ),
        title: Text(_money(r.amount, hidden),
            style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text(
          r.note == null || r.note!.isEmpty
              ? DateFormat('EEE, d MMM • HH:mm', 'id_ID').format(r.createdAt)
              : '${DateFormat('EEE, d MMM • HH:mm', 'id_ID').format(r.createdAt)}\n${r.note}',
        ),
        isThreeLine: r.note != null && r.note!.isNotEmpty,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              tooltip: 'Edit',
              icon: const Icon(Icons.edit_outlined, size: 20),
              onPressed: () => _showEditSheet(r),
            ),
            IconButton(
              tooltip: 'Hapus',
              icon: const Icon(Icons.delete_outline, size: 20),
              onPressed: () => _confirmDelete(r),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showEditSheet(CharityRecord r) async {
    final amountCtrl = TextEditingController(text: r.amount.toStringAsFixed(0));
    final noteCtrl = TextEditingController(text: r.note ?? '');
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
          left: 20,
          right: 20,
          top: 8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Edit sedekah', style: Theme.of(ctx).textTheme.titleMedium),
            const SizedBox(height: 16),
            TextField(
              controller: amountCtrl,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                prefixText: 'Rp ',
                hintText: 'Jumlah',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: noteCtrl,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                hintText: 'Catatan (opsional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: _green),
              onPressed: () async {
                final amount = double.tryParse(amountCtrl.text.trim());
                if (amount == null || amount <= 0) return;
                final note = noteCtrl.text.trim();
                await ref.read(sedekahRepositoryProvider).update(
                      id: r.id,
                      amount: amount,
                      note: note.isEmpty ? null : note,
                    );
                if (ctx.mounted) Navigator.of(ctx).pop();
              },
              child: const Text('Simpan perubahan'),
            ),
          ],
        ),
      ),
    );
    amountCtrl.dispose();
    noteCtrl.dispose();
  }

  Future<void> _confirmDelete(CharityRecord r) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus catatan sedekah?'),
        content: const Text('Catatan ini akan dihapus permanen.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Batal')),
          FilledButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('Hapus')),
        ],
      ),
    );
    if (ok == true) {
      await ref.read(sedekahRepositoryProvider).delete(r.id);
    }
  }

  Widget _chartCard(List<double> series, List<String> labels, bool hidden) {
    final hasData = series.any((v) => v > 0);
    final maxY = hasData
        ? series.reduce((a, b) => a > b ? a : b) * 1.25
        : 1.0;

    return Container(
      height: 240,
      padding: const EdgeInsets.fromLTRB(8, 20, 12, 8),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .surfaceContainerHighest
            .withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(20),
      ),
      child: !hasData
          ? Center(
              child: Text('Belum ada data',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.outline)),
            )
          : LineChart(
              LineChartData(
                minY: 0,
                maxY: maxY,
                minX: 0,
                maxX: (series.length - 1).toDouble(),
                lineTouchData: LineTouchData(
                  enabled: !hidden,
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (spots) => spots
                        .map((s) => LineTooltipItem(
                              _money(s.y, hidden),
                              const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 11),
                            ))
                        .toList(),
                  ),
                ),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 26,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        final i = value.round();
                        if (i < 0 || i >= labels.length) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(labels[i],
                              style: const TextStyle(fontSize: 10)),
                        );
                      },
                    ),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      for (var i = 0; i < series.length; i++)
                        FlSpot(i.toDouble(), series[i]),
                    ],
                    isCurved: true,
                    curveSmoothness: 0.3,
                    color: _green,
                    barWidth: 3,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, _, __, ___) =>
                          FlDotCirclePainter(
                              radius: 3,
                              color: _green,
                              strokeWidth: 0,
                              strokeColor: _green),
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          _green.withValues(alpha: 0.30),
                          _green.withValues(alpha: 0.0),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  /// Returns (values, labels, currentPeriodTotal, currentPeriodCount, caption).
  (List<double>, List<String>, double, int, String) _seriesFor(
      List<CharityRecord> all, _Period p, DateTime now) {
    switch (p) {
      case _Period.harian:
        final values = <double>[];
        final labels = <String>[];
        const wd = ['Sn', 'Sl', 'Rb', 'Km', 'Jm', 'Sb', 'Mg'];
        for (var k = 6; k >= 0; k--) {
          final day = now.dateOnly.subtract(Duration(days: k));
          values.add(_sum(all.where((r) => r.createdAt.isSameDay(day))));
          labels.add(wd[day.weekday - 1]);
        }
        final today = _sum(all.where((r) => r.createdAt.isSameDay(now)));
        final count =
            all.where((r) => r.createdAt.isSameDay(now)).length;
        return (values, labels, today, count, 'Hari ini');

      case _Period.mingguan:
        final values = <double>[];
        final labels = <String>[];
        final thisMonday =
            now.dateOnly.subtract(Duration(days: now.weekday - 1));
        for (var k = 7; k >= 0; k--) {
          final start = thisMonday.subtract(Duration(days: 7 * k));
          final end = start.add(const Duration(days: 7));
          values.add(_sum(all.where((r) =>
              !r.createdAt.isBefore(start) && r.createdAt.isBefore(end))));
          labels.add(DateFormat('d/M').format(start));
        }
        final weekEnd = thisMonday.add(const Duration(days: 7));
        final inWeek = all.where((r) =>
            !r.createdAt.isBefore(thisMonday) &&
            r.createdAt.isBefore(weekEnd));
        return (values, labels, _sum(inWeek), inWeek.length, 'Minggu ini');

      case _Period.bulanan:
        final values = <double>[];
        final labels = <String>[];
        for (var k = 5; k >= 0; k--) {
          final m = DateTime(now.year, now.month - k, 1);
          values.add(_sum(all.where((r) =>
              r.createdAt.year == m.year && r.createdAt.month == m.month)));
          labels.add(DateFormat('MMM', 'id_ID').format(m));
        }
        final inMonth = all.where((r) =>
            r.createdAt.year == now.year && r.createdAt.month == now.month);
        return (values, labels, _sum(inMonth), inMonth.length, 'Bulan ini');
    }
  }
}
