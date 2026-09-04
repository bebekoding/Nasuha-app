import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/sirah_data.dart';
import '../providers/sirah_progress_provider.dart';

/// Reader satu chapter Sirah — tipografi nyaman, prev/next.
class SirahDetailScreen extends ConsumerStatefulWidget {
  const SirahDetailScreen({
    super.key,
    required this.chapterNumber,
    this.chromeless = false,
  });
  final int chapterNumber;
  final bool chromeless;

  @override
  ConsumerState<SirahDetailScreen> createState() =>
      _SirahDetailScreenState();
}

class _SirahDetailScreenState extends ConsumerState<SirahDetailScreen> {
  @override
  void initState() {
    super.initState();
    // Tandai chapter ini sebagai dibuka/dibaca — persist + update
    // lastOpened untuk fitur "lanjutkan baca".
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref
          .read(sirahProgressProvider.notifier)
          .markRead(widget.chapterNumber);
    });
  }

  @override
  void didUpdateWidget(covariant SirahDetailScreen old) {
    super.didUpdateWidget(old);
    // Route berubah chapter (mis. push next dari nav bawah) — tandai baru.
    if (old.chapterNumber != widget.chapterNumber) {
      ref
          .read(sirahProgressProvider.notifier)
          .markRead(widget.chapterNumber);
    }
  }

  @override
  Widget build(BuildContext context) {
    final idx =
        kSirahChapters.indexWhere((c) => c.number == widget.chapterNumber);
    if (idx < 0) {
      final err = Center(
          child: Text('Chapter ${widget.chapterNumber} tidak ditemukan.'));
      return widget.chromeless
          ? err
          : Scaffold(appBar: AppBar(title: const Text('Sirah')), body: err);
    }
    final chapter = kSirahChapters[idx];
    final body = _Body(chapter: chapter, index: idx);
    if (widget.chromeless) return body;
    return Scaffold(
      appBar: AppBar(title: Text('Chapter ${chapter.number}')),
      body: body,
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({required this.chapter, required this.index});
  final SirahChapter chapter;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final progress = ref.watch(sirahProgressProvider);
    final paragraphs = chapter.body
        .split(RegExp(r'\n\n+'))
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Eyebrow: nomor + periode
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: scheme.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  'CHAPTER ${chapter.number} / ${kSirahChapters.length}',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontWeight: FontWeight.w800,
                    fontSize: 10,
                    letterSpacing: 1.4,
                    color: scheme.primary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  chapter.period,
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: scheme.onSurface.withValues(alpha: 0.55),
                  ),
                ),
              ),
              Icon(Icons.schedule,
                  size: 12, color: scheme.onSurface.withValues(alpha: 0.5)),
              const SizedBox(width: 3),
              Text(
                '${chapter.estimatedMinutes} mnt',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 11,
                  color: scheme.onSurface.withValues(alpha: 0.55),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Bar tipis: proges baca keseluruhan Sirah. Membantu user lihat
          // berapa jauh mereka dalam 20 chapter.
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress.fraction,
              minHeight: 5,
              backgroundColor: scheme.primary.withValues(alpha: 0.14),
              valueColor: AlwaysStoppedAnimation(scheme.primary),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${progress.done} dari ${progress.total} chapter dibaca',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: scheme.onSurface.withValues(alpha: 0.55),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            chapter.title,
            style: TextStyle(
              fontFamily: 'Space Grotesk',
              fontWeight: FontWeight.w800,
              fontSize: 32,
              height: 1.1,
              letterSpacing: -0.6,
              color: scheme.onSurface,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            chapter.subtitle,
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 15,
              fontStyle: FontStyle.italic,
              color: scheme.onSurface.withValues(alpha: 0.72),
            ),
          ),
          const SizedBox(height: 24),
          for (final p in paragraphs) ...[
            _RichParagraph(text: p),
            const SizedBox(height: 16),
          ],
          const SizedBox(height: 20),
          _NavRow(index: index),
        ],
      ),
    );
  }
}

/// Render paragraf: teks yang dikelilingi `**bold**` di-bold, sisanya normal.
class _RichParagraph extends StatelessWidget {
  const _RichParagraph({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final base = TextStyle(
      fontFamily: 'Plus Jakarta Sans',
      fontSize: 15.5,
      height: 1.75,
      color: scheme.onSurface.withValues(alpha: 0.92),
    );
    final spans = <TextSpan>[];
    // Split by "**"
    final parts = text.split('**');
    for (var i = 0; i < parts.length; i++) {
      if (parts[i].isEmpty) continue;
      final bold = i.isOdd;
      spans.add(TextSpan(
        text: parts[i],
        style: bold
            ? base.copyWith(
                fontFamily: 'Space Grotesk',
                fontWeight: FontWeight.w800,
                color: scheme.primary,
              )
            : null,
      ));
    }
    return SelectableText.rich(TextSpan(style: base, children: spans));
  }
}

class _NavRow extends StatelessWidget {
  const _NavRow({required this.index});
  final int index;

  @override
  Widget build(BuildContext context) {
    final prev = index > 0 ? kSirahChapters[index - 1] : null;
    final next = index < kSirahChapters.length - 1
        ? kSirahChapters[index + 1]
        : null;
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: prev == null
                ? null
                : () => context.pushReplacement('/sirah/${prev.number}'),
            icon: const Icon(Icons.chevron_left),
            label: Text(prev == null
                ? 'Awal'
                : '#${prev.number} · ${_short(prev.title)}'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: FilledButton.icon(
            onPressed: next == null
                ? null
                : () => context.pushReplacement('/sirah/${next.number}'),
            icon: const Icon(Icons.chevron_right),
            label: Text(next == null
                ? 'Akhir'
                : '#${next.number} · ${_short(next.title)}'),
          ),
        ),
      ],
    );
  }

  String _short(String s) => s.length > 18 ? '${s.substring(0, 16)}…' : s;
}
