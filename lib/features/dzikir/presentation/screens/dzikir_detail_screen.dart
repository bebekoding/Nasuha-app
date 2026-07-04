import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/theme/app_fonts.dart';
import '../../../muhasabah/presentation/providers/muhasabah_autolog.dart';
import '../../data/dzikir_data.dart';

class DzikirDetailScreen extends ConsumerStatefulWidget {
  const DzikirDetailScreen({
    super.key,
    required this.categoryIndex,
    this.chromeless = false,
  });
  final int categoryIndex;
  final bool chromeless;

  @override
  ConsumerState<DzikirDetailScreen> createState() =>
      _DzikirDetailScreenState();
}

class _DzikirDetailScreenState extends ConsumerState<DzikirDetailScreen> {
  @override
  void initState() {
    super.initState();
    final idx = widget.categoryIndex;
    if (idx >= 0 && idx < kDzikirCategories.length) {
      // Opening dzikir pagi/petang within its time window auto-records it.
      final id = kDzikirCategories[idx].id;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(muhasabahAutoLoggerProvider).onOpenDzikir(id);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.categoryIndex < 0 ||
        widget.categoryIndex >= kDzikirCategories.length) {
      const notFound = Center(child: Text('Kategori tidak ditemukan'));
      if (widget.chromeless) return notFound;
      return const Scaffold(body: notFound);
    }
    final category = kDzikirCategories[widget.categoryIndex];
    final body = ListView.separated(
      shrinkWrap: widget.chromeless,
      physics: widget.chromeless
          ? const NeverScrollableScrollPhysics()
          : null,
      padding: widget.chromeless
          ? EdgeInsets.zero
          : const EdgeInsets.fromLTRB(16, 8, 16, 32),
      itemCount: category.items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 14),
      itemBuilder: (ctx, i) =>
          _DzikirCard(item: category.items[i], index: i + 1),
    );
    if (widget.chromeless) return body;
    return Scaffold(
      appBar: AppBar(title: Text(category.title)),
      body: body,
    );
  }
}

class _DzikirCard extends StatefulWidget {
  const _DzikirCard({required this.item, required this.index});
  final DzikirItem item;
  final int index;

  @override
  State<_DzikirCard> createState() => _DzikirCardState();
}

class _DzikirCardState extends State<_DzikirCard> {
  int _done = 0;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    const color = Color(0xFFA77B43);
    final item = widget.item;
    final completed = _done >= item.count;

    return Container(
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: completed
              ? color.withValues(alpha: 0.5)
              : scheme.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: index + count badge
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 13,
                  backgroundColor: color.withValues(alpha: 0.15),
                  child: Text('${widget.index}',
                      style: const TextStyle(
                          color: color,
                          fontSize: 12,
                          fontWeight: FontWeight.w800)),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Text('${item.count}×',
                      style: const TextStyle(
                          color: color,
                          fontSize: 12,
                          fontWeight: FontWeight.w800)),
                ),
              ],
            ),
          ),
          // Arabic
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
            child: Text(
              item.arabic,
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              style: const TextStyle(
                fontFamily: arabicFontFamily,
                fontSize: 26,
                height: 2.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          // Latin
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              item.latin,
              style: TextStyle(
                fontSize: 13,
                fontStyle: FontStyle.italic,
                color: color,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Translation
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              item.translation,
              style: TextStyle(
                  fontSize: 13, color: scheme.onSurface, height: 1.5),
            ),
          ),
          // Note (keutamaan)
          if (item.note != null) ...[
            const SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFC1923C).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.auto_awesome,
                      size: 14, color: Color(0xFFC1923C)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(item.note!,
                        style: TextStyle(
                            fontSize: 12,
                            color: scheme.onSurface,
                            height: 1.4)),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 12),
          // Counter + quick-finish buttons.
          // Disusun dalam Column agar tiap tombol lebar penuh dan tidak
          // berebut ruang horizontal (yang sebelumnya membuat teks tombol
          // menumpuk vertikal pada bacaan 3×/33×/100×).
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.tonal(
                        onPressed: completed
                            ? null
                            : () => setState(() => _done++),
                        style: FilledButton.styleFrom(
                          backgroundColor: completed
                              ? color.withValues(alpha: 0.15)
                              : color.withValues(alpha: 0.12),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Text(
                          completed
                              ? '✓ Selesai'
                              : 'Ketuk  $_done / ${item.count}',
                          maxLines: 1,
                          softWrap: false,
                          overflow: TextOverflow.fade,
                          style: const TextStyle(
                              color: color, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    if (_done > 0)
                      IconButton(
                        tooltip: 'Reset',
                        onPressed: () => setState(() => _done = 0),
                        icon: Icon(Icons.refresh, color: scheme.outline),
                      ),
                  ],
                ),
                // "Tandai selesai" — menuntaskan satu bacaan dalam satu
                // ketukan (berguna untuk dzikir 33×/100× tanpa menekan
                // berulang). Hanya tampil untuk bacaan lebih dari 1×.
                if (item.count > 1 && !completed) ...[
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () =>
                          setState(() => _done = item.count),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: color,
                        side: BorderSide(
                            color: color.withValues(alpha: 0.5)),
                        padding:
                            const EdgeInsets.symmetric(vertical: 12),
                      ),
                      icon: const Icon(Icons.done_all, size: 18),
                      label: Text('Tandai selesai (${item.count}×)',
                          style:
                              const TextStyle(fontWeight: FontWeight.w700)),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
