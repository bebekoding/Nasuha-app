import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import '../../settings/presentation/providers/settings_providers.dart';
import 'profile_stats_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsControllerProvider);
    final statsAsync = ref.watch(profileStatsProvider);
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Avatar + name ──────────────────────────────────────
          Center(
            child: Column(
              children: [
                GestureDetector(
                  onTap: () => _changePhoto(context, ref),
                  child: Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [scheme.primary, scheme.tertiary],
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 46,
                          backgroundColor: scheme.surface,
                          child: _AvatarInner(
                            photoPath: settings.photoPath,
                            initials: _initials(settings.displayName),
                          ),
                        ),
                      ),
                      // Badge kamera — penanda avatar bisa diketuk
                      Positioned(
                        right: 2,
                        bottom: 2,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: scheme.primary,
                            shape: BoxShape.circle,
                            border:
                                Border.all(color: scheme.surface, width: 2),
                          ),
                          child: Icon(Icons.camera_alt,
                              size: 14, color: scheme.onPrimary),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () => _editName(context, ref, settings.displayName),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          settings.displayName?.isNotEmpty == true
                              ? settings.displayName!
                              : 'Hamba Allah',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(width: 6),
                        Icon(Icons.edit_outlined,
                            size: 16, color: scheme.outline),
                      ],
                    ),
                  ),
                ),
                if (settings.city != null)
                  Text(
                    settings.city!,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: scheme.outline),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // ── Stats grid ─────────────────────────────────────────
          statsAsync.when(
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (e, _) => Text('Gagal memuat statistik: $e'),
            data: (s) => GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.7,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              children: [
                _StatCard(
                  icon: Icons.local_fire_department,
                  label: 'Streak saat ini',
                  value: '${s.currentStreak} hari',
                  color: const Color(0xFFC1923C),
                ),
                _StatCard(
                  icon: Icons.emoji_events,
                  label: 'Streak terpanjang',
                  value: '${s.longestStreak} hari',
                  color: const Color(0xFFC17A53),
                ),
                _StatCard(
                  icon: Icons.calendar_month,
                  label: 'Total hari muhasabah',
                  value: '${s.totalDays}',
                  color: const Color(0xFFA77B43),
                ),
                _StatCard(
                  icon: Icons.insights,
                  label: 'Total XP',
                  value: '${s.lifetimeScore}',
                  color: scheme.primary,
                ),
                _StatCard(
                  icon: Icons.volunteer_activism,
                  label: 'Total sedekah',
                  value: NumberFormat.compactCurrency(
                    locale: 'id_ID',
                    symbol: 'Rp',
                    decimalDigits: 0,
                  ).format(s.totalCharity),
                  color: const Color(0xFFB5613F),
                ),
                _StatCard(
                  icon: Icons.military_tech,
                  label: 'Pencapaian',
                  value: '${s.achievementsUnlocked}/${s.achievementsTotal}',
                  color: const Color(0xFFA77B43),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // ── Menu list ──────────────────────────────────────────
          Card(
            child: Column(
              children: [
                _tile(context, Icons.emoji_events_outlined, 'Pencapaian',
                    '/achievements'),
                _divider(context),
                _tile(context, Icons.bar_chart, 'Analitik', '/analytics'),
                _divider(context),
                _tile(context, Icons.history, 'Riwayat Muhasabah',
                    '/muhasabah/history'),
                _divider(context),
                _tile(context, Icons.cloud_sync_outlined, 'Akun & Pemulihan',
                    '/backup'),
                _divider(context),
                _tile(context, Icons.settings_outlined, 'Pengaturan',
                    '/settings'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              'Nasuha • Level up your soul · Level up your amal',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: scheme.outline),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tile(
      BuildContext context, IconData icon, String title, String route) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right, size: 20),
      onTap: () => context.push(route),
    );
  }

  Widget _divider(BuildContext context) =>
      Divider(height: 1, indent: 56, color: Theme.of(context).dividerColor);

  String _initials(String? name) {
    if (name == null || name.trim().isEmpty) return '🕌';
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) {
      return parts.first.characters.take(1).toString().toUpperCase();
    }
    return (parts.first.characters.take(1).toString() +
            parts[1].characters.take(1).toString())
        .toUpperCase();
  }

  Future<void> _editName(
      BuildContext context, WidgetRef ref, String? current) async {
    final ctrl = TextEditingController(text: current ?? '');
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ubah Nama'),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(hintText: 'Nama panggilan'),
          onSubmitted: (v) => Navigator.of(ctx).pop(v.trim()),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Batal')),
          FilledButton(
              onPressed: () => Navigator.of(ctx).pop(ctrl.text.trim()),
              child: const Text('Simpan')),
        ],
      ),
    );
    if (result != null) {
      await ref.read(settingsControllerProvider.notifier).update(
            (s) => s..displayName = result.isEmpty ? null : result,
          );
    }
  }

  Future<void> _changePhoto(BuildContext context, WidgetRef ref) async {
    final current = ref.read(settingsControllerProvider).photoPath;
    final hasPhoto = current != null && current.isNotEmpty && _photoExists(current);

    final action = await showModalBottomSheet<String>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Pilih dari galeri'),
              onTap: () => Navigator.of(ctx).pop('pick'),
            ),
            if (hasPhoto)
              ListTile(
                leading: const Icon(Icons.delete_outline),
                title: const Text('Hapus foto'),
                onTap: () => Navigator.of(ctx).pop('remove'),
              ),
          ],
        ),
      ),
    );

    if (action == 'pick') {
      // Di web, `path` tak tersedia — minta bytes langsung. Simpan sebagai
      // data URL (base64) di kolom photoPath supaya schema tetap `String`.
      final res = await FilePicker.platform.pickFiles(
        type: FileType.image,
        withData: kIsWeb,
      );
      final picked = res?.files.single;
      if (picked == null) return;

      String? next;
      if (kIsWeb) {
        final Uint8List? bytes = picked.bytes;
        if (bytes == null) return;
        final ext = (picked.extension ?? 'png').toLowerCase();
        final mime = _mimeFromExt(ext);
        next = 'data:$mime;base64,${base64Encode(bytes)}';
      } else {
        final path = picked.path;
        if (path == null) return;
        // Salin ke folder app dengan nama unik (timestamp) supaya cache
        // gambar Flutter ikut ter-refresh saat foto diganti.
        final dir = await getApplicationDocumentsDirectory();
        final ext = path.split('.').last.toLowerCase();
        final dest =
            '${dir.path}/profile_${DateTime.now().millisecondsSinceEpoch}.$ext';
        try {
          await File(path).copy(dest);
        } catch (_) {
          return;
        }
        next = dest;
      }

      await ref
          .read(settingsControllerProvider.notifier)
          .update((s) => s..photoPath = next);
      _deleteIfExists(current, keep: next);
    } else if (action == 'remove') {
      await ref
          .read(settingsControllerProvider.notifier)
          .update((s) => s..photoPath = null);
      _deleteIfExists(current);
    }
  }

  /// Cek ada/tidak-nya "foto" — untuk mobile: file exist. Untuk web: data URL
  /// non-kosong.
  bool _photoExists(String p) {
    if (p.startsWith('data:')) return true;
    if (kIsWeb) return false; // path filesystem tak berguna di web
    try {
      return File(p).existsSync();
    } catch (_) {
      return false;
    }
  }

  void _deleteIfExists(String? path, {String? keep}) {
    if (path == null || path == keep) return;
    if (path.startsWith('data:')) return; // tak ada file untuk dihapus
    if (kIsWeb) return;
    try {
      final f = File(path);
      if (f.existsSync()) f.deleteSync();
    } catch (_) {/* abaikan */}
  }

  static String _mimeFromExt(String ext) {
    switch (ext) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      default:
        return 'image/png';
    }
  }
}

/// Isi avatar: foto profil bila ada & file masih ada, jika tidak → inisial.
class _AvatarInner extends StatelessWidget {
  const _AvatarInner({required this.photoPath, required this.initials});
  final String? photoPath;
  final String initials;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final image = _resolveImage(photoPath);
    if (image != null) {
      return CircleAvatar(
        radius: 42,
        backgroundColor: scheme.primaryContainer,
        backgroundImage: image,
      );
    }
    return CircleAvatar(
      radius: 42,
      backgroundColor: scheme.primaryContainer,
      child: Text(
        initials,
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w800,
          color: scheme.onPrimaryContainer,
        ),
      ),
    );
  }

  ImageProvider? _resolveImage(String? p) {
    if (p == null || p.isEmpty) return null;
    // Web: photoPath disimpan sbg data URL base64.
    if (p.startsWith('data:')) {
      try {
        final comma = p.indexOf(',');
        if (comma < 0) return null;
        final bytes = base64Decode(p.substring(comma + 1));
        return MemoryImage(bytes);
      } catch (_) {
        return null;
      }
    }
    // Mobile: photoPath = filesystem path.
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

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: color, size: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                    color: color,
                    fontSize: 18,
                    fontWeight: FontWeight.w800),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                    fontSize: 11),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
