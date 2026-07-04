import 'package:flutter/material.dart';

import '../../../../config/theme/app_fonts.dart';
import '../../data/sholat_sunnah_data.dart';

class SholatSunnahDetailScreen extends StatelessWidget {
  const SholatSunnahDetailScreen({
    super.key,
    required this.index,
    this.chromeless = false,
  });
  final int index;
  final bool chromeless;

  static const _color = Color(0xFFA77B43);

  @override
  Widget build(BuildContext context) {
    if (index < 0 || index >= kSholatSunnah.length) {
      const notFound = Center(child: Text('Tidak ditemukan'));
      if (chromeless) return notFound;
      return const Scaffold(body: notFound);
    }
    final item = kSholatSunnah[index];
    final scheme = Theme.of(context).colorScheme;

    final body = ListView(
      shrinkWrap: chromeless,
      physics: chromeless
          ? const NeverScrollableScrollPhysics()
          : null,
      padding: chromeless
          ? EdgeInsets.zero
          : const EdgeInsets.fromLTRB(16, 8, 16, 32),
      children: [
          // Info chips
          _InfoRow(icon: Icons.repeat, label: 'Jumlah', value: item.rakaat),
          _InfoRow(icon: Icons.schedule, label: 'Waktu', value: item.waktu),
          _InfoRow(
              icon: Icons.verified_outlined, label: 'Hukum', value: item.hukum),
          const SizedBox(height: 20),

          // Niat
          if (item.niat != null) ...[
            _sectionTitle(context, 'Niat'),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _color.withValues(alpha: 0.07),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _color.withValues(alpha: 0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    item.niat!.arabic,
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(
                        fontFamily: arabicFontFamily,
                        fontSize: 24,
                        height: 2.0,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 10),
                  Text(item.niat!.latin,
                      style: const TextStyle(
                          fontStyle: FontStyle.italic,
                          color: _color,
                          fontSize: 13,
                          height: 1.5)),
                  const SizedBox(height: 6),
                  Text(item.niat!.translation,
                      style: TextStyle(
                          fontSize: 13,
                          color: scheme.onSurface,
                          height: 1.5)),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],

          // Tata cara
          _sectionTitle(context, 'Tata Cara'),
          const SizedBox(height: 8),
          for (var i = 0; i < item.tataCara.length; i++)
            _Step(
              number: item.tataCara[i].startsWith('•') ||
                      item.tataCara[i].endsWith(':')
                  ? null
                  : _stepNumber(item.tataCara, i),
              text: item.tataCara[i],
            ),
          const SizedBox(height: 20),

          // Keutamaan
          _sectionTitle(context, 'Keutamaan'),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFC1923C).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.auto_awesome,
                    size: 16, color: Color(0xFFC1923C)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(item.keutamaan,
                      style: TextStyle(
                          fontSize: 13,
                          height: 1.55,
                          color: scheme.onSurface)),
                ),
              ],
            ),
          ),

          // Catatan
          if (item.catatan != null) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHighest.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline, size: 16, color: scheme.outline),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(item.catatan!,
                        style: TextStyle(
                            fontSize: 12,
                            color: scheme.onSurfaceVariant,
                            height: 1.4)),
                  ),
                ],
              ),
            ),
          ],
        ],
      );
    if (chromeless) return body;
    return Scaffold(
      appBar: AppBar(title: Text(item.title)),
      body: body,
    );
  }

  /// Compute the displayed step number, skipping heading/bullet lines.
  int _stepNumber(List<String> steps, int idx) {
    var n = 0;
    for (var i = 0; i <= idx; i++) {
      if (!steps[i].startsWith('•') && !steps[i].endsWith(':')) n++;
    }
    return n;
  }

  Widget _sectionTitle(BuildContext context, String t) => Text(
        t.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 1,
          color: Theme.of(context).colorScheme.primary,
        ),
      );
}

class _InfoRow extends StatelessWidget {
  const _InfoRow(
      {required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: scheme.primary),
          const SizedBox(width: 12),
          SizedBox(
            width: 56,
            child: Text(label,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: scheme.outline)),
          ),
          Expanded(
            child: Text(value,
                style: const TextStyle(fontSize: 13, height: 1.4)),
          ),
        ],
      ),
    );
  }
}

class _Step extends StatelessWidget {
  const _Step({required this.number, required this.text});
  final int? number;
  final String text;

  @override
  Widget build(BuildContext context) {
    const color = Color(0xFFA77B43);
    // Heading line (ends with ':')
    if (number == null && text.endsWith(':')) {
      return Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 4),
        child: Text(text,
            style: const TextStyle(
                fontWeight: FontWeight.w700, fontSize: 13, color: color)),
      );
    }
    // Bullet sub-item
    if (number == null) {
      return Padding(
        padding: const EdgeInsets.only(left: 12, top: 4, bottom: 4),
        child: Text(text,
            style: const TextStyle(fontSize: 13, height: 1.5)),
      );
    }
    // Numbered step
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text('$number',
                style: const TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.w800)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(text,
                  style: const TextStyle(fontSize: 13, height: 1.5)),
            ),
          ),
        ],
      ),
    );
  }
}
