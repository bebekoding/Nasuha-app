import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/qibla_providers.dart';

class QiblaScreen extends ConsumerWidget {
  const QiblaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bearingAsync = ref.watch(qiblaBearingProvider);
    final headingAsync = ref.watch(compassHeadingProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Arah Kiblat')),
      body: bearingAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (bearing) {
          if (bearing == null) {
            return const Center(child: Text('Lokasi tidak tersedia'));
          }
          return headingAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Compass error: $e')),
            data: (heading) {
              if (heading == null) {
                return const Center(
                    child: Text('Compass tidak tersedia di perangkat ini'));
              }
              final qiblaAngle = (bearing - heading) * (math.pi / 180);
              final aligned = (((bearing - heading) % 360) + 360) % 360;
              final isAligned = aligned < 5 || aligned > 355;

              return SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 16),
                    Text(
                      isAligned
                          ? 'Anda menghadap kiblat 🕋'
                          : 'Putar perangkat Anda',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isAligned
                            ? const Color(0xFFA77B43)
                            : Theme.of(context).colorScheme.outline,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Expanded(
                      child: Center(
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .outlineVariant,
                                    width: 2,
                                  ),
                                ),
                              ),
                              TweenAnimationBuilder<double>(
                                tween: Tween(begin: 0, end: qiblaAngle),
                                duration: const Duration(milliseconds: 300),
                                builder: (ctx, value, _) {
                                  return Transform.rotate(
                                    angle: value,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.navigation,
                                          size: 80,
                                          color: isAligned
                                              ? const Color(0xFFA77B43)
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                        ),
                                        const SizedBox(height: 16),
                                        const Text('🕋',
                                            style: TextStyle(fontSize: 48)),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Text('${aligned.toStringAsFixed(1)}°',
                              style: Theme.of(context).textTheme.titleLarge),
                          const SizedBox(height: 4),
                          Text(
                              'Arah kiblat: ${bearing.toStringAsFixed(1)}° • Anda: ${heading.toStringAsFixed(1)}°',
                              style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
