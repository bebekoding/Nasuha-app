import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/theme/app_fonts.dart';
import 'package:intl/intl.dart';

import '../../../muhasabah/presentation/providers/muhasabah_autolog.dart';
import '../../data/repositories/sedekah_repository.dart';
import '../widgets/radial_amount_slider.dart';

const _green = Color(0xFFA77B43);

class SedekahScreen extends ConsumerStatefulWidget {
  const SedekahScreen({super.key});

  @override
  ConsumerState<SedekahScreen> createState() => _SedekahScreenState();
}

class _SedekahScreenState extends ConsumerState<SedekahScreen> {
  double _amount = 0;
  double _max = 1000000; // dial range
  bool _scaleExpanded = false;
  final _amountCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();

  String _scaleLabel() {
    for (final s in _scales) {
      if (s.$2 == _max) return s.$1;
    }
    return '';
  }

  final _plain = NumberFormat.decimalPattern('id_ID');

  static const _scales = <(String, double)>[
    ('100 rb', 100000),
    ('1 jt', 1000000),
    ('5 jt', 5000000),
  ];

  @override
  void dispose() {
    _amountCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  void _setFromDial(double v) {
    setState(() => _amount = v);
    _amountCtrl.text = v <= 0 ? '' : v.toStringAsFixed(0);
  }

  void _setFromText(String raw) {
    final v = double.tryParse(raw.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    setState(() => _amount = v);
  }

  void _addQuick(double delta) {
    final v = (_amount + delta).clamp(0, double.infinity).toDouble();
    setState(() => _amount = v);
    _amountCtrl.text = v <= 0 ? '' : v.toStringAsFixed(0);
  }

  Future<void> _save() async {
    if (_amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tentukan jumlah dulu')),
      );
      return;
    }
    final note = _noteCtrl.text.trim();
    await ref.read(sedekahRepositoryProvider).add(
          amount: _amount,
          note: note.isEmpty ? null : note,
        );
    await ref.read(muhasabahAutoLoggerProvider).onSedekahRecorded();
    setState(() => _amount = 0);
    _amountCtrl.clear();
    _noteCtrl.clear();
    if (mounted) {
      FocusScope.of(context).unfocus();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sedekah tercatat. Barakallahu fiik 🌿'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Sedekah')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          const SizedBox(height: 4),
          Center(
            child: Text(
              'Berapa yang ingin disedekahkan?',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 20),

          // ── Big circular dial ────────────────────────────────
          Center(
            child: RadialAmountSlider(
              value: _amount.clamp(0, _max).toDouble(),
              max: _max,
              step: _max / 100,
              onChanged: _setFromDial,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Rp', style: TextStyle(color: scheme.outline)),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      _plain.format(_amount),
                      style: spaceGrotesk(
                        fontSize: 40,
                        fontWeight: FontWeight.w700,
                        color: scheme.primary,
                        letterSpacing: -1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text('geser untuk atur',
                      style: TextStyle(
                          fontSize: 11, color: scheme.outline)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // ── Scale selector (hidden by default, expandable) ───
          Center(
            child: TextButton.icon(
              onPressed: () =>
                  setState(() => _scaleExpanded = !_scaleExpanded),
              icon: Icon(_scaleExpanded ? Icons.expand_less : Icons.tune,
                  size: 16),
              label: Text('Skala dial · ${_scaleLabel()}'),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            child: _scaleExpanded
                ? Padding(
                    padding: const EdgeInsets.only(top: 2, bottom: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (final s in _scales) ...[
                          const SizedBox(width: 6),
                          ChoiceChip(
                            label: Text(s.$1),
                            selected: _max == s.$2,
                            onSelected: (_) => setState(() {
                              _max = s.$2;
                              if (_amount > _max) {
                                _amount = _max;
                                _amountCtrl.text = _amount.toStringAsFixed(0);
                              }
                            }),
                            visualDensity: VisualDensity.compact,
                          ),
                        ],
                      ],
                    ),
                  )
                : const SizedBox(width: double.infinity),
          ),
          const SizedBox(height: 8),

          // ── Quick add ────────────────────────────────────────
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            children: [
              for (final q in const [5000, 10000, 50000, 100000])
                ActionChip(
                  label: Text('+${_plain.format(q)}'),
                  onPressed: () => _addQuick(q.toDouble()),
                ),
              ActionChip(
                label: const Text('Reset'),
                onPressed: () => _setFromDial(0),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ── Type exact + note ────────────────────────────────
          TextField(
            controller: _amountCtrl,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: _setFromText,
            decoration: const InputDecoration(
              labelText: 'atau ketik jumlah',
              prefixText: 'Rp ',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _noteCtrl,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              labelText: 'Catatan / tujuan (opsional)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),

          // ── Save ─────────────────────────────────────────────
          FilledButton.icon(
            style: FilledButton.styleFrom(
                backgroundColor: _green,
                padding: const EdgeInsets.symmetric(vertical: 16)),
            onPressed: _save,
            icon: const Icon(Icons.volunteer_activism),
            label: const Text('Simpan Sedekah',
                style: TextStyle(fontWeight: FontWeight.w700)),
          ),
          const SizedBox(height: 12),

          // ── Open recap ───────────────────────────────────────
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
                foregroundColor: _green,
                side: BorderSide(color: _green.withValues(alpha: 0.5)),
                padding: const EdgeInsets.symmetric(vertical: 14)),
            onPressed: () => context.push('/sedekah/recap'),
            icon: const Icon(Icons.bar_chart),
            label: const Text('Lihat Rekap & Grafik'),
          ),
        ],
      ),
    );
  }
}
