import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../core/widgets/desktop_page_shell.dart';
import '../../data/repositories/quran_repository.dart';
import '../../domain/entities/surah.dart';

/// Layout Al-Quran khusus PWA desktop (width >= 800). Grid bento 4-col
/// untuk 114 surah + kartu "Lanjutkan bacaan" tebal di atas.
///
/// Hover per-surah: lift 4px + shadow bloom + accent stripe di kiri surah
/// number. Search bar reactif memfilter grid secara live.
class QuranDesktopScreen extends ConsumerStatefulWidget {
  const QuranDesktopScreen({super.key});

  @override
  ConsumerState<QuranDesktopScreen> createState() =>
      _QuranDesktopScreenState();
}

class _QuranDesktopScreenState extends ConsumerState<QuranDesktopScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final surahAsync = ref.watch(allSurahProvider);
    final lastReadAsync = ref.watch(lastReadProvider);

    return DesktopPageShell(
      currentRoute: '/quran',
      eyebrow: 'AL-QURAN',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _HeaderHero(lastReadAsync: lastReadAsync),
          const SizedBox(height: 40),
          _SearchBar(
            value: _query,
            onChanged: (v) => setState(() => _query = v),
          ),
          const SizedBox(height: 28),
          surahAsync.when(
            loading: () => const _GridSkeleton(),
            error: (e, _) => _ErrorTile(message: e.toString()),
            data: (list) {
              final filtered = _filter(list, _query);
              if (filtered.isEmpty) {
                return const _EmptyState();
              }
              return _SurahBentoGrid(surahs: filtered);
            },
          ),
        ],
      ),
    );
  }

  List<SurahSummary> _filter(List<SurahSummary> list, String q) {
    if (q.isEmpty) return list;
    final norm = q.trim().toLowerCase();
    return list.where((s) {
      return s.nameLatin.toLowerCase().contains(norm) ||
          s.nameTranslation.toLowerCase().contains(norm) ||
          s.number.toString() == norm;
    }).toList();
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// HEADER HERO — greeting + last read
// ═══════════════════════════════════════════════════════════════════════════

class _HeaderHero extends StatelessWidget {
  const _HeaderHero({required this.lastReadAsync});
  final AsyncValue<LastReadPosition?> lastReadAsync;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Text(
          '114 surah untukmu',
          style: TextStyle(
            fontFamily: 'Space Grotesk',
            fontSize: 48,
            fontWeight: FontWeight.w800,
            height: 1.05,
            color: scheme.onSurface,
            letterSpacing: -1.0,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Baca terus. Sedikit tiap hari lebih baik dari banyak sekali seumur hidup.',
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 17,
            height: 1.5,
            fontWeight: FontWeight.w500,
            color: scheme.onSurface.withValues(alpha: 0.8),
          ),
        ),
        const SizedBox(height: 32),
        lastReadAsync.when(
          loading: () => const _LastReadSkeleton(),
          error: (_, __) => const SizedBox.shrink(),
          data: (pos) {
            if (pos == null) return const SizedBox.shrink();
            return _LastReadCard(pos: pos);
          },
        ),
      ],
    );
  }
}

class _LastReadCard extends StatelessWidget {
  const _LastReadCard({required this.pos});
  final LastReadPosition pos;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final accent = AppColors.caramel;
    return HoverLiftCard(
      onTap: () => context.push('/quran/${pos.surahNumber}?ayah=${pos.verseNumber}'),
      accent: accent,
      borderRadius: 24,
      padding: const EdgeInsets.all(28),
      lift: 4,
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(Icons.bookmark, color: accent, size: 28),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lanjutkan bacaan',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2.0,
                    color: accent,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${pos.surahName} · Ayat ${pos.verseNumber}',
                  style: TextStyle(
                    fontFamily: 'Space Grotesk',
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: scheme.onSurface,
                    letterSpacing: -0.4,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward, color: accent, size: 22),
        ],
      ),
    );
  }
}

class _LastReadSkeleton extends StatelessWidget {
  const _LastReadSkeleton();
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      height: 108,
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
            color: scheme.outline.withValues(alpha: 0.14), width: 1),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// SEARCH BAR
// ═══════════════════════════════════════════════════════════════════════════

