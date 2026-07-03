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
    return LayoutBuilder(
      builder: (context, constraints) {
        const columns = 3;
        const gap = 24.0;
        final cardWidth =
            (constraints.maxWidth - gap * (columns - 1)) / columns;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (var i = 0; i < kLandingFeatures.length; i++)
              SizedBox(
                width: cardWidth,
                child: RevealOnScroll(
                  controller: controller,
                  delay: Duration(milliseconds: 60 * i),
                  child: _FeatureCard(
                    feature: kLandingFeatures[i],
                    rotateSign: (i % 2 == 0) ? 1 : -1,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 24,
              height: 1.5,
              color: const Color(0xFFC1923C),
            ),
            const SizedBox(width: 12),
            const Text(
              'FITUR',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFFC1923C),
                letterSpacing: 0.08 * 13,
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 24,
              height: 1.5,
              color: const Color(0xFFC1923C),
            ),
          ],
        ),
        const SizedBox(height: 24),
        const Text(
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
      ],
    );
  }
}

class _FeatureCard extends StatefulWidget {
  const _FeatureCard({required this.feature, required this.rotateSign});
  final LandingFeature feature;
  final int rotateSign;

  @override
  State<_FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<_FeatureCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final f = widget.feature;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 320),
        curve: const Cubic(0.16, 1, 0.3, 1),
        transform: Matrix4.identity()..translate(0.0, _hover ? -6.0 : 0.0),
        padding: const EdgeInsets.all(32),
        constraints: const BoxConstraints(minHeight: 340),
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
            ),
            const Spacer(),
            Text(
              f.title,
              style: const TextStyle(
                fontFamily: 'Space Grotesk',
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Color(0xFF3B2E22),
                height: 1.3,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              f.body,
              style: const TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 16,
                height: 1.6,
                fontWeight: FontWeight.w400,
                color: Color(0xFF897866),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 220),
                  opacity: _hover ? 1.0 : 0.6,
                  child: Text(
                    'Pelajari',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: f.accent,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                AnimatedSlide(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOut,
                  offset: _hover ? const Offset(0.25, 0) : Offset.zero,
                  child: Icon(
                    Icons.arrow_forward_rounded,
                    size: 14,
                    color: f.accent,
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
  });

  final IconData icon;
  final Color accent;
  final bool hover;
  final int rotateSign;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 320),
      curve: const Cubic(0.16, 1, 0.3, 1),
      width: 72,
      height: 72,
      transform: Matrix4.identity()
        ..scale(hover ? 1.06 : 1.0)
        ..rotateZ(hover ? rotateSign * (2 * math.pi / 180) : 0),
      transformAlignment: Alignment.center,
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(icon, size: 32, color: accent),
    );
  }
}
