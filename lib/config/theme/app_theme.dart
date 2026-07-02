import 'package:flutter/material.dart';
import 'app_fonts.dart';

import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData light() {
    final scheme = const ColorScheme.light().copyWith(
      primary: AppColors.lPrimary,
      onPrimary: Colors.white,
      primaryContainer: const Color(0xFFE8D5BC),
      onPrimaryContainer: const Color(0xFF3A2A1A),
      secondary: AppColors.goldLight,
      onSecondary: Colors.white,
      secondaryContainer: const Color(0xFFE8D5BC),
      onSecondaryContainer: const Color(0xFF463018),
      tertiary: AppColors.goldLight,
      onTertiary: Colors.white,
      surface: AppColors.lSurface,
      onSurface: AppColors.lInk,
      surfaceContainerHighest: AppColors.lSurfaceHi,
      surfaceContainerHigh: AppColors.lSurfaceHi,
      onSurfaceVariant: AppColors.lMuted,
      outline: const Color(0xFFC8B79E),
      outlineVariant: AppColors.lLine,
      error: AppColors.negativeLight,
      onError: Colors.white,
    );
    return _build(scheme, AppColors.lBg, AppColors.goldLight);
  }

  static ThemeData dark() {
    final scheme = const ColorScheme.dark().copyWith(
      primary: AppColors.dPrimary,
      onPrimary: const Color(0xFF1E140A),
      primaryContainer: AppColors.dPrimaryDim,
      onPrimaryContainer: AppColors.dInk,
      secondary: AppColors.goldDark,
      onSecondary: const Color(0xFF241904),
      secondaryContainer: const Color(0xFF42331F),
      onSecondaryContainer: const Color(0xFFEAD9BE),
      tertiary: AppColors.goldDark,
      onTertiary: const Color(0xFF241904),
      surface: AppColors.dSurface,
      onSurface: AppColors.dInk,
      surfaceContainerHighest: AppColors.dSurfaceHi,
      surfaceContainerHigh: AppColors.dSurfaceHi,
      onSurfaceVariant: AppColors.dMuted,
      outline: const Color(0xFF5A4A38),
      outlineVariant: AppColors.dLine,
      error: AppColors.negativeDark,
      onError: const Color(0xFF2A0A06),
    );
    return _build(scheme, AppColors.dBg, AppColors.goldDark);
  }

  static ThemeData _build(ColorScheme scheme, Color bg, Color gold) {
    final base = ThemeData(useMaterial3: true, colorScheme: scheme);

    // Body / UI = Plus Jakarta Sans (humanist). Display / numbers / headings
    // = Space Grotesk (geometric, athletic) — a real contrast-axis pairing.
    final body = plusJakartaSansTextTheme(base.textTheme);
    TextStyle grotesk(TextStyle? s, {double spacing = -0.5}) =>
        spaceGrotesk(textStyle: s, letterSpacing: spacing);

    final textTheme = body.copyWith(
      displayLarge: grotesk(body.displayLarge, spacing: -1.5)
          .copyWith(fontWeight: FontWeight.w700),
      displayMedium: grotesk(body.displayMedium, spacing: -1)
          .copyWith(fontWeight: FontWeight.w800),
      displaySmall: grotesk(body.displaySmall).copyWith(fontWeight: FontWeight.w700),
      headlineMedium:
          grotesk(body.headlineMedium).copyWith(fontWeight: FontWeight.w700),
      headlineSmall:
          grotesk(body.headlineSmall).copyWith(fontWeight: FontWeight.w700),
      titleLarge: grotesk(body.titleLarge, spacing: -0.3)
          .copyWith(fontWeight: FontWeight.w700),
    );

    return base.copyWith(
      scaffoldBackgroundColor: bg,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: bg,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: spaceGrotesk(
          color: scheme.onSurface,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: scheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: scheme.outlineVariant),
        ),
        margin: EdgeInsets.zero,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: plusJakartaSans(
              fontSize: 15.5, fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: scheme.primary,
          minimumSize: const Size.fromHeight(52),
          side: BorderSide(color: scheme.primary.withValues(alpha: 0.5), width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: plusJakartaSans(
              fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerHighest,
        hintStyle: TextStyle(color: scheme.onSurfaceVariant),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: scheme.primary, width: 1.6),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: scheme.surfaceContainerHighest,
        side: BorderSide(color: scheme.outlineVariant),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        labelStyle: plusJakartaSans(fontWeight: FontWeight.w600),
      ),
      dividerTheme: DividerThemeData(color: scheme.outlineVariant, thickness: 1),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
      ),
      splashFactory: InkSparkle.splashFactory,
    );
  }
}
