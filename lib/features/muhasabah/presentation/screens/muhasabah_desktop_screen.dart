import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../core/widgets/desktop_page_shell.dart';
import '../../data/repositories/muhasabah_repository.dart';
import '../providers/muhasabah_hidden_provider.dart';
import '../providers/muhasabah_providers.dart';
import '../widgets/score_card.dart';
import 'muhasabah_screen.dart';

/// Muhasabah desktop (width >= 800). 2-column: kiri sticky-vibe summary
/// (ScoreCard besar + tips + streak chip), kanan chip picker + entries list
/// (reuse MuhasabahBody dari mobile agar logika tak duplikat).
class MuhasabahDesktopScreen extends ConsumerStatefulWidget {
  const MuhasabahDesktopScreen({super.key});

  @override
  ConsumerState<MuhasabahDesktopScreen> createState() =>
      _MuhasabahDesktopScreenState();
}

class _MuhasabahDesktopScreenState
    extends ConsumerState<MuhasabahDesktopScreen> {
  bool _syncedToday = false;

  @override
  Widget build(BuildContext context) {
    final tagsAsync = ref.watch(tagsProvider);
    final scoreAsync = ref.watch(dailyScoreForSelectedDateProvider);
    final entriesAsync = ref.watch(entriesForSelectedDateProvider);
    final streakAsync = ref.watch(muhasabahStreakProvider);
    final today = DateTime.now();

    entriesAsync.whenData((_) {
      if (!_syncedToday) {
        _syncedToday = true;
        Future.microtask(() => ref
            .read(muhasabahRepositoryProvider)
            .autoSyncMissedPrayers(
              '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}',
            ));
      }
    });

    return DesktopPageShell(
      currentRoute: '/muhasabah',
      eyebrow: 'MUHASABAH',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Header(date: today),
          const SizedBox(height: 28),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 400,
                  child: _LeftSidebar(
                    score: scoreAsync.valueOrNull,
                    streak: streakAsync.valueOrNull?.current ?? 0,
                    longest: streakAsync.valueOrNull?.longest ?? 0,
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: _RightPanel(
                    tagsAsync: tagsAsync,
                    entriesAsync: entriesAsync,
                    scoreAsync: scoreAsync,
                    streakAsync: streakAsync,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// HEADER
// ═══════════════════════════════════════════════════════════════════════════

class _Header extends ConsumerWidget {
  const _Header({required this.date});
  final DateTime date;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final hidden = ref.watch(muhasabahHiddenProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    'Muhasabah hari ini',
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
                    '${DateFormat('EEEE, d MMMM y', 'id_ID').format(date)} — catat amal & khilaf, sadari lalu perbaiki.',
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
            _ToggleXpBtn(
              hidden: hidden,
              onTap: () =>
                  ref.read(muhasabahHiddenProvider.notifier).toggle(),
            ),
            const SizedBox(width: 8),
            _HistoryBtn(onTap: () => context.push('/muhasabah/history')),
          ],
        ),
      ],
    );
  }
}

class _ToggleXpBtn extends StatefulWidget {
  const _ToggleXpBtn({required this.hidden, required this.onTap});
  final bool hidden;
  final VoidCallback onTap;
  @override
  State<_ToggleXpBtn> createState() => _ToggleXpBtnState();
}

class _ToggleXpBtnState extends State<_ToggleXpBtn> {
  bool _hover = false;
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Tooltip(
          message:
              widget.hidden ? 'Tampilkan XP' : 'Sembunyikan XP',
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: scheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: scheme.outline
                      .withValues(alpha: _hover ? 0.4 : 0.22),
                  width: 1),
            ),
            child: Icon(
                widget.hidden
                    ? Icons.visibility_off
                    : Icons.visibility,
                size: 18,
                color: scheme.onSurface.withValues(alpha: 0.78)),
          ),
        ),
      ),
    );
  }
}

