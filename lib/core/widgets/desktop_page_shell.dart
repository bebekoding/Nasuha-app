import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../config/theme/app_colors.dart';
import '../../config/theme/neo_style.dart';
import '../../features/quran/data/repositories/quran_repository.dart';
import '../../features/settings/presentation/providers/settings_providers.dart';
import 'user_avatar.dart';

/// Chrome standar untuk halaman desktop PWA Nasuha.
///
/// Menyediakan top nav Nasuha (wordmark + link + mega-menu Ibadah +
/// settings + Akun chip), max-width container 1240px terpusat, sunburst
/// backdrop halus (light), dan optional back button + page eyebrow di
/// bawah nav.
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
    this.bodyIsScrollable = false,
  });

  final Widget child;
  final bool showBack;

  /// Optional label kecil di kiri-atas konten, misal "AL-QURAN" atau
  /// "MUHASABAH" untuk menegaskan halaman aktif.
  final String? eyebrow;

  /// Route saat ini untuk highlight nav link (misal '/analytics').
  final String? currentRoute;

  /// Kalau true, jangan bungkus dengan SingleChildScrollView — child
  /// bertanggung jawab scroll sendiri (CustomScrollView untuk reader).
  /// Chrome (nav + eyebrow) tetap fixed di atas, child mendapat sisa
  /// tinggi viewport via Expanded.
  final bool bodyIsScrollable;

  static const double maxContentWidth = 1240;
  static const double horizontalPadding = 48;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.dBg : AppColors.lBg;

    final chrome = Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: maxContentWidth),
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: horizontalPadding),
          child: bodyIsScrollable
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DesktopTopNav(currentRoute: currentRoute),
                    const SizedBox(height: 24),
                    if (showBack || eyebrow != null)
                      _PageHeaderRow(
                          eyebrow: eyebrow, showBack: showBack),
                    if (showBack || eyebrow != null)
                      const SizedBox(height: 16),
                    Expanded(child: child),
                  ],
                )
              : Column(
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
    );

    return Scaffold(
      backgroundColor: bg,
      body: Stack(
        children: [
          if (!isDark)
            const Positioned.fill(
              child: IgnorePointer(child: DesktopSunburstBackdrop()),
            ),
          bodyIsScrollable
              ? chrome
              : SingleChildScrollView(child: chrome),
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
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutQuart,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          transform: (_hover && !reduceMotion)
              ? (Matrix4.identity()
                ..translateByDouble(-1.0, -1.0, 0.0, 1.0))
              : Matrix4.identity(),
          decoration: BoxDecoration(
            color: scheme.surface,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
                color: NeoStyle.inkBorder(context), width: 1.5),
            boxShadow:
                NeoStyle.shadow(context, offset: _hover ? 4 : 2),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOutQuart,
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

class DesktopTopNav extends StatefulWidget {
  const DesktopTopNav({super.key, this.currentRoute});

  final String? currentRoute;

  @override
  State<DesktopTopNav> createState() => _DesktopTopNavState();
}

class _DesktopTopNavState extends State<DesktopTopNav> {
  final OverlayPortalController _megaCtrl = OverlayPortalController();
  final LayerLink _navLink = LayerLink();
  Timer? _closeTimer;
  bool _megaOpen = false;

  static const Object _megaTapGroup = 'nasuha-mega-menu';

  /// Route yang tergolong dalam mega-menu Ibadah (untuk state aktif trigger).
  static const List<String> _megaRoutes = [
    '/quran',
    '/dzikir',
    '/sholat-sunnah',
    '/zakat',
    '/sedekah',
  ];

  @override
  void dispose() {
    _closeTimer?.cancel();
    super.dispose();
  }

  void _openMega() {
    _closeTimer?.cancel();
    if (!_megaCtrl.isShowing) _megaCtrl.show();
    if (!_megaOpen) setState(() => _megaOpen = true);
  }

  void _toggleMega() => _megaOpen ? _closeMega() : _openMega();

  /// Grace 160ms supaya mouse bisa nyebrang gap trigger → panel tanpa
  /// menu keburu nutup (hover intent).
  void _scheduleClose() {
    _closeTimer?.cancel();
    _closeTimer = Timer(const Duration(milliseconds: 160), _closeMega);
  }

  void _closeMega() {
    _closeTimer?.cancel();
    if (_megaCtrl.isShowing) _megaCtrl.hide();
    if (_megaOpen && mounted) setState(() => _megaOpen = false);
  }

  void _go(String route) {
    _closeMega();
    GoRouter.of(context).push(route);
  }

  @override
  Widget build(BuildContext context) {
    final ink = Theme.of(context).colorScheme.onSurface;
    final route = widget.currentRoute;
    final megaActive =
        _megaRoutes.any((r) => route?.startsWith(r) ?? false);

    return OverlayPortal(
      controller: _megaCtrl,
      overlayChildBuilder: (context) {
        return CompositedTransformFollower(
          link: _navLink,
          showWhenUnlinked: false,
          targetAnchor: Alignment.bottomLeft,
          followerAnchor: Alignment.topLeft,
          offset: const Offset(0, 8),
          child: Align(
            alignment: Alignment.topLeft,
            child: TapRegion(
              groupId: _megaTapGroup,
              onTapOutside: (_) => _closeMega(),
              child: MouseRegion(
                onEnter: (_) => _closeTimer?.cancel(),
                onExit: (_) => _scheduleClose(),
                child: _MegaPanel(onNavigate: _go),
              ),
            ),
          ),
        );
      },
      child: CompositedTransformTarget(
        link: _navLink,
        child: SizedBox(
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
                active: route == '/' || route == null,
                onTap: () => GoRouter.of(context).go('/'),
              ),
              TapRegion(
                groupId: _megaTapGroup,
                child: MouseRegion(
                  onEnter: (_) => _openMega(),
                  onExit: (_) => _scheduleClose(),
                  child: _MegaTrigger(
                    label: 'Ibadah',
                    active: megaActive,
                    open: _megaOpen,
                    onTap: _toggleMega,
                  ),
                ),
              ),
              DesktopNavLink(
                label: 'Jadwal Sholat',
                active: route == '/prayer',
                onTap: () => GoRouter.of(context).push('/prayer'),
              ),
              DesktopNavLink(
                label: 'Arah Kiblat',
                active: route == '/qibla',
                onTap: () => GoRouter.of(context).push('/qibla'),
              ),
              DesktopNavLink(
                label: 'Analitik',
                active: route == '/analytics',
                onTap: () => GoRouter.of(context).push('/analytics'),
              ),
              DesktopNavLink(
                label: 'Rank',
                active: route == '/rank',
                onTap: () => GoRouter.of(context).push('/rank'),
              ),
              const Spacer(),
              _NavIconAction(
                icon: Icons.settings_outlined,
                tooltip: 'Pengaturan',
                onTap: () => GoRouter.of(context).push('/settings'),
              ),
              const SizedBox(width: 10),
              _NavProfileChip(
                  onTap: () => GoRouter.of(context).push('/profile')),
            ],
          ),
        ),
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
    final color = (widget.active || _hover)
        ? scheme.primary
        : scheme.onSurface;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: _UnderlinedNavLabel(
            show: widget.active || _hover,
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOutQuart,
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 15,
                fontWeight:
                    widget.active ? FontWeight.w700 : FontWeight.w500,
                color: color,
              ),
              child: Text(widget.label),
            ),
          ),
        ),
      ),
    );
  }
}

