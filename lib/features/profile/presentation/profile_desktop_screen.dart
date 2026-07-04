import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../config/theme/app_colors.dart';
import '../../../core/widgets/desktop_page_shell.dart';
import '../../settings/presentation/providers/settings_providers.dart';
import 'profile_actions.dart';
import 'profile_stats_provider.dart';

/// Profile desktop (width >= 800). 2-col: kiri avatar besar + name + city
/// + tombol edit. Kanan grid statistik (streak/XP/rank/achievements).
class ProfileDesktopScreen extends ConsumerWidget {
  const ProfileDesktopScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsControllerProvider);
    final statsAsync = ref.watch(profileStatsProvider);

    return DesktopPageShell(
      currentRoute: '/profile',
      eyebrow: 'PROFIL',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Header(),
          const SizedBox(height: 28),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: 420,
                  child: _IdentityCard(
                    displayName: settings.displayName,
                    photoPath: settings.photoPath,
                    city: settings.city,
                    onEditName: () => editProfileName(
                        context, ref, settings.displayName),
                    onChangePhoto: () => changeProfilePhoto(context, ref),
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(child: _StatsPanel(statsAsync: statsAsync)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _ShortcutRow(),
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
          'Profil kamu',
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
          'Data pribadi ini hanya di HP kamu. Nasuha tidak menyimpannya di server.',
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
// IDENTITY CARD — kiri
// ═══════════════════════════════════════════════════════════════════════════

class _IdentityCard extends StatelessWidget {
  const _IdentityCard({
    required this.displayName,
    required this.photoPath,
    required this.city,
    required this.onEditName,
    required this.onChangePhoto,
  });

  final String? displayName;
  final String? photoPath;
  final String? city;
  final VoidCallback onEditName;
  final VoidCallback onChangePhoto;

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
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: _AvatarButton(
              photoPath: photoPath,
              initials: profileInitials(displayName),
              onTap: onChangePhoto,
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: _EditableName(
              name: displayName,
              onTap: onEditName,
            ),
          ),
          if (city != null && city!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.location_on_outlined,
                      size: 14,
                      color: scheme.onSurface.withValues(alpha: 0.6)),
                  const SizedBox(width: 4),
                  Text(
                    city!,
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 13,
                      color: scheme.onSurface.withValues(alpha: 0.72),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 28),
          _ProfileAction(
              icon: Icons.settings_outlined,
              label: 'Pengaturan aplikasi',
              onTap: () => GoRouter.of(context).push('/settings'),
              accent: AppColors.coffee),
          const SizedBox(height: 10),
          _ProfileAction(
              icon: Icons.cloud_sync_outlined,
              label: 'Akun & pemulihan',
              onTap: () => GoRouter.of(context).push('/backup'),
              accent: AppColors.caramel),
          const SizedBox(height: 10),
          _ProfileAction(
              icon: Icons.emoji_events_outlined,
              label: 'Pencapaian',
              onTap: () => GoRouter.of(context).push('/achievements'),
              accent: AppColors.goldLight),
        ],
      ),
    );
  }
}

class _AvatarButton extends StatefulWidget {
  const _AvatarButton({
    required this.photoPath,
    required this.initials,
    required this.onTap,
  });

  final String? photoPath;
  final String initials;
  final VoidCallback onTap;

  @override
  State<_AvatarButton> createState() => _AvatarButtonState();
}

class _AvatarButtonState extends State<_AvatarButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOut,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [scheme.primary, AppColors.goldLight],
                ),
                boxShadow: _hover
                    ? [
                        BoxShadow(
                          color: scheme.primary.withValues(alpha: 0.32),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ]
                    : [],
              ),
              child: CircleAvatar(
                radius: 68,
                backgroundColor: scheme.surface,
                child: _AvatarInner(
                    photoPath: widget.photoPath,
                    initials: widget.initials),
              ),
            ),
            Positioned(
              right: 6,
              bottom: 6,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: scheme.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: scheme.surface, width: 3),
                ),
                child: const Icon(Icons.camera_alt,
                    size: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AvatarInner extends StatelessWidget {
  const _AvatarInner({required this.photoPath, required this.initials});
  final String? photoPath;
  final String initials;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final img = _resolveImage();
    if (img != null) {
      return ClipOval(
          child: Image(image: img, width: 132, height: 132, fit: BoxFit.cover));
    }
    return Text(
      initials.isEmpty ? '🕌' : initials,
      style: TextStyle(
        fontFamily: 'Space Grotesk',
        fontSize: 44,
        fontWeight: FontWeight.w800,
        color: scheme.primary,
      ),
    );
  }

  ImageProvider? _resolveImage() {
    final p = photoPath;
    if (p == null || p.isEmpty) return null;
    if (p.startsWith('data:')) {
      final commaIdx = p.indexOf(',');
      if (commaIdx == -1) return null;
      try {
        final bytes = base64Decode(p.substring(commaIdx + 1));
        return MemoryImage(bytes);
      } catch (_) {
        return null;
      }
    }
    if (kIsWeb) return null;
    try {
      final f = File(p);
      if (!f.existsSync()) return null;
      return FileImage(f);
    } catch (_) {
      return null;
    }
  }
}

