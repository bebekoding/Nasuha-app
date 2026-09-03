import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/hadits_data.dart';

/// Detail satu hadits — arab besar RTL + terjemah.
class HaditsDetailScreen extends ConsumerWidget {
  const HaditsDetailScreen({
    super.key,
    required this.slug,
    required this.number,
    this.chromeless = false,
  });
  final String slug;
  final int number;
  final bool chromeless;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(haditsCollectionProvider(slug));
    final body = async.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Gagal memuat: $e')),
      data: (c) {
        if (c == null) return const Center(child: Text('Tidak ditemukan'));
        Hadits? h;
        int idx = -1;
        for (var i = 0; i < c.hadits.length; i++) {
          if (c.hadits[i].number == number) {
            h = c.hadits[i];
            idx = i;
            break;
          }
        }
        if (h == null) {
          return const Center(child: Text('Hadits tidak ada di bundle offline.'));
        }
        return _Body(collection: c, hadits: h, index: idx);
      },
    );
    if (chromeless) return body;
    return Scaffold(
      appBar: AppBar(
        title: Text(async.valueOrNull?.name ?? 'Hadits'),
      ),
      body: body,
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    required this.collection,
    required this.hadits,
    required this.index,
  });
  final HaditsCollection collection;
  final Hadits hadits;
  final int index;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header — koleksi + nomor
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: scheme.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: scheme.primary.withValues(alpha: 0.32),
                    width: 1,
                  ),
                ),
                child: Text(
                  '${collection.name}  ·  #${hadits.number}',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    color: scheme.primary,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
              const Spacer(),
              IconButton(
                tooltip: 'Salin terjemahan',
                icon: const Icon(Icons.copy_all_outlined),
                onPressed: () {
                  Clipboard.setData(ClipboardData(
                    text: '${collection.name} #${hadits.number}\n\n'
                        '${hadits.arab}\n\n${hadits.translation}',
                  ));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Disalin')),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Arab besar RTL
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHighest.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: scheme.outline.withValues(alpha: 0.18),
                width: 1,
              ),
            ),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Text(
                hadits.arab,
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 24,
                  height: 2.0,
                  fontFamily: 'Amiri', // fallback ke default kalau tak ada
                  color: scheme.onSurface,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'TERJEMAHAN',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.4,
              color: scheme.primary,
            ),
          ),
          const SizedBox(height: 10),
          SelectableText(
            hadits.translation,
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 15,
              height: 1.7,
              color: scheme.onSurface.withValues(alpha: 0.92),
            ),
          ),
          const SizedBox(height: 32),
          _NavRow(collection: collection, index: index),
        ],
      ),
    );
  }
}

class _NavRow extends StatelessWidget {
  const _NavRow({required this.collection, required this.index});
  final HaditsCollection collection;
  final int index;

  @override
  Widget build(BuildContext context) {
    final prev = index > 0 ? collection.hadits[index - 1] : null;
    final next = index < collection.hadits.length - 1
        ? collection.hadits[index + 1]
        : null;
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: prev == null
                ? null
                : () => _go(context, collection.slug, prev.number),
            icon: const Icon(Icons.chevron_left),
            label: Text(prev == null ? 'Awal' : '#${prev.number}'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: FilledButton.icon(
            onPressed: next == null
                ? null
                : () => _go(context, collection.slug, next.number),
            icon: const Icon(Icons.chevron_right),
            label: Text(next == null ? 'Akhir' : '#${next.number}'),
          ),
        ),
      ],
    );
  }

  void _go(BuildContext ctx, String slug, int num) {
    // pushReplacement (go_router) supaya back stack tak menumpuk saat browse.
    ctx.pushReplacement('/hadits/$slug/$num');
  }
}
