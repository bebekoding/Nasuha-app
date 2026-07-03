import 'package:flutter/material.dart';

/// Palet accent per fitur — extend `AppColors` warm earthy hues.
const _coffee = Color(0xFF8A5A3A);
const _ochre = Color(0xFFC1923C);
const _caramel = Color(0xFFA77B43);
const _terracotta = Color(0xFFC17A53);
const _clay = Color(0xFFB5613F);

class LandingFeature {
  const LandingFeature({
    required this.icon,
    required this.title,
    required this.body,
    required this.accent,
  });

  final IconData icon;
  final String title;
  final String body;
  final Color accent;
}

const kLandingFeatures = <LandingFeature>[
  LandingFeature(
    icon: Icons.spa_outlined,
    title: 'Muhasabah harian',
    body:
        'Catat amalan & momen refleksi. XP-mu berjalan mengikuti niatmu, bukan lomba.',
    accent: _ochre,
  ),
  LandingFeature(
    icon: Icons.menu_book_outlined,
    title: 'Al-Quran',
    body:
        '114 surah, dua mode baca (terjemah & fokus mushaf). Marker otomatis biar tak kehilangan jejak.',
    accent: _caramel,
  ),
  LandingFeature(
    icon: Icons.auto_awesome_outlined,
    title: 'Dzikir & Doa',
    body:
        'Pagi, petang, sesudah sholat, tahajud. Ketuk hitung, atau selesai sekali tap.',
    accent: _clay,
  ),
  LandingFeature(
    icon: Icons.mosque_outlined,
    title: 'Jadwal Sholat & Kiblat',
    body:
        '5 waktu presisi lokasi, kompas kiblat. Adzan pengingat halus, bukan bising.',
    accent: _coffee,
  ),
  LandingFeature(
    icon: Icons.volunteer_activism_outlined,
    title: 'Sedekah tracker',
    body:
        'Input dial cepat, rekap harian/mingguan/bulanan. Yang penting, konsisten.',
    accent: _terracotta,
  ),
  LandingFeature(
    icon: Icons.insights_outlined,
    title: 'Analitik ibadah',
    body:
        'Streak per amalan, heatmap tahunan, kurva spiritual. Data untuk dirimu sendiri.',
    accent: _caramel,
  ),
  LandingFeature(
    icon: Icons.military_tech_outlined,
    title: 'Rank & XP',
    body:
        '24 level dari Mubtadi ke Muqarrab. Bukan lomba — cermin perjalanan.',
    accent: _ochre,
  ),
];

class LandingValuePillar {
  const LandingValuePillar({
    required this.icon,
    required this.title,
    required this.body,
    required this.accent,
  });

  final IconData icon;
  final String title;
  final String body;
  final Color accent;
}

const kLandingValues = <LandingValuePillar>[
  LandingValuePillar(
    icon: Icons.shield_moon_outlined,
    title: 'Privat & offline',
    body:
        'Semua data hidup di HP-mu. Tidak ada akun wajib, tidak ada iklan, tidak ada pihak ketiga yang mengintip.',
    accent: _coffee,
  ),
  LandingValuePillar(
    icon: Icons.self_improvement_outlined,
    title: 'Personal, bukan performatif',
    body:
        'Muhasabah harian, tidak ada leaderboard publik. Perjalananmu — hanya untukmu dan Allah.',
    accent: _ochre,
  ),
  LandingValuePillar(
    icon: Icons.balance_outlined,
    title: 'Ringan & sederhana',
    body:
        'Gamifikasi seperlunya. Tak ada notifikasi memaksa. Kamu yang atur ritme.',
    accent: _caramel,
  ),
];
