import 'package:flutter/material.dart';

import '../../models/muhasabah_tag.dart';

class SeedTag {
  final String slug;
  final String name;
  final int score;
  final TagKind kind;
  final IconData icon;

  const SeedTag({
    required this.slug,
    required this.name,
    required this.score,
    required this.kind,
    required this.icon,
  });
}

const List<SeedTag> kDefaultTags = [
  // Positive
  SeedTag(
      slug: 'sholat_subuh',
      name: 'Sholat Subuh',
      score: 10,
      kind: TagKind.positive,
      icon: Icons.wb_twilight),
  SeedTag(
      slug: 'sholat_dzuhur',
      name: 'Sholat Dzuhur',
      score: 10,
      kind: TagKind.positive,
      icon: Icons.wb_sunny),
  SeedTag(
      slug: 'sholat_ashar',
      name: 'Sholat Ashar',
      score: 10,
      kind: TagKind.positive,
      icon: Icons.wb_cloudy),
  SeedTag(
      slug: 'sholat_maghrib',
      name: 'Sholat Maghrib',
      score: 10,
      kind: TagKind.positive,
      icon: Icons.brightness_4),
  SeedTag(
      slug: 'sholat_isya',
      name: 'Sholat Isya',
      score: 10,
      kind: TagKind.positive,
      icon: Icons.nightlight),
  SeedTag(
      slug: 'sholat_berjamaah',
      name: 'Sholat Berjamaah',
      score: 10,
      kind: TagKind.positive,
      icon: Icons.groups),
  SeedTag(
      slug: 'tahajud',
      name: 'Tahajud',
      score: 20,
      kind: TagKind.positive,
      icon: Icons.bedtime),
  SeedTag(
      slug: 'sholat_dhuha',
      name: 'Sholat Dhuha',
      score: 15,
      kind: TagKind.positive,
      icon: Icons.light_mode),
  SeedTag(
      slug: 'baca_quran',
      name: 'Membaca Al-Quran',
      score: 15,
      kind: TagKind.positive,
      icon: Icons.menu_book),
  SeedTag(
      slug: 'dzikir_pagi',
      name: 'Dzikir Pagi',
      score: 10,
      kind: TagKind.positive,
      icon: Icons.wb_sunny_outlined),
  SeedTag(
      slug: 'dzikir_petang',
      name: 'Dzikir Petang',
      score: 10,
      kind: TagKind.positive,
      icon: Icons.wb_twilight),
  SeedTag(
      slug: 'puasa_sunnah',
      name: 'Puasa Sunnah',
      score: 20,
      kind: TagKind.positive,
      icon: Icons.no_food),
  SeedTag(
      slug: 'sedekah',
      name: 'Sedekah',
      score: 15,
      kind: TagKind.positive,
      icon: Icons.volunteer_activism),
  SeedTag(
      slug: 'belajar',
      name: 'Belajar',
      score: 10,
      kind: TagKind.positive,
      icon: Icons.auto_stories),
  SeedTag(
      slug: 'bekerja',
      name: 'Bekerja',
      score: 5,
      kind: TagKind.positive,
      icon: Icons.work),
  SeedTag(
      slug: 'family_time',
      name: 'Family Time',
      score: 10,
      kind: TagKind.positive,
      icon: Icons.family_restroom),
  SeedTag(
      slug: 'olahraga',
      name: 'Olahraga',
      score: 5,
      kind: TagKind.positive,
      icon: Icons.fitness_center),
  SeedTag(
      slug: 'membantu_orang_lain',
      name: 'Membantu Orang Lain',
      score: 10,
      kind: TagKind.positive,
      icon: Icons.handshake),
  SeedTag(
      slug: 'menuntut_ilmu',
      name: 'Menuntut Ilmu',
      score: 10,
      kind: TagKind.positive,
      icon: Icons.school),
  SeedTag(
      slug: 'menjaga_pandangan',
      name: 'Menjaga Pandangan',
      score: 10,
      kind: TagKind.positive,
      icon: Icons.remove_red_eye),
  SeedTag(
      slug: 'menjaga_lisan',
      name: 'Menjaga Lisan',
      score: 10,
      kind: TagKind.positive,
      icon: Icons.record_voice_over),

  // Negative
  SeedTag(
      slug: 'tidak_sholat_fardu',
      name: 'Tidak Sholat Fardhu',
      score: -25,
      kind: TagKind.negative,
      icon: Icons.alarm_off),
  SeedTag(
      slug: 'menunda_sholat',
      name: 'Menunda Sholat',
      score: -10,
      kind: TagKind.negative,
      icon: Icons.timer_off),
  SeedTag(
      slug: 'ghibah',
      name: 'Ghibah',
      score: -10,
      kind: TagKind.negative,
      icon: Icons.forum),
  SeedTag(
      slug: 'berbohong',
      name: 'Berbohong',
      score: -15,
      kind: TagKind.negative,
      icon: Icons.error_outline),
  SeedTag(
      slug: 'marah_berlebihan',
      name: 'Marah Berlebihan',
      score: -10,
      kind: TagKind.negative,
      icon: Icons.local_fire_department),
  SeedTag(
      slug: 'merokok',
      name: 'Merokok',
      score: -10,
      kind: TagKind.negative,
      icon: Icons.smoking_rooms),
  SeedTag(
      slug: 'membuang_waktu',
      name: 'Membuang Waktu',
      score: -5,
      kind: TagKind.negative,
      icon: Icons.hourglass_empty),
  SeedTag(
      slug: 'tidak_menjaga_pandangan',
      name: 'Tidak Menjaga Pandangan',
      score: -15,
      kind: TagKind.negative,
      icon: Icons.visibility_off),
  SeedTag(
      slug: 'nonton_porno',
      name: 'Nonton Porno',
      score: -50,
      kind: TagKind.negative,
      icon: Icons.block),
];
