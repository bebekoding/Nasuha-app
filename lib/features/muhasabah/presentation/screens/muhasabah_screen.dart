import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/theme/app_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/tag_icons.dart';

import '../../../../models/muhasabah_entry.dart';
import '../../../../models/muhasabah_tag.dart';
import '../../data/repositories/muhasabah_repository.dart';
import '../providers/muhasabah_hidden_provider.dart';
import '../providers/muhasabah_providers.dart';
import '../widgets/score_card.dart';

// ── Tag group definitions (presentation-only, no DB column needed) ──────────

const _prayerSlugs = [
  'sholat_subuh',
  'sholat_dzuhur',
  'sholat_ashar',
  'sholat_maghrib',
  'sholat_isya',
];

const _prioritySlugs = [
  'tahajud',
  'baca_quran',
  'dzikir_pagi',
  'dzikir_petang',
  'sedekah',
  'belajar',
  'bekerja',
  'family_time',
];

const _missedPrayerSlug = 'tidak_sholat_fardu';
const _autoNote = '__auto__';

// ── Screen ───────────────────────────────────────────────────────────────────

class MuhasabahScreen extends ConsumerStatefulWidget {
  const MuhasabahScreen({super.key});

  @override
  ConsumerState<MuhasabahScreen> createState() => _MuhasabahScreenState();
}

class _MuhasabahScreenState extends ConsumerState<MuhasabahScreen> {
  bool _syncedToday = false;

  @override
  Widget build(BuildContext context) {
    final tagsAsync = ref.watch(tagsProvider);
    final scoreAsync = ref.watch(dailyScoreForSelectedDateProvider);
    final entriesAsync = ref.watch(entriesForSelectedDateProvider);
    final streakAsync = ref.watch(muhasabahStreakProvider);
    final today = DateTime.now();

    // Auto-sync missed prayers once per build cycle when entries are loaded.
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Muhasabah'),
        actions: [
          IconButton(
            icon: Icon(ref.watch(muhasabahHiddenProvider)
                ? Icons.visibility_off
                : Icons.visibility),
            tooltip: ref.watch(muhasabahHiddenProvider)
                ? 'Tampilkan XP'
                : 'Sembunyikan XP',
            onPressed: () =>
                ref.read(muhasabahHiddenProvider.notifier).toggle(),
          ),
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'Riwayat',
            onPressed: () => context.push('/muhasabah/history'),
          ),
        ],
      ),
      body: tagsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Gagal memuat: $e')),
        data: (tags) => entriesAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Gagal memuat: $e')),
          data: (entries) => MuhasabahBody(
            tags: tags,
            entries: entries,
            score: scoreAsync.valueOrNull,
            streak: streakAsync.valueOrNull?.current ?? 0,
          ),
        ),
      ),
    );
  }

}

// ── Main body ─────────────────────────────────────────────────────────────────

class MuhasabahBody extends ConsumerWidget {
  const MuhasabahBody({
    super.key,
    required this.tags,
    required this.entries,
    required this.score,
    required this.streak,
    this.hideScoreCard = false,
    this.padding,
  });

  final List<MuhasabahTag> tags;
  final List<MuhasabahEntry> entries;
  final dynamic score;
  final int streak;

  /// Set true kalau layout luar sudah render ScoreCard sendiri (mis. desktop
  /// yang taruh score card di sidebar kiri).
  final bool hideScoreCard;

  /// Override padding ListView (mobile default: 16/8/16/32).
  final EdgeInsets? padding;

  // Set of slugs logged today (excluding auto-entries so prayers still count)
  Set<String> get _loggedSlugs =>
      entries.map((e) => e.tagSlug).toSet();

