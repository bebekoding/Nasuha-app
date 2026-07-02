import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/repositories/quran_repository.dart';

class QuranScreen extends ConsumerStatefulWidget {
  const QuranScreen({super.key});

  @override
  ConsumerState<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends ConsumerState<QuranScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final surahAsync = ref.watch(allSurahProvider);
    final lastReadAsync = ref.watch(lastReadProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Al-Quran')),
      body: surahAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.cloud_off, size: 64),
              const SizedBox(height: 16),
              Text('Gagal memuat: $e', textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => ref.invalidate(allSurahProvider),
                child: const Text('Coba lagi'),
              ),
            ],
          )),
        ),
        data: (surahList) {
          final filtered = _query.isEmpty
              ? surahList
              : surahList
                  .where((s) =>
                      s.nameLatin
                          .toLowerCase()
                          .contains(_query.toLowerCase()) ||
                      s.number.toString() == _query ||
                      s.nameTranslation
                          .toLowerCase()
                          .contains(_query.toLowerCase()))
                  .toList();

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (lastReadAsync.valueOrNull != null) ...[
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.bookmark, color: Color(0xFFC1923C)),
                    title: const Text('Lanjutkan membaca'),
                    subtitle: Text(
                        '${lastReadAsync.value!.surahName} • Ayat ${lastReadAsync.value!.verseNumber}'),
                    trailing: const Icon(Icons.play_arrow, size: 20),
                    onTap: () => context.push(
                        '/quran/${lastReadAsync.value!.surahNumber}?ayah=${lastReadAsync.value!.verseNumber}'),
                  ),
                ),
                const SizedBox(height: 12),
              ],
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Cari surah...',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (v) => setState(() => _query = v),
              ),
              const SizedBox(height: 12),
              for (final s in filtered)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    tileColor: Theme.of(context)
                        .colorScheme
                        .surfaceContainerHighest
                        .withValues(alpha: 0.3),
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context)
                          .colorScheme
                          .primaryContainer,
                      child: Text('${s.number}',
                          style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer)),
                    ),
                    title: Text(s.nameLatin,
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text(
                        '${s.nameTranslation} • ${s.verseCount} ayat • ${s.revelation}'),
                    trailing: Text(
                      s.nameArabic,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    onTap: () => context.push('/quran/${s.number}'),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
