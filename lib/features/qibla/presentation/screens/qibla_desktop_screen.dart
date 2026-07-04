import 'dart:math' as math;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../core/widgets/desktop_page_shell.dart';
import '../providers/qibla_providers.dart';

/// Arah Kiblat desktop (width >= 800). 2-col: kiri compass rose besar
/// dengan arrow tween ke bearing Ka'bah. Kanan info card lokasi + hint
/// + web-limitation notice (browser jarang expose compass).
class QiblaDesktopScreen extends ConsumerWidget {
  const QiblaDesktopScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bearingAsync = ref.watch(qiblaBearingProvider);
    final headingAsync = ref.watch(compassHeadingProvider);

    return DesktopPageShell(
      currentRoute: '/qibla',
      eyebrow: 'ARAH KIBLAT',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Header(),
          const SizedBox(height: 28),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 3,
                  child: _CompassPanel(
                    bearingAsync: bearingAsync,
                    headingAsync: headingAsync,
                  ),
                ),
                const SizedBox(width: 24),
                SizedBox(
                  width: 380,
                  child: _InfoPanel(bearingAsync: bearingAsync),
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

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text(
          'Arah kiblat',
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
          'Sudut menghadap Ka\'bah dari lokasi kamu, dihitung real-time.',
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

// ═══════════════════════════════════════════════════════════════════════════
// COMPASS PANEL — kiri
// ═══════════════════════════════════════════════════════════════════════════

class _CompassPanel extends StatelessWidget {
  const _CompassPanel({
    required this.bearingAsync,
    required this.headingAsync,
  });
  final AsyncValue<double?> bearingAsync;
  final AsyncValue<double?> headingAsync;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(32),
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
      child: bearingAsync.when(
        loading: () => const _LoadingBlock(msg: 'Mendapatkan lokasi…'),
        error: (e, _) => _MessageBlock(
          icon: Icons.error_outline,
          title: 'Tidak bisa ambil lokasi',
          message: '$e',
          accent: AppColors.clay,
        ),
        data: (bearing) {
          if (bearing == null) {
            return const _MessageBlock(
              icon: Icons.location_off_outlined,
              title: 'Lokasi tidak tersedia',
              message:
                  'Aktifkan izin lokasi di browser agar Nasuha bisa menghitung sudut ke Ka\'bah.',
              accent: AppColors.terracotta,
            );
          }
          return headingAsync.when(
            loading: () =>
                _StaticCompass(bearing: bearing, headingKnown: false),
            error: (e, _) => _MessageBlock(
              icon: Icons.explore_off_outlined,
              title: 'Compass tak tersedia',
              message: kIsWeb
                  ? 'Browser desktop biasanya tidak expose magnetometer. '
                      'Buka Nasuha di HP untuk kompas real-time. Sementara, '
                      'sudut absolut ke Ka\'bah bisa dibaca di panel kanan.'
                  : '$e',
              accent: AppColors.terracotta,
            ),
            data: (heading) {
              if (heading == null) {
                return _StaticCompass(
                    bearing: bearing, headingKnown: false);
              }
              return _LiveCompass(bearing: bearing, heading: heading);
            },
          );
        },
      ),
    );
  }
}

class _LiveCompass extends StatelessWidget {
  const _LiveCompass({required this.bearing, required this.heading});
  final double bearing;
  final double heading;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final qiblaAngle = (bearing - heading) * (math.pi / 180);
    final aligned = (((bearing - heading) % 360) + 360) % 360;
    final isAligned = aligned < 5 || aligned > 355;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _AlignmentBanner(isAligned: isAligned),
        const SizedBox(height: 20),
        AspectRatio(
          aspectRatio: 1,
          child: Stack(
            alignment: Alignment.center,
            children: [
              _CompassRing(),
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: qiblaAngle),
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutCubic,
                builder: (ctx, value, _) {
                  return Transform.rotate(
                    angle: value,
                    child: _KaabaArrow(isAligned: isAligned),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Bearing ke Ka\'bah: ${bearing.toStringAsFixed(1)}° · Heading kamu: ${heading.toStringAsFixed(1)}°',
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 13,
            color: scheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}

class _StaticCompass extends StatelessWidget {
  const _StaticCompass({required this.bearing, required this.headingKnown});
  final double bearing;
  final bool headingKnown;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    // Tunjukkan compass "north-up" dengan arrow ke bearing absolut.
    final angle = bearing * (math.pi / 180);
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.caramel.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            'MODE STATIS · UTARA DI ATAS',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.4,
              color: AppColors.caramel,
            ),
          ),
        ),
        const SizedBox(height: 20),
        AspectRatio(
          aspectRatio: 1,
          child: Stack(
            alignment: Alignment.center,
            children: [
              _CompassRing(),
              Transform.rotate(
                angle: angle,
                child: const _KaabaArrow(isAligned: false),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Sudut absolut ke Ka\'bah: ${bearing.toStringAsFixed(1)}° dari utara',
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 13,
            color: scheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}

class _AlignmentBanner extends StatelessWidget {
  const _AlignmentBanner({required this.isAligned});
  final bool isAligned;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isAligned
            ? AppColors.caramel.withValues(alpha: 0.16)
            : scheme.onSurface.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: isAligned
              ? AppColors.caramel
              : scheme.outline.withValues(alpha: 0.22),
          width: 1.4,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isAligned ? Icons.check_circle : Icons.rotate_right,
            size: 16,
            color: isAligned
                ? AppColors.caramel
                : scheme.onSurface.withValues(alpha: 0.6),
          ),
          const SizedBox(width: 8),
          Text(
            isAligned
                ? 'Kamu menghadap kiblat'
                : 'Putar perangkat sampai panah lurus ke atas',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: isAligned
                  ? AppColors.caramel
                  : scheme.onSurface.withValues(alpha: 0.72),
            ),
          ),
        ],
      ),
    );
  }
}

