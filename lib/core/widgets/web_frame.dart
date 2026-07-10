import 'dart:math' as math;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';


/// Membingkai layar aplikasi menjadi lebar "mobile-ish" saat dibuka di web
/// desktop, sehingga HUD/tile tidak melar. Di mobile atau viewport sempit,
/// widget ini pass-through.
///
/// Breakpoint: web + width >= 800px. Konten dibatasi 480px dan diberi gutter
/// cream di kiri/kanan dengan bayangan halus supaya kesan "phone frame".
class WebFrame extends StatelessWidget {
  const WebFrame({super.key, required this.child});

  final Widget child;

  static const double _maxContentWidth = 480;
  static const double _activateWidth = 800;

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) return child;
    final width = MediaQuery.of(context).size.width;
    if (width < _activateWidth) return child;

    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // Gutter sengaja lebih gelap dari surface app supaya "phone frame"
    // terlihat jelas sebagai layer terpisah, bukan menyatu dengan konten.
    final gutterColor = isDark
        ? const Color(0xFF1A140D)
        : const Color(0xFFDCCEB4);
    final frameShadow = isDark
        ? Colors.black.withValues(alpha: 0.35)
        : const Color(0xFF3B2E22).withValues(alpha: 0.12);

    final gutter = math.max(0.0, (width - _maxContentWidth) / 2);

    // Padding memaksa child (Scaffold) mendapat lebar tepat _maxContentWidth
    // sekaligus tetap fill full height. Lebih deterministik dari Row/Center.
    return ColoredBox(
      color: gutterColor,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: gutter),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: scheme.surface,
            boxShadow: [
              BoxShadow(
                color: frameShadow,
                blurRadius: 28,
                spreadRadius: 2,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipRect(child: child),
        ),
      ),
    );
  }
}
