import 'package:flutter/material.dart';

import '../../data/landing_features.dart';
import 'reveal_on_scroll.dart';

class LandingValue extends StatelessWidget {
  const LandingValue({super.key, required this.controller});

  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF4ECDD),
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
                  child: const _Header(),
                ),
                const SizedBox(height: 80),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var i = 0; i < kLandingValues.length; i++) ...[
                      Expanded(
                        child: RevealOnScroll(
                          controller: controller,
                          delay: Duration(milliseconds: 80 * i),
                          child: _Pillar(pillar: kLandingValues[i]),
                        ),
                      ),
                      if (i < kLandingValues.length - 1)
                        const SizedBox(width: 40),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    // Tanpa eyebrow — 2-baris display heading yg cukup punya bobot sendiri.
    return const Text(
      'Bukan sekadar checklist.\nTempat tumbuh yang tenang.',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: 'Space Grotesk',
        fontSize: 56,
        height: 1.1,
        fontWeight: FontWeight.w700,
        color: Color(0xFF3B2E22),
        letterSpacing: -0.02 * 56,
      ),
    );
  }
}

class _Pillar extends StatefulWidget {
  const _Pillar({required this.pillar});
  final LandingValuePillar pillar;

  @override
  State<_Pillar> createState() => _PillarState();
}

class _PillarState extends State<_Pillar> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final p = widget.pillar;
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,
            width: 80,
            height: 80,
            transform: Matrix4.identity()..scale(_hover ? 1.08 : 1.0),
            transformAlignment: Alignment.center,
            decoration: BoxDecoration(
              color: p.accent.withValues(alpha: _hover ? 0.22 : 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(p.icon, size: 40, color: p.accent),
          ),
          const SizedBox(height: 24),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 220),
            style: TextStyle(
              fontFamily: 'Space Grotesk',
              fontSize: 24,
              height: 1.3,
              fontWeight: FontWeight.w700,
              color: _hover ? p.accent : const Color(0xFF3B2E22),
            ),
            child: Text(p.title),
          ),
          const SizedBox(height: 12),
          Text(
            p.body,
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 16,
              height: 1.6,
              fontWeight: FontWeight.w400,
              color: Color(0xFF6E5D4A), // 5.1:1 vs cream
            ),
          ),
        ],
      ),
    );
  }
}
