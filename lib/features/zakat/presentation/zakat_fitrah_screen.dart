import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../config/theme/app_colors.dart';
import 'widgets/zakat_ui.dart';

enum _FitrahMode { beras, uang }

/// Kalkulator Zakat Fitrah — live.
///
/// Dasar: HR Bukhari no. 1503 & Muslim no. 984 (muttafaq 'alaih) dari
/// Ibnu Umar r.a. — satu sha' bahan makanan pokok per jiwa, ditunaikan
/// sebelum shalat Ied. 1 sha' ≈ 2,5 kg (SK BAZNAS: 2,5 kg / 3,5 liter;
/// sebagian ulama menganjurkan 3,0 kg sebagai kehati-hatian).
/// Nominal uang (pendapat Hanafiyah, ditetapkan BAZNAS RI No. 14/2026):
/// Rp50.000/jiwa — sesuaikan harga beras konsumsi daerah.
class ZakatFitrahScreen extends StatefulWidget {
  const ZakatFitrahScreen({super.key, this.chromeless = false});
  final bool chromeless;

  @override
  State<ZakatFitrahScreen> createState() => _ZakatFitrahScreenState();
}

class _ZakatFitrahScreenState extends State<ZakatFitrahScreen> {
  int _jiwa = 1;
  _FitrahMode _mode = _FitrahMode.beras;
  double _kgPerJiwa = 2.5;
  final _hargaPerJiwa = TextEditingController(text: '50.000');

  @override
  void initState() {
    super.initState();
    _hargaPerJiwa.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _hargaPerJiwa.dispose();
    super.dispose();
  }

  double get _totalKg => _jiwa * _kgPerJiwa;
  int get _totalUang => _jiwa * parseRupiah(_hargaPerJiwa.text);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    const accent = AppColors.caramel;

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── 1. Jumlah jiwa.
        const ZakatSectionLabel('JUMLAH JIWA'),
        const SizedBox(height: 12),
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          decoration: BoxDecoration(
            color: scheme.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
                color: accent.withValues(alpha: 0.5), width: 1.5),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Berapa jiwa yang dizakati?',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: scheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Diri sendiri + seluruh tanggungan.',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 12,
                        color: scheme.onSurface.withValues(alpha: 0.62),
                      ),
                    ),
                  ],
                ),
              ),
              _StepBtn(
                icon: Icons.remove,
                accent: accent,
                enabled: _jiwa > 1,
                onTap: () => setState(() => _jiwa--),
              ),
              SizedBox(
                width: 56,
                child: Text(
                  '$_jiwa',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Space Grotesk',
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: scheme.onSurface,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ),
              _StepBtn(
                icon: Icons.add,
                accent: accent,
                enabled: _jiwa < 99,
                onTap: () => setState(() => _jiwa++),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),

        // ── 2. Bentuk pembayaran.
        const ZakatSectionLabel('BENTUK PEMBAYARAN'),
        const SizedBox(height: 12),
        _ModeSegment(
          mode: _mode,
          accent: accent,
          onChanged: (m) => setState(() => _mode = m),
        ),
        const SizedBox(height: 18),

        // ── 3. Parameter per mode.
        if (_mode == _FitrahMode.beras) ...[
          Text(
            'Takaran per jiwa',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              color: scheme.onSurface,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _KgChip(
                label: '2,5 kg',
                caption: 'SK BAZNAS',
                selected: _kgPerJiwa == 2.5,
                accent: accent,
                onTap: () => setState(() => _kgPerJiwa = 2.5),
              ),
              const SizedBox(width: 10),
              _KgChip(
                label: '3,0 kg',
                caption: 'Kehati-hatian',
                selected: _kgPerJiwa == 3.0,
                accent: accent,
                onTap: () => setState(() => _kgPerJiwa = 3.0),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '1 sha’ ≈ 2,5 kg atau 3,5 liter beras yang biasa kamu makan.',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 12,
              height: 1.5,
              color: scheme.onSurface.withValues(alpha: 0.62),
            ),
          ),
        ] else ...[
          CurrencyField(
            label: 'Nominal per jiwa',
            controller: _hargaPerJiwa,
            icon: Icons.payments_outlined,
            accent: accent,
            helper:
                'Rp50.000/jiwa (SK BAZNAS RI No. 14/2026) — boleh '
                'disesuaikan harga beras konsumsi di daerahmu.',
          ),
        ],
        const SizedBox(height: 28),

        // ── 4. Hasil live.
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          switchInCurve: Curves.easeOutQuart,
          child: Container(
            key: ValueKey('$_mode-$_jiwa-$_kgPerJiwa-$_totalUang'),
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  accent.withValues(alpha: 0.08),
                  accent.withValues(alpha: 0.2),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: accent.withValues(alpha: 0.55), width: 1.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.rice_bowl, size: 18, color: accent),
                    const SizedBox(width: 8),
                    Text(
                      'Total zakat fitrah ($_jiwa jiwa)',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: scheme.onSurface,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  _mode == _FitrahMode.beras
                      ? '${NumberFormat('#,##0.#', 'id_ID').format(_totalKg)} kg beras'
                      : formatRupiah(_totalUang),
                  style: TextStyle(
                    fontFamily: 'Space Grotesk',
                    fontSize: 34,
                    fontWeight: FontWeight.w800,
                    height: 1.05,
                    letterSpacing: -0.6,
                    color: scheme.onSurface,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
                if (_mode == _FitrahMode.beras) ...[
                  const SizedBox(height: 4),
                  Text(
                    '≈ ${NumberFormat('#,##0.#', 'id_ID').format(_jiwa * 3.5)} liter',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 13,
                      color: scheme.onSurface.withValues(alpha: 0.68),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        const ZakatNote(
          icon: Icons.schedule,
          text:
              'Waktu: boleh sejak awal Ramadhan; paling utama sebelum '
              'shalat Idulfitri. Setelah shalat Ied nilainya menjadi '
              'sedekah biasa (HR Abu Dawud 1609, hasan).',
        ),
        const SizedBox(height: 20),

        // ── 5. Dalil.
        const DalilExpansion(
          title: 'Dalil zakat fitrah',
          arabic:
              'فَرَضَ رَسُولُ اللَّهِ ﷺ زَكَاةَ الْفِطْرِ صَاعًا مِنْ تَمْرٍ أَوْ صَاعًا مِنْ شَعِيرٍ عَلَى الْعَبْدِ وَالْحُرِّ وَالذَّكَرِ وَالأُنْثَى وَالصَّغِيرِ وَالْكَبِيرِ مِنَ الْمُسْلِمِينَ',
          translation:
              '"Rasulullah ﷺ mewajibkan zakat fitrah satu sha’ kurma '
              'atau satu sha’ gandum atas hamba dan orang merdeka, '
              'laki-laki dan perempuan, kecil dan besar dari kaum '
              'muslimin — dan memerintahkan agar ditunaikan sebelum '
              'orang-orang keluar menuju shalat (Ied)."',
          source:
              'HR Bukhari no. 1503 & Muslim no. 984 (muttafaq ’alaih) — '
              'derajat tertinggi keshahihan.',
          accent: AppColors.caramel,
          points: [
            'Wajib atas setiap muslim yang punya kelebihan makanan '
                'di malam & hari Ied.',
            'Kepala keluarga menanggung zakat seluruh tanggungannya.',
            'Bentuk uang (qimah) adalah pendapat Hanafiyah yang '
                'diadopsi BAZNAS untuk kemudahan.',
          ],
        ),
      ],
    );

    if (widget.chromeless) return content;

    return Scaffold(
      appBar: AppBar(title: const Text('Zakat Fitrah')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          child: content,
        ),
      ),
    );
  }
}

