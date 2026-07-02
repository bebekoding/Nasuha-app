import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../config/theme/theme_controller.dart';
import '../../../core/constants/app_constants.dart';

class _Page {
  final String icon;
  final String title;
  final String description;
  const _Page(this.icon, this.title, this.description);
}

const _pages = [
  _Page(
    '🕌',
    'Selamat datang di Nasuha',
    'Sahabat pertumbuhan diri Anda — semua data milik Anda, hanya untuk Anda.',
  ),
  _Page(
    '📿',
    'Catat amal harian Anda',
    'Tag positif menambah XP, tag negatif menguranginya. Sederhana dan jujur pada diri sendiri.',
  ),
  _Page(
    '📈',
    'Lihat perjalanan spiritual',
    'Grafik, heatmap, dan streak membantu Anda istiqomah hari demi hari.',
  ),
  _Page(
    '🔒',
    'Privasi adalah prioritas',
    'Tanpa fitur sosial, tanpa leaderboard, tanpa perbandingan. Hanya Anda dan Allah.',
  ),
];

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _controller = PageController();
  int _index = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    final prefs = ref.read(sharedPrefsProvider);
    await prefs.setBool(AppConstants.prefsOnboardingDone, true);
    if (mounted) context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _index = i),
                itemBuilder: (ctx, i) {
                  final p = _pages[i];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(p.icon, style: const TextStyle(fontSize: 96)),
                        const SizedBox(height: 24),
                        Text(p.title,
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(fontWeight: FontWeight.w800)),
                        const SizedBox(height: 12),
                        Text(p.description,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyLarge),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_pages.length, (i) {
                final selected = i == _index;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  height: 8,
                  width: selected ? 24 : 8,
                  decoration: BoxDecoration(
                    color: selected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(99),
                  ),
                );
              }),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: FilledButton(
                onPressed: () {
                  if (_index < _pages.length - 1) {
                    _controller.nextPage(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                    );
                  } else {
                    _finish();
                  }
                },
                child: Text(
                    _index < _pages.length - 1 ? 'Lanjut' : 'Mulai'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
