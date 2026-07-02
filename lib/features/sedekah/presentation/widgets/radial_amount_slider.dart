import 'dart:math' as math;

import 'package:flutter/material.dart';

/// A large circular dial. Drag around the 270° arc to set an amount between
/// 0 and [max] (snapped to [step]). The [child] is shown centered on top.
class RadialAmountSlider extends StatelessWidget {
  const RadialAmountSlider({
    super.key,
    required this.value,
    required this.max,
    required this.step,
    required this.onChanged,
    required this.child,
    this.size = 250,
    this.color = const Color(0xFFA77B43),
  });

  final double value;
  final double max;
  final double step;
  final ValueChanged<double> onChanged;
  final Widget child;
  final double size;
  final Color color;

  static const _startDeg = 135.0;
  static const _sweepDeg = 270.0;

  void _handle(Offset local) {
    final c = Offset(size / 2, size / 2);
    final v = local - c;
    if (v.distance < size * 0.18) return; // ignore taps near the center
    var deg = math.atan2(v.dy, v.dx) * 180 / math.pi;
    deg = (deg + 360) % 360;
    final delta = (deg - _startDeg + 360) % 360;
    double frac;
    if (delta <= _sweepDeg) {
      frac = delta / _sweepDeg;
    } else {
      // Bottom dead-zone: snap to the nearer end.
      frac = delta <= 315 ? 1.0 : 0.0;
    }
    var newVal = (frac * max / step).round() * step;
    newVal = newVal.clamp(0.0, max);
    if (newVal != value) onChanged(newVal);
  }

  @override
  Widget build(BuildContext context) {
    final frac = max <= 0 ? 0.0 : (value / max).clamp(0.0, 1.0);
    return GestureDetector(
      onPanDown: (d) => _handle(d.localPosition),
      onPanUpdate: (d) => _handle(d.localPosition),
      child: CustomPaint(
        size: Size(size, size),
        painter: _DialPainter(
          frac: frac,
          color: color,
          trackColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        ),
        child: SizedBox(
          width: size,
          height: size,
          child: Center(child: child),
        ),
      ),
    );
  }
}

class _DialPainter extends CustomPainter {
  _DialPainter({
    required this.frac,
    required this.color,
    required this.trackColor,
  });

  final double frac;
  final Color color;
  final Color trackColor;

  static const _start = 135.0 * math.pi / 180;
  static const _sweep = 270.0 * math.pi / 180;
  static const _stroke = 20.0;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - _stroke / 2 - 6;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final track = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = _stroke
      ..strokeCap = StrokeCap.round
      ..color = trackColor.withValues(alpha: 0.6);
    canvas.drawArc(rect, _start, _sweep, false, track);

    if (frac > 0) {
      final prog = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = _stroke
        ..strokeCap = StrokeCap.round
        ..shader = SweepGradient(
          startAngle: _start,
          endAngle: _start + _sweep,
          colors: [color.withValues(alpha: 0.6), color],
          transform: GradientRotation(_start),
        ).createShader(rect);
      canvas.drawArc(rect, _start, _sweep * frac, false, prog);
    }

    // Handle knob at the current position.
    final ang = _start + _sweep * frac;
    final knob = Offset(
      center.dx + radius * math.cos(ang),
      center.dy + radius * math.sin(ang),
    );
    canvas.drawCircle(knob, _stroke / 2 + 4, Paint()..color = Colors.white);
    canvas.drawCircle(knob, _stroke / 2, Paint()..color = color);
    canvas.drawCircle(
      knob,
      _stroke / 2 - 5,
      Paint()..color = Colors.white.withValues(alpha: 0.9),
    );
  }

  @override
  bool shouldRepaint(covariant _DialPainter old) =>
      old.frac != frac || old.color != color || old.trackColor != trackColor;
}