  // Count of today's entries per slug (for badge display)
  Map<String, int> get _countBySlug {
    final m = <String, int>{};
    for (final e in entries) {
      m[e.tagSlug] = (m[e.tagSlug] ?? 0) + 1;
    }
    return m;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final positive = tags.where((t) => t.kind == TagKind.positive).toList();
    final negative = tags.where((t) => t.kind == TagKind.negative).toList();

    final prayerTags =
        _priorityOrdered(_prayerSlugs, positive);
    final priorityTags =
        _priorityOrdered(_prioritySlugs, positive);
    final restPositive = positive
        .where((t) =>
            !_prayerSlugs.contains(t.slug) &&
            !_prioritySlugs.contains(t.slug))
        .toList();

    final missedPrayerTag =
        negative.firstWhere((t) => t.slug == _missedPrayerSlug,
            orElse: () => negative.first);
    final otherNegative = negative
        .where((t) => t.slug != _missedPrayerSlug)
        .toList();

    // How many prayers done today (unique slugs)
    final prayersDone = entries
        .map((e) => e.tagSlug)
        .where(_prayerSlugs.contains)
        .toSet()
        .length;
    final missedCount = (5 - prayersDone).clamp(0, 5);

    final logged = _loggedSlugs;
    final counts = _countBySlug;
    final hidden = ref.watch(muhasabahHiddenProvider);

    return ListView(
      padding: padding ?? const EdgeInsets.fromLTRB(16, 8, 16, 32),
      children: [
        // Status HUD — enlarged on the Muhasabah screen, points hidden by default.
        // Kalau layout luar sudah render sendiri (desktop sidebar), skip.
        if (!hideScoreCard) ...[
          ScoreCard(
            score: score,
            streak: streak,
            large: true,
            hidePoints: hidden,
          ),
          const SizedBox(height: 24),
        ],

        // ── SHOLAT 5 WAKTU ──────────────────────────────────────
        _SectionHeader(
          title: 'Sholat 5 Waktu',
          trailing: prayersDone == 5
              ? const _AllDoneChip()
              : Text(
                  '$prayersDone / 5',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
        ),
        const SizedBox(height: 8),
        if (prayersDone == 5)
          _allPrayersDoneCard(context)
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final t in prayerTags)
                if (!logged.contains(t.slug))
                  _ActionChip(
                    tag: t,
                    onTap: () => _add(context, ref, t),
                  ),
            ],
          ),
        const SizedBox(height: 20),

        // ── AMALAN HARIAN ────────────────────────────────────────
        const _SectionHeader(title: 'Amalan Harian'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final t in priorityTags)
              if (!logged.contains(t.slug))
                _ActionChip(tag: t, onTap: () => _add(context, ref, t)),
          ],
        ),
        if (priorityTags.every((t) => logged.contains(t.slug))) ...[
          const SizedBox(height: 8),
          _completedNote(context, 'Semua amalan harian tercatat 🌿'),
        ],
        const SizedBox(height: 20),

        // ── LAINNYA (positif) ─────────────────────────────────────
        const _SectionHeader(title: 'Lainnya'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final t in restPositive)
              if (!logged.contains(t.slug))
                _ActionChip(tag: t, onTap: () => _add(context, ref, t)),
            // Add custom tag button
            _AddCustomChip(onTap: () => _showAddTagSheet(context, ref)),
          ],
        ),
        const SizedBox(height: 20),

        // ── CATATAN NEGATIF ───────────────────────────────────────
        const _SectionHeader(title: 'Catatan Negatif'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            // Tidak Sholat Fardhu — always visible, shows total count
            _MissedPrayerChip(
              tag: missedPrayerTag,
              autoCount: missedCount,
              manualCount: (counts[_missedPrayerSlug] ?? 0) -
                  entries
                      .where((e) =>
                          e.tagSlug == _missedPrayerSlug &&
                          e.note == _autoNote)
                      .length,
              onTap: () => _add(context, ref, missedPrayerTag),
            ),
            // Menunda Sholat — multi-tap, badge count
            for (final t in otherNegative)
              if (t.slug == 'menunda_sholat')
                _MultiTapChip(
                  tag: t,
                  count: counts[t.slug] ?? 0,
                  onTap: () => _add(context, ref, t),
                ),
            // Other negative — one-tap disable
            for (final t in otherNegative)
              if (t.slug != 'menunda_sholat' && !logged.contains(t.slug))
                _ActionChip(
                  tag: t,
                  onTap: () => _add(context, ref, t),
                ),
          ],
        ),
        const SizedBox(height: 24),

        // ── CATATAN HARI INI ─────────────────────────────────────
        _SectionHeader(
          title: 'Catatan hari ini',
          trailing: Text(
            DateFormat('EEE, d MMM', 'id_ID').format(DateTime.now()),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        const SizedBox(height: 8),
        _EntriesList(entries: entries),
      ],
    );
  }

  List<MuhasabahTag> _priorityOrdered(
      List<String> order, List<MuhasabahTag> src) {
    final map = {for (final t in src) t.slug: t};
    return [
      for (final s in order)
        if (map.containsKey(s)) map[s]!,
    ];
  }

  Widget _allPrayersDoneCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFA77B43).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: const Color(0xFFA77B43).withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Text('🕌', style: TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Alhamdulillah, sholat 5 waktu terpenuhi hari ini',
              style: TextStyle(
                color: Color(0xFFA77B43),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _completedNote(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Text(
        text,
        style: TextStyle(
          color: const Color(0xFFA77B43),
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Future<void> _add(
      BuildContext context, WidgetRef ref, MuhasabahTag tag) async {
    final repo = ref.read(muhasabahRepositoryProvider);
    await repo.addEntry(tag);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Tercatat: ${tag.name}'),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  Future<void> _showAddTagSheet(BuildContext context, WidgetRef ref) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (ctx) => _AddTagSheet(),
    );
  }
}

// ── Widgets ───────────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.trailing});
  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: spaceGrotesk(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Theme.of(context).colorScheme.onSurface,
            letterSpacing: -0.2,
          ),
        ),
        if (trailing != null) ...[
          const Spacer(),
          trailing!,
        ],
      ],
    );
  }
}

