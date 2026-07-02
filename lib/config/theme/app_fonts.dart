import 'package:flutter/material.dart';

/// Offline, bundled-font helpers replacing `google_fonts`. The .ttf variable
/// fonts live in `assets/fonts/` (declared in pubspec); `fontWeight` maps to
/// each font's `wght` axis. Call shape mirrors the old `GoogleFonts.*` API so
/// call sites only change their prefix.
const String displayFontFamily = 'Space Grotesk'; // display / numbers / headings
const String bodyFontFamily = 'Plus Jakarta Sans'; // body / UI

/// Naskh Arab untuk semua teks Arab (Quran, dzikir, niat sholat). Mencakup
/// tanda mushaf (mis. U+08D6) yang tak ada di font sistem.
const String arabicFontFamily = 'Scheherazade New';

TextStyle spaceGrotesk({
  TextStyle? textStyle,
  Color? color,
  double? fontSize,
  FontWeight? fontWeight,
  double? height,
  double? letterSpacing,
}) {
  return (textStyle ?? const TextStyle()).copyWith(
    fontFamily: displayFontFamily,
    color: color,
    fontSize: fontSize,
    fontWeight: fontWeight,
    height: height,
    letterSpacing: letterSpacing,
  );
}

TextStyle plusJakartaSans({
  TextStyle? textStyle,
  Color? color,
  double? fontSize,
  FontWeight? fontWeight,
  double? height,
  double? letterSpacing,
}) {
  return (textStyle ?? const TextStyle()).copyWith(
    fontFamily: bodyFontFamily,
    color: color,
    fontSize: fontSize,
    fontWeight: fontWeight,
    height: height,
    letterSpacing: letterSpacing,
  );
}

/// Applies the body font family across an existing [TextTheme].
TextTheme plusJakartaSansTextTheme(TextTheme base) =>
    base.apply(fontFamily: bodyFontFamily);
