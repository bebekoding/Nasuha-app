import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../core/widgets/desktop_page_shell.dart';
import '../../../../models/charity_record.dart';
import '../../../muhasabah/presentation/providers/muhasabah_autolog.dart';
import '../../data/repositories/sedekah_repository.dart';
import '../widgets/radial_amount_slider.dart';

/// Sedekah dashboard desktop (width >= 800).
///
/// 2-col: kiri radial input focused (dial + amount + note + save + quick-add).
/// Kanan: total lifetime + hari ini + minggu ini + daftar record hari ini
/// dengan hover reveal action (edit/delete).
class SedekahDesktopScreen extends ConsumerStatefulWidget {
  const SedekahDesktopScreen({super.key});

  @override
  ConsumerState<SedekahDesktopScreen> createState() =>
      _SedekahDesktopScreenState();
}

class _SedekahDesktopScreenState
    extends ConsumerState<SedekahDesktopScreen> {
  double _amount = 0;
  double _max = 1000000;
  final _amountCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();

  static const _scales = <(String, double)>[
    ('100 rb', 100000),
    ('1 jt', 1000000),
    ('5 jt', 5000000),
  ];

  static const _quickAdds = [10000.0, 25000.0, 50000.0, 100000.0];

  @override
  void dispose() {
    _amountCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  void _setAmount(double v) {
    setState(() => _amount = v);
    _amountCtrl.text = v <= 0 ? '' : v.toStringAsFixed(0);
  }

  void _addQuick(double d) {
    _setAmount((_amount + d).clamp(0, double.infinity).toDouble());
  }

  Future<void> _save() async {
    if (_amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tentukan jumlah dulu')),
      );
      return;
    }
    final note = _noteCtrl.text.trim();
    await ref
        .read(sedekahRepositoryProvider)
        .add(amount: _amount, note: note.isEmpty ? null : note);
    await ref.read(muhasabahAutoLoggerProvider).onSedekahRecorded();
    setState(() => _amount = 0);
    _amountCtrl.clear();
    _noteCtrl.clear();
    if (mounted) {
      FocusScope.of(context).unfocus();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sedekah tercatat. Barakallahu fiik'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final todayAsync = ref.watch(sedekahTodayProvider);
    final totalAsync = ref.watch(sedekahTotalProvider);

    return DesktopPageShell(
      currentRoute: '/sedekah',
      eyebrow: 'SEDEKAH',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Header(),
          const SizedBox(height: 32),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Left: input focused
                SizedBox(
                  width: 500,
                  child: _InputPanel(
                    amount: _amount,
                    max: _max,
                    amountCtrl: _amountCtrl,
                    noteCtrl: _noteCtrl,
                    onDial: _setAmount,
                    onText: (raw) {
                      final v = double.tryParse(
                              raw.replaceAll(RegExp(r'[^0-9]'), '')) ??
                          0;
                      setState(() => _amount = v);
                    },
                    onScaleChange: (m) => setState(() => _max = m),
                    scales: _scales,
                    quickAdds: _quickAdds,
                    onQuickAdd: _addQuick,
                    onSave: _save,
                  ),
                ),
                const SizedBox(width: 24),
                // Right: recap
                Expanded(
                  child: _RecapPanel(
                    todayAsync: todayAsync,
                    totalAsync: totalAsync,
                    onEdit: (r) => _showEditDialog(r),
                    onDelete: (r) async {
                      await ref
                          .read(sedekahRepositoryProvider)
                          .delete(r.id);
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _CtaFooter(),
        ],
      ),
    );
  }

  Future<void> _showEditDialog(CharityRecord r) async {
    final amountCtrl =
        TextEditingController(text: r.amount.toStringAsFixed(0));
    final noteCtrl = TextEditingController(text: r.note ?? '');
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit sedekah'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: amountCtrl,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(labelText: 'Jumlah (Rp)'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: noteCtrl,
              decoration:
                  const InputDecoration(labelText: 'Catatan (opsional)'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
    if (result == true) {
      final v = double.tryParse(amountCtrl.text) ?? r.amount;
      await ref.read(sedekahRepositoryProvider).update(
            id: r.id,
            amount: v,
            note: noteCtrl.text.trim().isEmpty ? null : noteCtrl.text.trim(),
          );
    }
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// HEADER
// ═══════════════════════════════════════════════════════════════════════════

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Text(
          'Berapa yang ingin disedekahkan?',
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
        Text(
          'Kecil rutin lebih berkah dari besar sekali-kali. '
          'Catat langsung, biar hidup lebih ringan.',
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 17,
            height: 1.5,
            fontWeight: FontWeight.w500,
            color: scheme.onSurface.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// INPUT PANEL — kiri
// ═══════════════════════════════════════════════════════════════════════════

class _InputPanel extends StatelessWidget {
  const _InputPanel({
    required this.amount,
    required this.max,
    required this.amountCtrl,
    required this.noteCtrl,
    required this.onDial,
    required this.onText,
    required this.onScaleChange,
    required this.scales,
    required this.quickAdds,
    required this.onQuickAdd,
    required this.onSave,
  });

  final double amount;
  final double max;
  final TextEditingController amountCtrl;
  final TextEditingController noteCtrl;
  final ValueChanged<double> onDial;
  final ValueChanged<String> onText;
  final ValueChanged<double> onScaleChange;
  final List<(String, double)> scales;
  final List<double> quickAdds;
  final ValueChanged<double> onQuickAdd;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
            color: scheme.outline.withValues(alpha: 0.16), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: scheme.onSurface.withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: RadialAmountSlider(
              value: amount.clamp(0, max).toDouble(),
              max: max,
              step: max / 100,
              onChanged: onDial,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Rp',
                      style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 14,
                          color: scheme.onSurface
                              .withValues(alpha: 0.55))),
                  const SizedBox(height: 2),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      NumberFormat.decimalPattern('id_ID')
                          .format(amount),
                      style: const TextStyle(
                        fontFamily: 'Space Grotesk',
                        fontSize: 44,
                        fontWeight: FontWeight.w800,
                        color: AppColors.clay,
                        letterSpacing: -1.6,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text('geser untuk atur',
                      style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 11,
                          color: scheme.onSurface
                              .withValues(alpha: 0.55))),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: amountCtrl,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: onText,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Space Grotesk',
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: AppColors.clay,
              letterSpacing: -0.5,
            ),
            decoration: InputDecoration(
              prefixText: 'Rp ',
              prefixStyle: TextStyle(
                fontFamily: 'Space Grotesk',
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: scheme.onSurface.withValues(alpha: 0.5),
              ),
              hintText: '0',
              hintStyle: TextStyle(
                fontFamily: 'Space Grotesk',
                fontSize: 32,
                color: scheme.onSurface.withValues(alpha: 0.35),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                    color: scheme.outline.withValues(alpha: 0.22)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                    color: scheme.outline.withValues(alpha: 0.22)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: AppColors.clay, width: 1.6),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                'Skala dial:',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: scheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(width: 8),
              for (final s in scales)
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: _ScaleChip(
                    label: s.$1,
                    active: max == s.$2,
                    onTap: () => onScaleChange(s.$2),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              for (final d in quickAdds)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _QuickAddChip(
                      label: '+${_formatShort(d)}',
                      onTap: () => onQuickAdd(d),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),
          TextField(
            controller: noteCtrl,
            decoration: InputDecoration(
              hintText: 'Catatan (opsional) — mis. masjid dekat rumah',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                    color: scheme.outline.withValues(alpha: 0.22)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                    color: scheme.outline.withValues(alpha: 0.22)),
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: _SaveButton(onTap: onSave),
          ),
        ],
      ),
    );
  }

  String _formatShort(double v) {
    if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(0)}jt';
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(0)}rb';
    return v.toStringAsFixed(0);
  }
}

class _ScaleChip extends StatelessWidget {
  const _ScaleChip(
      {required this.label, required this.active, required this.onTap});
  final String label;
  final bool active;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: active
                ? AppColors.clay.withValues(alpha: 0.18)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: active
                  ? AppColors.clay
                  : scheme.outline.withValues(alpha: 0.28),
              width: 1,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: active
                  ? AppColors.clay
                  : scheme.onSurface.withValues(alpha: 0.72),
            ),
          ),
        ),
      ),
    );
  }
}

