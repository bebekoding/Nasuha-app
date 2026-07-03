import 'package:flutter/material.dart';

/// Widget yang men-*fade + slide-up* anak-anaknya saat ~25% area masuk viewport.
///
/// Pakai `ScrollController` shared dari `LandingScreen`. Cek posisi via
/// `RenderBox.localToGlobal` — cukup untuk halaman marketing single-scroll.
/// Menghormati `MediaQuery.disableAnimations` (proxy `prefers-reduced-motion`).
class RevealOnScroll extends StatefulWidget {
  const RevealOnScroll({
    super.key,
    required this.controller,
    required this.child,
    this.delay = Duration.zero,
    this.offsetY = 24,
    this.duration = const Duration(milliseconds: 480),
    this.thresholdFraction = 0.15, // 15% element visible → trigger
  });

  final ScrollController controller;
  final Widget child;
  final Duration delay;
  final double offsetY;
  final Duration duration;
  final double thresholdFraction;

  @override
  State<RevealOnScroll> createState() => _RevealOnScrollState();
}

class _RevealOnScrollState extends State<RevealOnScroll> {
  final _key = GlobalKey();
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_check);
    WidgetsBinding.instance.addPostFrameCallback((_) => _check());
  }

  @override
  void dispose() {
    widget.controller.removeListener(_check);
    super.dispose();
  }

  void _check() {
    if (_visible) return;
    final ctx = _key.currentContext;
    if (ctx == null) return;
    final box = ctx.findRenderObject();
    if (box is! RenderBox || !box.hasSize) return;
    final screenHeight = MediaQuery.of(context).size.height;
    final topLeft = box.localToGlobal(Offset.zero);
    final elementTop = topLeft.dy;
    final trigger =
        screenHeight - (box.size.height * widget.thresholdFraction);
    if (elementTop < trigger) {
      if (widget.delay == Duration.zero) {
        setState(() => _visible = true);
      } else {
        Future.delayed(widget.delay, () {
          if (mounted) setState(() => _visible = true);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final reduce = MediaQuery.of(context).disableAnimations;
    return AnimatedOpacity(
      key: _key,
      duration: reduce ? Duration.zero : widget.duration,
      curve: Curves.easeOutCubic,
      opacity: _visible ? 1 : 0,
      child: AnimatedSlide(
        duration: reduce ? Duration.zero : widget.duration,
        curve: const Cubic(0.16, 1, 0.3, 1),
        offset: _visible
            ? Offset.zero
            : Offset(0, widget.offsetY / 100), // fractional offset
        child: widget.child,
      ),
    );
  }
}
