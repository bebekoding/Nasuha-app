import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/theme/app_fonts.dart';
import '../../../muhasabah/presentation/providers/muhasabah_autolog.dart';
import '../../data/repositories/quran_repository.dart';
import '../../domain/entities/surah.dart';
import '../providers/quran_reading_mode.dart';

const int _kLastSurah = 114;

/// Naskh Arab untuk teks Al-Quran (lihat [arabicFontFamily]).
const String _arabicFont = arabicFontFamily;

/// Continuous Quran reader. Renders **one widget per ayah** inside a
/// [CustomScrollView] so only visible ayat are laid out (long surahs no longer
/// freeze the UI), and loads surahs **both forward and backward** around the
/// surah the user opened — the `center` sliver keeps the scroll position steady
/// when earlier surahs are prepended.
class SurahDetailScreen extends ConsumerStatefulWidget {
  const SurahDetailScreen({
    super.key,
    required this.surahNumber,
    this.initialAyah,
  });

  final int surahNumber;
  final int? initialAyah;

  @override
  ConsumerState<SurahDetailScreen> createState() => _SurahDetailScreenState();
}

class _SurahDetailScreenState extends ConsumerState<SurahDetailScreen> {
  final ScrollController _scroll = ScrollController();

  /// Surahs currently loaded, kept ascending by number.
  final List<SurahDetail> _surahs = [];

  /// Sliver key marking the start of the surah the user opened. Everything
  /// before it lives in a reverse sliver above; everything from it onward in
  /// the forward sliver below.
  final _centerKey = GlobalKey();

  /// Per-ayah keys ("surah:ayah") for precise scroll-to / resume.
  final Map<String, GlobalKey> _ayahKeys = {};

  int _firstNum = 1; // lowest surah loaded
  int _nextNum = 1; // next surah to load forward (one past the highest)
  bool _loadingNext = false;
  bool _loadingPrev = false;
  bool _initialLoading = true;
  String? _error;

  double _fontSize = 30;
  bool _didJumpToInitial = false;
  int _jumpTries = 0;

  static const _minFont = 22.0;
  static const _maxFont = 46.0;

  GlobalKey _ayahKey(int s, int a) =>
      _ayahKeys.putIfAbsent('$s:$a', () => GlobalKey());

