import 'package:flutter/material.dart';

/// A single lifetime rank ("gelar") on the rank journey. Ranks are earned by
/// accumulating net lifetime XP (the sum of every day's muhasabah score), so a
/// rank can slip back down — and even below zero into the negative tiers — when
/// sins outweigh good. Chosen on purpose for honest self-accounting.
class RankTier {
  const RankTier({
    required this.level,
    required this.title,
    required this.meaning,
    required this.minXp,
    required this.color,
    required this.icon,
  });

  /// Display level: negative/zero for the deficit tiers, 1..24 going up.
  final int level;

  /// Short Arabic-derived title.
  final String title;

  /// One-line Indonesian gloss shown on the rank screen.
  final String meaning;

  /// Net lifetime XP required to *reach* this level (negative for deficit tiers).
  final int minXp;

  /// Accent colour — ashen for deficit tiers, then warms earthy → gold climbing.
  final Color color;

  /// Symbol shown inside the level medallion.
  final IconData icon;
}

// Deficit (below zero) — ashen, "unlit" tones to read as a dimmed soul.
const _ash1 = Color(0xFF9A8C7E); // nearest baseline
const _ash2 = Color(0xFF7C7068);
const _ash3 = Color(0xFF5E534C); // floor

// Warm palette anchors (mirrors app_colors.dart), earthiest at the bottom of
// the climb, richest gold at the summit.
const _taupe = Color(0xFFA6785F);
const _terracotta = Color(0xFFC17A53);
const _clay = Color(0xFFB5613F);
const _caramel = Color(0xFFA77B43);
const _coffee = Color(0xFF8A5A3A);
const _ochre = Color(0xFFC1923C);
const _gold = Color(0xFFD4A017);

/// The ranks, ascending by [minXp]. Three deficit tiers sit below zero; from
/// level 1 the [minXp] grows ~exponentially so early levels arrive in days and
/// the summit is a multi-year journey for a steady ~100-points/day practitioner.
const List<RankTier> kRankTiers = [
  // --- Deficit (XP below zero) ---
  RankTier(level: -2, title: 'Ghariq', meaning: 'Tenggelam dalam lalai — bangkitlah', minXp: -3000, color: _ash3, icon: Icons.waves),
  RankTier(level: -1, title: 'Zhalim', meaning: 'Menzalimi diri, masih ada jalan pulang', minXp: -1500, color: _ash2, icon: Icons.heart_broken),
  RankTier(level: 0, title: 'Ghafil', meaning: 'Lalai, saatnya kembali', minXp: -500, color: _ash1, icon: Icons.cloud),

  // --- Ascending ---
  RankTier(level: 1, title: 'Mubtadi', meaning: 'Pemula yang baru melangkah', minXp: 0, color: _taupe, icon: Icons.eco),
  RankTier(level: 2, title: 'Salik', meaning: 'Penempuh jalan kebaikan', minXp: 100, color: _taupe, icon: Icons.directions_walk),
  RankTier(level: 3, title: 'Talib', meaning: 'Pencari ilmu dan hidayah', minXp: 300, color: _taupe, icon: Icons.search),
  RankTier(level: 4, title: 'Murid', meaning: 'Hati yang berhasrat berbenah', minXp: 600, color: _taupe, icon: Icons.favorite_border),
  RankTier(level: 5, title: 'Abid', meaning: 'Tekun dalam ibadah', minXp: 1000, color: _terracotta, icon: Icons.self_improvement),
  RankTier(level: 6, title: 'Qanit', meaning: 'Taat lagi khusyuk', minXp: 1500, color: _terracotta, icon: Icons.front_hand),
  RankTier(level: 7, title: 'Awwab', meaning: 'Senantiasa kembali kepada-Nya', minXp: 2200, color: _terracotta, icon: Icons.replay),
  RankTier(level: 8, title: "Ta'ib", meaning: 'Bersungguh dalam taubat', minXp: 3000, color: _terracotta, icon: Icons.healing),
  RankTier(level: 9, title: 'Hanif', meaning: 'Lurus di atas tauhid', minXp: 4000, color: _clay, icon: Icons.straighten),
  RankTier(level: 10, title: 'Zahid', meaning: 'Zuhud dari gemerlap dunia', minXp: 5500, color: _clay, icon: Icons.spa),
  RankTier(level: 11, title: 'Mujahid', meaning: 'Bersungguh melawan hawa nafsu', minXp: 7500, color: _clay, icon: Icons.fitness_center),
  RankTier(level: 12, title: 'Sabir', meaning: 'Sabar dalam ketaatan dan ujian', minXp: 10000, color: _clay, icon: Icons.hourglass_bottom),
  RankTier(level: 13, title: 'Syakir', meaning: 'Pandai bersyukur', minXp: 13000, color: _caramel, icon: Icons.volunteer_activism),
  RankTier(level: 14, title: "Khasyi'", meaning: 'Khusyuk dan rendah hati', minXp: 17000, color: _caramel, icon: Icons.nightlight),
  RankTier(level: 15, title: "Wari'", meaning: 'Menjauhi yang syubhat', minXp: 22000, color: _caramel, icon: Icons.shield_outlined),
  RankTier(level: 16, title: 'Taqiy', meaning: 'Bertakwa dalam sunyi dan ramai', minXp: 28000, color: _caramel, icon: Icons.verified_user),
  RankTier(level: 17, title: 'Muttaqi', meaning: 'Kokoh dalam ketakwaan', minXp: 35000, color: _coffee, icon: Icons.shield),
  RankTier(level: 18, title: 'Salih', meaning: 'Saleh dalam amal dan akhlak', minXp: 44000, color: _coffee, icon: Icons.local_florist),
  RankTier(level: 19, title: 'Muhsin', meaning: 'Beribadah dalam ihsan', minXp: 55000, color: _coffee, icon: Icons.auto_awesome),
  RankTier(level: 20, title: 'Mukhlis', meaning: 'Ikhlas tanpa pamrih', minXp: 70000, color: _coffee, icon: Icons.diamond),
  RankTier(level: 21, title: 'Rabbani', meaning: 'Tertambat pada Tuhannya', minXp: 90000, color: _ochre, icon: Icons.brightness_5),
  RankTier(level: 22, title: 'Siddiq', meaning: 'Jujur dan teguh dalam kebenaran', minXp: 115000, color: _ochre, icon: Icons.verified),
  RankTier(level: 23, title: "'Arif", meaning: 'Mengenal Allah dengan hati', minXp: 150000, color: _ochre, icon: Icons.lightbulb),
  RankTier(level: 24, title: 'Muqarrab', meaning: 'Didekatkan kepada Allah', minXp: 200000, color: _gold, icon: Icons.workspace_premium),
];

