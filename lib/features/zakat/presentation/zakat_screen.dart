import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../config/theme/app_colors.dart';
import '../../../config/theme/app_fonts.dart';
import '../../../config/theme/neo_style.dart';

/// Hub Zakat — dua sub-menu (Zakat Mal & Zakat Fitrah) + dalil pembuka.
///
/// [chromeless] true = dipakai di desktop web via _desktopWrapOr (tanpa
/// Scaffold/AppBar — shell yang menyediakan chrome + scroll).
class ZakatScreen extends StatelessWidget {
  const ZakatScreen({super.key, this.chromeless = false});
  final bool chromeless;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Dalil pembuka: perintah zakat.
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.goldLight.withValues(alpha: 0.08),
                AppColors.goldLight.withValues(alpha: 0.18),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
                color: AppColors.goldLight.withValues(alpha: 0.5),
                width: 1.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'خُذْ مِنْ أَمْوَالِهِمْ صَدَقَةً تُطَهِّرُهُمْ وَتُزَكِّيهِمْ بِهَا',
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontFamily: arabicFontFamily,
                  fontSize: 24,
                  height: 2.0,
                  color: scheme.onSurface,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '"Ambillah zakat dari harta mereka, guna membersihkan '
                'dan menyucikan mereka…"',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 13.5,
                  height: 1.6,
                  fontStyle: FontStyle.italic,
                  color: scheme.onSurface.withValues(alpha: 0.85),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'QS At-Taubah: 103',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.goldLight,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Pilih jenis zakat',
          style: TextStyle(
            fontFamily: 'Space Grotesk',
            fontSize: 22,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.4,
            color: scheme.onSurface,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Kalkulator sesuai nash Al-Quran & hadits shahih.',
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 13.5,
            height: 1.5,
            color: scheme.onSurface.withValues(alpha: 0.72),
          ),
        ),
        const SizedBox(height: 16),
        _SubmenuCard(
          accent: AppColors.ochre,
          icon: Icons.paid,
          title: 'Zakat Mal',
          subtitle:
              'Harta simpanan setahun — tabungan, emas, dagangan. '
              'Nisab 85 gram emas · kadar 2,5%.',
          badge: 'HR Abu Dawud 1573 — shahih',
          onTap: () => context.push('/zakat/mal'),
        ),
        const SizedBox(height: 14),
        _SubmenuCard(
          accent: AppColors.caramel,
          icon: Icons.rice_bowl,
          title: 'Zakat Fitrah',
          subtitle:
              'Penyuci jiwa di penghujung Ramadhan — satu sha’ '
              '(±2,5 kg beras) untuk setiap jiwa.',
          badge: 'HR Bukhari 1503 · Muslim 984',
          onTap: () => context.push('/zakat/fitrah'),
        ),
      ],
    );

    if (chromeless) return content;

    return Scaffold(
      appBar: AppBar(title: const Text('Zakat')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          child: content,
        ),
      ),
    );
  }
}

class _SubmenuCard extends StatefulWidget {
  const _SubmenuCard({
    required this.accent,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.onTap,
  });

  final Color accent;
  final IconData icon;
  final String title;
  final String subtitle;
  final String badge;
  final VoidCallback onTap;

  @override
  State<_SubmenuCard> createState() => _SubmenuCardState();
}

class _SubmenuCardState extends State<_SubmenuCard> {
  bool _pressed = false;
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    final a = widget.accent;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOutQuart,
            // Neo-brutal: press masuk ke bayangan, hover terangkat.
            transform: reduceMotion
                ? Matrix4.identity()
                : (_pressed
                    ? Matrix4.translationValues(3, 3, 0)
                    : (_hover
                        ? Matrix4.translationValues(-2, -2, 0)
                        : Matrix4.identity())),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  scheme.surface,
                  NeoStyle.tint(context, a, isDark ? 0.12 : 0.08),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: NeoStyle.border(context),
              boxShadow: NeoStyle.shadow(context,
                  offset: _pressed ? 1 : (_hover ? 6 : 4)),
            ),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: a.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(widget.icon, color: a, size: 26),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(
                          fontFamily: 'Space Grotesk',
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.3,
                          color: scheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.subtitle,
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 12.5,
                          height: 1.5,
                          color: scheme.onSurface.withValues(alpha: 0.75),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: a.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          widget.badge,
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.3,
                            color: a,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOutQuart,
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _hover ? a : Colors.transparent,
                    border: Border.all(color: a, width: 1.5),
                  ),
                  child: Icon(Icons.arrow_forward,
                      size: 17, color: _hover ? Colors.white : a),
                ),
              ],
            ),
        ),
      ),
    );
  }
}
