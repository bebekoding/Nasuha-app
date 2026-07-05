import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../config/theme/theme_controller.dart';
import '../../../../services/notification/web_notifier.dart'
    if (dart.library.io) '../../../../services/notification/web_notifier_stub.dart';
import '../../../muhasabah/data/repositories/muhasabah_repository.dart';
import '../../../muhasabah/presentation/providers/muhasabah_enabled_provider.dart';
import '../../../prayer_time/data/prayer_notification_scheduler.dart';
import '../providers/settings_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  static const _calcMethods = {
    'muslimWorldLeague': 'Muslim World League',
    'egyptian': 'Egyptian',
    'karachi': 'Karachi',
    'ummAlQura': 'Umm Al-Qura',
    'dubai': 'Dubai',
    'qatar': 'Qatar',
    'kuwait': 'Kuwait',
    'singapore': 'Singapore (Indonesia)',
    'turkey': 'Turkey',
    'tehran': 'Tehran',
    'northAmerica': 'North America',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan')),
      body: const SettingsBody(),
    );
  }
}

class SettingsBody extends ConsumerWidget {
  const SettingsBody({super.key, this.shrinkWrap = false});

  final bool shrinkWrap;

  static const _calcMethods = SettingsScreen._calcMethods;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsControllerProvider);
    final themeMode = ref.watch(themeControllerProvider);
    final settingsCtrl = ref.read(settingsControllerProvider.notifier);
    final themeCtrl = ref.read(themeControllerProvider.notifier);

    return ListView(
        shrinkWrap: shrinkWrap,
        physics: shrinkWrap ? const NeverScrollableScrollPhysics() : null,
        children: [
          const _SectionTitle('Tampilan'),
          ListTile(
            leading: const Icon(Icons.brightness_6),
            title: const Text('Tema'),
            subtitle: Text(switch (themeMode) {
              ThemeMode.light => 'Terang',
              ThemeMode.dark => 'Gelap',
              ThemeMode.system => 'Mengikuti sistem',
            }),
            trailing: DropdownButton<ThemeMode>(
              value: themeMode,
              underline: const SizedBox(),
              items: const [
                DropdownMenuItem(
                    value: ThemeMode.system, child: Text('Sistem')),
                DropdownMenuItem(
                    value: ThemeMode.light, child: Text('Terang')),
                DropdownMenuItem(
                    value: ThemeMode.dark, child: Text('Gelap')),
              ],
              onChanged: (v) => v == null ? null : themeCtrl.set(v),
            ),
          ),
          const Divider(),
          const _SectionTitle('Sholat'),
          ListTile(
            leading: const Icon(Icons.calculate_outlined),
            title: const Text('Metode kalkulasi'),
            subtitle:
                Text(_calcMethods[settings.calculationMethod] ?? 'Default'),
            trailing: DropdownButton<String>(
              value: settings.calculationMethod,
              underline: const SizedBox(),
              items: _calcMethods.entries
                  .map((e) => DropdownMenuItem(
                        value: e.key,
                        child: Text(e.value),
                      ))
                  .toList(),
              onChanged: (v) => v == null
                  ? null
                  : settingsCtrl.update((s) => s..calculationMethod = v),
            ),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.notifications_active_outlined),
            title: const Text('Notifikasi adzan'),
            subtitle: kIsWeb
                ? const Text(
                    'Web: hanya berjalan saat tab Nasuha terbuka.',
                    style: TextStyle(fontSize: 12),
                  )
                : null,
            value: settings.adhanNotifications,
            onChanged: (v) async {
              if (v && kIsWeb) {
                final granted =
                    await WebNotifier.instance.requestPermission();
                if (!granted) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text(
                        'Izin notifikasi ditolak browser. Aktifkan lewat setting browser.'),
                  ));
                  return;
                }
              }
              settingsCtrl.update((s) => s..adhanNotifications = v);
              // Enable → langsung jadwalkan adzan 48 jam ke depan.
              // Disable → cancel semua (dilakukan di dalam scheduler).
              try {
                await ref
                    .read(prayerNotificationSchedulerProvider)
                    .scheduleNext48h();
                if (v && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(kIsWeb
                        ? 'Notif adzan aktif. Biarkan tab Nasuha terbuka supaya notif jalan.'
                        : 'Notif adzan aktif untuk 48 jam ke depan.'),
                    duration: const Duration(seconds: 3),
                  ));
                }
              } catch (_) {
                // Best-effort, jangan blocking UI.
              }
            },
          ),
          SwitchListTile(
            secondary: const Icon(Icons.alarm),
            title: const Text('Pengingat ibadah'),
            subtitle: kIsWeb
                ? const Text(
                    'Web: hanya berjalan saat tab Nasuha terbuka.',
                    style: TextStyle(fontSize: 12),
                  )
                : null,
            value: settings.reminderNotifications,
            onChanged: (v) async {
              if (v && kIsWeb) {
                final granted =
                    await WebNotifier.instance.requestPermission();
                if (!granted) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text(
                        'Izin notifikasi ditolak browser. Aktifkan lewat setting browser.'),
                  ));
                  return;
                }
              }
              settingsCtrl.update((s) => s..reminderNotifications = v);
              try {
                await ref
                    .read(prayerNotificationSchedulerProvider)
                    .scheduleNext48h();
              } catch (_) {}
            },
          ),
          if (kIsWeb)
            ListTile(
              leading: const Icon(Icons.notifications_none),
              title: const Text('Tes notifikasi web'),
              subtitle: const Text(
                  'Kirim satu notifikasi sekarang untuk memastikan izin browser aktif'),
              trailing: const Icon(Icons.play_arrow),
              onTap: () async {
                final n = WebNotifier.instance;
                if (n.permission != 'granted') {
                  final ok = await n.requestPermission();
                  if (!ok) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Izin notifikasi belum aktif.'),
                    ));
                    return;
                  }
                }
                n.show(
                  title: 'Nasuha ✅',
                  body: 'Notifikasi web bekerja. Selamat!',
                  tag: 'test',
                );
              },
            ),
          const Divider(),
          const _SectionTitle('Privasi & Keamanan'),
          SwitchListTile(
            secondary: const Icon(Icons.fingerprint),
            title: const Text('Kunci biometrik'),
            subtitle:
                const Text('Buka aplikasi dengan biometrik / PIN perangkat'),
            value: settings.biometricLock,
            onChanged: (v) =>
                settingsCtrl.update((s) => s..biometricLock = v),
          ),
          ListTile(
            leading: const Icon(Icons.cloud_sync_outlined),
            title: const Text('Akun & Pemulihan'),
            subtitle: const Text(
                'Login & pulihkan data saat ganti atau kehilangan HP'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/backup'),
          ),
          const Divider(),
          const _SectionTitle('Muhasabah'),
          ListTile(
            leading: const Icon(Icons.delete_sweep_outlined),
            title: const Text('Nonaktifkan & Reset Data'),
            subtitle: const Text(
                'Berhenti menggunakan Muhasabah dan hapus semua catatan'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showResetDialog(context, ref),
          ),
          const Divider(),
          const _SectionTitle('Tentang'),
          FutureBuilder<PackageInfo>(
            future: PackageInfo.fromPlatform(),
            builder: (context, snap) {
              final v = snap.data?.version ?? '';
              return ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('Nasuha'),
                subtitle: Text(
                  '${v.isEmpty ? '' : 'Versi $v — '}'
                  'Level up your soul · Level up your amal',
                ),
              );
            },
          ),
        ],
      );
  }
}

