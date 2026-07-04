import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/muhasabah_enabled_provider.dart';

class _Step {
  final IconData icon;
  final String title;
  final String body;
  const _Step({required this.icon, required this.title, required this.body});
}

const _steps = [
  _Step(
    icon: Icons.self_improvement,
    title: 'Apa itu Muhasabah?',
    body:
        'Evaluasi diri harian — mencatat amal baik dan hal yang perlu '
        'diperbaiki setiap hari, agar lebih sadar menjalani hidup sebagai '
        'seorang Muslim.',
  ),
  _Step(
    icon: Icons.touch_app,
    title: 'Cara menggunakannya',
    body:
        'Setiap hari, ketuk amalan yang sudah Anda kerjakan (sholat, baca '
        'Quran, sedekah, dll) dan catat juga hal yang ingin dikurangi. '
        'Cukup beberapa ketukan.',
  ),
  _Step(
    icon: Icons.insights,
    title: 'Lihat perkembangan',
    body:
        'Setiap catatan menjadi XP harian. Dari sana muncul grafik '
        'perkembangan, streak konsistensi, dan pencapaian — membantu Anda '
        'tetap istiqomah.',
  ),
  _Step(
    icon: Icons.lock_outline,
    title: 'Privasi & pilihan Anda',
    body:
        'Semua data tersimpan di perangkat Anda. Fitur ini opsional — boleh '
        'diaktifkan sekarang atau nanti, dan bisa dimatikan kapan saja lewat '
        'menu Muhasabah.',
  ),
];

class MuhasabahIntroScreen extends ConsumerWidget {
  const MuhasabahIntroScreen({super.key, this.chromeless = false});

  final bool chromeless;

  void _back(BuildContext context) =>
      context.canPop() ? context.pop() : context.go('/');

  Future<void> _activate(BuildContext context, WidgetRef ref) async {
    await ref.read(muhasabahEnabledProvider.notifier).enable();
    // Replace the intro page with the Muhasabah screen while keeping Home
    // beneath it in the stack, so back returns to Home (not exits the app).
    if (context.mounted) context.pushReplacement('/muhasabah');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final body = ListView(
      shrinkWrap: chromeless,
      physics: chromeless
          ? const NeverScrollableScrollPhysics()
          : null,
      padding: chromeless
          ? EdgeInsets.zero
          : const EdgeInsets.fromLTRB(24, 8, 24, 16),
      children: [
          // Hero
          Center(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: scheme.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.self_improvement,
                      size: 52, color: scheme.primary),
                ),
                const SizedBox(height: 16),
                Text(
                  'Selamat datang di Muhasabah',
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 6),
                Text(
                  'Kenali fitur ini sebelum mengaktifkannya',
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: scheme.outline),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // Steps
          for (var i = 0; i < _steps.length; i++) ...[
            _StepCard(step: _steps[i], number: i + 1),
            const SizedBox(height: 12),
          ],
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => _activate(context, ref),
              style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16)),
              child: const Text('Aktifkan Muhasabah',
                  style: TextStyle(fontWeight: FontWeight.w700)),
            ),
          ),
          const SizedBox(height: 4),
          Center(
            child: TextButton(
              onPressed: () => _back(context),
              child: const Text('Nanti saja'),
            ),
          ),
          const SizedBox(height: 8),
        ],
      );
    if (chromeless) return body;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => _back(context),
        ),
        title: const Text('Muhasabah'),
      ),
      body: body,
    );
  }
}

class _StepCard extends StatelessWidget {
  const _StepCard({required this.step, required this.number});
  final _Step step;
  final int number;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: scheme.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(step.icon, color: scheme.primary, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(step.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 15)),
                const SizedBox(height: 4),
                Text(step.body,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurfaceVariant, height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