/// Label nav + underline yang "menggambar" dari kiri saat show (CauseHouse
/// cue). Underline = paint-only scaleX transform, tanpa intrinsic layout.
class _UnderlinedNavLabel extends StatelessWidget {
  const _UnderlinedNavLabel({required this.show, required this.child});
  final bool show;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Padding(padding: const EdgeInsets.only(bottom: 6), child: child),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: 2,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutQuart,
            transform: Matrix4.diagonal3Values(show ? 1.0 : 0.001, 1.0, 1.0),
            transformAlignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: scheme.primary,
              borderRadius: BorderRadius.circular(1),
            ),
          ),
        ),
      ],
    );
  }
}

/// Trigger "Ibadah ▾" untuk mega-menu — visual identik DesktopNavLink
/// plus chevron yang berputar saat panel terbuka.
class _MegaTrigger extends StatefulWidget {
  const _MegaTrigger({
    required this.label,
    required this.active,
    required this.open,
    required this.onTap,
  });

  final String label;
  final bool active;
  final bool open;
  final VoidCallback onTap;

  @override
  State<_MegaTrigger> createState() => _MegaTriggerState();
}

class _MegaTriggerState extends State<_MegaTrigger> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final lit = widget.active || widget.open || _hover;
    final color = lit ? scheme.primary : scheme.onSurface;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: _UnderlinedNavLabel(
            show: widget.active || widget.open || _hover,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOutQuart,
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 15,
                    fontWeight: widget.active
                        ? FontWeight.w700
                        : FontWeight.w500,
                    color: color,
                  ),
                  child: Text(widget.label),
                ),
                const SizedBox(width: 3),
                AnimatedRotation(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutQuart,
                  turns: widget.open ? 0.5 : 0.0,
                  child: Icon(Icons.keyboard_arrow_down,
                      size: 17, color: color),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// MEGA PANEL — dropdown "Ibadah" ala CauseHouse: link display besar +
// hairline divider di kiri, highlight card di kanan, utility row bawah.
// ═══════════════════════════════════════════════════════════════════════════

class _MegaPanel extends ConsumerStatefulWidget {
  const _MegaPanel({required this.onNavigate});
  final void Function(String route) onNavigate;

  @override
  ConsumerState<_MegaPanel> createState() => _MegaPanelState();
}

class _MegaPanelState extends ConsumerState<_MegaPanel>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entrance;

  /// Index link yang sedang di-hover — preview kanan mengikuti.
  int _hovered = 0;

  static const List<({IconData icon, String label, String route})> _links = [
    (icon: Icons.menu_book, label: 'Al-Quran', route: '/quran'),
    (icon: Icons.fingerprint, label: 'Dzikir', route: '/dzikir'),
    (icon: Icons.mosque, label: 'Sholat Sunnah', route: '/sholat-sunnah'),
    (icon: Icons.paid, label: 'Zakat', route: '/zakat'),
    (icon: Icons.volunteer_activism, label: 'Sedekah', route: '/sedekah'),
  ];

  @override
  void initState() {
    super.initState();
    _entrance = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    )..forward();
  }

  @override
  void dispose() {
    _entrance.dispose();
    super.dispose();
  }

  /// Konten preview kanan per link — data ringan dari app state
  /// (bookmark Quran) atau daftar konten yang memang tersedia di fitur.
  _MegaPreviewData _previewFor(int index) {
    switch (index) {
      case 0:
        final lastRead = ref.watch(lastReadProvider).valueOrNull;
        if (lastRead != null) {
          return _MegaPreviewData(
            icon: Icons.menu_book,
            accent: AppColors.caramel,
            title: lastRead.surahName,
            desc: 'Terakhir dibaca — ayat ${lastRead.verseNumber}.',
            rows: const ['114 surah lengkap', 'Mode Fokus & Terjemah'],
            cta: 'LANJUTKAN',
            route:
                '/quran/${lastRead.surahNumber}?ayah=${lastRead.verseNumber}',
          );
        }
        return const _MegaPreviewData(
          icon: Icons.menu_book,
          accent: AppColors.caramel,
          title: 'Al-Quran',
          desc: 'Mushaf digital 114 surah.',
          rows: ['Al-Fatihah', 'Yasin', 'Al-Mulk'],
          cta: 'MULAI BACA',
          route: '/quran',
        );
      case 1:
        return const _MegaPreviewData(
          icon: Icons.fingerprint,
          accent: AppColors.ochre,
          title: 'Dzikir',
          desc: 'Dzikir harian dengan penghitung.',
          rows: [
            'Dzikir Pagi',
            'Dzikir Petang',
            'Setelah Sholat Fardhu',
          ],
          cta: 'BUKA DZIKIR',
          route: '/dzikir',
        );
      case 2:
        return const _MegaPreviewData(
          icon: Icons.mosque,
          accent: AppColors.coffee,
          title: 'Sholat Sunnah',
          desc: 'Niat + tata cara lengkap.',
          rows: ['Dhuha', 'Tahajud', 'Rawatib'],
          cta: 'LIHAT PANDUAN',
          route: '/sholat-sunnah',
        );
      case 3:
        return const _MegaPreviewData(
          icon: Icons.paid,
          accent: AppColors.goldLight,
          title: 'Zakat',
          desc: 'Hitung kewajiban zakatmu.',
          rows: [
            'Zakat Mal — nisab 85 g emas',
            'Zakat Fitrah — 2,5 kg/jiwa',
          ],
          cta: 'HITUNG ZAKAT',
          route: '/zakat',
        );
      default:
        return const _MegaPreviewData(
          icon: Icons.volunteer_activism,
          accent: AppColors.clay,
          title: 'Sedekah',
          desc: 'Catat & pantau sedekah harianmu.',
          rows: ['Catat cepat radial dial', 'Rekap & grafik'],
          cta: 'CATAT SEDEKAH',
          route: '/sedekah',
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final line = isDark ? AppColors.dLine : AppColors.lLine;
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    final preview = _previewFor(_hovered);

    final panel = Container(
      width: 620,
      padding: const EdgeInsets.fromLTRB(28, 24, 28, 18),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: NeoStyle.border(context),
        boxShadow: NeoStyle.shadow(context, offset: 6),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'IBADAH HARIAN',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2.0,
                          color:
                              scheme.onSurface.withValues(alpha: 0.55),
                        ),
                      ),
                      const SizedBox(height: 6),
                      for (int i = 0; i < _links.length; i++) ...[
                        if (i > 0)
                          Container(
                              height: 1,
                              color: line.withValues(alpha: 0.7)),
                        _MegaLink(
                          label: _links[i].label,
                          highlighted: _hovered == i,
                          onHover: () => setState(() => _hovered = i),
                          onTap: () =>
                              widget.onNavigate(_links[i].route),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 26),
                Container(width: 1, color: line.withValues(alpha: 0.7)),
                const SizedBox(width: 26),
                SizedBox(
                  width: 224,
                  child: AnimatedSwitcher(
                    duration: reduceMotion
                        ? Duration.zero
                        : const Duration(milliseconds: 200),
                    switchInCurve: Curves.easeOutQuart,
                    switchOutCurve: Curves.easeInQuad,
                    transitionBuilder: (child, anim) => FadeTransition(
                      opacity: anim,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0.04, 0),
                          end: Offset.zero,
                        ).animate(anim),
                        child: child,
                      ),
                    ),
                    child: _MegaPreviewCard(
                      key: ValueKey(_hovered),
                      data: preview,
                      onTap: () => widget.onNavigate(preview.route),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Container(height: 1, color: line.withValues(alpha: 0.7)),
          const SizedBox(height: 12),
          Row(
            children: [
              _MegaFootLink(
                icon: Icons.settings_backup_restore,
                label: 'Pemulihan data',
                onTap: () => widget.onNavigate('/backup'),
              ),
              const SizedBox(width: 20),
              _MegaFootLink(
                icon: Icons.settings_outlined,
                label: 'Pengaturan',
                onTap: () => widget.onNavigate('/settings'),
              ),
            ],
          ),
        ],
      ),
    );

    if (reduceMotion) return panel;

    return AnimatedBuilder(
      animation: _entrance,
      builder: (context, child) {
        final t = Curves.easeOutQuart.transform(_entrance.value);
        return Opacity(
          opacity: t,
          child: Transform.translate(
            offset: Offset(0, (1 - t) * -8),
            child: child,
          ),
        );
      },
      child: panel,
    );
  }
}

