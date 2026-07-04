import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../models/muhasabah_entry.dart';
import '../../../../models/muhasabah_tag.dart';
import '../../data/repositories/muhasabah_repository.dart';

final _allEntriesProvider = StreamProvider<List<MuhasabahEntry>>((ref) {
  return ref.watch(muhasabahRepositoryProvider).watchAllEntries();
});

class MuhasabahHistoryScreen extends ConsumerWidget {
  const MuhasabahHistoryScreen({super.key, this.chromeless = false});

  final bool chromeless;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesAsync = ref.watch(_allEntriesProvider);
    final body = entriesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (entries) {
          if (entries.isEmpty) {
            return const Center(child: Text('Belum ada riwayat'));
          }
          // Group by dateKey
          final grouped = <String, List<MuhasabahEntry>>{};
          for (final e in entries) {
            grouped.putIfAbsent(e.dateKey, () => []).add(e);
          }
          final dateKeys = grouped.keys.toList();
          return ListView.builder(
            shrinkWrap: chromeless,
            physics: chromeless
                ? const NeverScrollableScrollPhysics()
                : null,
            padding: chromeless
                ? EdgeInsets.zero
                : const EdgeInsets.all(16),
            itemCount: dateKeys.length,
            itemBuilder: (ctx, i) {
              final key = dateKeys[i];
              final list = grouped[key]!;
              final date = DateTime.parse(key);
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat('EEEE, d MMM y', 'id_ID').format(date),
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 8),
                      for (final e in list)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Icon(
                                e.kind == TagKind.positive
                                    ? Icons.add_circle_outline
                                    : Icons.remove_circle_outline,
                                size: 18,
                                color: e.kind == TagKind.positive
                                    ? const Color(0xFFA77B43)
                                    : const Color(0xFFB5613F),
                              ),
                              const SizedBox(width: 8),
                              Expanded(child: Text(e.tagName)),
                              Text('${e.tagScore > 0 ? '+' : ''}${e.tagScore}'),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      );
    if (chromeless) return body;
    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat Muhasabah')),
      body: body,
    );
  }
}