class _AllDoneChip extends StatelessWidget {
  const _AllDoneChip();
  @override
  Widget build(BuildContext context) => Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFA77B43).withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(99),
        ),
        child: const Text('✓ Semua',
            style: TextStyle(
                color: Color(0xFFA77B43),
                fontSize: 12,
                fontWeight: FontWeight.w700)),
      );
}

/// Standard one-tap chip — positive or negative.
class _ActionChip extends ConsumerWidget {
  const _ActionChip({required this.tag, required this.onTap});
  final MuhasabahTag tag;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hidden = ref.watch(muhasabahHiddenProvider);
    final scheme = Theme.of(context).colorScheme;
    final isPos = tag.kind == TagKind.positive;
    final color = isPos ? scheme.primary : scheme.error;
    final icon = tagIconFor(tag.iconCodePoint,
        fallback:
            isPos ? Icons.add_circle_outline : Icons.remove_circle_outline);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: color.withValues(alpha: 0.30)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 6),
              Text(tag.name,
                  style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w600,
                      fontSize: 13)),
              if (!hidden) ...[
                const SizedBox(width: 4),
                _ScoreBadge(score: tag.score, color: color),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Multi-tap chip with count badge (Menunda Sholat).
class _MultiTapChip extends StatelessWidget {
  const _MultiTapChip(
      {required this.tag, required this.count, required this.onTap});
  final MuhasabahTag tag;
  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const color = Color(0xFFB5613F);
    final icon = tagIconFor(tag.iconCodePoint, fallback: Icons.timer_off);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: color.withValues(alpha: 0.25)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 6),
              Text(tag.name,
                  style: const TextStyle(
                      color: color,
                      fontWeight: FontWeight.w600,
                      fontSize: 13)),
              if (count > 0) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Text('×$count',
                      style: const TextStyle(
                          color: color,
                          fontSize: 11,
                          fontWeight: FontWeight.w800)),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Special chip for "Tidak Sholat Fardhu".
/// Shows auto-computed missed count + manual extra count.
class _MissedPrayerChip extends StatelessWidget {
  const _MissedPrayerChip({
    required this.tag,
    required this.autoCount,
    required this.manualCount,
    required this.onTap,
  });
  final MuhasabahTag tag;
  final int autoCount;
  final int manualCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final total = autoCount + manualCount;
    const color = Color(0xFFB5613F);
    final isGood = total == 0;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: isGood
                ? Colors.grey.withValues(alpha: 0.08)
                : color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
                color: isGood
                    ? Colors.grey.withValues(alpha: 0.2)
                    : color.withValues(alpha: 0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.alarm_off,
                  color: isGood ? Colors.grey : color, size: 16),
              const SizedBox(width: 6),
              Text(
                tag.name,
                style: TextStyle(
                  color: isGood ? Colors.grey : color,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              const SizedBox(width: 6),
              // Auto-computed badge
              if (autoCount > 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.auto_mode,
                          size: 10, color: color),
                      const SizedBox(width: 2),
                      Text('$autoCount',
                          style: const TextStyle(
                              color: color,
                              fontSize: 11,
                              fontWeight: FontWeight.w800)),
                    ],
                  ),
                ),
              // Manual extra badge
              if (manualCount > 0) ...[
                const SizedBox(width: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.22),
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Text('+$manualCount',
                      style: const TextStyle(
                          color: color,
                          fontSize: 11,
                          fontWeight: FontWeight.w800)),
                ),
              ],
              if (isGood)
                const Padding(
                  padding: EdgeInsets.only(left: 4),
                  child: Text('✓',
                      style: TextStyle(
                          color: Color(0xFFA77B43),
                          fontWeight: FontWeight.w800)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddCustomChip extends StatelessWidget {
  const _AddCustomChip({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context)
                  .colorScheme
                  .outline
                  .withValues(alpha: 0.4),
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add,
                  size: 16,
                  color: Theme.of(context).colorScheme.outline),
              const SizedBox(width: 6),
              Text('Tambah',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.outline,
                      fontWeight: FontWeight.w600,
                      fontSize: 13)),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScoreBadge extends StatelessWidget {
  const _ScoreBadge({required this.score, required this.color});
  final int score;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(99),
        ),
        child: Text(
          '${score > 0 ? '+' : ''}$score',
          style: TextStyle(
              color: color, fontSize: 10, fontWeight: FontWeight.w800),
        ),
      );
}