class _MegaLink extends StatelessWidget {
  const _MegaLink({
    required this.label,
    required this.highlighted,
    required this.onHover,
    required this.onTap,
  });

  final String label;

  /// true saat preview kanan sedang menampilkan konten link ini.
  final bool highlighted;
  final VoidCallback onHover;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => onHover(),
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutQuart,
          padding: EdgeInsets.only(
            top: 13,
            bottom: 13,
            left: highlighted ? 8 : 0,
          ),
          child: Row(
            children: [
              Expanded(
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOutQuart,
                  style: TextStyle(
                    fontFamily: 'Space Grotesk',
                    fontSize: 21,
                    fontWeight: FontWeight.w700,
                    height: 1.1,
                    letterSpacing: -0.3,
                    color:
                        highlighted ? scheme.primary : scheme.onSurface,
                  ),
                  child: Text(label),
                ),
              ),
              AnimatedSlide(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOutQuart,
                offset: highlighted ? Offset.zero : const Offset(-0.3, 0),
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 180),
                  opacity: highlighted ? 1.0 : 0.0,
                  child: Icon(Icons.arrow_forward,
                      size: 18, color: scheme.primary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Data konten preview kanan mega-menu.
class _MegaPreviewData {
  const _MegaPreviewData({
    required this.icon,
    required this.accent,
    required this.title,
    required this.desc,
    required this.rows,
    required this.cta,
    required this.route,
  });

  final IconData icon;
  final Color accent;
  final String title;
  final String desc;
  final List<String> rows;
  final String cta;
  final String route;
}

class _MegaPreviewCard extends StatelessWidget {
  const _MegaPreviewCard({super.key, required this.data, required this.onTap});

  final _MegaPreviewData data;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = data.accent;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            accent.withValues(alpha: isDark ? 0.14 : 0.08),
            accent.withValues(alpha: isDark ? 0.24 : 0.18),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        border:
            Border.all(color: accent.withValues(alpha: 0.5), width: 1.5),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(data.icon, color: accent, size: 22),
          ),
          const SizedBox(height: 14),
          Text(
            data.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'Space Grotesk',
              fontSize: 20,
              fontWeight: FontWeight.w800,
              height: 1.1,
              letterSpacing: -0.3,
              color: scheme.onSurface,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            data.desc,
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 13,
              height: 1.5,
              color: scheme.onSurface.withValues(alpha: 0.78),
            ),
          ),
          const SizedBox(height: 10),
          for (final row in data.rows)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                children: [
                  Icon(Icons.arrow_forward, size: 12, color: accent),
                  const SizedBox(width: 7),
                  Expanded(
                    child: Text(
                      row,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: scheme.onSurface.withValues(alpha: 0.75),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 14),
          NasuhaPillButton(
            label: data.cta,
            compact: true,
            showArrow: true,
            onTap: onTap,
          ),
        ],
      ),
    );
  }
}