class _QuickAddChip extends StatefulWidget {
  const _QuickAddChip({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;
  @override
  State<_QuickAddChip> createState() => _QuickAddChipState();
}

class _QuickAddChipState extends State<_QuickAddChip> {
  bool _hover = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(vertical: 12),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: _hover
                ? AppColors.caramel.withValues(alpha: 0.16)
                : AppColors.caramel.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.caramel.withValues(alpha: _hover ? 0.4 : 0.22),
              width: 1,
            ),
          ),
          child: Text(
            widget.label,
            style: const TextStyle(
              fontFamily: 'Space Grotesk',
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.caramel,
            ),
          ),
        ),
      ),
    );
  }
}

class _SaveButton extends StatefulWidget {
  const _SaveButton({required this.onTap});
  final VoidCallback onTap;
  @override
  State<_SaveButton> createState() => _SaveButtonState();
}

class _SaveButtonState extends State<_SaveButton> {
  bool _hover = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(vertical: 16),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.clay,
            borderRadius: BorderRadius.circular(14),
            boxShadow: _hover
                ? [
                    BoxShadow(
                      color: AppColors.clay.withValues(alpha: 0.36),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: AppColors.clay.withValues(alpha: 0.16),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check, color: Colors.white, size: 20),
              SizedBox(width: 10),
              Text(
                'Simpan sedekah',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
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
// RECAP PANEL — kanan
// ═══════════════════════════════════════════════════════════════════════════

class _RecapPanel extends StatelessWidget {
  const _RecapPanel({
    required this.todayAsync,
    required this.totalAsync,
    required this.onEdit,
    required this.onDelete,
  });

  final AsyncValue<List<CharityRecord>> todayAsync;
  final AsyncValue<({double total, int count})> totalAsync;
  final ValueChanged<CharityRecord> onEdit;
  final ValueChanged<CharityRecord> onDelete;

  @override
  Widget build(BuildContext context) {
    final rp = NumberFormat.decimalPattern('id_ID');
    final today = todayAsync.valueOrNull ?? const [];
    final todayTotal = today.fold<double>(0, (a, b) => a + b.amount);
    final lifetime = totalAsync.valueOrNull?.total ?? 0;
    final lifetimeCount = totalAsync.valueOrNull?.count ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _MetricTile(
                accent: AppColors.clay,
                icon: Icons.today,
                label: 'HARI INI',
                value: 'Rp ${rp.format(todayTotal)}',
                sub: '${today.length} catatan',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _MetricTile(
                accent: AppColors.caramel,
                icon: Icons.paid,
                label: 'LIFETIME',
                value: 'Rp ${rp.format(lifetime)}',
                sub: '$lifetimeCount catatan total',
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          'Catatan hari ini',
          style: TextStyle(
            fontFamily: 'Space Grotesk',
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Theme.of(context).colorScheme.onSurface,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 12),
        if (today.isEmpty)
          const _EmptyTodayTile()
        else
          for (final r in today) ...[
            _RecordRow(record: r, onEdit: onEdit, onDelete: onDelete),
            const SizedBox(height: 8),
          ],
      ],
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
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
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
            color: accent.withValues(alpha: 0.22), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: accent, size: 18),
              ),
              const SizedBox(width: 10),
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2.0,
                  color: accent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Space Grotesk',
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: scheme.onSurface,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            sub,
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 13,
              color: scheme.onSurface.withValues(alpha: 0.72),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyTodayTile extends StatelessWidget {
  const _EmptyTodayTile();
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: scheme.outline.withValues(alpha: 0.18), width: 1),
      ),
      child: Row(
        children: [
          Icon(Icons.spa,
              color: scheme.onSurface.withValues(alpha: 0.5), size: 20),
          const SizedBox(width: 12),
          Text(
            'Belum ada sedekah hari ini. Mulai dari yang kecil.',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 14,
              color: scheme.onSurface.withValues(alpha: 0.75),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecordRow extends StatefulWidget {
  const _RecordRow(
      {required this.record, required this.onEdit, required this.onDelete});
  final CharityRecord record;
  final ValueChanged<CharityRecord> onEdit;
  final ValueChanged<CharityRecord> onDelete;

  @override
  State<_RecordRow> createState() => _RecordRowState();
}

class _RecordRowState extends State<_RecordRow> {
  bool _hover = false;
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final rp = NumberFormat.decimalPattern('id_ID');
    final r = widget.record;
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: _hover
              ? AppColors.caramel.withValues(alpha: 0.06)
              : scheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _hover
                ? AppColors.caramel.withValues(alpha: 0.32)
                : scheme.outline.withValues(alpha: 0.16),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.volunteer_activism,
                color: AppColors.clay, size: 20),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Rp ${rp.format(r.amount)}',
                    style: TextStyle(
                      fontFamily: 'Space Grotesk',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: scheme.onSurface,
                    ),
                  ),
                  if ((r.note ?? '').isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      r.note!,
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 13,
                        color: scheme.onSurface.withValues(alpha: 0.72),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 180),
              opacity: _hover ? 1 : 0.0,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => widget.onEdit(r),
                    icon: Icon(Icons.edit_outlined,
                        size: 18,
                        color: scheme.onSurface.withValues(alpha: 0.7)),
                    tooltip: 'Edit',
                  ),
                  IconButton(
                    onPressed: () => widget.onDelete(r),
                    icon: const Icon(Icons.delete_outline,
                        size: 18, color: AppColors.negativeLight),
                    tooltip: 'Hapus',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// CTA FOOTER — link ke rekap detail
// ═══════════════════════════════════════════════════════════════════════════

class _CtaFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        HoverLiftCard(
          onTap: () => context.push('/sedekah/recap'),
          accent: AppColors.caramel,
          borderRadius: 14,
          padding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          lift: 2,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.show_chart,
                  size: 18, color: AppColors.caramel),
              const SizedBox(width: 10),
              Text(
                'Lihat grafik & rekap harian/mingguan/bulanan',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward,
                  size: 16, color: AppColors.caramel),
            ],
          ),
        ),
        const SizedBox(width: 12),
        HoverLiftCard(
          onTap: () => context.push('/sedekah/history'),
          accent: AppColors.terracotta,
          borderRadius: 14,
          padding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          lift: 2,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.history,
                  size: 18, color: AppColors.terracotta),
              const SizedBox(width: 10),
              Text(
                'Riwayat lengkap semua sedekah',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward,
                  size: 16, color: AppColors.terracotta),
            ],
          ),
        ),
      ],
    );
  }
}
