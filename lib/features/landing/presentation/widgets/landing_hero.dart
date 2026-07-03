import 'package:flutter/material.dart';

/// Hero section: eyebrow, headline (gradient highlight), subtitle, 2 CTA,
/// emblem parallax. Entrance stagger loading.
class LandingHero extends StatefulWidget {
  const LandingHero({
    super.key,
    required this.controller,
    required this.onPrimary,
    required this.onSecondary,
  });

  final ScrollController controller;
  final VoidCallback onPrimary;
  final VoidCallback onSecondary;

  @override
  State<LandingHero> createState() => _LandingHeroState();
}

class _LandingHeroState extends State<LandingHero>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entrance;
  double _scrollY = 0;

  @override
  void initState() {
    super.initState();
    _entrance = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    // Trigger entrance sedikit setelah first frame supaya splash HTML sudah hilang.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 80), _entrance.forward);
    });
    widget.controller.addListener(_onScroll);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onScroll);
    _entrance.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!widget.controller.hasClients) return;
    final y = widget.controller.offset;
    if ((y - _scrollY).abs() < 1) return;
    setState(() => _scrollY = y);
  }

  double _delay(int step) => (step * 80) / 1200; // 80 ms per step, dari 1200 ms
  Animation<double> _fadeAt(int step) => CurvedAnimation(
        parent: _entrance,
        curve: Interval(_delay(step), (_delay(step) + 0.4).clamp(0.0, 1.0),
            curve: Curves.easeOut),
      );

  @override
  Widget build(BuildContext context) {
    final reduce = MediaQuery.of(context).disableAnimations;
    final parallaxOffset = reduce ? 0.0 : (_scrollY * 0.08).clamp(-40.0, 40.0);

    return Container(
      padding: const EdgeInsets.only(top: 120, bottom: 80),
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 900),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48),
          child: Column(
            children: [
              _reveal(0, _Eyebrow()),
              const SizedBox(height: 24),
              _reveal(1, const _Headline()),
              const SizedBox(height: 24),
              _reveal(2, const _Subtitle()),
              const SizedBox(height: 40),
              _reveal(
                3,
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _PrimaryCta(
                      label: 'Mulai Perjalanan',
                      onTap: widget.onPrimary,
                    ),
                    const SizedBox(width: 16),
                    _GhostCta(
                      label: 'Lihat Fitur',
                      onTap: widget.onSecondary,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 72),
              _reveal(
                5,
                Transform.translate(
                  offset: Offset(0, -parallaxOffset),
                  child: const _Emblem(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _reveal(int step, Widget child) {
    return FadeTransition(
      opacity: _fadeAt(step),
      child: AnimatedBuilder(
        animation: _fadeAt(step),
        builder: (_, c) => Transform.translate(
          offset: Offset(0, (1 - _fadeAt(step).value) * 24),
          child: c,
        ),
        child: child,
      ),
    );
  }
}

class _Eyebrow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: const BoxDecoration(
            color: Color(0xFFC1923C),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 10),
        const Text(
          'MUSLIM PERSONAL GROWTH',
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFFC1923C),
            letterSpacing: 0.08 * 13,
          ),
        ),
      ],
    );
  }
}

class _Headline extends StatelessWidget {
  const _Headline();

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        style: const TextStyle(
          fontFamily: 'Space Grotesk',
          fontSize: 72,
          height: 1.05,
          fontWeight: FontWeight.w700,
          color: Color(0xFF3B2E22),
          letterSpacing: -0.02 * 72,
        ),
        children: [
          const TextSpan(text: 'Setiap hari adalah\n'),
          WidgetSpan(
            alignment: PlaceholderAlignment.baseline,
            baseline: TextBaseline.alphabetic,
            child: ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Color(0xFFC1923C), Color(0xFF8A5A3A)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ).createShader(bounds),
              child: const Text(
                'satu langkah kecil',
                style: TextStyle(
                  fontFamily: 'Space Grotesk',
                  fontSize: 72,
                  height: 1.05,
                  fontWeight: FontWeight.w700,
                  color: Colors.white, // masked
                  letterSpacing: -0.02 * 72,
                ),
              ),
            ),
          ),
          const TextSpan(text: '.'),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}

class _Subtitle extends StatelessWidget {
  const _Subtitle();

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 640),
      child: const Text(
        'Muhasabah harian, Al-Quran, Dzikir, Sedekah, dan analitik ibadah. '
        'Semua di satu tempat, tetap privat di HP-mu.',
        style: TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          fontSize: 18,
          height: 1.55,
          fontWeight: FontWeight.w400,
          color: Color(0xFF897866),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _PrimaryCta extends StatefulWidget {
  const _PrimaryCta({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  State<_PrimaryCta> createState() => _PrimaryCtaState();
}

class _PrimaryCtaState extends State<_PrimaryCta> {
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
          transform: Matrix4.identity()
            ..translate(0.0, _hover ? -2.0 : 0.0)
            ..scale(_hover ? 1.02 : 1.0),
          transformAlignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
          decoration: BoxDecoration(
            color:
                _hover ? const Color(0xFF6E4730) : const Color(0xFF8A5A3A),
            borderRadius: BorderRadius.circular(999),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF8A5A3A)
                    .withValues(alpha: _hover ? 0.32 : 0.16),
                blurRadius: _hover ? 32 : 16,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.label,
                style: const TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFFCF7EE),
                ),
              ),
              const SizedBox(width: 8),
              AnimatedSlide(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOut,
                offset: _hover ? const Offset(0.25, 0) : Offset.zero,
                child: const Icon(
                  Icons.arrow_forward_rounded,
                  size: 18,
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

class _GhostCta extends StatefulWidget {
  const _GhostCta({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  State<_GhostCta> createState() => _GhostCtaState();
}

class _GhostCtaState extends State<_GhostCta> {
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
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 18),
          decoration: BoxDecoration(
            color: _hover
                ? const Color(0xFFC1923C).withValues(alpha: 0.10)
                : Colors.transparent,
            border: Border.all(
              color: const Color(0xFF8A5A3A),
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            widget.label,
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF8A5A3A),
            ),
          ),
        ),
      ),
    );
  }
}

class _Emblem extends StatelessWidget {
  const _Emblem();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 360,
      height: 360,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Glow radial subtle behind emblem
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFFC1923C).withValues(alpha: 0.14),
                  const Color(0xFFC1923C).withValues(alpha: 0.0),
                ],
                stops: const [0.0, 0.7],
              ),
            ),
          ),
          Image.asset(
            'assets/icon/nasuha_icon_fg.png',
            width: 240,
            height: 240,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}
