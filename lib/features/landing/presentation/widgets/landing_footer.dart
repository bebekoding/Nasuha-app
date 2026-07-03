import 'package:flutter/material.dart';

class LandingFooter extends StatelessWidget {
  const LandingFooter({super.key, required this.onFeatureTap});

  final VoidCallback onFeatureTap;

  static const _bg = Color(0xFF221A12);
  static const _ink = Color(0xFFF0E8DB);
  static const _muted = Color(0xFFB4A691);
  static const _hairline = Color(0xFF453826);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _bg,
      padding: const EdgeInsets.only(top: 80, bottom: 32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 3, child: _BrandCol()),
                    const SizedBox(width: 32),
                    Expanded(
                      flex: 2,
                      child: _Col(
                        title: 'Fitur',
                        items: const [
                          'Muhasabah',
                          'Al-Quran',
                          'Dzikir',
                          'Sedekah',
                          'Analitik',
                        ],
                        onTap: (_) => onFeatureTap(),
                      ),
                    ),
                    const SizedBox(width: 32),
                    Expanded(
                      flex: 2,
                      child: _Col(
                        title: 'Nasuha',
                        items: const [
                          'Filosofi',
                          'Privasi',
                          'Ubah nama',
                        ],
                      ),
                    ),
                    const SizedBox(width: 32),
                    Expanded(
                      flex: 2,
                      child: _Col(
                        title: 'Bantuan',
                        items: const [
                          'FAQ',
                          'Kontak',
                          'Kirim masukan',
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 64),
                Container(height: 1, color: _hairline),
                const SizedBox(height: 24),
                Row(
                  children: [
                    const Text(
                      '© 2026 Nasuha  ·  Made with 🤍 in Indonesia',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: _muted,
                      ),
                    ),
                    const Spacer(),
                    _MutedLink(
                      icon: Icons.code_rounded,
                      label: 'GitHub',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BrandCol extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFF362B1E),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(2),
              child: Image.asset(
                'assets/icon/nasuha_icon_fg.png',
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'Nasuha',
              style: TextStyle(
                fontFamily: 'Space Grotesk',
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: LandingFooter._ink,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          'Level up your soul · Level up your amal',
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 14,
            height: 1.6,
            fontWeight: FontWeight.w400,
            color: LandingFooter._muted,
          ),
        ),
      ],
    );
  }
}

class _Col extends StatelessWidget {
  const _Col({required this.title, required this.items, this.onTap});

  final String title;
  final List<String> items;
  final void Function(String)? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: LandingFooter._ink,
            letterSpacing: 0.08 * 12,
          ),
        ),
        const SizedBox(height: 16),
        for (final item in items) ...[
          _FooterLink(label: item, onTap: () => onTap?.call(item)),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _FooterLink extends StatefulWidget {
  const _FooterLink({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  State<_FooterLink> createState() => _FooterLinkState();
}

class _FooterLinkState extends State<_FooterLink> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 200),
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: _hover ? const Color(0xFFDDBE7C) : LandingFooter._muted,
          ),
          child: Text(widget.label),
        ),
      ),
    );
  }
}

class _MutedLink extends StatelessWidget {
  const _MutedLink({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: LandingFooter._muted),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: LandingFooter._muted,
          ),
        ),
      ],
    );
  }
}
