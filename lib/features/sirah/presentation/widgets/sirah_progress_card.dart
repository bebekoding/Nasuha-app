import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/theme/neo_style.dart';
import '../../data/sirah_data.dart';
import '../providers/sirah_progress_provider.dart';

/// Kartu ringkas progres baca Sirah — dipakai di home mobile & desktop.
/// - Belum mulai baca: tampilkan CTA "Mulai Baca".
/// - Sudah ada progres: tampilkan bar + nama chapter terakhir + "Lanjutkan".
class SirahProgressCard extends ConsumerWidget {
  const SirahProgressCard({super.key, this.compact = false});

  /// [compact] = true → padding lebih rapat (versi home mobile).
  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(sirahProgressProvider);
    final scheme = Theme.of(context).colorScheme;
    final last = progress.lastOpened;
    final lastChapter = last == null
        ? null
        : kSirahChapters.firstWhere(
            (c) => c.number == last,
            orElse: () => kSirahChapters.first,
          );

    final targetRoute = lastChapter != null
        ? '/sirah/${lastChapter.number}'
        : '/sirah';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => context.push(targetRoute),
        child: Container(
          padding: EdgeInsets.all(compact ? 14 : 18),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                NeoStyle.tint(context, scheme.primary, 0.14),
                NeoStyle.tint(context, scheme.tertiary, 0.08),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: scheme.primary.withValues(alpha: 0.32),
              width: 1.2,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: scheme.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.brightness_3,
                        color: scheme.onPrimary, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sirah Nabawi',
                          style: TextStyle(
                            fontFamily: 'Space Grotesk',
                            fontWeight: FontWeight.w800,
                            fontSize: compact ? 15 : 16,
                            color: scheme.onSurface,
                          ),
                        ),
                        Text(
                          lastChapter == null
                              ? 'Mulai baca 20 chapter'
                              : 'Chapter ${lastChapter.number}: ${lastChapter.title}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 12,
                            color:
                                scheme.onSurface.withValues(alpha: 0.72),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward,
                      color: scheme.primary, size: 20),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: progress.fraction,
                  minHeight: 7,
                  backgroundColor: scheme.primary.withValues(alpha: 0.16),
                  valueColor: AlwaysStoppedAnimation(scheme.primary),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '${progress.done} / ${progress.total} chapter dibaca',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: scheme.onSurface.withValues(alpha: 0.62),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
