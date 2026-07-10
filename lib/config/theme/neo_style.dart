import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Vocabulary "soft neo-brutalism" untuk box/kartu Nasuha — ref jurnal-in:
/// border ink solid 1.5px + hard offset shadow (tanpa blur) satu warna ink
/// konsisten. Fill tetap tinted per-accent (identitas fitur), tapi garis
/// dan bayangan selalu espresso ink supaya setiap box tegas di atas cream.
class NeoStyle {
  NeoStyle._();

  static const double borderWidth = 1.5;

  /// Warna garis ink: espresso di light, cream-ink diredam di dark.
  static Color inkBorder(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark
        ? AppColors.dInk.withValues(alpha: 0.55)
        : AppColors.lInk;
  }

  static Border border(BuildContext context) =>
      Border.all(color: inkBorder(context), width: borderWidth);

  /// Tint accent yang DI-BLEND opaque dengan surface. WAJIB dipakai untuk
  /// fill kartu ber-hard-shadow: fill semi-transparan akan menampakkan
  /// bayangan ink yang berada persis di belakang box (blur 0, offset
  /// kecil) sehingga kartu tampak gelap.
  static Color tint(BuildContext context, Color accent, double alpha) {
    final surface = Theme.of(context).colorScheme.surface;
    return Color.alphaBlend(accent.withValues(alpha: alpha), surface);
  }

  /// Hard offset shadow ala neo-brutalism — `offset px` ke kanan-bawah,
  /// blur 0. Di dark pakai hitam solid (ink terang tak masuk akal sebagai
  /// bayangan).
  static List<BoxShadow> shadow(BuildContext context,
      {double offset = 4}) {
    if (offset <= 0) return const [];
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return [
      BoxShadow(
        color: isDark ? Colors.black.withValues(alpha: 0.55) : AppColors.lInk,
        offset: Offset(offset, offset),
        blurRadius: 0,
      ),
    ];
  }
}
