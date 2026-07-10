import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../config/theme/app_colors.dart';
import '../../../core/widgets/desktop_page_shell.dart' show NasuhaPillButton;
import 'widgets/zakat_ui.dart';

/// Kalkulator Zakat Mal (harta) — live, tanpa tombol submit.
///
/// Dasar perhitungan:
/// - Nisab = 20 dinar emas = **85 gram emas murni** (HR Abu Dawud no. 1573
///   dari Ali bin Abi Thalib r.a., dishahihkan Al-Albani).
/// - Kadar = 5/200 dirham = **2,5%** (hadits yang sama).
/// - Syarat haul: harta tersimpan genap 1 tahun hijriah.
class ZakatMalScreen extends StatefulWidget {
  const ZakatMalScreen({super.key, this.chromeless = false});
  final bool chromeless;

  @override
  State<ZakatMalScreen> createState() => _ZakatMalScreenState();
}

class _ZakatMalScreenState extends State<ZakatMalScreen> {
  static const double _nisabGram = 85;
  static const double _rate = 0.025;

  // Harga emas Antam ±Rp2,63jt/gram (Juli 2026) — editable oleh user.
  final _gold = TextEditingController(text: '2.633.000');
  final _tunai = TextEditingController();
  final _emas = TextEditingController();
  final _investasi = TextEditingController();
  final _piutang = TextEditingController();
  final _dagang = TextEditingController();
  final _hutang = TextEditingController();

  late final List<TextEditingController> _all = [
    _gold, _tunai, _emas, _investasi, _piutang, _dagang, _hutang,
  ];

  @override
  void initState() {
    super.initState();
    for (final c in _all) {
      c.addListener(_recompute);
    }
  }

  @override
  void dispose() {
    for (final c in _all) {
      c.dispose();
    }
    super.dispose();
  }

  void _recompute() => setState(() {});

  int get _nisab => (parseRupiah(_gold.text) * _nisabGram).round();
  int get _totalHarta =>
      parseRupiah(_tunai.text) +
      parseRupiah(_emas.text) +
      parseRupiah(_investasi.text) +
      parseRupiah(_piutang.text) +
      parseRupiah(_dagang.text);
  // NOTE: jangan pakai bitwise (1 << 62) untuk bound — di Dart web
  // operasi bitwise ter-truncate 32-bit. Pakai konstanta literal aman.
  static const int _maxSafe = 900000000000000; // 900 triliun
  int get _netto {
    final n = _totalHarta - parseRupiah(_hutang.text);
    if (n < 0) return 0;
    if (n > _maxSafe) return _maxSafe;
    return n;
  }
  bool get _wajib => _nisab > 0 && _netto >= _nisab;
  int get _zakat => (_netto * _rate).round();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    const accent = AppColors.ochre;

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── 1. Harga emas → nisab live.
        const ZakatSectionLabel('DASAR NISAB'),
        const SizedBox(height: 12),
        CurrencyField(
          label: 'Harga emas hari ini (per gram)',
          controller: _gold,
          icon: Icons.monetization_on_outlined,
          accent: accent,
          helper:
              'Sesuaikan dengan harga emas murni terkini di daerahmu.',
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: accent.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(14),
            border:
                Border.all(color: accent.withValues(alpha: 0.4), width: 1.2),
          ),
          child: Row(
            children: [
              Icon(Icons.flag_outlined, size: 18, color: accent),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Nisab = 85 gram × harga emas',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: scheme.onSurface.withValues(alpha: 0.75),
                  ),
                ),
              ),
              Text(
                formatRupiah(_nisab),
                style: TextStyle(
                  fontFamily: 'Space Grotesk',
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: accent,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),

        // ── 2. Harta.
        const ZakatSectionLabel('HARTA KAMU (TERSIMPAN 1 TAHUN)'),
        const SizedBox(height: 12),
        CurrencyField(
          label: 'Uang tunai, tabungan & deposito',
          controller: _tunai,
          icon: Icons.account_balance_wallet_outlined,
          accent: accent,
        ),
        const SizedBox(height: 14),
        CurrencyField(
          label: 'Emas & perak (nilai jual saat ini)',
          controller: _emas,
          icon: Icons.workspace_premium_outlined,
          accent: accent,
        ),
        const SizedBox(height: 14),
        CurrencyField(
          label: 'Saham, reksadana & investasi lain',
          controller: _investasi,
          icon: Icons.trending_up,
          accent: accent,
        ),
        const SizedBox(height: 14),
        CurrencyField(
          label: 'Piutang yang bisa ditagih',
          controller: _piutang,
          icon: Icons.receipt_long_outlined,
          accent: accent,
        ),
        const SizedBox(height: 14),
        CurrencyField(
          label: 'Nilai barang dagangan',
          controller: _dagang,
          icon: Icons.storefront_outlined,
          accent: accent,
          helper: 'Stok + modal berputar usaha (bukan aset tetap).',
        ),
        const SizedBox(height: 24),

        // ── 3. Pengurang.
        const ZakatSectionLabel('PENGURANG'),
        const SizedBox(height: 12),
        CurrencyField(
          label: 'Hutang jatuh tempo tahun ini',
          controller: _hutang,
          icon: Icons.remove_circle_outline,
          accent: AppColors.clay,
          helper:
              'Hutang yang wajib dibayar dalam waktu dekat mengurangi '
              'harta kena zakat.',
        ),
        const SizedBox(height: 28),

        // ── 4. Hasil live.
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          switchInCurve: Curves.easeOutQuart,
          child: _ResultPanel(
            key: ValueKey('$_wajib-$_zakat-$_netto'),
            wajib: _wajib,
            netto: _netto,
            nisab: _nisab,
            zakat: _zakat,
            onRecord: () => context.push('/sedekah'),
          ),
        ),
        const SizedBox(height: 20),
        const ZakatNote(
          icon: Icons.hourglass_bottom,
          text:
              'Haul: zakat mal jatuh tempo setelah harta di atas nisab '
              'tersimpan genap 1 tahun hijriah (±354 hari). Bayarkan '
              'setiap tahun pada tanggal haul-mu.',
        ),
        const SizedBox(height: 20),

        // ── 5. Dalil & syarat (progressive disclosure).
        const DalilExpansion(
          title: 'Dalil & syarat wajib zakat mal',
          arabic:
              'فَإِذَا كَانَتْ لَكَ مِائَتَا دِرْهَمٍ وَحَالَ عَلَيْهَا الْحَوْلُ فَفِيهَا خَمْسَةُ دَرَاهِمَ، وَلَيْسَ عَلَيْكَ شَيْءٌ حَتَّى يَكُونَ لَكَ عِشْرُونَ دِينَارًا وَحَالَ عَلَيْهَا الْحَوْلُ فَفِيهَا نِصْفُ دِينَارٍ',
          translation:
              '"Bila engkau memiliki 200 dirham dan telah berlalu satu '
              'tahun, zakatnya 5 dirham. Dan tidak ada kewajiban emas '
              'atasmu hingga engkau memiliki 20 dinar; bila telah '
              'berlalu satu tahun, zakatnya setengah dinar."',
          source:
              'HR Abu Dawud no. 1573, dari Ali bin Abi Thalib r.a. — '
              'dishahihkan Al-Albani. (5÷200 = 2,5% · 20 dinar = 85 g emas)',
          accent: AppColors.ochre,
          points: [
            'Milik penuh — bukan pinjaman/titipan.',
            'Mencapai nisab: setara 85 gram emas murni.',
            'Haul: tersimpan genap 1 tahun hijriah.',
            'Melebihi kebutuhan pokok & bebas hutang jatuh tempo.',
            'Perintah dasar: QS At-Taubah 103 & QS Al-Baqarah 267.',
          ],
        ),
      ],
    );

    if (widget.chromeless) return content;

    return Scaffold(
      appBar: AppBar(title: const Text('Zakat Mal')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          child: content,
        ),
      ),
    );
  }
}

