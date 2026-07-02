import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../services/backup/drive_backup_client.dart';
import '../providers/backup_providers.dart';

class BackupScreen extends ConsumerStatefulWidget {
  const BackupScreen({super.key});

  @override
  ConsumerState<BackupScreen> createState() => _BackupScreenState();
}

class _BackupScreenState extends ConsumerState<BackupScreen> {
  final _passwordCtrl = TextEditingController();
  bool _busy = false;
  String? _status;
  BackupFile? _restorable; // most recent cloud backup on a fresh device

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkRestorable());
  }

  @override
  void dispose() {
    _passwordCtrl.dispose();
    super.dispose();
  }

  String? get _password =>
      _passwordCtrl.text.trim().isEmpty ? null : _passwordCtrl.text.trim();

  Future<void> _checkRestorable() async {
    final ctrl = ref.read(backupControllerProvider.notifier);
    final found = await ctrl.findRestorableBackup();
    if (mounted && found != null) setState(() => _restorable = found);
  }

  Future<void> _run(Future<void> Function() action, {String? successMsg}) async {
    setState(() {
      _busy = true;
      _status = null;
    });
    try {
      await action();
      if (mounted) setState(() => _status = successMsg);
    } catch (e) {
      if (mounted) setState(() => _status = _friendlyError(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  /// Turn raw plugin exceptions into something the user can act on. The most
  /// common is Google sign-in error code 10 (DEVELOPER_ERROR) — the OAuth
  /// client isn't registered in Google Cloud Console yet.
  String _friendlyError(Object e) {
    final s = e.toString();
    final isSignInConfig = s.contains('sign_in_failed') ||
        s.contains('ApiException: 10') ||
        RegExp(r'[,(]\s*10\s*[,)]').hasMatch(s);
    if (isSignInConfig) {
      return 'Login Google belum aktif. Aplikasi perlu didaftarkan dulu di '
          'Google Cloud Console (OAuth client untuk com.nasuha.app). '
          'Sementara itu, pakai "Cadangan File" di bawah — sudah berfungsi penuh.';
    }
    if (s.contains('network') || s.contains('SocketException')) {
      return 'Gagal tersambung. Periksa koneksi internet lalu coba lagi.';
    }
    if (s.contains('sign_in_canceled') || s.contains('canceled')) {
      return 'Login dibatalkan.';
    }
    return 'Gagal: $e';
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(backupControllerProvider);
    final ctrl = ref.read(backupControllerProvider.notifier);
    final lastBackupAt = ctrl.lastBackupAt;

    return Scaffold(
      appBar: AppBar(title: const Text('Akun & Pemulihan')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _privacyCard(context),
          const SizedBox(height: 16),

          // ── New-device restore banner ─────────────────────────
          if (_restorable != null) ...[
            _restoreBanner(context, _restorable!),
            const SizedBox(height: 16),
          ],

          // ════════ SECTION 1: GOOGLE DRIVE ════════
          const _SectionTitle('Cadangan Google Drive'),
          if (!state.checked)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (!state.signedIn)
            _signInCard(context, ctrl)
          else
            _accountCard(context, state, ctrl),

          if (state.signedIn) ...[
            const SizedBox(height: 16),
            const _SectionTitle('Password Enkripsi'),
            _passwordField(),
            const SizedBox(height: 16),
            const _SectionTitle('Auto-backup'),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Backup otomatis harian'),
              subtitle: const Text(
                  'Upload backup saat app dibuka, maks. sekali per 24 jam.'),
              value: ctrl.autoBackupEnabled,
              onChanged:
                  _busy ? null : (v) => _run(() => ctrl.setAutoBackup(v)),
            ),
            if (lastBackupAt != null)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.history),
                title: const Text('Backup terakhir'),
                subtitle: Text(DateFormat('EEE, d MMM y · HH:mm', 'id_ID')
                    .format(lastBackupAt)),
              ),
            const SizedBox(height: 8),
            FilledButton.icon(
              onPressed: _busy
                  ? null
                  : () => _run(() async {
                        final r = await ctrl.backupNow(password: _password);
                        if (mounted) {
                          setState(() => _status =
                              'Backup tersimpan${r.encrypted ? ' (terenkripsi)' : ''}.');
                        }
                      }),
              icon: const Icon(Icons.cloud_upload_outlined),
              label: const Text('Backup sekarang ke Drive'),
            ),
            const SizedBox(height: 16),
            const _SectionTitle('Riwayat backup Drive'),
            _driveHistory(context, state, ctrl),
          ],

          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 8),

          // ════════ SECTION 2: FILE MANUAL ════════
          const _SectionTitle('Cadangan File (tanpa Google)'),
          Text(
            'Simpan data ke file yang bisa Anda kirim ke diri sendiri '
            '(WhatsApp, email, Google Drive manual, dll). Untuk pulihkan di '
            'HP baru, cukup buka file ini lewat tombol "Pulihkan dari file".',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Theme.of(context).colorScheme.outline),
          ),
          const SizedBox(height: 8),
          if (!state.signedIn) ...[
            // password field also available here for file encryption
            _passwordField(),
            const SizedBox(height: 8),
          ],
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _busy ? null : _exportToFile,
                  icon: const Icon(Icons.ios_share),
                  label: const Text('Export ke file'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _busy ? null : _importFromFile,
                  icon: const Icon(Icons.folder_open),
                  label: const Text('Pulihkan dari file'),
                ),
              ),
            ],
          ),

          if (_status != null) ...[
            const SizedBox(height: 16),
            _statusCard(context),
          ],
          if (_busy) ...[
            const SizedBox(height: 12),
            const Center(child: CircularProgressIndicator()),
          ],
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────── Widgets ──

  Widget _privacyCard(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context)
              .colorScheme
              .primaryContainer
              .withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.shield_outlined, size: 18),
                const SizedBox(width: 8),
                Text('Data tetap milik Anda',
                    style: Theme.of(context).textTheme.titleSmall),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Cadangan disimpan di folder tersembunyi Google Drive Anda '
              '(App Folder) — hanya aplikasi ini yang bisa membacanya. '
              'Developer tidak punya akses. Jika Anda set password, data '
              'dienkripsi AES-256 di perangkat sebelum diunggah/diexport.',
              style: TextStyle(fontSize: 13),
            ),
          ],
        ),
      );

  Widget _restoreBanner(BuildContext context, BackupFile f) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFA77B43).withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
        border:
            Border.all(color: const Color(0xFFA77B43).withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.cloud_done, color: Color(0xFFA77B43)),
              const SizedBox(width: 8),
              Expanded(
                child: Text('Cadangan ditemukan!',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: const Color(0xFFA77B43),
                        fontWeight: FontWeight.w800)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Perangkat ini masih kosong dan kami menemukan cadangan terakhir '
            'tertanggal ${DateFormat('EEE, d MMM y · HH:mm', 'id_ID').format(f.createdAt.toLocal())}. '
            'Pulihkan data Anda sekarang?',
            style: const TextStyle(fontSize: 13),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              FilledButton.icon(
                style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFA77B43)),
                onPressed: _busy ? null : () => _confirmRestore(context, f.id),
                icon: const Icon(Icons.restore, size: 18),
                label: const Text('Pulihkan sekarang'),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed:
                    _busy ? null : () => setState(() => _restorable = null),
                child: const Text('Nanti'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _signInCard(BuildContext context, BackupController ctrl) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.cloud_off, size: 40),
              const SizedBox(height: 8),
              Text('Belum terhubung ke Google Drive',
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center),
              const SizedBox(height: 4),
              Text(
                'Masuk agar data otomatis tersimpan & bisa dipulihkan saat '
                'ganti atau kehilangan HP.',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Theme.of(context).colorScheme.outline),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: _busy
                    ? null
                    : () => _run(() async {
                          await ctrl.signIn();
                          await _checkRestorable();
                        }, successMsg: 'Berhasil masuk.'),
                icon: const Icon(Icons.login),
                label: const Text('Masuk dengan Google'),
              ),
            ],
          ),
        ),
      );

  Widget _accountCard(
          BuildContext context, dynamic state, BackupController ctrl) =>
      Card(
        child: ListTile(
          leading: state.account?.photoUrl != null
              ? CircleAvatar(
                  backgroundImage: NetworkImage(state.account!.photoUrl!))
              : const CircleAvatar(child: Icon(Icons.person)),
          title:
              Text(state.account!.displayName ?? state.account!.email),
          subtitle: Text(state.account!.email),
          trailing: TextButton(
            onPressed: _busy
                ? null
                : () => _run(() async {
                      await ctrl.signOut();
                      if (mounted) setState(() => _restorable = null);
                    }),
            child: const Text('Keluar'),
          ),
        ),
      );

  Widget _passwordField() => TextField(
        controller: _passwordCtrl,
        obscureText: true,
        decoration: const InputDecoration(
          labelText: 'Password backup (opsional)',
          helperText:
              'Kosongkan = tanpa enkripsi tambahan. PENTING: jika lupa '
              'password, backup tidak bisa dipulihkan.',
          helperMaxLines: 3,
          prefixIcon: Icon(Icons.lock_outline),
        ),
      );

  Widget _driveHistory(
      BuildContext context, dynamic state, BackupController ctrl) {
    return FutureBuilder<List<BackupFile>>(
      key: ValueKey(state),
      future: ctrl.listBackups(),
      builder: (ctx, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (snap.hasError) {
          return Padding(
            padding: const EdgeInsets.all(12),
            child: Text('Gagal memuat: ${snap.error}'),
          );
        }
        final list = snap.data ?? [];
        if (list.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Text('Belum ada backup. Buat backup pertama Anda.',
                style: Theme.of(context).textTheme.bodySmall),
          );
        }
        return Column(
          children: [
            for (final f in list)
              Card(
                child: ListTile(
                  leading: const Icon(Icons.description_outlined),
                  title: Text(DateFormat('EEE, d MMM y · HH:mm', 'id_ID')
                      .format(f.createdAt.toLocal())),
                  subtitle:
                      Text('${(f.sizeBytes / 1024).toStringAsFixed(1)} KB'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        tooltip: 'Pulihkan',
                        icon: const Icon(Icons.restore),
                        onPressed:
                            _busy ? null : () => _confirmRestore(ctx, f.id),
                      ),
                      IconButton(
                        tooltip: 'Hapus',
                        icon: const Icon(Icons.delete_outline),
                        onPressed: _busy
                            ? null
                            : () => _run(() => ctrl.deleteBackup(f.id),
                                    successMsg: 'Backup dihapus.')
                                .then((_) => setState(() {})),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _statusCard(BuildContext context) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context)
              .colorScheme
              .surfaceContainerHighest
              .withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.info_outline, size: 18),
            const SizedBox(width: 8),
            Expanded(child: Text(_status!)),
          ],
        ),
      );

  // ─────────────────────────────────────────── Actions ──

  Future<void> _exportToFile() async {
    await _run(() async {
      final file = await ref
          .read(backupControllerProvider.notifier)
          .exportToFile(password: _password);
      await Share.shareXFiles(
        [XFile(file.path)],
        subject: 'Cadangan Muhasabah',
        text: 'Cadangan data Muhasabah. Simpan file ini baik-baik.',
      );
      if (mounted) {
        setState(() => _status = _password != null
            ? 'File terenkripsi siap dibagikan/disimpan.'
            : 'File cadangan siap dibagikan/disimpan.');
      }
    });
  }

  Future<void> _importFromFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.any);
    if (result == null || result.files.single.path == null) return;
    final path = result.files.single.path!;
    final ctrl = ref.read(backupControllerProvider.notifier);

    String? pwd = _password;
    final encrypted = await ctrl.fileIsEncrypted(path);
    if (encrypted) {
      pwd = await _askPassword();
      if (pwd == null) return; // cancelled
    }

    if (!mounted) return;
    final confirmed = await _confirmRestoreDialog(context);
    if (confirmed != true) return;

    await _run(
      () => ctrl.importFromFile(path: path, password: pwd),
      successMsg: 'Data berhasil dipulihkan dari file. Mulai ulang aplikasi.',
    );
  }

  Future<String?> _askPassword() async {
    final ctrl = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('File terenkripsi'),
        content: TextField(
          controller: ctrl,
          obscureText: true,
          autofocus: true,
          decoration: const InputDecoration(
              hintText: 'Masukkan password backup'),
          onSubmitted: (v) => Navigator.of(ctx).pop(v.trim()),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Batal')),
          FilledButton(
              onPressed: () => Navigator.of(ctx).pop(ctrl.text.trim()),
              child: const Text('Buka')),
        ],
      ),
    );
  }

  Future<bool?> _confirmRestoreDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Pulihkan data?'),
        content: const Text(
          'Semua data lokal saat ini akan diganti dengan isi cadangan. '
          'Aksi ini tidak bisa dibatalkan. Lanjutkan?',
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Batal')),
          FilledButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('Pulihkan')),
        ],
      ),
    );
  }

  Future<void> _confirmRestore(BuildContext context, String fileId) async {
    final confirmed = await _confirmRestoreDialog(context);
    if (confirmed != true) return;
    final ctrl = ref.read(backupControllerProvider.notifier);
    await _run(
      () => ctrl.restore(fileId: fileId, password: _password),
      successMsg: 'Backup berhasil dipulihkan. Mulai ulang aplikasi.',
    );
    if (mounted) setState(() => _restorable = null);
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);
  final String title;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 8),
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
