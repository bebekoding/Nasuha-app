import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../data/repositories/sedekah_repository.dart';

class SedekahHistoryScreen extends ConsumerWidget {
  const SedekahHistoryScreen({super.key, this.chromeless = false});

  final bool chromeless;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncAll = ref.watch(sedekahAllProvider);
    final currency = NumberFormat.currency(
        locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    final body = asyncAll.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (list) {
          if (list.isEmpty) {
            return const Center(child: Text('Belum ada riwayat sedekah'));
          }
          return ListView.builder(
            shrinkWrap: chromeless,
            physics: chromeless
                ? const NeverScrollableScrollPhysics()
                : null,
            padding: chromeless
                ? EdgeInsets.zero
                : const EdgeInsets.all(16),
            itemCount: list.length,
            itemBuilder: (ctx, i) {
              final r = list[i];
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.volunteer_activism,
                      color: Color(0xFFA77B43)),
                  title: Text(currency.format(r.amount),
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(
                    '${DateFormat('EEE, d MMM y · HH:mm', 'id_ID').format(r.createdAt)}'
                    '${r.note != null ? '\n${r.note}' : ''}',
                  ),
                  isThreeLine: r.note != null,
                ),
              );
            },
          );
        },
      );
    if (chromeless) return body;
    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat Sedekah')),
      body: body,
    );
  }
}