class _CompassRing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                scheme.surface,
                AppColors.caramel.withValues(alpha: 0.06),
              ],
            ),
            border: Border.all(
                color: scheme.outline.withValues(alpha: 0.24), width: 1.4),
          ),
        ),
        // Rose lines
        for (int i = 0; i < 12; i++)
          Transform.rotate(
            angle: (i * 30) * (math.pi / 180),
            child: FractionallySizedBox(
              heightFactor: 1.0,
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Column(
                  children: [
                    Container(
                      width: i % 3 == 0 ? 2 : 1,
                      height: i % 3 == 0 ? 22 : 14,
                      color: i % 3 == 0
                          ? scheme.onSurface.withValues(alpha: 0.35)
                          : scheme.onSurface.withValues(alpha: 0.16),
                    ),
                  ],
                ),
              ),
            ),
          ),
        // Cardinal labels
        Positioned(top: 30, child: _Cardinal(label: 'U', accent: true)),
        Positioned(bottom: 30, child: _Cardinal(label: 'S')),
        Positioned(left: 30, child: _Cardinal(label: 'B')),
        Positioned(right: 30, child: _Cardinal(label: 'T')),
      ],
    );
  }
}

class _Cardinal extends StatelessWidget {
  const _Cardinal({required this.label, this.accent = false});
  final String label;
  final bool accent;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Text(
      label,
      style: TextStyle(
        fontFamily: 'Space Grotesk',
        fontSize: 14,
        fontWeight: FontWeight.w800,
        color: accent
            ? AppColors.terracotta
            : scheme.onSurface.withValues(alpha: 0.6),
        letterSpacing: 0.4,
      ),
    );
  }
}

class _KaabaArrow extends StatelessWidget {
  const _KaabaArrow({required this.isAligned});
  final bool isAligned;