class _ResultPanel extends StatelessWidget {
  const _ResultPanel({
    super.key,
    required this.wajib,
    required this.netto,
    required this.nisab,
    required this.zakat,
    required this.onRecord,
  });

  final bool wajib;
  final int netto;
  final int nisab;
  final int zakat;
  final VoidCallback onRecord;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = wajib ? AppColors.goldLight : AppColors.taupe;
    final kosong = netto == 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            accent.withValues(alpha: isDark ? 0.14 : 0.08),
            accent.withValues(alpha: isDark ? 0.26 : 0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border:
            Border.all(color: accent.withValues(alpha: 0.55), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status badge — icon + teks (bukan warna saja).
          Row(
            children: [
              Icon(
                kosong
                    ? Icons.calculate_outlined
                    : (wajib
                        ? Icons.verified_outlined
                        : Icons.info_outline),
                size: 18,
                color: accent,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  kosong
                      ? 'Isi hartamu untuk mulai menghitung'
                      : (wajib
                          ? 'Mencapai nisab — wajib zakat'
                          : 'Belum mencapai nisab — belum wajib'),
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: scheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
          if (!kosong) ...[
            const SizedBox(height: 14),
            Text(
              'Harta bersih: ${formatRupiah(netto)}  ·  '
              'Nisab: ${formatRupiah(nisab)}',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 12.5,
                fontFeatures: const [FontFeature.tabularFigures()],
                color: scheme.onSurface.withValues(alpha: 0.72),
              ),
            ),
          ],
          if (wajib) ...[
            const SizedBox(height: 12),
            Text(
              'Zakat mal kamu (2,5%)',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.6,
                color: scheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              formatRupiah(zakat),
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
            const SizedBox(height: 16),
            NasuhaPillButton(
              label: 'CATAT DI SEDEKAH',
              showArrow: true,
              compact: true,
              onTap: onRecord,
            ),
          ],
        ],
      ),
    );
  }
}