class _SearchBar extends StatefulWidget {
  const _SearchBar({required this.value, required this.onChanged});
  final String value;
  final ValueChanged<String> onChanged;

  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  late final TextEditingController _ctrl;
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.value);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Focus(
      onFocusChange: (f) => setState(() => _focused = f),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _focused
                ? scheme.primary
                : scheme.outline.withValues(alpha: 0.22),
            width: _focused ? 1.6 : 1.2,
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.search,
                size: 20, color: scheme.onSurface.withValues(alpha: 0.7)),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: _ctrl,
                onChanged: widget.onChanged,
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 15,
                  color: scheme.onSurface,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText:
                      'Cari surah (nama, arti, nomor)…  contoh: Al-Fatihah',
                  hintStyle: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 15,
                    color: scheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ),
            if (widget.value.isNotEmpty)
              IconButton(
                onPressed: () {
                  _ctrl.clear();
                  widget.onChanged('');
                },
                icon: const Icon(Icons.close, size: 18),
                color: scheme.onSurface.withValues(alpha: 0.6),
              ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// BENTO GRID
// ═══════════════════════════════════════════════════════════════════════════

class _SurahBentoGrid extends StatelessWidget {
  const _SurahBentoGrid({required this.surahs});
  final List<SurahSummary> surahs;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = 16.0;
        const cols = 4;
        final tileW = (constraints.maxWidth - gap * (cols - 1)) / cols;
        final rows = (surahs.length / cols).ceil();
        return Column(
          children: [
            for (int row = 0; row < rows; row++) ...[
              if (row > 0) const SizedBox(height: gap),
              Row(
                children: [
                  for (int col = 0; col < cols; col++) ...[
                    if (col > 0) const SizedBox(width: gap),
                    if (row * cols + col < surahs.length)
                      SizedBox(
                        width: tileW,
                        child: _SurahTile(
                          surah: surahs[row * cols + col],
                          accentIndex: (row * cols + col) % 5,
                        ),
                      )
                    else
                      SizedBox(width: tileW),
                  ],
                ],
              ),
            ],
          ],
        );
      },
    );
  }
}

class _SurahTile extends StatelessWidget {
  const _SurahTile({required this.surah, required this.accentIndex});
  final SurahSummary surah;
  final int accentIndex;

  static const _accents = [
    AppColors.coffee,
    AppColors.caramel,
    AppColors.clay,
    AppColors.ochre,
    AppColors.terracotta,
  ];

  @override
  Widget build(BuildContext context) {
    final accent = _accents[accentIndex];
    final scheme = Theme.of(context).colorScheme;
    return HoverLiftCard(
      onTap: () => context.push('/quran/${surah.number}'),
      accent: accent,
      borderRadius: 18,
      padding: const EdgeInsets.all(20),
      height: 176,
      lift: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Text(
                  '${surah.number}',
                  style: TextStyle(
                    fontFamily: 'Space Grotesk',
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: accent,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                surah.nameArabic,
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontFamily: 'Scheherazade New',
                  fontSize: 22,
                  height: 1.0,
                  color: scheme.onSurface.withValues(alpha: 0.85),
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            surah.nameLatin,
            style: TextStyle(
              fontFamily: 'Space Grotesk',
              fontSize: 18,
              fontWeight: FontWeight.w800,
              height: 1.1,
              color: scheme.onSurface,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            surah.nameTranslation,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 13,
              color: scheme.onSurface.withValues(alpha: 0.72),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                '${surah.verseCount} ayat',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.4,
                  color: scheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 3,
                height: 3,
                decoration: BoxDecoration(
                  color: scheme.onSurface.withValues(alpha: 0.4),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                surah.revelation,
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.4,
                  color: scheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// SKELETON / EMPTY / ERROR
// ═══════════════════════════════════════════════════════════════════════════

class _GridSkeleton extends StatelessWidget {
  const _GridSkeleton();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return LayoutBuilder(builder: (context, c) {
      const gap = 16.0;
      const cols = 4;
      final tileW = (c.maxWidth - gap * (cols - 1)) / cols;
      return Column(
        children: List.generate(3, (row) {
          return Padding(
            padding: EdgeInsets.only(top: row == 0 ? 0 : gap),
            child: Row(
              children: List.generate(cols, (col) {
                return Padding(
                  padding: EdgeInsets.only(left: col == 0 ? 0 : gap),
                  child: Container(
                    width: tileW,
                    height: 176,
                    decoration: BoxDecoration(
                      color: scheme.surface,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                          color: scheme.outline.withValues(alpha: 0.12),
                          width: 1),
                    ),
                  ),
                );
              }),
            ),
          );
        }),
      );
    });
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 80),
      child: Column(
        children: [
          Icon(Icons.search_off,
              size: 40, color: scheme.onSurface.withValues(alpha: 0.4)),
          const SizedBox(height: 12),
          Text(
            'Tidak ada surah yang cocok.',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 15,
              color: scheme.onSurface.withValues(alpha: 0.72),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorTile extends StatelessWidget {
  const _ErrorTile({required this.message});
  final String message;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Text('Gagal memuat: $message'),
    );
  }
}
