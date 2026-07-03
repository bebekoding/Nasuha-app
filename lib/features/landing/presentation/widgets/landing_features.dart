import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../data/landing_features.dart';
import 'reveal_on_scroll.dart';

class LandingFeatures extends StatelessWidget {
  const LandingFeatures({super.key, required this.controller});

  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFEDE1CE),
      padding: const EdgeInsets.symmetric(vertical: 120),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Column(
              children: [
                RevealOnScroll(
                  controller: controller,
                  child: const _SectionHeader(),
                ),
                const SizedBox(height: 80),
                _grid(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _grid() {
    // Bento asymmetric — Muhasabah (index 0) hero-card span 2 kolom di row 1
    // untuk menghindari "identical card grid" SaaS cliché.
    //
    // Row 1: [ Muhasabah (2 col)         ][ Al-Quran (1 col) ]
    // Row 2: [ Dzikir ][ Sholat & Kiblat ][ Sedekah          ]
    // Row 3: [ Analitik ][ Rank & XP (2 col)                 ]
    const gap = 24.0;
    return Column(
      children: [
        _row(
          [
            _cell(0, flex: 2, hero: true, delay: 0),
            _cell(1, flex: 1, delay: 60),
          ],
          gap,
        ),
        const SizedBox(height: gap),
        _row(
          [
            _cell(2, flex: 1, delay: 120),
            _cell(3, flex: 1, delay: 180),
            _cell(4, flex: 1, delay: 240),
          ],
          gap,
        ),
        const SizedBox(height: gap),
        _row(
          [
            _cell(5, flex: 1, delay: 300),
            _cell(6, flex: 2, hero: true, delay: 360),
          ],
          gap,
        ),
      ],
    );
  }

  Widget _row(List<Widget> cells, double gap) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < cells.length; i++) ...[
            cells[i],
            if (i < cells.length - 1) SizedBox(width: gap),
          ],
        ],
      ),
    );
  }

  Widget _cell(int index,
      {required int flex, bool hero = false, required int delay}) {
    return Expanded(
      flex: flex,
      child: RevealOnScroll(
        controller: controller,
        delay: Duration(milliseconds: delay),
        child: _FeatureCard(
          feature: kLandingFeatures[index],
          rotateSign: (index % 2 == 0) ? 1 : -1,
          hero: hero,
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader();

  @override
  Widget build(BuildContext context) {
    // Tanpa eyebrow — heading solo carry hierarchy (menghindari
    // "eyebrow-above-every-section" AI grammar).
    return Column(
      children: const [
        Text(
          'Tujuh hal untuk hari lebih sadar',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Space Grotesk',
            fontSize: 56,
            height: 1.1,
            fontWeight: FontWeight.w700,
            color: Color(0xFF3B2E22),
            letterSpacing: -0.02 * 56,
          ),
        ),
        SizedBox(height: 16),
        Text(
          'Semuanya bekerja di dalam satu aplikasi. Semuanya offline.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 20,
            height: 1.5,
            fontWeight: FontWeight.w400,
            color: Color(0xFF6E5D4A),
          ),
        ),
      ],
    );
  }
}

class _FeatureCard extends StatefulWidget {
  const _FeatureCard({
    required this.feature,
    required this.rotateSign,
    this.hero = false,
  });
  final LandingFeature feature;
  final int rotateSign;
  final bool hero;

  @override
  State<_FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<_FeatureCard> {
  bool _hover = false;

  // Untuk label "Pelajari →" — pakai primary coffee (5.6:1 vs card cream),
  // bukan accent kartu (beberapa accent seperti ochre 2.6:1 fail contrast).
  static const _linkColor = Color(0xFF8A5A3A);

  @override
  Widget build(BuildContext context) {
    final f = widget.feature;
    final hero = widget.hero;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 320),
        curve: const Cubic(0.16, 1, 0.3, 1),
        transform: Matrix4.identity()..translate(0.0, _hover ? -6.0 : 0.0),
        padding: EdgeInsets.all(hero ? 40 : 32),
        constraints: BoxConstraints(minHeight: hero ? 380 : 340),
        decoration: BoxDecoration(
          color: const Color(0xFFFCF7EE),
          border: Border.all(
            color: _hover
                ? const Color(0xFF8A5A3A).withValues(alpha: 0.24)
                : const Color(0xFFE3D6BF),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: _hover
              ? [
                  BoxShadow(
                    color: const Color(0xFF3B2E22).withValues(alpha: 0.16),
                    blurRadius: 40,
                    offset: const Offset(0, 20),
                  ),
                ]
              : [
                  BoxShadow(
                    color: const Color(0xFF3B2E22).withValues(alpha: 0.06),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _IconTile(
              icon: f.icon,
              accent: f.accent,
              hover: _hover,
              rotateSign: widget.rotateSign,
              hero: hero,
            ),
            const Spacer(),
            Text(
              f.title,
              style: TextStyle(
                fontFamily: 'Space Grotesk',
                fontSize: hero ? 32 : 24,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF3B2E22),
                height: 1.25,
                letterSpacing: hero ? -0.02 * 32 : 0,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              f.body,
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: hero ? 18 : 16,
                height: 1.6,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF6E5D4A), // 5.1:1 vs cream
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 220),
                  opacity: _hover ? 1.0 : 0.75,
                  child: const Text(
                    'Pelajari',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _linkColor,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                AnimatedSlide(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOut,
                  offset: _hover ? const Offset(0.25, 0) : Offset.zero,
                  child: const Icon(
                    Icons.arrow_forward_rounded,
                    size: 14,
                    color: _linkColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _IconTile extends StatelessWidget {
  const _IconTile({
    required this.icon,
    required this.accent,
    required this.hover,
    required this.rotateSign,
    this.hero = false,
  });

  final IconData icon;
  final Color accent;
  final bool hover;
  final int rotateSign;
  final bool hero;

  @override
  Widget build(BuildContext context) {
    final side = hero ? 88.0 : 72.0;
    final iconSize = hero ? 40.0 : 32.0;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 320),
      curve: const Cubic(0.16, 1, 0.3, 1),
      width: side,
      height: side,
      transform: Matrix4.identity()
        ..scale(hover ? 1.06 : 1.0)
        ..rotateZ(hover ? rotateSign * (2 * math.pi / 180) : 0),
      transformAlignment: Alignment.center,
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(icon, size: iconSize, color: accent),
    );
  }
}
