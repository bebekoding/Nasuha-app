import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../config/theme/neo_style.dart';
import '../../../../services/compass/compass_service.dart';
import '../providers/qibla_providers.dart';

/// Arah Kiblat mobile.
///
/// Empat state, tidak ada yang menampilkan exception mentah:
/// 1. Loading lokasi (maks ±8 detik — provider punya timeout).
/// 2. Lokasi tidak tersedia → panduan + tombol "Coba lagi".
/// 3. Lokasi ada, kompas tidak (desktop web / sensor absen) →
///    **mode statis**: dial utara-atas + panah bearing + derajat.
/// 4. Kompas hidup → dial live mengikuti arah perangkat.
class QiblaScreen extends ConsumerWidget {
  const QiblaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coordsAsync = ref.watch(qiblaCoordsProvider);
    final bearingAsync = ref.watch(qiblaBearingProvider);
    final headingAsync = ref.watch(compassHeadingProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Arah Kiblat')),
      body: SafeArea(
        child: bearingAsync.when(
          loading: () => const _CenterNote(
            spinner: true,
            text: 'Mendapatkan lokasi…',
          ),
          error: (_, __) => _NoLocation(
              onRetry: () => ref.invalidate(qiblaCoordsProvider)),
          data: (bearing) {
            if (bearing == null) {
              return _NoLocation(
                  onRetry: () => ref.invalidate(qiblaCoordsProvider));
            }
            final coords = coordsAsync.valueOrNull;
            final heading = headingAsync.valueOrNull;
            return _QiblaBody(
              bearing: bearing,
              heading: heading,
              fromSaved: coords?.fromSaved ?? false,
              city: coords?.city,
            );
          },
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// BODY — dial (live / statis) + info
// ═══════════════════════════════════════════════════════════════════════════

class _QiblaBody extends ConsumerWidget {
  const _QiblaBody({
    required this.bearing,
    required this.heading,
    required this.fromSaved,
    required this.city,
  });

  final double bearing;
  final double? heading;
  final bool fromSaved;
  final String? city;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final live = heading != null;
    // Live: panah berputar relatif heading. Statis: dial utara di atas,
    // panah menunjuk sudut bearing.
    final angleDeg = live ? (bearing - heading!) : bearing;
    final angleRad = angleDeg * (math.pi / 180);
    final aligned = ((angleDeg % 360) + 360) % 360;
    final isAligned = live && (aligned < 5 || aligned > 355);
    final compass = ref.watch(compassServiceProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      child: Column(
        children: [
          Text(
            live
                ? (isAligned
                    ? 'Kamu sudah menghadap kiblat 🕋'
                    : 'Putar perangkatmu perlahan')
                : 'Arahkan sisi atas HP ke utara, lalu ikuti panah',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: isAligned ? AppColors.goldLight : scheme.onSurface,
            ),
          ),
          const SizedBox(height: 20),
          // ── Dial.
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: scheme.surface,
              shape: BoxShape.circle,
              border: NeoStyle.border(context),
              boxShadow: NeoStyle.shadow(context),
            ),
            child: SizedBox(
              width: 250,
              height: 250,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Penanda utara (mode statis).
                  if (!live)
                    Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        'U',
                        style: TextStyle(
                          fontFamily: 'Space Grotesk',
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: scheme.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: angleRad),
                    duration: const Duration(milliseconds: 300),
                    builder: (ctx, value, _) => Transform.rotate(
                      angle: value,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.navigation,
                            size: 88,
                            color: isAligned
                                ? AppColors.goldLight
                                : scheme.primary,
                          ),
                          const SizedBox(height: 12),
                          const Text('🕋',
                              style: TextStyle(fontSize: 44)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          // ── Angka bearing.
          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  scheme.surface,
                  NeoStyle.tint(context, AppColors.ochre, 0.14),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: NeoStyle.border(context),
              boxShadow: NeoStyle.shadow(context),
            ),
            child: Column(
              children: [
                Text(
                  'ARAH KIBLAT DARI LOKASIMU',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.6,
                    color: scheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${bearing.toStringAsFixed(1)}°',
                  style: TextStyle(
                    fontFamily: 'Space Grotesk',
                    fontSize: 40,
                    fontWeight: FontWeight.w800,
                    height: 1.0,
                    letterSpacing: -0.8,
                    color: scheme.onSurface,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
                Text(
                  'searah jarum jam dari utara sejati',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 12,
                    color: scheme.onSurface.withValues(alpha: 0.62),
                  ),
                ),
                if (live) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Heading kamu: ${heading!.toStringAsFixed(1)}° · selisih ${aligned.toStringAsFixed(1)}°',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      fontFeatures: const [FontFeature.tabularFigures()],
                      color: scheme.onSurface.withValues(alpha: 0.75),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (fromSaved) ...[
            const SizedBox(height: 12),
            _HintRow(
              icon: Icons.history,
              text:
                  'Memakai lokasi tersimpan${city != null ? ' ($city)' : ''} '
                  'karena GPS tidak tersedia.',
            ),
          ],
          if (!live) ...[
            const SizedBox(height: 12),
            _HintRow(
              icon: Icons.explore_off_outlined,
              text: 'Kompas perangkat tidak tersedia. Dial di atas '
                  'menunjukkan sudut tetap dari utara.',
            ),
            if (compass.needsPermissionGesture) ...[
              const SizedBox(height: 14),
              FilledButton.icon(
                onPressed: () async {
                  final ok = await compass.requestPermission();
                  if (ok) ref.invalidate(compassHeadingProvider);
                },
                icon: const Icon(Icons.explore, size: 18),
                label: const Text('Aktifkan kompas'),
              ),
            ],
          ],
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// STATES
// ═══════════════════════════════════════════════════════════════════════════

class _NoLocation extends StatelessWidget {
  const _NoLocation({required this.onRetry});
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                scheme.surface,
                NeoStyle.tint(context, AppColors.terracotta, 0.12),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: NeoStyle.border(context),
            boxShadow: NeoStyle.shadow(context),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.location_off_outlined,
                  size: 40, color: AppColors.terracotta),
              const SizedBox(height: 14),
              Text(
                'Lokasi tidak tersedia',
                style: TextStyle(
                  fontFamily: 'Space Grotesk',
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                  color: scheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Izinkan akses lokasi di browser/HP kamu, atau buka '
                'Jadwal Sholat sekali supaya lokasimu '
                'tersimpan. Kiblat akan memakainya secara otomatis.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 13.5,
                  height: 1.55,
                  color: scheme.onSurface.withValues(alpha: 0.78),
                ),
              ),
              const SizedBox(height: 18),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Coba lagi'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CenterNote extends StatelessWidget {
  const _CenterNote({required this.text, this.spinner = false});
  final String text;
  final bool spinner;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (spinner) ...[
            const SizedBox(
              width: 26,
              height: 26,
              child: CircularProgressIndicator(strokeWidth: 2.5),
            ),
            const SizedBox(height: 14),
          ],
          Text(
            text,
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 14,
              color: scheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}

class _HintRow extends StatelessWidget {
  const _HintRow({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon,
            size: 16, color: scheme.onSurface.withValues(alpha: 0.55)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 12.5,
              height: 1.5,
              color: scheme.onSurface.withValues(alpha: 0.68),
            ),
          ),
        ),
      ],
    );
  }
}
