import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../../../../config/theme/app_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../models/daily_score.dart';
import '../../../rank/data/rank_tiers.dart';

/// Home / Muhasabah "status HUD" — a dark power-panel: a streak ring (progress
/// to the next 7-day milestone), the day's score (count-up, coloured by state),
/// and a pulsing streak flame. [large] enlarges it for the Muhasabah screen;
/// [hidePoints] masks the amal/dosa numbers (focus on the deed, not the score).
class ScoreCard extends StatefulWidget {
  const ScoreCard({
    super.key,
    required this.score,
    required this.streak,
    this.large = false,
    this.hidePoints = false,
    this.rank,
    this.onRankTap,
  });

  final DailyScore? score;
  final int streak;
  final bool large;
  final bool hidePoints;

  /// When provided, a lifetime-rank strip is shown at the top of the card.
  final RankProgress? rank;
  final VoidCallback? onRankTap;

  @override
  State<ScoreCard> createState() => _ScoreCardState();
}

class _ScoreCardState extends State<ScoreCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final hide = widget.hidePoints;
    final large = widget.large;
    final total = widget.score?.total ?? 0;
    final pos = widget.score?.positiveCount ?? 0;
    final neg = widget.score?.negativeCount ?? 0;

    final toneColor = hide
        ? scheme.onSurface
        : (total > 0
            ? scheme.primary
            : (total == 0 ? scheme.onSurfaceVariant : scheme.error));
    final caption = hide
        ? 'Fokus beramal hari ini'
        : (total > 30
            ? 'Hari yang kuat'
            : (total >= 0 ? 'Terus istiqomah' : 'Waktunya bangkit'));

    final inBand = widget.streak % 7;
    final ringFrac = widget.streak > 0 && inBand == 0 ? 1.0 : inBand / 7.0;
    final nextMilestone = ((widget.streak ~/ 7) + 1) * 7;

    final numberStyle = spaceGrotesk(
      color: toneColor,
      fontWeight: FontWeight.w700,
      fontSize: large ? 56 : 40,
      height: 1,
      letterSpacing: -1.5,
    );

    return Container(
      padding: EdgeInsets.all(large ? 24 : 20),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: scheme.outline, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: scheme.primary.withValues(alpha: 0.10),
            blurRadius: 28,
            spreadRadius: -8,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -24,
            top: -28,
            child: Container(
              width: large ? 150 : 120,
              height: large ? 150 : 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  scheme.primary.withValues(alpha: 0.16),
                  scheme.primary.withValues(alpha: 0.0),
                ]),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.rank != null) ...[
                _RankStrip(
                    progress: widget.rank!,
                    large: large,
                    onTap: widget.onRankTap),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: large ? 16 : 14),
                  child: Divider(
                      height: 1,
                      thickness: 1,
                      color: scheme.outlineVariant.withValues(alpha: 0.6)),
                ),
              ],
              Row(
                children: [
                  _StreakRing(
                    pulse: _pulse,
                frac: ringFrac,
                streak: widget.streak,
                gold: scheme.tertiary,
                track: scheme.surfaceContainerHighest,
                size: large ? 116 : 96,
              ),
              SizedBox(width: large ? 22 : 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(caption,
                        style: spaceGrotesk(
                            color: scheme.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                            fontSize: large ? 15 : 13,
                            letterSpacing: -0.2)),
                    SizedBox(height: large ? 4 : 2),
                    if (hide)
                      Text('• • •', style: numberStyle)
                    else
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: total.toDouble()),
                        duration: const Duration(milliseconds: 650),
                        curve: Curves.easeOutCubic,
                        builder: (_, v, __) =>
                            Text('${v.round()}', style: numberStyle),
                      ),
                    Text('XP hari ini',
                        style: TextStyle(
                            color: scheme.onSurfaceVariant,
                            fontSize: large ? 13 : 12)),
                    SizedBox(height: large ? 16 : 12),
                    if (!hide)
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          _Pill(
                              icon: Icons.trending_up,
                              label: '$pos baik',
                              color: scheme.primary),
                          _Pill(
                              icon: Icons.trending_down,
                              label: '$neg kurang',
                              color: scheme.error),
                          if (widget.streak > 0)
                            Text(
                              '→ $nextMilestone hari',
                              style: spaceGrotesk(
                                  color: scheme.tertiary.withValues(alpha: 0.95),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700),
                            ),
                        ],
                      )
                    else
                      Row(
                        children: [
                          Icon(Icons.lock_outline,
                              size: 14, color: scheme.onSurfaceVariant),
                          const SizedBox(width: 6),
                          Text('XP disembunyikan',
                              style: TextStyle(
                                  color: scheme.onSurfaceVariant,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                  ],
                ),
              ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RankStrip extends StatelessWidget {
  const _RankStrip({required this.progress, required this.large, this.onTap});

  final RankProgress progress;
  final bool large;
  final VoidCallback? onTap;

  static final _xpFmt = NumberFormat.decimalPattern('id_ID');

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tier = progress.tier;
    final color = tier.color;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _MiniMedallion(icon: tier.icon, color: color, large: large),
              SizedBox(width: large ? 12 : 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(tier.title,
                        style: spaceGrotesk(
                            color: scheme.onSurface,
                            fontWeight: FontWeight.w700,
                            fontSize: large ? 18 : 16,
                            height: 1,
                            letterSpacing: -0.3)),
                    const SizedBox(height: 1),
                    Text('Level ${tier.level} · ${_xpFmt.format(progress.xp)} XP',
                        style: TextStyle(
                            color: scheme.onSurfaceVariant,
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              if (onTap != null)
                Icon(Icons.chevron_right,
                    size: 20, color: scheme.onSurfaceVariant),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: Stack(
              children: [
                Container(
                    height: 7, color: scheme.surfaceContainerHighest),
                FractionallySizedBox(
                  widthFactor: progress.fraction.clamp(0.0, 1.0),
                  child: Container(
                    height: 7,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [color.withValues(alpha: 0.75), color]),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          Text(
            progress.isMax
                ? 'Tingkat tertinggi tercapai 🏆'
                : '${_xpFmt.format(progress.xpRemaining)} XP lagi → ${progress.next!.title}',
            style: TextStyle(
                color: scheme.onSurfaceVariant,
                fontSize: 11,
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _MiniMedallion extends StatelessWidget {
  const _MiniMedallion(
      {required this.icon, required this.color, required this.large});

  final IconData icon;
  final Color color;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final size = large ? 42.0 : 38.0;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: 0.95),
            color.withValues(alpha: 0.65),
          ],
        ),
        borderRadius: BorderRadius.circular(size * 0.32),
        border: Border.all(color: color.withValues(alpha: 0.9), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.35),
            blurRadius: 8,
            spreadRadius: -2,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(child: Icon(icon, color: Colors.white, size: size * 0.5)),
    );
  }
}

class _StreakRing extends StatelessWidget {
  const _StreakRing({
    required this.pulse,
    required this.frac,
    required this.streak,
    required this.gold,
    required this.track,
    required this.size,
  });

  final Animation<double> pulse;
  final double frac;
  final int streak;
  final Color gold;
  final Color track;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: AnimatedBuilder(
        animation: pulse,
        builder: (context, _) {
          return CustomPaint(
            painter: _RingPainter(
              frac: frac,
              gold: gold,
              track: track,
              glow: 0.4 + pulse.value * 0.6,
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Transform.scale(
                    scale: 1 + pulse.value * 0.12,
                    child: Icon(Icons.local_fire_department,
                        color: gold, size: size * 0.22),
                  ),
                  Text('$streak',
                      style: spaceGrotesk(
                          color: gold,
                          fontWeight: FontWeight.w700,
                          fontSize: size * 0.26,
                          height: 1)),
                  Text('hari',
                      style: TextStyle(
                          color: gold.withValues(alpha: 0.8),
                          fontSize: size * 0.11)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({
    required this.frac,
    required this.gold,
    required this.track,
    required this.glow,
  });

  final double frac;
  final Color gold;
  final Color track;
  final double glow;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 6;
    final rect = Rect.fromCircle(center: center, radius: radius);
    const start = -math.pi / 2;
    final stroke = size.width * 0.075;

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..color = track,
    );
    if (frac > 0) {
      canvas.drawArc(
        rect,
        start,
        2 * math.pi * frac,
        false,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = stroke
          ..strokeCap = StrokeCap.round
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 6 * glow)
          ..color = gold.withValues(alpha: 0.5),
      );
      canvas.drawArc(
        rect,
        start,
        2 * math.pi * frac,
        false,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = stroke
          ..strokeCap = StrokeCap.round
          ..color = gold,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _RingPainter old) =>
      old.frac != frac || old.glow != glow;
}

class _Pill extends StatelessWidget {
  const _Pill({required this.icon, required this.label, required this.color});

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 13),
          const SizedBox(width: 4),
          Text(label,
              style: TextStyle(
                  color: color, fontSize: 12, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
