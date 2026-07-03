import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../core/widgets/desktop_page_shell.dart';
import '../../data/dzikir_data.dart';

/// Dzikir desktop (width >= 800). Bento 3-col categories. Click → route
/// /dzikir/:idx tetap DzikirDetailScreen existing (mobile counter flow OK
/// karena reading + counter portrait-natural).
class DzikirDesktopScreen extends StatelessWidget {
  const DzikirDesktopScreen({super.key});

  static const _accents = [
    AppColors.caramel,
    AppColors.coffee,
    AppColors.clay,
    AppColors.ochre,
    AppColors.terracotta,
  ];

  @override
  Widget build(BuildContext context) {
    return DesktopPageShell(
      currentRoute: '/dzikir',
      eyebrow: 'DZIKIR',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Header(),
          const SizedBox(height: 32),
          _CategoryGrid(accents: _accents),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text(
          'Dzikir harian',
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
          'Pagi dan petang jadi jangkar hari. Sedikit yang rutin lebih baik dari banyak yang jarang.',
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

class _CategoryGrid extends StatelessWidget {
  const _CategoryGrid({required this.accents});
  final List<Color> accents;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      const gap = 20.0;
      const cols = 3;
      final w = (constraints.maxWidth - gap * (cols - 1)) / cols;
      final rows = (kDzikirCategories.length / cols).ceil();
      return Column(
        children: [
          for (int r = 0; r < rows; r++) ...[
            if (r > 0) const SizedBox(height: gap),
            Row(
              children: [
                for (int c = 0; c < cols; c++) ...[
                  if (c > 0) const SizedBox(width: gap),
                  if (r * cols + c < kDzikirCategories.length)
                    SizedBox(
                      width: w,
                      child: _CategoryCard(
                        category: kDzikirCategories[r * cols + c],
                        index: r * cols + c,
                        accent: accents[(r * cols + c) % accents.length],
                      ),
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

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.category,
    required this.index,
    required this.accent,
  });
  final DzikirCategory category;
  final int index;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return HoverLiftCard(
      onTap: () => context.push('/dzikir/$index'),
      accent: accent,
      borderRadius: 22,
      padding: const EdgeInsets.all(24),
      height: 240,
      lift: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(category.icon, color: accent, size: 26),
          ),
          const Spacer(),
          Text(
            category.title,
            style: TextStyle(
              fontFamily: 'Space Grotesk',
              fontSize: 24,
              fontWeight: FontWeight.w800,
              height: 1.1,
              color: scheme.onSurface,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            category.subtitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 13,
              height: 1.5,
              color: scheme.onSurface.withValues(alpha: 0.75),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Text(
                '${category.items.length} bacaan',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  color: accent,
                ),
              ),
              const Spacer(),
              Icon(Icons.arrow_forward, size: 18, color: accent),
            ],
          ),
        ],
      ),
    );
  }
}