class _MegaFootLink extends StatefulWidget {
  const _MegaFootLink({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  State<_MegaFootLink> createState() => _MegaFootLinkState();
}

class _MegaFootLinkState extends State<_MegaFootLink> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = _hover
        ? scheme.primary
        : scheme.onSurface.withValues(alpha: 0.62);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, size: 15, color: color),
              const SizedBox(width: 6),
              Text(
                widget.label,
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: color,
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
            borderRadius: BorderRadius.circular(999),
            side: BorderSide(
                color: scheme.onSurface.withValues(alpha: 0.28),
                width: 1.5),
          ),
        ),
      ),
    );
  }
}

class _NavProfileChip extends ConsumerStatefulWidget {
  const _NavProfileChip({required this.onTap});
  final VoidCallback onTap;

  @override
  ConsumerState<_NavProfileChip> createState() => _NavProfileChipState();
}

class _NavProfileChipState extends ConsumerState<_NavProfileChip> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    final photoPath = ref.watch(settingsControllerProvider).photoPath;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Tooltip(
          message: 'Akun',
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOutQuart,
            padding: const EdgeInsets.all(4),
            transform: (_hover && !reduceMotion)
                ? (Matrix4.identity()
                  ..translateByDouble(-1.0, -1.0, 0.0, 1.0))
                : Matrix4.identity(),
            decoration: BoxDecoration(
              color: scheme.primary,
              shape: BoxShape.circle,
              border: Border.all(
                  color: NeoStyle.inkBorder(context), width: 1.5),
              boxShadow:
                  NeoStyle.shadow(context, offset: _hover ? 5 : 3),
            ),
            child: UserAvatar(
              photoPath: photoPath,
              size: 34,
              background: scheme.onPrimary.withValues(alpha: 0.18),
              foreground: scheme.onPrimary,
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// PILL BUTTON — CTA reusable ala CauseHouse: pill firm, label uppercase
// tracked, hover lift + shadow (filled) / fill-invert (outline).
// ═══════════════════════════════════════════════════════════════════════════

class NasuhaPillButton extends StatefulWidget {
  const NasuhaPillButton({
    super.key,
    required this.label,
    required this.onTap,
    this.filled = true,
    this.color,
    this.showArrow = false,
    this.compact = false,
  });

  /// Label tombol — biasakan uppercase ("BUKA JADWAL").
  final String label;
  final VoidCallback onTap;

  /// true = pill terisi warna; false = outline yang terisi saat hover.
  final bool filled;

  /// Warna pill; default `scheme.primary` (coffee brown).
  final Color? color;

  final bool showArrow;

  /// Padding & font lebih kecil untuk konteks sempit (mega panel dsb).
  final bool compact;

  @override
  State<NasuhaPillButton> createState() => _NasuhaPillButtonState();
}

class _NasuhaPillButtonState extends State<NasuhaPillButton> {
  bool _hover = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    final base = widget.color ?? scheme.primary;
    final onBase =
        widget.color == null ? scheme.onPrimary : Colors.white;

    // Outline variant: transparan → terisi penuh saat hover (invert).
    final bg = widget.filled
        ? base
        : (_hover ? base : Colors.transparent);
    final fg = widget.filled
        ? onBase
        : (_hover ? onBase : base);

    final pad = widget.compact
        ? const EdgeInsets.symmetric(horizontal: 16, vertical: 10)
        : const EdgeInsets.symmetric(horizontal: 22, vertical: 13);
    final fontSize = widget.compact ? 11.5 : 12.5;

    // Neo-brutal press: tombol "masuk" ke arah bayangan.
    Matrix4 transform = Matrix4.identity();
    if (!reduceMotion) {
      if (_pressed) {
        transform = Matrix4.identity()
          ..translateByDouble(2.0, 2.0, 0.0, 1.0);
      } else if (_hover) {
        transform = Matrix4.identity()
          ..translateByDouble(-1.0, -1.0, 0.0, 1.0);
      }
    }
    final shadowOffset = _pressed ? 1.0 : (_hover ? 5.0 : 3.0);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() {
        _hover = false;
        _pressed = false;
      }),
      child: GestureDetector(
        onTap: widget.onTap,
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOutQuart,
          padding: pad,
          transform: transform,
          transformAlignment: Alignment.center,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: NeoStyle.inkBorder(context), width: 1.5),
            boxShadow: NeoStyle.shadow(context, offset: shadowOffset),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOutQuart,
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: fontSize,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                  color: fg,
                ),
                child: Text(widget.label),
              ),
              if (widget.showArrow) ...[
                const SizedBox(width: 7),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOutQuart,
                  transform: Matrix4.translationValues(
                      (_hover && !reduceMotion) ? 3 : 0, 0, 0),
                  child: Icon(Icons.arrow_forward,
                      size: widget.compact ? 14 : 16, color: fg),
                ),
              ],
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

    // Neo-brutal hover: kartu terangkat diagonal menjauhi bayangan hard.
    final transform = (_hover && !reduceMotion)
        ? (Matrix4.identity()..translateByDouble(-3.0, -3.0, 0.0, 1.0))
        : Matrix4.identity();

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
            border: NeoStyle.border(context),
            boxShadow:
                NeoStyle.shadow(context, offset: _hover ? 6 : 3),
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