  @override
  Widget build(BuildContext context) {
    final color =
        isAligned ? AppColors.caramel : AppColors.terracotta;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('🕋',
            style: TextStyle(
              fontSize: 42,
              shadows: [
                Shadow(
                  color: color.withValues(alpha: 0.4),
                  blurRadius: 16,
                ),
              ],
            )),
        const SizedBox(height: 4),
        Container(
          width: 3,
          height: 130,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            border: Border.all(color: Colors.white, width: 2),
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// INFO PANEL — kanan
// ═══════════════════════════════════════════════════════════════════════════

class _InfoPanel extends StatelessWidget {
  const _InfoPanel({required this.bearingAsync});
  final AsyncValue<double?> bearingAsync;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                scheme.surface,
                AppColors.caramel.withValues(alpha: 0.10),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
                color: AppColors.caramel.withValues(alpha: 0.32),
                width: 1.4),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.caramel.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text('🕋',
                        style: TextStyle(fontSize: 20)),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Ka\'bah — Mekkah',
                    style: TextStyle(
                      fontFamily: 'Space Grotesk',
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: scheme.onSurface,
                      letterSpacing: -0.3,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              bearingAsync.when(
                loading: () => Text(
                  'Menghitung sudut…',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 13,
                    color: scheme.onSurface.withValues(alpha: 0.72),
                  ),
                ),
                error: (_, __) => Text(
                  'Belum bisa dihitung.',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 13,
                    color: scheme.onSurface.withValues(alpha: 0.72),
                  ),
                ),
                data: (bearing) => Text(
                  bearing == null
                      ? 'Belum bisa dihitung — cek izin lokasi.'
                      : 'Sudut absolut ke Ka\'bah dari utara: '
                          '${bearing.toStringAsFixed(1)}°',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 13,
                    height: 1.55,
                    fontWeight: FontWeight.w500,
                    color: scheme.onSurface.withValues(alpha: 0.85),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _TipCard(
          icon: Icons.phone_iphone,
          title: 'Pakai HP untuk kompas real-time',
          body:
              'Browser desktop biasanya tidak izinkan akses magnetometer. Buka nasuha-app.vercel.app di HP kamu — kompas akan otomatis mengikuti arah HP.',
          accent: AppColors.clay,
        ),
        const SizedBox(height: 12),
        _TipCard(
          icon: Icons.info_outline,
          title: 'Cara membaca sudut',
          body:
              'Angka bearing adalah sudut searah jarum jam dari utara sejati. Contoh: 295° = utara-barat.',
          accent: AppColors.coffee,
        ),
        const SizedBox(height: 12),
        _TipCard(
          icon: Icons.self_improvement,
          title: 'Kalau ragu',
          body:
              'Cek dengan aplikasi kompas HP kamu, atau tanyakan pada masjid terdekat. Nasuha memakai perhitungan great-circle standar.',
          accent: AppColors.ochre,
        ),
      ],
    );
  }
}

class _TipCard extends StatelessWidget {
  const _TipCard({
    required this.icon,
    required this.title,
    required this.body,
    required this.accent,
  });
  final IconData icon;
  final String title;
  final String body;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: scheme.outline.withValues(alpha: 0.16), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(icon, color: accent, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Space Grotesk',
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: scheme.onSurface,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  body,
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 12,
                    height: 1.5,
                    color: scheme.onSurface.withValues(alpha: 0.78),
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
// MESSAGE / LOADING BLOCKS
// ═══════════════════════════════════════════════════════════════════════════

class _LoadingBlock extends StatelessWidget {
  const _LoadingBlock({required this.msg});
  final String msg;
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: 500,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            Text(
              msg,
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 13,
                color: scheme.onSurface.withValues(alpha: 0.72),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageBlock extends StatelessWidget {
  const _MessageBlock({
    required this.icon,
    required this.title,
    required this.message,
    required this.accent,
  });
  final IconData icon;
  final String title;
  final String message;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: 480,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: accent.withValues(alpha: 0.14),
                ),
                child: Icon(icon, size: 34, color: accent),
              ),
              const SizedBox(height: 20),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Space Grotesk',
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: scheme.onSurface,
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 14,
                  height: 1.55,
                  color: scheme.onSurface.withValues(alpha: 0.75),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
