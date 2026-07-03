import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../core/widgets/desktop_page_shell.dart';
import '../../data/sholat_sunnah_data.dart';

/// Sholat Sunnah desktop (width >= 800). Bento 2-col cards untuk daftar
/// sunnah (Dhuha, Tahajud, Rawatib, Witir, dsb). Click → route detail
/// existing (portrait-friendly reading pattern).
class SholatSunnahDesktopScreen extends StatelessWidget {
  const SholatSunnahDesktopScreen({super.key});

  static const _accents = [
    AppColors.ochre,
    AppColors.coffee,
    AppColors.caramel,
    AppColors.clay,
    AppColors.terracotta,
  ];

  @override
  Widget build(BuildContext context) {
    return DesktopPageShell(
      currentRoute: '/sholat-sunnah',
      eyebrow: 'SHOLAT SUNNAH',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Header(),
          const SizedBox(height: 32),
          _SunnahGrid(accents: _accents),
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
          'Sholat sunnah',
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
          'Tambahan yang menutup kekurangan fardhu. Tata cara, niat, dan keutamaan singkat.',
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

class _SunnahGrid extends StatelessWidget {
  const _SunnahGrid({required this.accents});
  final List<Color> accents;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      const gap = 20.0;
      const cols = 2;
      final w = (constraints.maxWidth - gap * (cols - 1)) / cols;
      final rows = (kSholatSunnah.length / cols).ceil();
      return Column(
        children: [
          for (int r = 0; r < rows; r++) ...[
            if (r > 0) const SizedBox(height: gap),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (int c = 0; c < cols; c++) ...[
                  if (c > 0) const SizedBox(width: gap),
                  if (r * cols + c < kSholatSunnah.length)
                    SizedBox(
                      width: w,
                      child: _SunnahCard(
                        item: kSholatSunnah[r * cols + c],
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

class _SunnahCard extends StatelessWidget {
  const _SunnahCard({
    required this.item,
    required this.index,
    required this.accent,
  });
  final SholatSunnah item;
  final int index;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return HoverLiftCard(
      onTap: () => context.push('/sholat-sunnah/$index'),
      accent: accent,
      borderRadius: 22,
      padding: const EdgeInsets.all(24),
      lift: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(item.icon, color: accent, size: 26),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: TextStyle(
                        fontFamily: 'Space Grotesk',
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        height: 1.1,
                        color: scheme.onSurface,
                        letterSpacing: -0.4,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        _Pill(text: item.rakaat, color: accent),
                        const SizedBox(width: 6),
                        _Pill(
                            text: item.hukum,
                            color: accent,
                            outline: true),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            item.waktu,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 13,
              height: 1.5,
              color: scheme.onSurface.withValues(alpha: 0.75),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.menu_book, size: 15, color: accent),
              const SizedBox(width: 6),
              Text(
                'Baca tata cara & niat',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.4,
                  color: accent,
                ),
              ),
              const Spacer(),
              Icon(Icons.arrow_forward, size: 16, color: accent),
            ],
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.text, required this.color, this.outline = false});
  final String text;
  final Color color;
  final bool outline;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: outline ? Colors.transparent : color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
        border:
            outline ? Border.all(color: color.withValues(alpha: 0.32)) : null,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.6,
          color: color,
        ),
      ),
    );
  }
}
