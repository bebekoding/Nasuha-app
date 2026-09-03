import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Satu hadits: nomor dalam koleksi + teks arab + terjemah.
class Hadits {
  final int number;
  final String arab;
  final String translation;
  const Hadits({
    required this.number,
    required this.arab,
    required this.translation,
  });
}

/// Koleksi hadits (Bukhari, Muslim, dst).
class HaditsCollection {
  final String slug;
  final String name;
  final int totalSource; // total hadits di kitab asli
  final List<Hadits> hadits; // subset yang di-bundle
  final IconData icon;
  const HaditsCollection({
    required this.slug,
    required this.name,
    required this.totalSource,
    required this.hadits,
    required this.icon,
  });

  int get count => hadits.length;
}

// Ikon per koleksi — dipilih agar mudah dibedakan di grid.
const Map<String, IconData> _icons = {
  'bukhari': Icons.menu_book,
  'muslim': Icons.auto_stories,
  'abu-daud': Icons.book,
  'tirmidzi': Icons.library_books,
  'nasai': Icons.chrome_reader_mode,
  'ibnu-majah': Icons.import_contacts,
};

Future<List<HaditsCollection>> loadHaditsBundle() async {
  final raw = await rootBundle.loadString('assets/data/hadits.json');
  final data = json.decode(raw) as Map<String, dynamic>;
  final cols = (data['collections'] as List).cast<Map<String, dynamic>>();
  return cols.map((c) {
    final items = (c['hadits'] as List)
        .cast<Map<String, dynamic>>()
        .map((h) => Hadits(
              number: h['n'] as int,
              arab: h['a'] as String,
              translation: h['t'] as String,
            ))
        .toList();
    return HaditsCollection(
      slug: c['slug'] as String,
      name: c['name'] as String,
      totalSource: c['total_source'] as int,
      hadits: items,
      icon: _icons[c['slug']] ?? Icons.menu_book,
    );
  }).toList();
}

/// Provider — cached after first read (asset load is one-shot).
final haditsCollectionsProvider =
    FutureProvider<List<HaditsCollection>>((ref) => loadHaditsBundle());

/// Convenience: lookup satu koleksi by slug.
final haditsCollectionProvider =
    FutureProvider.family<HaditsCollection?, String>((ref, slug) async {
  final all = await ref.watch(haditsCollectionsProvider.future);
  for (final c in all) {
    if (c.slug == slug) return c;
  }
  return null;
});