class _StepBtn extends StatelessWidget {
  const _StepBtn({
    required this.icon,
    required this.accent,
    required this.enabled,
    required this.onTap,
  });

  final IconData icon;
  final Color accent;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: enabled,
      child: GestureDetector(
        onTap: enabled ? onTap : null,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 150),
          opacity: enabled ? 1.0 : 0.4,
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(14),
              border:
                  Border.all(color: accent.withValues(alpha: 0.5), width: 1.5),
            ),
            child: Icon(icon, size: 22, color: accent),
          ),
        ),
      ),
    );
  }
}

class _ModeSegment extends StatelessWidget {
  const _ModeSegment({
    required this.mode,
    required this.accent,
    required this.onChanged,
  });

  final _FitrahMode mode;
  final Color accent;
  final ValueChanged<_FitrahMode> onChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    Widget seg(_FitrahMode m, IconData icon, String label) {
      final selected = mode == m;
      return Expanded(
        child: GestureDetector(
          onTap: () => onChanged(m),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutQuart,
            height: 52,
            decoration: BoxDecoration(
              color: selected ? accent : Colors.transparent,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon,
                    size: 18,
                    color: selected ? Colors.white : accent),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: selected ? Colors.white : scheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: accent.withValues(alpha: 0.5), width: 1.5),
      ),
      child: Row(
        children: [
          seg(_FitrahMode.beras, Icons.rice_bowl, 'Beras'),
          const SizedBox(width: 5),
          seg(_FitrahMode.uang, Icons.payments_outlined, 'Uang'),
        ],
      ),
    );
  }
}

class _KgChip extends StatelessWidget {
  const _KgChip({
    required this.label,
    required this.caption,
    required this.selected,
    required this.accent,
    required this.onTap,
  });

  final String label;
  final String caption;
  final bool selected;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutQuart,
          padding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: selected
                ? accent.withValues(alpha: 0.16)
                : scheme.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: accent.withValues(alpha: selected ? 0.75 : 0.35),
              width: selected ? 1.8 : 1.2,
            ),
          ),
          child: Row(
            children: [
              Icon(
                selected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                size: 18,
                color: accent,
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontFamily: 'Space Grotesk',
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: scheme.onSurface,
                    ),
                  ),
                  Text(
                    caption,
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 11,
                      color: scheme.onSurface.withValues(alpha: 0.62),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
