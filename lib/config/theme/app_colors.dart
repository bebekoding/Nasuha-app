import 'package:flutter/material.dart';

/// Nasuha palette — warm **cream & brown** (earthy, soft, calming). Light-first.
/// Coffee-brown primary on cream surfaces; muted caramel / terracotta / ochre
/// accents. No green, no pure black, no stark white.
class AppColors {
  AppColors._();

  // ── Light (primary) ─────────────────────────────────────────
  static const lBg = Color(0xFFF4ECDD); // warm cream
  static const lSurface = Color(0xFFFCF7EE); // soft warm white (cards)
  static const lSurfaceHi = Color(0xFFEDE1CE); // deeper cream fill (inputs)
  static const lLine = Color(0xFFE3D6BF); // tan hairline
  static const lPrimary = Color(0xFF8A5A3A); // coffee brown (white text ~5.5:1)
  static const lPrimaryDim = Color(0xFF6E4730);
  static const lInk = Color(0xFF3B2E22); // espresso (not black)
  static const lMuted = Color(0xFF897866); // warm taupe

  // ── Dark (secondary, warm espresso) ─────────────────────────
  static const dBg = Color(0xFF221A12);
  static const dSurface = Color(0xFF2C2318);
  static const dSurfaceHi = Color(0xFF362B1E);
  static const dLine = Color(0xFF453826);
  static const dPrimary = Color(0xFFCBA074); // warm caramel for dark
  static const dPrimaryDim = Color(0xFFA77B43);
  static const dInk = Color(0xFFF0E8DB);
  static const dMuted = Color(0xFFB4A691);

  // ── Accents (per brightness) ────────────────────────────────
  static const goldLight = Color(0xFFC1923C); // warm ochre (streak/level)
  static const goldDark = Color(0xFFDDBE7C);
  static const negativeLight = Color(0xFFB5613F); // rust / clay (not alarming)
  static const negativeDark = Color(0xFFD8917A);

  // ── Warm earthy category hues (menu tiles & accents) ─────────
  static const coffee = Color(0xFF8A5A3A);
  static const caramel = Color(0xFFA77B43);
  static const terracotta = Color(0xFFC17A53);
  static const clay = Color(0xFFB5613F);
  static const ochre = Color(0xFFC1923C);
  static const taupe = Color(0xFFA6785F);

  // Legacy aliases.
  static const seed = lPrimary;
  static const positive = caramel;
  static const negative = clay;
  static const gold = goldLight;
}
