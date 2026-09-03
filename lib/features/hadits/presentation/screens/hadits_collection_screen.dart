import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/hadits_data.dart';

/// List semua hadits dari satu koleksi. Search + jump to number.
class HaditsCollectionScreen extends ConsumerStatefulWidget {
  const HaditsCollectionScreen({
    super.key,
    required this.slug,
    this.chromeless = false,
  });
  final String slug;
  final bool chromeless;

  @override
  ConsumerState<HaditsCollectionScreen> createState() =>
      _HaditsCollectionScreenState();
}

class _HaditsCollectionScreenState
    extends ConsumerState<HaditsCollectionScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(haditsCollectionProvider(widget.slug));
    final body = async.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Gagal memuat: $e')),
      data: (c) {
        if (c == null) {
          return const Center(child: Text('Koleksi tidak ditemukan'));
        }
        final q = _query.trim().toLowerCase();
        final filtered = q.isEmpty
            ? c.hadits
            : c.hadits.where((h) {
                if (h.number.toString().contains(q)) return true;
                return h.translation.toLowerCase().contains(q);
              }).toList();
        return _CollectionBody(
          collection: c,
          filtered: filtered,
          onQuery: (s) => setState(() => _query = s),
        );
      },
    );
    if (widget.chromeless) return body;
    return Scaffold(
      appBar: AppBar(
        title: Text(async.valueOrNull?.name ?? 'Hadits'),
      ),
      body: body,
    );
  }
}

class _CollectionBody extends StatelessWidget {
  const _CollectionBody({
    required this.collection,
    required this.filtered,
    required this.onQuery,
  });
  final HaditsCollection collection;
  final List<Hadits> filtered;
  final ValueChanged<String> onQuery;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Cari nomor atau kata di terjemahan…',
              prefixIcon: const Icon(Icons.search),
              isDense: true,
              filled: true,
              fillColor: scheme.surfaceContainerHighest.withValues(alpha: 0.5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: onQuery,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          child: Row(
            children: [
              Text(
                '${filtered.length} hadits',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: scheme.onSurface.withValues(alpha: 0.62),
                ),
              ),
              const Spacer(),
              Text(
                'dari ${collection.totalSource}',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 12,
                  color: scheme.onSurface.withValues(alpha: 0.44),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: filtered.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      'Tidak ada hadits yang cocok.',
                      style: TextStyle(
                        color: scheme.onSurface.withValues(alpha: 0.55),
                      ),
                    ),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (_, i) {
                    final h = filtered[i];
                    return _HaditsTile(
                      collection: collection,
                      hadits: h,
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _HaditsTile extends StatelessWidget {
  const _HaditsTile({required this.collection, required this.hadits});
  final HaditsCollection collection;
  final Hadits hadits;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    // Snippet 2-baris dari terjemah (skip pola "Telah menceritakan…" jika bisa).
    final snippet = hadits.translation
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: scheme.outline.withValues(alpha: 0.18),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () =>
            context.push('/hadits/${collection.slug}/${hadits.number}'),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: scheme.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: scheme.primary.withValues(alpha: 0.28),
                    width: 1,
                  ),
                ),
                child: Text(
                  '${hadits.number}',
                  style: TextStyle(
                    fontFamily: 'Space Grotesk',
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                    color: scheme.primary,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  snippet,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 13.5,
                    height: 1.5,
                    color: scheme.onSurface.withValues(alpha: 0.88),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.chevron_right,
                  size: 20,
                  color: scheme.onSurface.withValues(alpha: 0.45)),
            ],
          ),
        ),
      ),
    );
  }
}
