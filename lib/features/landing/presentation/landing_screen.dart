import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'widgets/landing_cta.dart';
import 'widgets/landing_features.dart';
import 'widgets/landing_footer.dart';
import 'widgets/landing_hero.dart';
import 'widgets/landing_nav.dart';
import 'widgets/landing_value.dart';

/// Landing page marketing — PC-only (width ≥ 900 px). Mobile / non-web
/// visitor otomatis di-redirect ke `/home`.
class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final _scroll = ScrollController();

  // Key anchor untuk scroll ke section (dari nav link).
  final _featuresKey = GlobalKey();
  final _valueKey = GlobalKey();

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _goHome() => context.go('/home');

  void _scrollTo(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOutCubic,
    );
  }

  void _onLinkTap(String anchor) {
    switch (anchor) {
      case 'fitur':
        _scrollTo(_featuresKey);
        break;
      case 'nilai':
        _scrollTo(_valueKey);
        break;
      case 'faq':
        // TODO: FAQ section (belum ada) — sementara arahkan ke value.
        _scrollTo(_valueKey);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    // Mobile / non-web → langsung ke home dashboard (bukan landing).
    // Ini defensive: gate di app_router.dart sudah handle, tapi kalau ada
    // resize atau direct nav ke `/landing`, ini yang catch.
    if (!kIsWeb || width < 900) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) context.go('/home');
      });
      return const Scaffold(
        backgroundColor: Color(0xFFF4ECDD),
        body: Center(child: CircularProgressIndicator(color: Color(0xFF8A5A3A))),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF4ECDD),
      body: Stack(
        children: [
          // Content scroll
          Positioned.fill(
            child: SingleChildScrollView(
              controller: _scroll,
              child: Column(
                children: [
                  const SizedBox(height: 72), // reserve for sticky nav
                  LandingHero(
                    controller: _scroll,
                    onPrimary: _goHome,
                    onSecondary: () => _scrollTo(_featuresKey),
                  ),
                  KeyedSubtree(
                    key: _featuresKey,
                    child: LandingFeatures(controller: _scroll),
                  ),
                  KeyedSubtree(
                    key: _valueKey,
                    child: LandingValue(controller: _scroll),
                  ),
                  LandingCta(controller: _scroll, onTap: _goHome),
                  LandingFooter(onFeatureTap: () => _scrollTo(_featuresKey)),
                ],
              ),
            ),
          ),
          // Sticky nav
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: LandingNav(
              controller: _scroll,
              onCta: _goHome,
              onLinkTap: _onLinkTap,
            ),
          ),
        ],
      ),
    );
  }
}