// ── Entries list ──────────────────────────────────────────────────────────────

class _EntriesList extends ConsumerWidget {
  const _EntriesList({required this.entries});
  final List<MuhasabahEntry> entries;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hidden = ref.watch(muhasabahHiddenProvider);
    // Filter out auto entries from display — they're informational
    final visible =
        entries.where((e) => e.note != _autoNote).toList();

    if (visible.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: Text(
            'Belum ada catatan hari ini',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(
                    color: Theme.of(context).colorScheme.outline),
          ),
        ),
      );
    }

    return Column(
      children: [
        for (final e in visible)
          Dismissible(
            key: ValueKey(e.id),
            background: Container(
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              child: const Icon(Icons.delete_outline, color: Colors.red),
            ),
            direction: DismissDirection.endToStart,
            onDismissed: (_) =>
                ref.read(muhasabahRepositoryProvider).deleteEntry(e.id),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: ListTile(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                tileColor: Theme.of(context)
                    .colorScheme
                    .surfaceContainerHighest
                    .withValues(alpha: 0.4),
                leading: CircleAvatar(
                  radius: 18,
                  backgroundColor: (e.kind == TagKind.positive
                          ? const Color(0xFFA77B43)
                          : const Color(0xFFB5613F))
                      .withValues(alpha: 0.15),
                  child: Icon(
                    e.kind == TagKind.positive
                        ? Icons.add
                        : Icons.remove,
                    size: 16,
                    color: e.kind == TagKind.positive
                        ? const Color(0xFFA77B43)
                        : const Color(0xFFB5613F),
                  ),
                ),
                title: Text(e.tagName,
                    style:
                        const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text(
                  e.note == MuhasabahRepository.autoFeatureNote
                      ? '${DateFormat('HH:mm').format(e.createdAt)} · otomatis'
                      : DateFormat('HH:mm').format(e.createdAt),
                ),
                trailing: hidden
                    ? null
                    : Text(
                        '${e.tagScore > 0 ? '+' : ''}${e.tagScore}',
                        style: TextStyle(
                          color: e.kind == TagKind.positive
                              ? const Color(0xFFA77B43)
                              : const Color(0xFFB5613F),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                dense: true,
              ),
            ),
          ),
      ],
    );
  }
}

// ── Add custom tag sheet ──────────────────────────────────────────────────────

class _AddTagSheet extends ConsumerStatefulWidget {
  @override
  ConsumerState<_AddTagSheet> createState() => _AddTagSheetState();
}

class _AddTagSheetState extends ConsumerState<_AddTagSheet> {
  final _nameCtrl = TextEditingController();
  final _scoreCtrl = TextEditingController(text: '10');
  TagKind _kind = TagKind.positive;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _scoreCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        left: 20,
        right: 20,
        top: 8,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Tambah Tag Custom',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),
          TextField(
            controller: _nameCtrl,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(hintText: 'Nama tag'),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _scoreCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      hintText: 'XP (mis. 10 atau -10)'),
                ),
              ),
              const SizedBox(width: 12),
              SegmentedButton<TagKind>(
                segments: const [
                  ButtonSegment(
                      value: TagKind.positive,
                      icon: Icon(Icons.add, size: 16),
                      label: Text('Positif')),
                  ButtonSegment(
                      value: TagKind.negative,
                      icon: Icon(Icons.remove, size: 16),
                      label: Text('Negatif')),
                ],
                selected: {_kind},
                onSelectionChanged: (s) =>
                    setState(() => _kind = s.first),
                style: ButtonStyle(
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () async {
              final name = _nameCtrl.text.trim();
              final score =
                  int.tryParse(_scoreCtrl.text.trim()) ?? 10;
              if (name.isEmpty) return;
              await ref
                  .read(muhasabahRepositoryProvider)
                  .addCustomTag(name: name, score: score, kind: _kind);
              if (context.mounted) Navigator.of(context).pop();
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }
}
