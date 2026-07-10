import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' hide TextDirection;

import '../../../../config/theme/app_fonts.dart';

/// Formatter input rupiah: digit-only + pemisah ribuan id_ID (titik) live.
/// Kursor dijaga di akhir supaya perilaku mengetik tetap natural.
class RupiahInputFormatter extends TextInputFormatter {
  static final NumberFormat _fmt = NumberFormat.decimalPattern('id_ID');

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) return const TextEditingValue(text: '');
    final n = int.parse(digits);
    final text = _fmt.format(n);
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

/// Parse text field rupiah ("2.633.000") → int (2633000). Kosong → 0.
int parseRupiah(String text) =>
    int.tryParse(text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;

/// Format angka → "Rp 2.633.000".
String formatRupiah(num n) =>
    'Rp ${NumberFormat.decimalPattern('id_ID').format(n.round())}';

/// Field input nominal rupiah dengan label tampak + helper text persisten.
class CurrencyField extends StatelessWidget {
  const CurrencyField({
    super.key,
    required this.label,
    required this.controller,
    this.helper,
    this.icon,
    this.accent,
  });

  final String label;
  final TextEditingController controller;
  final String? helper;
  final IconData? icon;
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16, color: accent ?? scheme.primary),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                color: scheme.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: [RupiahInputFormatter()],
          style: TextStyle(
            fontFamily: 'Space Grotesk',
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: scheme.onSurface,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
          decoration: InputDecoration(
            prefixText: 'Rp ',
            prefixStyle: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: scheme.onSurface.withValues(alpha: 0.6),
            ),
            hintText: '0',
            helperText: helper,
            helperMaxLines: 2,
            helperStyle: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 12,
              height: 1.4,
              color: scheme.onSurface.withValues(alpha: 0.62),
            ),
          ),
        ),
      ],
    );
  }
}

/// Label section kecil di dalam kalkulator ("HARTA KAMU", "PENGURANG").
class ZakatSectionLabel extends StatelessWidget {
  const ZakatSectionLabel(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'Plus Jakarta Sans',
        fontSize: 11.5,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.8,
        color: scheme.onSurface.withValues(alpha: 0.55),
      ),
    );
  }
}

/// Kartu dalil dengan teks Arab (naskh) + terjemah + sumber — dan optional
/// daftar poin tambahan. Dipakai sebagai progressive disclosure (collapsed
/// by default) supaya kalkulator tetap fokus.
class DalilExpansion extends StatelessWidget {
  const DalilExpansion({
    super.key,
    required this.title,
    this.arabic,
    required this.translation,
    required this.source,
    this.points = const [],
    this.accent,
  });

  final String title;
  final String? arabic;
  final String translation;
  final String source;
  final List<String> points;
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final a = accent ?? scheme.primary;
    return Container(
      decoration: BoxDecoration(
        color: a.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: a.withValues(alpha: 0.35), width: 1.2),
      ),
      clipBehavior: Clip.hardEdge,
      child: Theme(
        // Hilangkan divider bawaan ExpansionTile.
        data: Theme.of(context)
            .copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          iconColor: a,
          collapsedIconColor: a,
          leading: Icon(Icons.menu_book_outlined, size: 20, color: a),
          title: Text(
            title,
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: scheme.onSurface,
            ),
          ),
          children: [
            if (arabic != null) ...[
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  arabic!,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontFamily: arabicFontFamily,
                    fontSize: 22,
                    height: 2.0,
                    color: scheme.onSurface,
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
            Text(
              translation,
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 13.5,
                height: 1.6,
                color: scheme.onSurface.withValues(alpha: 0.85),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              source,
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: a,
              ),
            ),
            if (points.isNotEmpty) ...[
              const SizedBox(height: 12),
              for (final p in points)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Icon(Icons.check_circle_outline,
                            size: 14, color: a),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          p,
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 13,
                            height: 1.5,
                            color:
                                scheme.onSurface.withValues(alpha: 0.82),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Catatan kecil bergaris — untuk info waktu pembayaran / haul.
class ZakatNote extends StatelessWidget {
  const ZakatNote({super.key, required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: scheme.onSurface.withValues(alpha: 0.55)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 12.5,
              height: 1.55,
              color: scheme.onSurface.withValues(alpha: 0.68),
            ),
          ),
        ),
      ],
    );
  }
}
