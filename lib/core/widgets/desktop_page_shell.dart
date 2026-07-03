import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../config/theme/app_colors.dart';

/// Chrome standar untuk halaman desktop PWA Nasuha.
///
/// Menyediakan top nav Nasuha (wordmark + link + settings + Akun chip),
/// max-width container 1240px terpusat, sunburst backdrop halus (light),
/// dan optional back button + page eyebrow di bawah nav.
///
/// Dipakai oleh semua screen kecuali DesktopHomeScreen (yang punya
/// full-width hero + section rhythm sendiri) dan flow onboarding.
class DesktopPageShell extends StatelessWidget {
  const DesktopPageShell({
    super.key,
    required this.child,
    this.showBack = true,
    this.eyebrow,
    this.currentRoute,
  });

  final Widget child;
  final bool showBack;

  /// Optional label kecil di kiri-atas konten, misal "AL-QURAN" atau
  /// "MUHASABAH" untuk menegaskan halaman aktif.
  final String? eyebrow;

  /// Route saat ini untuk highlight nav link (misal '/analytics').
  final String? currentRoute;

  static const double maxContentWidth = 1240;
  static const double horizontalPadding = 48;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.dBg : AppColors.lBg;

    return Scaffold(
      backgroundColor: bg,
      body: Stack(
        children: [
          if (!isDark)
            const Positioned.fill(
              child: IgnorePointer(child: DesktopSunburstBackdrop()),
            ),
          SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints:
                    const BoxConstraints(maxWidth: maxContentWidth),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: horizontalPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DesktopTopNav(currentRoute: currentRoute),
                      const SizedBox(height: 32),
                      if (showBack || eyebrow != null)
                        _PageHeaderRow(
                            eyebrow: eyebrow, showBack: showBack),
                      if (showBack || eyebrow != null)
                        const SizedBox(height: 16),
                      child,
                      const SizedBox(height: 60),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PageHeaderRow extends StatelessWidget {
  const _PageHeaderRow({required this.eyebrow, required this.showBack});
  final String? eyebrow;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        if (showBack)
          _BackButton(onTap: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              GoRouter.of(context).go('/');
            }
          }),
        if (showBack && eyebrow != null) const SizedBox(width: 16),
        if (eyebrow != null)
          Text(
            eyebrow!,
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 2.4,
              color: scheme.primary,
            ),
          ),
      ],
    );
  }
}

class _BackButton extends StatefulWidget {
  const _BackButton({required this.onTap});
  final VoidCallback onTap;

  @override
  State<_BackButton> createState() => _BackButtonState();
}

