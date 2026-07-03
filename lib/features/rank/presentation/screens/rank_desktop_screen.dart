import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/widgets/desktop_page_shell.dart';
import '../../data/rank_tiers.dart';
import '../providers/rank_provider.dart';

final _xpFmt = NumberFormat.decimalPattern('id_ID');

/// Rank desktop (width >= 800). 2-col:
/// - Kiri sticky (~440px): current tier medallion hero + XP progress + next-tier hint
/// - Kanan (Expanded): tier ladder scroll — semua tier dengan status
///   achieved/current/locked, medallion + level + title + arti + XP threshold
class RankDesktopScreen extends ConsumerWidget {
  const RankDesktopScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressAsync = ref.watch(rankProgressProvider);

    return DesktopPageShell(
      currentRoute: '/rank',
      eyebrow: 'RANK',
      child: progressAsync.when(
        loading: () => const Padding(
          padding: EdgeInsets.symmetric(vertical: 100),
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (_, __) => const Padding(
          padding: EdgeInsets.symmetric(vertical: 100),
          child: Center(child: Text('Gagal memuat rank')),
        ),
        data: (progress) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Header(progress: progress),
            const SizedBox(height: 28),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 440,
                    child: _CurrentTierHero(progress: progress),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: _TierLadder(progress: progress),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// HEADER
// ═══════════════════════════════════════════════════════════════════════════

class _Header extends StatelessWidget {
  const _Header({required this.progress});
  final RankProgress progress;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text(
          'Perjalanan spiritualmu',
          style: TextStyle(
            fontFamily: 'Space Grotesk',
            fontSize: 42,
            fontWeight: FontWeight.w800,
            height: 1.05,
            color: scheme.onSurface,
            letterSpacing: -0.9,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Kumpulkan XP dari amal untuk naik tingkat. Level bisa turun kalau khilaf menumpuk — itulah hakikat muhasabah.',
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 16,
            height: 1.5,
            fontWeight: FontWeight.w500,
            color: scheme.onSurface.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// CURRENT TIER HERO — kiri
// ═══════════════════════════════════════════════════════════════════════════

class _CurrentTierHero extends StatelessWidget {
  const _CurrentTierHero({required this.progress});
  final RankProgress progress;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tier = progress.tier;
    final color = tier.color;
    final progressPct = progress.xpForNextTier == 0
        ? 1.0
        : (progress.xpIntoTier / progress.xpForNextTier).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: scheme.surface,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            scheme.surface,
            color.withValues(alpha: 0.10),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withValues(alpha: 0.32), width: 1.4),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.14),
            blurRadius: 26,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PERINGKAT SAAT INI',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 2.0,
              color: color,
            ),
          ),
          const SizedBox(height: 20),
          // Medallion + level number badge
          Center(
            child: _MedallionHero(tier: tier, color: color),
          ),
          const SizedBox(height: 24),
          Center(
            child: Text(
              tier.title,
              style: TextStyle(
                fontFamily: 'Space Grotesk',
                fontSize: 34,
                fontWeight: FontWeight.w800,
                height: 1.0,
                color: scheme.onSurface,
                letterSpacing: -0.8,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              'Level ${tier.level}',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              tier.meaning,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 13,
                height: 1.55,
                color: scheme.onSurface.withValues(alpha: 0.75),
              ),
            ),
          ),
          const SizedBox(height: 28),
          // Progress
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total XP',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.4,
                  color: scheme.onSurface.withValues(alpha: 0.72),
                ),
              ),
              Text(
                _xpFmt.format(progress.xp),
                style: TextStyle(
                  fontFamily: 'Space Grotesk',
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: scheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progressPct,
              minHeight: 10,
              backgroundColor: scheme.onSurface.withValues(alpha: 0.08),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          const SizedBox(height: 10),
          if (progress.next != null)
            Text(
              '${_xpFmt.format(progress.xpForNextTier - progress.xpIntoTier)} XP lagi → ${progress.next!.title}',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: scheme.onSurface.withValues(alpha: 0.75),
              ),
            )
          else
            Text(
              'Puncak ladder — pertahankan.',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
        ],
      ),
    );
  }
}

class _MedallionHero extends StatefulWidget {
  const _MedallionHero({required this.tier, required this.color});
  final RankTier tier;
  final Color color;

  @override
  State<_MedallionHero> createState() => _MedallionHeroState();
}

