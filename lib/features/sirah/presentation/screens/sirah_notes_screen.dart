import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/theme/neo_style.dart';
import '../../data/sirah_notes.dart';

/// Halaman "Catatan Riwayat & Sanad" — dipisah dari body chapter supaya
/// pengalaman baca cerita tetap fokus. User yang ingin verifikasi riwayat
/// / sanad bisa merujuk ke sini.
class SirahNotesScreen extends StatelessWidget {
  const SirahNotesScreen({super.key, this.chromeless = false});
  final bool chromeless;

  @override
  Widget build(BuildContext context) {
    final body = _Body();
    if (chromeless) return body;
    return Scaffold(
      appBar: AppBar(title: const Text('Catatan Riwayat')),
      body: body,
    );
  }
}

class _Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    // Kelompokkan per-chapter untuk section header yang rapi.
    final Map<int, List<SirahNote>> grouped = {};
    for (final n in kSirahNotes) {
      grouped.putIfAbsent(n.chapterNumber, () => []).add(n);
    }
    final chapters = grouped.keys.toList()..sort();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      children: [
        // Header pengantar
        Container(
          margin: const EdgeInsets.only(bottom: 20),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: NeoStyle.tint(context, scheme.primary, 0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: scheme.primary.withValues(alpha: 0.28),
              width: 1.2,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.menu_book,
                      color: scheme.primary, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Catatan Riwayat & Sanad',
                    style: TextStyle(
                      fontFamily: 'Space Grotesk',
                      fontWeight: FontWeight.w800,
                      fontSize: 17,
                      color: scheme.onSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                'Cerita Sirah di app ini adalah ringkasan populer '
                'yang sengaja disusun ringkas & mengalir. Sebagian '
                'detail (tanggal, kisah pendukung, angka) memiliki '
                'riwayat variasi atau sanad yang diperbincangkan.\n\n'
                'Bagian yang bertanda catatan dijabarkan di halaman '
                'ini — dikelompokkan per-chapter. Untuk kajian '
                'mendalam, tetap rujuk kitab asli & bimbingan ustadz.',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 13,
                  height: 1.6,
                  color: scheme.onSurface.withValues(alpha: 0.78),
                ),
              ),
            ],
          ),
        ),

        for (final ch in chapters) ...[
          _ChapterHeader(
            chapterNumber: ch,
            chapterTitle: grouped[ch]!.first.chapterTitle,
          ),
          const SizedBox(height: 8),
          for (final note in grouped[ch]!) _NoteTile(note: note),
          const SizedBox(height: 20),
        ],
      ],
    );
  }
}

class _ChapterHeader extends StatelessWidget {
  const _ChapterHeader({
    required this.chapterNumber,
    required this.chapterTitle,
  });
  final int chapterNumber;
  final String chapterTitle;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () => context.push('/sirah/$chapterNumber'),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Row(
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: scheme.primary.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                'CHAPTER $chapterNumber',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w800,
                  fontSize: 10,
                  letterSpacing: 1.3,
                  color: scheme.primary,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                chapterTitle,
                style: TextStyle(
                  fontFamily: 'Space Grotesk',
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: scheme.onSurface,
                ),
              ),
            ),
            Icon(Icons.chevron_right,
                size: 18, color: scheme.onSurface.withValues(alpha: 0.5)),
          ],
        ),
      ),
    );
  }
}

class _NoteTile extends StatelessWidget {
  const _NoteTile({required this.note});
  final SirahNote note;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final paragraphs = note.body
        .split(RegExp(r'\n\n+'))
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: scheme.outline.withValues(alpha: 0.22),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            note.subject,
            style: TextStyle(
              fontFamily: 'Space Grotesk',
              fontWeight: FontWeight.w700,
              fontSize: 14.5,
              color: scheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          for (var i = 0; i < paragraphs.length; i++) ...[
            _RichNote(text: paragraphs[i]),
            if (i < paragraphs.length - 1) const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}

/// Render dukungan bold via **markdown-lite** — sama seperti reader body.
class _RichNote extends StatelessWidget {
  const _RichNote({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final base = TextStyle(
      fontFamily: 'Plus Jakarta Sans',
      fontSize: 13,
      height: 1.65,
      color: scheme.onSurface.withValues(alpha: 0.85),
    );
    final spans = <TextSpan>[];
    final parts = text.split('**');
    for (var i = 0; i < parts.length; i++) {
      if (parts[i].isEmpty) continue;
      final bold = i.isOdd;
      spans.add(TextSpan(
        text: parts[i],
        style: bold
            ? base.copyWith(
                fontWeight: FontWeight.w800,
                color: scheme.primary,
              )
            : null,
      ));
    }
    return SelectableText.rich(TextSpan(style: base, children: spans));
  }
}