class _HistoryBtn extends StatefulWidget {
  const _HistoryBtn({required this.onTap});
  final VoidCallback onTap;
  @override
  State<_HistoryBtn> createState() => _HistoryBtnState();
}

class _HistoryBtnState extends State<_HistoryBtn> {
  bool _hover = false;
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: scheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: scheme.outline
                    .withValues(alpha: _hover ? 0.4 : 0.22),
                width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.history,
                  size: 18,
                  color: scheme.onSurface.withValues(alpha: 0.78)),
              const SizedBox(width: 8),
              Text('Riwayat',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: scheme.onSurface,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// LEFT SIDEBAR — score card + streak + tips
// ═══════════════════════════════════════════════════════════════════════════

class _LeftSidebar extends ConsumerWidget {
  const _LeftSidebar({
    required this.score,
    required this.streak,
    required this.longest,
  });
  final dynamic score;
  final int streak;
  final int longest;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hidden = ref.watch(muhasabahHiddenProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ScoreCard(
          score: score,
          streak: streak,
          large: true,
          hidePoints: hidden,
        ),
        const SizedBox(height: 16),
        _StreakSideCard(current: streak, longest: longest),
        const SizedBox(height: 16),
        const _TipsCard(),
      ],
    );
  }
}

class _StreakSideCard extends StatelessWidget {
  const _StreakSideCard({required this.current, required this.longest});
  final int current;
  final int longest;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
            color: AppColors.goldLight.withValues(alpha: 0.24), width: 1.2),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.goldLight.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.local_fire_department,
                color: AppColors.goldLight, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text('$current',
                        style: TextStyle(
                          fontFamily: 'Space Grotesk',
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: scheme.onSurface,
                        )),
                    const SizedBox(width: 6),
                    Text('hari streak',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 13,
                          color: scheme.onSurface.withValues(alpha: 0.72),
                        )),
                  ],
                ),
                const SizedBox(height: 2),
                Text('Terpanjang: $longest hari',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 12,
                      color: scheme.onSurface.withValues(alpha: 0.68),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TipsCard extends StatelessWidget {
  const _TipsCard();
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.caramel.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
            color: AppColors.caramel.withValues(alpha: 0.28), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb_outline,
                  color: AppColors.caramel, size: 18),
              const SizedBox(width: 8),
              Text('Tips',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.6,
                    color: AppColors.caramel,
                  )),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Catat pelan-pelan sepanjang hari. Ketuk chip amalan setelah selesai — atau ketuk chip khilaf saat baru sadar keliru. Nasuha bukan hukuman, ini alat refleksi.',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 13,
              height: 1.55,
              color: scheme.onSurface.withValues(alpha: 0.78),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// RIGHT PANEL — reuse MuhasabahBody
// ═══════════════════════════════════════════════════════════════════════════

class _RightPanel extends StatelessWidget {
  const _RightPanel({
    required this.tagsAsync,
    required this.entriesAsync,
    required this.scoreAsync,
    required this.streakAsync,
  });

  final AsyncValue tagsAsync;
  final AsyncValue entriesAsync;
  final AsyncValue scoreAsync;
  final AsyncValue streakAsync;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
            color: scheme.outline.withValues(alpha: 0.16), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: scheme.onSurface.withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      // Cap height agar list ter-scroll internal (bukan seluruh page).
      constraints: const BoxConstraints(minHeight: 640, maxHeight: 900),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: tagsAsync.when(
          loading: () =>
              const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Gagal memuat: $e')),
          data: (tags) => entriesAsync.when(
            loading: () =>
                const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Gagal memuat: $e')),
            data: (entries) => MuhasabahBody(
              tags: tags,
              entries: entries,
              score: scoreAsync.valueOrNull,
              streak: streakAsync.valueOrNull?.current ?? 0,
              hideScoreCard: true,
              padding: const EdgeInsets.fromLTRB(28, 24, 28, 24),
            ),
          ),
        ),
      ),
    );
  }
}