class _MedallionHeroState extends State<_MedallionHero>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
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
    return SizedBox(
      width: 168,
      height: 168,
      child: AnimatedBuilder(
        animation: _pulse,
        builder: (_, __) {
          final t = _pulse.value;
          return Stack(
            alignment: Alignment.center,
            children: [
              // Halo bloom
              Container(
                width: 168,
                height: 168,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.color.withValues(alpha: 0.06 + t * 0.06),
                ),
              ),
              Container(
                width: 138,
                height: 138,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.color.withValues(alpha: 0.14 + t * 0.06),
                ),
              ),
              // Medallion
              Container(
                width: 108,
                height: 108,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      widget.color.withValues(alpha: 0.9),
                      widget.color,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: widget.color.withValues(alpha: 0.4),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Icon(widget.tier.icon,
                    color: Colors.white, size: 52),
              ),
              // Level badge di kanan-bawah
              Positioned(
                right: 8,
                bottom: 8,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: scheme.surface,
                    border: Border.all(color: widget.color, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: scheme.onSurface.withValues(alpha: 0.14),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${widget.tier.level}',
                    style: TextStyle(
                      fontFamily: 'Space Grotesk',
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: widget.color,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// TIER LADDER — kanan
// ═══════════════════════════════════════════════════════════════════════════

class _TierLadder extends StatelessWidget {
  const _TierLadder({required this.progress});
  final RankProgress progress;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
            color: scheme.outline.withValues(alpha: 0.16), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Semua tingkatan',
            style: TextStyle(
              fontFamily: 'Space Grotesk',
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: scheme.onSurface,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${kRankTiers.length} tier dari negatif ke puncak. Hover untuk lihat threshold XP.',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 13,
              color: scheme.onSurface.withValues(alpha: 0.72),
            ),
          ),
          const SizedBox(height: 16),
          for (int i = 0; i < kRankTiers.length; i++) ...[
            _TierRow(
              tier: kRankTiers[i],
              currentLevel: progress.tier.level,
              xp: progress.xp,
            ),
            if (i < kRankTiers.length - 1) const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}

class _TierRow extends StatefulWidget {
  const _TierRow(
      {required this.tier, required this.currentLevel, required this.xp});
  final RankTier tier;
  final int currentLevel;
  final int xp;

  @override
  State<_TierRow> createState() => _TierRowState();
}

class _TierRowState extends State<_TierRow> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isCurrent = widget.tier.level == widget.currentLevel;
    final isAchieved =
        !isCurrent && widget.xp >= widget.tier.minXp;
    final isLocked = !isCurrent && !isAchieved;
    final color = widget.tier.color;

    final borderColor = isCurrent
        ? color
        : (isAchieved
            ? color.withValues(alpha: 0.32)
            : scheme.outline.withValues(alpha: 0.16));
    final bgFill = isCurrent
        ? color.withValues(alpha: 0.08)
        : (_hover
            ? color.withValues(alpha: 0.04)
            : scheme.onSurface.withValues(alpha: 0.02));

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: bgFill,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: borderColor, width: isCurrent ? 1.6 : 1.0),
        ),
        child: Row(
          children: [
            _TierMedallion(
                tier: widget.tier,
                color: color,
                achieved: isCurrent || isAchieved),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        widget.tier.title,
                        style: TextStyle(
                          fontFamily: 'Space Grotesk',
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: isLocked
                              ? scheme.onSurface.withValues(alpha: 0.5)
                              : scheme.onSurface,
                        ),
                      ),
                      const SizedBox(width: 10),
                      if (isCurrent)
                        _StatusPill(
                            label: 'SAAT INI',
                            color: color,
                            filled: true),
                      if (isAchieved)
                        _StatusPill(label: 'DILEWATI', color: color),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    widget.tier.meaning,
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 12,
                      color: scheme.onSurface.withValues(alpha: 0.72),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Level ${widget.tier.level}',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                    color: scheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${_xpFmt.format(widget.tier.minXp)} XP',
                  style: TextStyle(
                    fontFamily: 'Space Grotesk',
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: isLocked
                        ? scheme.onSurface.withValues(alpha: 0.5)
                        : color,
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

class _TierMedallion extends StatelessWidget {
  const _TierMedallion({
    required this.tier,
    required this.color,
    required this.achieved,
  });
  final RankTier tier;
  final Color color;
  final bool achieved;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: achieved ? color : color.withValues(alpha: 0.14),
        border: Border.all(
          color: achieved
              ? color
              : scheme.outline.withValues(alpha: 0.24),
          width: 1.4,
        ),
      ),
      child: Icon(
        tier.icon,
        color: achieved ? Colors.white : color.withValues(alpha: 0.5),
        size: 20,
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill(
      {required this.label, required this.color, this.filled = false});
  final String label;
  final Color color;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: filled ? color : color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          fontSize: 9,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.2,
          color: filled ? Colors.white : color,
        ),
      ),
    );
  }
}
