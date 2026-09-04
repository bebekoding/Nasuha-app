import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/theme/neo_style.dart';
import '../../data/sirah_data.dart';

/// Landing menu Sirah — grid chapter yang bisa di-tap.
class SirahScreen extends StatelessWidget {
  const SirahScreen({super.key, this.chromeless = false});
  final bool chromeless;

  @override
  Widget build(BuildContext context) {
    final body = _Body();
    if (chromeless) return body;
    return Scaffold(
      appBar: AppBar(title: const Text('Sirah Nabawi')),
      body: body,
    );
  }
}

class _Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 16),
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
              Text('Sirah Nabawiyah',
                  style: TextStyle(
                    fontFamily: 'Space Grotesk',
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                    color: scheme.onSurface,
                  )),
              const SizedBox(height: 6),
              Text(
                'Perjalanan Rasulullah ﷺ dari kelahiran hingga wafat — '
                '20 chapter pendek, disarikan dari Ar-Raheeq Al-Makhtum '
                '(Al-Mubarakpuri) dan Sirah Ibnu Hisyam.',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 13,
                  height: 1.5,
                  color: scheme.onSurface.withValues(alpha: 0.72),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: scheme.surface.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: scheme.outline.withValues(alpha: 0.24),
                    width: 1,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline,
                        size: 15,
                        color: scheme.onSurface.withValues(alpha: 0.65)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Ringkasan populer untuk pembelajaran. Sebagian '
                        'detail (tanggal, angka, kisah pendukung) '
                        'memiliki riwayat variasi — ditandai di dalam '
                        'teks bila relevan. Untuk kajian mendalam, '
                        'rujuk kitab asli & bimbingan ustadz.',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 11.5,
                          height: 1.5,
                          color: scheme.onSurface.withValues(alpha: 0.72),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        for (final c in kSirahChapters) _ChapterTile(chapter: c),
      ],
    );
  }
}

class _ChapterTile extends StatelessWidget {
  const _ChapterTile({required this.chapter});
  final SirahChapter chapter;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: scheme.outline.withValues(alpha: 0.22),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () => context.push('/sirah/${chapter.number}'),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nomor chapter dalam badge
              Container(
                width: 46,
                height: 46,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: NeoStyle.tint(context, scheme.primary, 0.14),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: scheme.primary.withValues(alpha: 0.32),
                    width: 1,
                  ),
                ),
                child: Text(
                  '${chapter.number}',
                  style: TextStyle(
                    fontFamily: 'Space Grotesk',
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                    color: scheme.primary,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chapter.title,
                      style: TextStyle(
                        fontFamily: 'Space Grotesk',
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: scheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      chapter.subtitle,
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 13,
                        color: scheme.onSurface.withValues(alpha: 0.72),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.schedule,
                            size: 12,
                            color:
                                scheme.onSurface.withValues(alpha: 0.5)),
                        const SizedBox(width: 4),
                        Text(
                          '${chapter.estimatedMinutes} mnt · ${chapter.period}',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 11,
                            color:
                                scheme.onSurface.withValues(alpha: 0.55),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right,
                  color: scheme.onSurface.withValues(alpha: 0.5)),
            ],
          ),
        ),
      ),
    );
  }
}
