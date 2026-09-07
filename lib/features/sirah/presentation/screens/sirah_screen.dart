import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/theme/neo_style.dart';
import '../../data/sirah_data.dart';
import '../providers/sirah_progress_provider.dart';

/// Landing menu Sirah — grid chapter yang bisa di-tap.
class SirahScreen extends ConsumerWidget {
  const SirahScreen({super.key, this.chromeless = false});
  final bool chromeless;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final body = _Body();
    if (chromeless) return body;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sirah Nabawi'),
        actions: [
          Consumer(builder: (context, ref, _) {
            final started = ref.watch(sirahProgressProvider).isStarted;
            if (!started) return const SizedBox.shrink();
            return IconButton(
              tooltip: 'Reset progres',
              icon: const Icon(Icons.refresh),
              onPressed: () => _confirmReset(context, ref),
            );
          }),
        ],
      ),
      body: body,
    );
  }
}

Future<void> _confirmReset(BuildContext context, WidgetRef ref) async {
  final ok = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      icon: const Icon(Icons.refresh),
      title: const Text('Reset progres baca?'),
      content: const Text(
        'Semua chapter akan ditandai belum dibaca dan posisi "lanjutkan" '
        'dihapus. Konten Sirah tidak terhapus.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('Batal'),
        ),
        FilledButton.tonal(
          onPressed: () => Navigator.pop(ctx, true),
          child: const Text('Reset'),
        ),
      ],
    ),
  );
  if (ok == true) {
    await ref.read(sirahProgressProvider.notifier).reset();
  }
}

class _Body extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final progress = ref.watch(sirahProgressProvider);
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
              const SizedBox(height: 14),
              // Progress bar baca — menonjol supaya user tahu posisi.
              Row(
                children: [
                  Text(
                    'PROGRES BACA',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.4,
                      color: scheme.primary,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${progress.done} / ${progress.total} chapter',
                    style: TextStyle(
                      fontFamily: 'Space Grotesk',
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: scheme.onSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: progress.fraction,
                  minHeight: 8,
                  backgroundColor: scheme.primary.withValues(alpha: 0.14),
                  valueColor: AlwaysStoppedAnimation(scheme.primary),
                ),
              ),
              if (progress.lastOpened != null) ...[
                const SizedBox(height: 10),
                _ContinueButton(chapterNumber: progress.lastOpened!),
              ],
            ],
          ),
        ),
        for (final c in kSirahChapters)
          _ChapterTile(chapter: c, read: progress.isRead(c.number)),
        const SizedBox(height: 12),
        const _NotesEntryTile(),
      ],
    );
  }
}

/// Entry menuju halaman Catatan Riwayat — diletakkan setelah chapter 20
/// supaya tidak mengganggu urutan cerita, tapi tetap discoverable.
class _NotesEntryTile extends StatelessWidget {
  const _NotesEntryTile();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.hardEdge,
      color: NeoStyle.tint(context, scheme.tertiary, 0.10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: scheme.tertiary.withValues(alpha: 0.42),
          width: 1.2,
        ),
      ),
      child: InkWell(
        onTap: () => context.push('/sirah/riwayat'),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 46,
                height: 46,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: NeoStyle.tint(context, scheme.tertiary, 0.22),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: scheme.tertiary.withValues(alpha: 0.36),
                    width: 1,
                  ),
                ),
                child: Icon(Icons.menu_book, color: scheme.tertiary),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Catatan Riwayat & Sanad',
                      style: TextStyle(
                        fontFamily: 'Space Grotesk',
                        fontWeight: FontWeight.w700,
                        fontSize: 15.5,
                        color: scheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Penjelasan riwayat variasi & sanad untuk '
                      'yang ingin verifikasi lebih dalam.',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 12.5,
                        height: 1.4,
                        color: scheme.onSurface.withValues(alpha: 0.72),
                      ),
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

class _ContinueButton extends StatelessWidget {
  const _ContinueButton({required this.chapterNumber});
  final int chapterNumber;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    // Cari chapter object untuk display.
    final ch = kSirahChapters.firstWhere(
      (c) => c.number == chapterNumber,
      orElse: () => kSirahChapters.first,
    );
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: () => context.push('/sirah/${ch.number}'),
        icon: const Icon(Icons.play_arrow, size: 18),
        label: Text(
          'Lanjutkan chapter ${ch.number} — ${ch.title}',
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        style: FilledButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          padding: const EdgeInsets.symmetric(vertical: 10),
        ),
      ),
    );
  }
}

class _ChapterTile extends StatelessWidget {
  const _ChapterTile({required this.chapter, required this.read});
  final SirahChapter chapter;
  final bool read;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    // Tile "sudah dibaca" pakai tinting soft supaya beda visual tapi
    // tetap bisa dibuka ulang.
    final tint = read
        ? NeoStyle.tint(context, scheme.primary, 0.06)
        : scheme.surface;
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      color: tint,
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: read
              ? scheme.primary.withValues(alpha: 0.34)
              : scheme.outline.withValues(alpha: 0.22),
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
              // Nomor chapter dalam badge — atau centang kalau sudah dibaca.
              Container(
                width: 46,
                height: 46,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: read
                      ? scheme.primary
                      : NeoStyle.tint(context, scheme.primary, 0.14),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: scheme.primary.withValues(alpha: 0.32),
                    width: 1,
                  ),
                ),
                child: read
                    ? Icon(Icons.check,
                        color: scheme.onPrimary, size: 22)
                    : Text(
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
                        Expanded(
                          child: Text(
                            '${chapter.estimatedMinutes} mnt · ${chapter.period}',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 11,
                              color:
                                  scheme.onSurface.withValues(alpha: 0.55),
                            ),
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
