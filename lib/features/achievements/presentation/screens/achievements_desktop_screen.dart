import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../core/widgets/desktop_page_shell.dart';
import '../../../../models/achievement.dart';
import '../../data/achievement_repository.dart';

/// Pencapaian desktop (width >= 800). Bento 3-col badges dengan gold
/// unlocked / warm-neutral locked, progress bar accent, hover subtle lift.
class AchievementsDesktopScreen extends ConsumerWidget {
  const AchievementsDesktopScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncAch = ref.watch(achievementsProvider);

    return DesktopPageShell(
      currentRoute: '/achievements',
      eyebrow: 'PENCAPAIAN',
      child: asyncAch.when(
        loading: () => const Padding(
          padding: EdgeInsets.symmetric(vertical: 100),
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (e, _) => Text('Error: $e'),
        data: (list) {
          final unlocked = list.where((a) => a.isUnlocked).length;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Header(unlocked: unlocked, total: list.length),
              const SizedBox(height: 32),
              _BadgesGrid(list: list),
            ],
          );
        },
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.unlocked, required this.total});
  final int unlocked;
  final int total;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(
                'Pencapaianmu',
                style: TextStyle(
                  fontFamily: 'Space Grotesk',
                  fontSize: 44,
                  fontWeight: FontWeight.w800,
                  height: 1.05,
                  color: scheme.onSurface,
                  letterSpacing: -0.9,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Kumpulan lencana yang menandai konsistensi kamu. Cepat lambat bukan soal — konsisten yang penting.',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 16,
                  height: 1.5,
                  fontWeight: FontWeight.w500,
                  color: scheme.onSurface.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 24),
        _UnlockedPill(unlocked: unlocked, total: total),
      ],
    );
  }
}

class _UnlockedPill extends StatelessWidget {
  const _UnlockedPill({required this.unlocked, required this.total});
  final int unlocked;
  final int total;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.goldLight.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: AppColors.goldLight.withValues(alpha: 0.4), width: 1.4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.emoji_events,
              color: AppColors.goldLight, size: 22),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'DILUNCURKAN',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.6,
                  color: AppColors.goldLight,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '$unlocked',
                    style: TextStyle(
                      fontFamily: 'Space Grotesk',
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      height: 1.0,
                      color: scheme.onSurface,
                    ),
                  ),
                  Text(
                    ' / $total',
                    style: TextStyle(
                      fontFamily: 'Space Grotesk',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: scheme.onSurface.withValues(alpha: 0.6),
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

class _BadgesGrid extends StatelessWidget {
  const _BadgesGrid({required this.list});
  final List<Achievement> list;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      const gap = 16.0;
      const cols = 3;
      final w = (constraints.maxWidth - gap * (cols - 1)) / cols;
      final rows = (list.length / cols).ceil();
      return Column(
        children: [
          for (int r = 0; r < rows; r++) ...[
            if (r > 0) const SizedBox(height: gap),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (int c = 0; c < cols; c++) ...[
                  if (c > 0) const SizedBox(width: gap),
                  if (r * cols + c < list.length)
                    SizedBox(
                      width: w,
                      child: _BadgeCard(achievement: list[r * cols + c]),
                    )
                  else
                    SizedBox(width: w),
                ],
              ],
            ),
          ],
        ],
      );
    });
  }
}

class _BadgeCard extends StatefulWidget {
  const _BadgeCard({required this.achievement});
  final Achievement achievement;

  @override
  State<_BadgeCard> createState() => _BadgeCardState();
}

class _BadgeCardState extends State<_BadgeCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    final a = widget.achievement;
    final unlocked = a.isUnlocked;
    final progress = a.targetValue == 0
        ? 0.0
        : (a.currentValue / a.targetValue).clamp(0.0, 1.0);
    final color =
        unlocked ? AppColors.goldLight : scheme.onSurface.withValues(alpha: 0.4);

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        transform: (_hover && !reduceMotion)
            ? (Matrix4.identity()..translateByDouble(0.0, -3.0, 0.0, 1.0))
            : Matrix4.identity(),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: unlocked
                  ? AppColors.goldLight.withValues(alpha: _hover ? 0.5 : 0.32)
                  : scheme.outline.withValues(alpha: _hover ? 0.3 : 0.16),
              width: 1.2),
          boxShadow: _hover
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ]
              : [
                  BoxShadow(
                    color: scheme.onSurface.withValues(alpha: 0.04),
                    blurRadius: 12,
                    offset: const Offset(0, 5),
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color.withValues(alpha: 0.14),
                  ),
                  child: Icon(
                    unlocked ? Icons.emoji_events : Icons.lock_outline,
                    color: color,
                    size: 24,
                  ),
                ),
                const Spacer(),
                if (unlocked)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.goldLight,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Text(
                      'DILUNCURKAN',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              a.title,
              style: TextStyle(
                fontFamily: 'Space Grotesk',
                fontSize: 17,
                fontWeight: FontWeight.w800,
                height: 1.15,
                color: unlocked
                    ? scheme.onSurface
                    : scheme.onSurface.withValues(alpha: 0.75),
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              a.description,
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 13,
                height: 1.45,
                color: scheme.onSurface.withValues(alpha: 0.75),
              ),
            ),
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 6,
                backgroundColor: scheme.onSurface.withValues(alpha: 0.08),
                valueColor: AlwaysStoppedAnimation<Color>(
                  unlocked
                      ? AppColors.goldLight
                      : scheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '${a.currentValue} / ${a.targetValue}',
              style: TextStyle(
                fontFamily: 'Space Grotesk',
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: scheme.onSurface.withValues(alpha: 0.72),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