/// Where the user stands: their current [tier], the [next] one (null at the
/// summit), and how far along the current band they are.
class RankProgress {
  const RankProgress({
    required this.tier,
    required this.next,
    required this.xp,
    required this.fraction,
    required this.xpIntoTier,
    required this.xpForNextTier,
  });

  final RankTier tier;
  final RankTier? next;
  final int xp;

  /// 0..1 progress through the current band (1.0 at max level).
  final double fraction;

  /// XP earned within the current band.
  final int xpIntoTier;

  /// Total span of the current band (next.minXp − tier.minXp); 0 at max.
  final int xpForNextTier;

  bool get isMax => next == null;

  /// XP still needed to reach the next tier (0 at max).
  int get xpRemaining => isMax ? 0 : (xpForNextTier - xpIntoTier).clamp(0, xpForNextTier);
}

/// Resolves a net lifetime [xp] (may be negative) to a [RankProgress]. XP below
/// the lowest tier simply sits at 0% of that floor tier.
RankProgress rankForXp(int xp) {
  var idx = 0;
  for (var i = 0; i < kRankTiers.length; i++) {
    if (xp >= kRankTiers[i].minXp) {
      idx = i;
    } else {
      break;
    }
  }

  final current = kRankTiers[idx];
  final next = idx + 1 < kRankTiers.length ? kRankTiers[idx + 1] : null;
  if (next == null) {
    return RankProgress(
      tier: current,
      next: null,
      xp: xp,
      fraction: 1,
      xpIntoTier: 0,
      xpForNextTier: 0,
    );
  }

  final span = next.minXp - current.minXp;
  final into = (xp - current.minXp).clamp(0, span);
  return RankProgress(
    tier: current,
    next: next,
    xp: xp,
    fraction: span == 0 ? 0 : into / span,
    xpIntoTier: into,
    xpForNextTier: span,
  );
}