  @override
  void initState() {
    super.initState();
    _firstNum = widget.surahNumber;
    _nextNum = widget.surahNumber;
    _scroll.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(muhasabahAutoLoggerProvider).onReadQuran();
    });
    _loadInitial();
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _loadInitial() async {
    try {
      final detail =
          await ref.read(quranRepositoryProvider).getSurah(widget.surahNumber);
      if (!mounted) return;
      setState(() {
        _surahs.add(detail);
        _firstNum = widget.surahNumber;
        _nextNum = widget.surahNumber + 1;
        _initialLoading = false;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _jumpToInitial();
        _maybeLoad();
      });
    } catch (e) {
      if (mounted) setState(() => _error = '$e');
    }
  }

  /// Resume to [SurahDetailScreen.initialAyah]. With lazy slivers the target
  /// ayah may not be built yet, so step the scroll forward a viewport at a
  /// time until its context exists, then reveal it precisely.
  void _jumpToInitial() {
    if (_didJumpToInitial) return;
    final ayah = widget.initialAyah;
    if (ayah == null || ayah <= 1) {
      _didJumpToInitial = true;
      return;
    }
    final ctx = _ayahKeys['${widget.surahNumber}:$ayah']?.currentContext;
    if (ctx != null) {
      _didJumpToInitial = true;
      Scrollable.ensureVisible(ctx,
          duration: const Duration(milliseconds: 350), alignment: 0.08);
      return;
    }
    if (_jumpTries++ < 60 && _scroll.hasClients) {
      final pos = _scroll.position;
      if (pos.pixels < pos.maxScrollExtent) {
        _scroll.jumpTo(
            (pos.pixels + pos.viewportDimension * 0.85)
                .clamp(pos.minScrollExtent, pos.maxScrollExtent));
      }
      WidgetsBinding.instance.addPostFrameCallback((_) => _jumpToInitial());
    } else {
      _didJumpToInitial = true;
    }
  }

  void _onScroll() => _maybeLoad();

  /// Load the next/previous surah when the viewport is near (or below) an
  /// edge. Driven both by scroll events AND proactively after every load — so
  /// short surahs that fit on one screen (no scroll room, e.g. Al-Ikhlas →
  /// Al-Falaq) still chain-load instead of getting stuck on the spinner.
  void _maybeLoad() {
    if (!_scroll.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _maybeLoad());
      return;
    }
    final pos = _scroll.position;
    if (!_loadingNext &&
        _nextNum <= _kLastSurah &&
        pos.pixels >= pos.maxScrollExtent - 1600) {
      _loadNext();
    }
    if (!_loadingPrev &&
        _firstNum > 1 &&
        pos.pixels <= pos.minScrollExtent + 1600) {
      _loadPrev();
    }
  }

  Future<void> _loadNext() async {
    if (_loadingNext || _nextNum > _kLastSurah) return;
    setState(() => _loadingNext = true);
    try {
      final detail = await ref.read(quranRepositoryProvider).getSurah(_nextNum);
      if (!mounted) return;
      setState(() {
        _surahs.add(detail);
        _nextNum++;
        _loadingNext = false;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) => _maybeLoad());
    } catch (_) {
      if (mounted) setState(() => _loadingNext = false);
    }
  }

  Future<void> _loadPrev() async {
    if (_loadingPrev || _firstNum <= 1) return;
    setState(() => _loadingPrev = true);
    try {
      final detail =
          await ref.read(quranRepositoryProvider).getSurah(_firstNum - 1);
      if (!mounted) return;
      setState(() {
        _surahs.insert(0, detail);
        _firstNum--;
        _loadingPrev = false;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) => _maybeLoad());
    } catch (_) {
      if (mounted) setState(() => _loadingPrev = false);
    }
  }

  Future<void> _mark(SurahDetail detail, int ayah) async {
    await ref.read(quranRepositoryProvider).setLastRead(
          surahNumber: detail.summary.number,
          verseNumber: ayah,
          surahName: detail.summary.nameLatin,
        );
    ref.invalidate(lastReadProvider);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ditandai: ${detail.summary.nameLatin} ayat $ayah'),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  // ───────────────────────── Block model ─────────────────────────
  // A flat list of small widgets (header / ayah / footer) so the sliver builds
  // lazily — only what's on screen is laid out.

  @override
  Widget build(BuildContext context) {
    final focusMode = ref.watch(quranFocusModeProvider);
    final lastRead = ref.watch(lastReadProvider).valueOrNull;

    final title = _surahs.isNotEmpty
        ? _surahs
            .firstWhere((s) => s.summary.number == widget.surahNumber,
                orElse: () => _surahs.first)
            .summary
            .nameLatin
        : 'Surah ${widget.surahNumber}';

    final toggle = IconButton(
      tooltip: focusMode ? 'Mode terjemah' : 'Mode fokus (full ayat)',
      icon: Icon(focusMode ? Icons.menu_book_outlined : Icons.auto_stories),
      onPressed: () => ref.read(quranFocusModeProvider.notifier).toggle(),
    );

    final body = _initialLoading
        ? Center(child: CircularProgressIndicator(color: focusMode ? _gold : null))
        : _error != null
            ? Center(
                child: Text('Error: $_error',
                    style: TextStyle(color: focusMode ? _ink : null)))
            : _buildReader(focusMode, lastRead);

    if (focusMode) {
      return Theme(
        data: _focusTheme(context),
        child: Scaffold(
          backgroundColor: _bg,
          appBar: AppBar(
            backgroundColor: _bg,
            foregroundColor: _ink,
            elevation: 0,
            title: Text(title),
            actions: [toggle],
          ),
          body: body,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(title), actions: [toggle]),
      body: body,
    );
  }

  Widget _buildReader(bool focusMode, dynamic lastRead) {
    final lastSurah = lastRead?.surahNumber as int?;
    final lastAyah = lastRead?.verseNumber as int?;

    // Split loaded surahs into the part at/after the opened surah (forward,
    // center sliver) and the part before it (backward, reverse sliver).
    final centerIdx =
        _surahs.indexWhere((s) => s.summary.number == widget.surahNumber);
    final fwdSurahs = centerIdx < 0 ? _surahs : _surahs.sublist(centerIdx);
    final bwdSurahs = centerIdx <= 0 ? <SurahDetail>[] : _surahs.sublist(0, centerIdx);

    // Forward blocks: each surah → header + ayat; trailing footer.
    final fwd = <_Block>[];
    for (final d in fwdSurahs) {
      fwd.add(_HeaderBlock(d));
      for (final v in d.verses) {
        fwd.add(_AyahBlock(d, v));
      }
    }
    fwd.add(_FooterBlock(end: _nextNum > _kLastSurah));

    // Backward blocks: normal reading order, then reversed so item 0 sits just
    // above the center; a loader/marker block ends up at the very top.
    final bwdNormal = <_Block>[];
    for (final d in bwdSurahs) {
      bwdNormal.add(_HeaderBlock(d));
      for (final v in d.verses) {
        bwdNormal.add(_AyahBlock(d, v));
      }
    }
    final bwd = bwdNormal.reversed.toList();
    if (_firstNum > 1) bwd.add(_TopLoaderBlock());

    final padH = focusMode ? 20.0 : 16.0;

    Widget item(_Block b) => _renderBlock(
          b,
          focusMode: focusMode,
          lastSurah: lastSurah,
          lastAyah: lastAyah,
        );

    final scrollView = CustomScrollView(
      controller: _scroll,
      center: _centerKey,
      anchor: 0,
      slivers: [
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: padH),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (ctx, i) => item(bwd[i]),
              childCount: bwd.length,
            ),
          ),
        ),
        SliverPadding(
          key: _centerKey,
          padding: EdgeInsets.fromLTRB(padH, 8, padH, focusMode ? 48 : 24),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (ctx, i) => item(fwd[i]),
              childCount: fwd.length,
            ),
          ),
        ),
      ],
    );

    if (focusMode) {
      return Column(
        children: [
          Expanded(child: scrollView),
          _FontSizeBar(
            value: _fontSize,
            onDecrease: _fontSize > _minFont
                ? () => setState(
                    () => _fontSize = (_fontSize - 2).clamp(_minFont, _maxFont))
                : null,
            onIncrease: _fontSize < _maxFont
                ? () => setState(
                    () => _fontSize = (_fontSize + 2).clamp(_minFont, _maxFont))
                : null,
          ),
        ],
      );
    }
    return scrollView;
  }

  Widget _renderBlock(
    _Block b, {
    required bool focusMode,
    required int? lastSurah,
    required int? lastAyah,
  }) {
    if (b is _HeaderBlock) {
      return focusMode ? _focusHeader(b.d) : _translationHeader(b.d);
    }
    if (b is _AyahBlock) {
      final marked =
          lastSurah == b.d.summary.number && lastAyah == b.v.number;
      return focusMode
          ? _focusAyah(b.d, b.v, marked: marked)
          : _translationAyah(b.d, b.v);
    }
    if (b is _FooterBlock) {
      return _footer(focusMode, b.end);
    }
    if (b is _TopLoaderBlock) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
                strokeWidth: 2.5, color: focusMode ? _gold : null),
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _footer(bool focusMode, bool end) {
    if (end) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Center(
          child: Text('۞ Akhir Al-Quran ۞',
              style: TextStyle(
                  color: focusMode ? _gold : null,
                  fontWeight: FontWeight.w600)),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 28),
      child: Center(
        child: SizedBox(
          width: 26,
          height: 26,
          child: CircularProgressIndicator(
              strokeWidth: 2.5, color: focusMode ? _gold : null),
        ),
      ),
    );
  }

  // ───────────────────────── Mode Fokus (full ayat) ─────────────────────────

  Widget _focusHeader(SurahDetail detail) {
    final num = detail.summary.number;
    final showBismillah = num != 1 && num != 9;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 8, bottom: 20),
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            color: _surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _gold.withValues(alpha: 0.25)),
          ),
          child: Column(
            children: [
              Text(detail.summary.nameArabic,
                  style: const TextStyle(
                      fontFamily: _arabicFont,
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: _gold)),
              const SizedBox(height: 4),
              Text(
                '${detail.summary.nameLatin} · ${detail.summary.verseCount} ayat',
                style: const TextStyle(color: _muted, fontSize: 13),
              ),
            ],
          ),
        ),
        if (showBismillah) ...[
          const Text(
            'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
            style: TextStyle(
                fontFamily: _arabicFont,
                fontSize: 26,
                height: 2,
                color: _gold,
                fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 16),
        ],
      ],
    );
  }

  Widget _focusAyah(SurahDetail detail, Verse v, {required bool marked}) {
    return Padding(
      key: _ayahKey(detail.summary.number, v.number),
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Text.rich(
        TextSpan(children: [
          TextSpan(text: '${v.arabic} '),
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: GestureDetector(
              onTap: () => _mark(detail, v.number),
              child: _AyahMarker(label: _toArabicIndic(v.number), marked: marked),
            ),
          ),
        ]),
        textAlign: TextAlign.justify,
        textDirection: TextDirection.rtl,
        style: TextStyle(
          fontFamily: _arabicFont,
          fontSize: _fontSize,
          height: 2.2,
          color: _ink,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  // ───────────────────────── Mode Terjemah (asli) ─────────────────────────

  Widget _translationHeader(SurahDetail detail) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 16, top: 4),
      decoration: BoxDecoration(
        color:
            Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(detail.summary.nameArabic,
              style: const TextStyle(
                  fontFamily: _arabicFont,
                  fontSize: 32,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(detail.summary.nameLatin,
              style: Theme.of(context).textTheme.titleLarge),
          Text(detail.summary.nameTranslation,
              style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 8),
          Text(
              '${detail.summary.verseCount} ayat • ${detail.summary.revelation}',
              style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }

  Widget _translationAyah(SurahDetail detail, Verse v) {
    return Card(
      key: _ayahKey(detail.summary.number, v.number),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor:
                      Theme.of(context).colorScheme.secondaryContainer,
                  child: Text('${v.number}',
                      style: const TextStyle(fontSize: 12)),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.bookmark_border),
                  tooltip: 'Tandai terakhir dibaca',
                  onPressed: () => _mark(detail, v.number),
                ),
                IconButton(
                  icon: const Icon(Icons.star_border),
                  tooltip: 'Favorit',
                  onPressed: () =>
                      ref.read(quranRepositoryProvider).toggleFavorite(
                            surahNumber: detail.summary.number,
                            verseNumber: v.number,
                            surahName: detail.summary.nameLatin,
                          ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              v.arabic,
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              style: const TextStyle(
                fontFamily: _arabicFont,
                fontSize: 24,
                height: 2,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Text(v.latin,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(fontStyle: FontStyle.italic)),
            const SizedBox(height: 8),
            Text(v.translation, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }

  String _toArabicIndic(int n) => n
      .toString()
      .split('')
      .map((c) => '٠١٢٣٤٥٦٧٨٩'[int.parse(c)])
      .join();
}

// ─────────────────── Block types ───────────────────

abstract class _Block {}

class _HeaderBlock extends _Block {
  _HeaderBlock(this.d);
  final SurahDetail d;
}

class _AyahBlock extends _Block {
  _AyahBlock(this.d, this.v);
  final SurahDetail d;
  final Verse v;
}

class _FooterBlock extends _Block {
  _FooterBlock({required this.end});
  final bool end;
}

class _TopLoaderBlock extends _Block {}

// ─────────────────── Palet & komponen Mode Fokus ───────────────────

const Color _bg = Color(0xFF15110C);
const Color _surface = Color(0xFF1F1913);
const Color _ink = Color(0xFFEDE3CE);
const Color _muted = Color(0xFFB7A98E);
const Color _gold = Color(0xFFC9A24B);

ThemeData _focusTheme(BuildContext context) {
  final base = Theme.of(context);
  return base.copyWith(
    scaffoldBackgroundColor: _bg,
    colorScheme: base.colorScheme.copyWith(surface: _bg, onSurface: _ink),
  );
}

/// Penanda akhir ayat — lingkaran emas berisi nomor ayat (angka Arab).
/// Saat [marked] true (posisi terakhir dibaca) lingkaran terisi penuh.
class _AyahMarker extends StatelessWidget {
  const _AyahMarker({required this.label, this.marked = false});
  final String label;
  final bool marked;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      constraints: const BoxConstraints(minWidth: 30),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
            color: _gold.withValues(alpha: marked ? 1 : 0.7),
            width: marked ? 2 : 1.4),
        color: _gold.withValues(alpha: marked ? 0.85 : 0.10),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: marked ? const Color(0xFF15110C) : _gold,
            fontSize: 14,
            fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _FontSizeBar extends StatelessWidget {
  const _FontSizeBar({
    required this.value,
    required this.onDecrease,
    required this.onIncrease,
  });

  final double value;
  final VoidCallback? onDecrease;
  final VoidCallback? onIncrease;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: const BoxDecoration(
        color: _surface,
        border: Border(top: BorderSide(color: Color(0xFF2C241B))),
      ),
      child: Row(
        children: [
          const Icon(Icons.text_fields, size: 18, color: _muted),
          const SizedBox(width: 8),
          const Text('Ukuran teks',
              style: TextStyle(color: _muted, fontSize: 13)),
          const Spacer(),
          IconButton(
            onPressed: onDecrease,
            icon: const Icon(Icons.remove_circle_outline),
            color: _gold,
            disabledColor: _muted.withValues(alpha: 0.3),
            tooltip: 'Perkecil',
          ),
          Text('${value.round()}',
              style: const TextStyle(
                  color: _ink, fontWeight: FontWeight.w700, fontSize: 15)),
          IconButton(
            onPressed: onIncrease,
            icon: const Icon(Icons.add_circle_outline),
            color: _gold,
            disabledColor: _muted.withValues(alpha: 0.3),
            tooltip: 'Perbesar',
          ),
        ],
      ),
    );
  }
}
