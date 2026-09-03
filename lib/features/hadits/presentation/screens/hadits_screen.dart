import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/theme/neo_style.dart';
import '../../data/hadits_data.dart';

/// Landing menu Hadits — daftar koleksi (kutubus sittah).
class HaditsScreen extends ConsumerWidget {
  const HaditsScreen({super.key, this.chromeless = false});
  final bool chromeless;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(haditsCollectionsProvider);
    final body = async.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Gagal memuat: $e')),
      data: (cols) => _CollectionsList(collections: cols),
    );
    if (chromeless) return body;
    return Scaffold(
      appBar: AppBar(title: const Text('Hadits')),
      body: body,
    );
  }
}

class _CollectionsList extends StatelessWidget {
  const _CollectionsList({required this.collections});
  final List<HaditsCollection> collections;

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
              Text('Kutubus Sittah',
                  style: TextStyle(
                    fontFamily: 'Space Grotesk',
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    color: scheme.onSurface,
                  )),
              const SizedBox(height: 4),
              Text(
                'Enam kitab hadits paling otoritatif dalam Islam. '
                'Terjemahan Bahasa Indonesia dari koleksi open-source '
                'gadingnst/hadith-api (MIT).',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 13,
                  height: 1.5,
                  color: scheme.onSurface.withValues(alpha: 0.72),
                ),
              ),
            ],
          ),
        ),
        for (final c in collections) _CollectionTile(collection: c),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            'ℹ️ Angka di sebelah kanan adalah jumlah hadits yang '
            'ter-bundle offline dari total kitab. Batch berikutnya '
            'akan menambah cakupan.',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 12,
              height: 1.4,
              color: scheme.onSurface.withValues(alpha: 0.55),
            ),
          ),
        ),
      ],
    );
  }
}

class _CollectionTile extends StatelessWidget {
  const _CollectionTile({required this.collection});
  final HaditsCollection collection;

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
        onTap: () => context.push('/hadits/${collection.slug}'),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: NeoStyle.tint(context, scheme.primary, 0.14),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(collection.icon, color: scheme.primary),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(collection.name,
                        style: TextStyle(
                          fontFamily: 'Space Grotesk',
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: scheme.onSurface,
                        )),
                    const SizedBox(height: 2),
                    Text(
                      '${collection.count} dari ${collection.totalSource} hadits',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 12,
                        color: scheme.onSurface.withValues(alpha: 0.62),
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
