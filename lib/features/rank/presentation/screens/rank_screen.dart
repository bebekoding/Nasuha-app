import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../config/theme/app_fonts.dart';
import 'package:intl/intl.dart';

import '../../data/rank_tiers.dart';
import '../providers/rank_provider.dart';

final _xpFmt = NumberFormat.decimalPattern('id_ID');

class RankScreen extends ConsumerWidget {
  const RankScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressAsync = ref.watch(rankProgressProvider);
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perjalanan'),
        backgroundColor: Colors.transparent,
      ),
      body: progressAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Gagal memuat rank')),
        data: (progress) {
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
            children: [
              _CurrentRankHeader(progress: progress),
              const SizedBox(height: 24),
              Text(
                'Semua tingkatan',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Text(
                'Kumpulkan XP dari amal sepanjang waktu untuk naik tingkat. '
                'Tingkat bisa turun jika dosa menumpuk — itulah muhasabah.',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: scheme.onSurfaceVariant, height: 1.35),
              ),
              const SizedBox(height: 12),
              for (final tier in kRankTiers)
                _TierRow(
                  tier: tier,
                  xp: progress.xp,
                  isCurrent: tier.level == progress.tier.level,
                ),
            ],
          );
        },
      ),
    );
  }
}

class _CurrentRankHeader extends StatelessWidget {
  const _CurrentRankHeader({required this.progress});

  final RankProgress progress;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tier = progress.tier;
    final color = tier.color;

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: 0.18),
            color.withValues(alpha: 0.06),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withValues(alpha: 0.55), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.22),
            blurRadius: 24,
            spreadRadius: -8,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              _Medallion(icon: tier.icon, color: color, size: 64),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Level ${tier.level}',
                        style: spaceGrotesk(
                            color: color,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                            letterSpacing: 0.3)),
                    Text(tier.title,
                        style: spaceGrotesk(
                            color: scheme.onSurface,
                            fontWeight: FontWeight.w700,
                            fontSize: 28,
                            height: 1.05,
                            letterSpacing: -0.5)),
                    const SizedBox(height: 2),
                    Text(tier.meaning,
                        style: TextStyle(
                            color: scheme.onSurfaceVariant,
                            fontSize: 12.5,
                            height: 1.25)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          _ProgressBar(fraction: progress.fraction, color: color),
          const SizedBox(height: 8),
          Row(
            children: [
              Text('${_xpFmt.format(progress.xp)} XP',
                  style: spaceGrotesk(
                      color: scheme.onSurface,
                      fontWeight: FontWeight.w700,
                      fontSize: 13)),
              const Spacer(),
              if (progress.isMax)
                Text('Tingkat tertinggi 🏆',
                    style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.w700,
                        fontSize: 12.5))
              else
                Text(
                    '${_xpFmt.format(progress.xpRemaining)} XP lagi → ${progress.next!.title}',
                    style: TextStyle(
                        color: scheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                        fontSize: 12.5)),
            ],
          ),
        ],
      ),
    );
  }
}

class _TierRow extends StatelessWidget {
  const _TierRow({
    required this.tier,
    required this.xp,
    required this.isCurrent,
  });

  final RankTier tier;
  final int xp;
  final bool isCurrent;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final achieved = xp >= tier.minXp;
    final color = tier.color;

    final mutedColor = scheme.onSurfaceVariant.withValues(alpha: 0.55);

    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isCurrent
            ? color.withValues(alpha: 0.12)
            : scheme.surfaceContainerHighest.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCurrent
              ? color.withValues(alpha: 0.65)
              : scheme.outlineVariant.withValues(alpha: 0.5),
          width: isCurrent ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          _Medallion(
            icon: tier.icon,
            color: achieved ? color : mutedColor,
            size: 44,
            faded: !achieved,
            badge: tier.level,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(tier.title,
                        style: spaceGrotesk(
                            color: achieved ? scheme.onSurface : mutedColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 16)),
                    if (isCurrent) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text('Sekarang',
                            style: TextStyle(
                                color: color,
                                fontSize: 10,
                                fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ],
                ),
                Text(tier.meaning,
                    style: TextStyle(
                        color: achieved
                            ? scheme.onSurfaceVariant
                            : mutedColor,
                        fontSize: 12,
                        height: 1.2)),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Icon(
                achieved ? Icons.verified : Icons.lock_outline,
                size: 16,
                color: achieved ? color : mutedColor,
              ),
              const SizedBox(height: 3),
              Text('${_xpFmt.format(tier.minXp)} XP',
                  style: spaceGrotesk(
                      color: achieved ? scheme.onSurfaceVariant : mutedColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }
}

/// A shield/medallion stamped with the level's icon. When [badge] is set, the
/// level number is shown as a small tag at the corner so the numbering stays
/// visible alongside the icon.
class _Medallion extends StatelessWidget {
  const _Medallion({
    required this.icon,
    required this.color,
    required this.size,
    this.faded = false,
    this.badge,
  });

  final IconData icon;
  final Color color;
  final double size;
  final bool faded;
  final int? badge;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withValues(alpha: faded ? 0.20 : 0.95),
                color.withValues(alpha: faded ? 0.12 : 0.65),
              ],
            ),
            borderRadius: BorderRadius.circular(size * 0.32),
            border: Border.all(
                color: color.withValues(alpha: faded ? 0.35 : 0.9),
                width: 1.5),
            boxShadow: faded
                ? null
                : [
                    BoxShadow(
                      color: color.withValues(alpha: 0.35),
                      blurRadius: 10,
                      spreadRadius: -3,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: Center(
            child: Icon(icon,
                color: faded ? color.withValues(alpha: 0.8) : Colors.white,
                size: size * 0.5),
          ),
        ),
        if (badge != null)
          Positioned(
            right: -5,
            bottom: -5,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              decoration: BoxDecoration(
                color: scheme.surface,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                    color: color.withValues(alpha: faded ? 0.5 : 0.9),
                    width: 1.2),
              ),
              child: Text('$badge',
                  style: spaceGrotesk(
                      color: faded ? scheme.onSurfaceVariant : color,
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                      height: 1.1)),
            ),
          ),
      ],
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.fraction, required this.color});

  final double fraction;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: Stack(
        children: [
          Container(
            height: 10,
            color: scheme.surfaceContainerHighest,
          ),
          FractionallySizedBox(
            widthFactor: fraction.clamp(0.0, 1.0),
            child: Container(
              height: 10,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  color.withValues(alpha: 0.75),
                  color,
                ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
