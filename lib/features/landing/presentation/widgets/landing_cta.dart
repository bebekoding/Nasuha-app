import 'package:flutter/material.dart';

import 'reveal_on_scroll.dart';

class LandingCta extends StatelessWidget {
  const LandingCta({
    super.key,
    required this.controller,
    required this.onTap,
  });

  final ScrollController controller;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF8A5A3A),
      padding: const EdgeInsets.symmetric(vertical: 100),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: RevealOnScroll(
              controller: controller,
              child: Column(
                children: [
                  const Text(
                    'Mulai. Kecil.\nSetiap hari.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Space Grotesk',
                      fontSize: 48,
                      height: 1.1,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFFCF7EE),
                      letterSpacing: -0.02 * 48,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Nasuha ringan, gratis, dan bekerja tanpa koneksi.\n'
                    'Buka sekarang, tak perlu buat akun.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 18,
                      height: 1.55,
                      fontWeight: FontWeight.w400,
                      color:
                          const Color(0xFFFCF7EE).withValues(alpha: 0.85),
                    ),
                  ),
                  const SizedBox(height: 40),
                  _InvertedCta(onTap: onTap),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _InvertedCta extends StatefulWidget {
  const _InvertedCta({required this.onTap});
  final VoidCallback onTap;

  @override
  State<_InvertedCta> createState() => _InvertedCtaState();
}

class _InvertedCtaState extends State<_InvertedCta> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          transform: Matrix4.identity()..scale(_hover ? 1.03 : 1.0),
          transformAlignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
          decoration: BoxDecoration(
            color:
                _hover ? const Color(0xFFF4ECDD) : const Color(0xFFFCF7EE),
            borderRadius: BorderRadius.circular(999),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFC1923C)
                    .withValues(alpha: _hover ? 0.44 : 0.0),
                blurRadius: 32,
                spreadRadius: _hover ? 2 : 0,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Mulai Perjalanan',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF8A5A3A),
                ),
              ),
              const SizedBox(width: 10),
              AnimatedSlide(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOut,
                offset: _hover ? const Offset(0.25, 0) : Offset.zero,
                child: const Icon(
                  Icons.arrow_forward_rounded,
                  size: 20,
                  color: Color(0xFF8A5A3A),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