class _EditableName extends StatefulWidget {
  const _EditableName({required this.name, required this.onTap});
  final String? name;
  final VoidCallback onTap;

  @override
  State<_EditableName> createState() => _EditableNameState();
}

class _EditableNameState extends State<_EditableName> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.name?.isNotEmpty == true ? widget.name! : 'Hamba Allah',
              style: TextStyle(
                fontFamily: 'Space Grotesk',
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: scheme.onSurface,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(width: 8),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 180),
              opacity: _hover ? 1.0 : 0.55,
              child: Icon(Icons.edit_outlined,
                  size: 18, color: scheme.primary),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileAction extends StatefulWidget {
  const _ProfileAction({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.accent,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color accent;

  @override
  State<_ProfileAction> createState() => _ProfileActionState();
}

class _ProfileActionState extends State<_ProfileAction> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding:
              const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          decoration: BoxDecoration(
            color: _hover
                ? widget.accent.withValues(alpha: 0.08)
                : scheme.onSurface.withValues(alpha: 0.03),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: _hover
                  ? widget.accent.withValues(alpha: 0.32)
                  : scheme.outline.withValues(alpha: 0.14),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(widget.icon, color: widget.accent, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.label,
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: scheme.onSurface,
                  ),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                transform:
                    Matrix4.translationValues(_hover ? 4 : 0, 0, 0),
                child: Icon(Icons.arrow_forward,
                    size: 16, color: widget.accent),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// STATS PANEL — kanan
// ═══════════════════════════════════════════════════════════════════════════

class _StatsPanel extends StatelessWidget {
  const _StatsPanel({required this.statsAsync});
  final AsyncValue<ProfileStats> statsAsync;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final fmt = NumberFormat.decimalPattern('id_ID');
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
            color: scheme.outline.withValues(alpha: 0.16), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Statistik ibadah',
            style: TextStyle(
              fontFamily: 'Space Grotesk',
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: scheme.onSurface,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Angka total sejak kamu mulai pakai Nasuha.',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 13,
              color: scheme.onSurface.withValues(alpha: 0.72),
            ),
          ),
          const SizedBox(height: 20),
          statsAsync.when(
            loading: () => const Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => Text('Error: $e'),
            data: (s) => Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _StatBox(
                        accent: AppColors.goldLight,
                        icon: Icons.local_fire_department,
                        label: 'STREAK SAAT INI',
                        value: '${s.currentStreak}',
                        unit: 'hari',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatBox(
                        accent: AppColors.terracotta,
                        icon: Icons.emoji_flags,
                        label: 'STREAK TERPANJANG',
                        value: '${s.longestStreak}',
                        unit: 'hari',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _StatBox(
                        accent: AppColors.coffee,
                        icon: Icons.bolt,
                        label: 'TOTAL XP',
                        value: fmt.format(s.lifetimeScore),
                        unit: 'XP',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatBox(
                        accent: AppColors.caramel,
                        icon: Icons.calendar_month,
                        label: 'HARI AKTIF',
                        value: '${s.totalDays}',
                        unit: 'hari',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _StatBox(
                        accent: AppColors.clay,
                        icon: Icons.volunteer_activism,
                        label: 'SEDEKAH DICATAT',
                        value: '${s.charityCount}',
                        unit: 'kali',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatBox(
                        accent: AppColors.ochre,
                        icon: Icons.emoji_events,
                        label: 'PENCAPAIAN',
                        value: '${s.achievementsUnlocked}',
                        unit: '/ ${s.achievementsTotal}',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({
    required this.accent,
    required this.icon,
    required this.label,
    required this.value,
    required this.unit,
  });
  final Color accent;
  final IconData icon;
  final String label;
  final String value;
  final String unit;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: scheme.onSurface.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: accent.withValues(alpha: 0.22), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(icon, color: accent, size: 16),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.4,
                    color: accent,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontFamily: 'Space Grotesk',
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: scheme.onSurface,
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                unit,
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 12,
                  color: scheme.onSurface.withValues(alpha: 0.62),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// SHORTCUT ROW — cepat ke fitur populer
// ═══════════════════════════════════════════════════════════════════════════

class _ShortcutRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: HoverLiftCard(
            onTap: () => GoRouter.of(context).push('/analytics'),
            accent: AppColors.terracotta,
            borderRadius: 16,
            padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            lift: 3,
            child: Row(
              children: [
                Icon(Icons.bar_chart,
                    size: 20, color: AppColors.terracotta),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Lihat analitik ritme ibadahmu',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
                const Icon(Icons.arrow_forward,
                    size: 16, color: AppColors.terracotta),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: HoverLiftCard(
            onTap: () => GoRouter.of(context).push('/rank'),
            accent: AppColors.goldLight,
            borderRadius: 16,
            padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            lift: 3,
            child: Row(
              children: [
                Icon(Icons.emoji_events,
                    size: 20, color: AppColors.goldLight),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Lihat peringkat & perjalanan level',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
                const Icon(Icons.arrow_forward,
                    size: 16, color: AppColors.goldLight),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