Future<void> _showResetDialog(BuildContext context, WidgetRef ref) async {
  final muhasabahOn = ref.read(muhasabahEnabledProvider);
  final choice = await showDialog<_ResetChoice>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Nonaktifkan Muhasabah?'),
      content: const Text(
        'Pilih tindakan:\n\n'
        '• "Nonaktifkan saja" — fitur disembunyikan, data tetap tersimpan '
        'jika suatu saat ingin diaktifkan kembali.\n\n'
        '• "Hapus semua & nonaktifkan" — semua catatan, XP, dan streak '
        'dihapus permanen. Tidak bisa dibatalkan.',
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(ctx).pop(_ResetChoice.cancel),
            child: const Text('Batal')),
        OutlinedButton(
            onPressed: () => Navigator.of(ctx).pop(_ResetChoice.disableOnly),
            child: const Text('Nonaktifkan saja')),
        Builder(builder: (bCtx) {
          final cs = Theme.of(bCtx).colorScheme;
          return FilledButton(
            style: FilledButton.styleFrom(
                backgroundColor: cs.error,
                foregroundColor: cs.onError),
            onPressed: () =>
                Navigator.of(ctx).pop(_ResetChoice.disableAndReset),
            child: const Text('Hapus semua & nonaktifkan'),
          );
        }),
      ],
    ),
  );
  if (choice == null || choice == _ResetChoice.cancel) return;
  if (!muhasabahOn && choice == _ResetChoice.disableOnly) return;

  if (choice == _ResetChoice.disableAndReset) {
    await ref.read(muhasabahRepositoryProvider).resetAllData();
  }
  await ref.read(muhasabahEnabledProvider.notifier).disable();
  if (context.mounted) context.go('/');
}

enum _ResetChoice { cancel, disableOnly, disableAndReset }

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);
  final String title;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: Theme.of(context).colorScheme.primary,
          letterSpacing: 1,
        ),
      ),
    );
  }
}
