import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

/// Sticky nav bar dengan efek shrink saat scroll > 80 px (ala apple.com).
class LandingNav extends StatelessWidget {
  const LandingNav({
    super.key,
    required this.controller,
    required this.onCta,
    required this.onLinkTap,
  });

  final ScrollController controller;
  final VoidCallback onCta;
  final void Function(String anchor) onLinkTap;

  static const _linkColor = Color(0xFF897866);
  static const _linkHover = Color(0xFF3B2E22);
  static const _line = Color(0xFFE3D6BF);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final scrolled = controller.hasClients && controller.offset > 80;
        final height = scrolled ? 56.0 : 72.0;
        final blur = scrolled ? 20.0 : 8.0;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 240),
          curve: Curves.easeOut,
          height: height,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: scrolled ? _line : Colors.transparent,
                width: 1,
              ),
            ),
          ),
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
              child: Container(
                color: const Color(0xFFFCF7EE).withValues(alpha: 0.72),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1200),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 48),
                      child: Row(
                        children: [
                          _Brand(scrolled: scrolled),
                          const Spacer(),
                          _NavLink(
                            label: 'Fitur',
                            onTap: () => onLinkTap('fitur'),
                          ),
                          const SizedBox(width: 32),
                          _NavLink(
                            label: 'Nilai',
                            onTap: () => onLinkTap('nilai'),
                          ),
                          const SizedBox(width: 32),
                          _NavLink(
                            label: 'FAQ',
                            onTap: () => onLinkTap('faq'),
                          ),
                          const Spacer(),
                          _CtaPill(onTap: onCta),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _Brand extends StatelessWidget {
  const _Brand({required this.scrolled});
  final bool scrolled;

  @override
  Widget build(BuildContext context) {
    final size = scrolled ? 28.0 : 32.0;
    return Row(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 240),
          curve: Curves.easeOut,
          width: size,
          height: size,
          decoration: BoxDecoration(
            image: const DecorationImage(
              image: AssetImage('assets/icon/nasuha_icon_fg.png'),
              fit: BoxFit.contain,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(width: 10),
        const Text(
          'Nasuha',
          style: TextStyle(
            fontFamily: 'Space Grotesk',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFF3B2E22),
            letterSpacing: -0.02 * 20,
          ),
        ),
      ],
    );
  }
}

class _NavLink extends StatefulWidget {
  const _NavLink({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: _hover ? LandingNav._linkHover : LandingNav._linkColor,
              ),
              child: Text(widget.label),
            ),
            const SizedBox(height: 4),
            AnimatedContainer(
              duration: const Duration(milliseconds: 240),
              curve: Curves.easeOut,
              height: 1.5,
              width: _hover ? 20 : 0,
              color: LandingNav._linkHover,
            ),
          ],
        ),
      ),
    );
  }
}

class _CtaPill extends StatefulWidget {
  const _CtaPill({required this.onTap});
  final VoidCallback onTap;

  @override
  State<_CtaPill> createState() => _CtaPillState();
}

class _CtaPillState extends State<_CtaPill> {
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
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          transform: Matrix4.identity()
            ..translate(0.0, _hover ? -1.0 : 0.0)
            ..scale(_hover ? 1.02 : 1.0),
          transformAlignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
          decoration: BoxDecoration(
            color:
                _hover ? const Color(0xFF6E4730) : const Color(0xFF8A5A3A),
            borderRadius: BorderRadius.circular(999),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF8A5A3A)
                    .withValues(alpha: _hover ? 0.28 : 0.14),
                blurRadius: _hover ? 22 : 10,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Mulai',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFFCF7EE),
                ),
              ),
              const SizedBox(width: 6),
              AnimatedSlide(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                offset: _hover ? const Offset(0.25, 0) : Offset.zero,
                child: const Icon(
                  Icons.arrow_forward_rounded,
                  size: 16,
                  color: Color(0xFFFCF7EE),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