class _BackButtonState extends State<_BackButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: scheme.surface,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
                color: scheme.outline.withValues(alpha: 0.22), width: 1),
            boxShadow: _hover
                ? [
                    BoxShadow(
                      color: scheme.onSurface.withValues(alpha: 0.08),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : const [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOut,
                transform: Matrix4.translationValues(_hover ? -3 : 0, 0, 0),
                child: Icon(Icons.arrow_back,
                    size: 16, color: scheme.onSurface),
              ),
              const SizedBox(width: 8),
              Text(
                'Kembali',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: scheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// TOP NAV — dipakai DesktopPageShell & DesktopHomeScreen
// ═══════════════════════════════════════════════════════════════════════════

class DesktopTopNav extends StatelessWidget {
  const DesktopTopNav({super.key, this.currentRoute});

  final String? currentRoute;

  @override
  Widget build(BuildContext context) {
    final ink = Theme.of(context).colorScheme.onSurface;
    return SizedBox(
      height: 72,
      child: Row(
        children: [
          GestureDetector(
            onTap: () => GoRouter.of(context).go('/'),
            behavior: HitTestBehavior.opaque,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Text(
                'Nasuha',
                style: TextStyle(
                  fontFamily: 'Space Grotesk',
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: ink,
                  letterSpacing: -0.4,
                ),
              ),
            ),
          ),
          const SizedBox(width: 40),
          DesktopNavLink(
            label: 'Beranda',
            active: currentRoute == '/' || currentRoute == null,
            onTap: () => GoRouter.of(context).go('/'),
          ),
          DesktopNavLink(
            label: 'Al-Quran',
            active: currentRoute?.startsWith('/quran') ?? false,
            onTap: () => GoRouter.of(context).push('/quran'),
          ),
          DesktopNavLink(
            label: 'Analitik',
            active: currentRoute == '/analytics',
            onTap: () => GoRouter.of(context).push('/analytics'),
          ),
          DesktopNavLink(
            label: 'Rank',
            active: currentRoute == '/rank',
            onTap: () => GoRouter.of(context).push('/rank'),
          ),
          DesktopNavLink(
            label: 'Pemulihan',
            active: currentRoute == '/backup',
            onTap: () => GoRouter.of(context).push('/backup'),
          ),
          const Spacer(),
          _NavIconAction(
            icon: Icons.settings_outlined,
            tooltip: 'Pengaturan',
            onTap: () => GoRouter.of(context).push('/settings'),
          ),
          const SizedBox(width: 8),
          _NavProfileChip(
              onTap: () => GoRouter.of(context).push('/profile')),
        ],
      ),
    );
  }
}

class DesktopNavLink extends StatefulWidget {
  const DesktopNavLink({
    super.key,
    required this.label,
    required this.onTap,
    this.active = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool active;

  @override
  State<DesktopNavLink> createState() => _DesktopNavLinkState();
}

class _DesktopNavLinkState extends State<DesktopNavLink> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = widget.active
        ? scheme.primary
        : (_hover ? scheme.primary : scheme.onSurface);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOut,
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 15,
                  fontWeight:
                      widget.active ? FontWeight.w700 : FontWeight.w500,
                  color: color,
                ),
                child: Text(widget.label),
              ),
              const SizedBox(height: 4),
              AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOut,
                height: 2,
                width: widget.active ? 20 : 0,
                decoration: BoxDecoration(
                  color: scheme.primary,
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavIconAction extends StatelessWidget {
  const _NavIconAction({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Tooltip(
      message: tooltip,
      child: IconButton(
        onPressed: onTap,
        icon: Icon(icon, size: 22),
        color: scheme.onSurface.withValues(alpha: 0.78),
        style: IconButton.styleFrom(
          backgroundColor: scheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
                color: scheme.outline.withValues(alpha: 0.22), width: 1),
          ),
        ),
      ),
    );
  }
}

class _NavProfileChip extends StatefulWidget {
  const _NavProfileChip({required this.onTap});
  final VoidCallback onTap;

  @override
  State<_NavProfileChip> createState() => _NavProfileChipState();
}

class _NavProfileChipState extends State<_NavProfileChip> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: scheme.primary,
            borderRadius: BorderRadius.circular(28),
            boxShadow: _hover
                ? [
                    BoxShadow(
                      color: scheme.primary.withValues(alpha: 0.32),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : const [],
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.person_outline, size: 18, color: Colors.white),
              SizedBox(width: 8),
              Text(
                'Akun',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// SUNBURST BACKDROP — dipakai DesktopPageShell & DesktopHomeScreen
// ═══════════════════════════════════════════════════════════════════════════

class DesktopSunburstBackdrop extends StatelessWidget {
  const DesktopSunburstBackdrop({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _SunburstPainter());
  }
}

class _SunburstPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final origin = Offset(size.width / 2, -140);
    const rayCount = 22;
    final paint = Paint()
      ..color = const Color(0xFFEDE1CE).withValues(alpha: 0.55)
      ..style = PaintingStyle.fill;
    for (int i = 0; i < rayCount; i++) {
      final angle = math.pi * i / rayCount;
      const w = 24.0;
      canvas.save();
      canvas.translate(origin.dx, origin.dy);
      canvas.rotate(angle);
      final path = Path()
        ..moveTo(-w / 2, 0)
        ..lineTo(w / 2, 0)
        ..lineTo(w * 6, size.height + 200)
        ..lineTo(-w * 6, size.height + 200)
        ..close();
      canvas.drawPath(path, paint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ═══════════════════════════════════════════════════════════════════════════
// HOVER CARD — reusable apple-style hover container
// ═══════════════════════════════════════════════════════════════════════════

/// Container yang lift + scale + shadow-bloom saat hover (mouse) — pattern
/// apple.com/mac untuk semua tap-tap card di desktop.
class HoverLiftCard extends StatefulWidget {
  const HoverLiftCard({
    super.key,
    required this.child,
    required this.onTap,
    this.accent,
    this.borderRadius = 20,
    this.borderColor,
    this.padding = const EdgeInsets.all(22),
    this.height,
    this.lift = 4.0,
    this.scale = 1.0,
  });

  final Widget child;
  final VoidCallback onTap;

  /// Warna aksen untuk shadow bloom saat hover; kalau null pakai onSurface.
  final Color? accent;

  final double borderRadius;
  final Color? borderColor;
  final EdgeInsets padding;
  final double? height;

  /// Berapa px translateY saat hover.
  final double lift;

  /// Scale saat hover (1.02 = 2% zoom; 1.0 = tak scale).
  final double scale;

  @override
  State<HoverLiftCard> createState() => _HoverLiftCardState();
}

class _HoverLiftCardState extends State<HoverLiftCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    final accent = widget.accent ?? scheme.onSurface;
    final borderColor =
        widget.borderColor ?? accent.withValues(alpha: 0.22);

    Matrix4 transform;
    if (_hover && !reduceMotion) {
      transform = Matrix4.identity()
        ..translateByDouble(0.0, -widget.lift, 0.0, 1.0);
      if (widget.scale != 1.0) {
        transform.scaleByDouble(widget.scale, widget.scale, 1.0, 1.0);
      }
    } else {
      transform = Matrix4.identity();
    }

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          transform: transform,
          transformAlignment: Alignment.center,
          height: widget.height,
          padding: widget.padding,
          decoration: BoxDecoration(
            color: scheme.surface,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: Border.all(color: borderColor, width: 1.2),
            boxShadow: _hover
                ? [
                    BoxShadow(
                      color: accent.withValues(alpha: 0.22),
                      blurRadius: 24,
                      offset: const Offset(0, 12),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: scheme.onSurface.withValues(alpha: 0.04),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
