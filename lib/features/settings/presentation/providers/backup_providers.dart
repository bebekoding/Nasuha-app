import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../config/theme/theme_controller.dart';
import '../../../../services/backup/backup_service.dart';
import '../../../../services/backup/drive_backup_client.dart';

const _autoBackupKey = 'pref_auto_backup_enabled';
const _lastBackupKey = 'pref_last_backup_at';

class BackupSignInState {
  final GoogleSignInAccount? account;
  final bool checked;
  const BackupSignInState({this.account, this.checked = false});

  bool get signedIn => account != null;

  BackupSignInState copyWith({GoogleSignInAccount? account, bool? checked}) =>
      BackupSignInState(
        account: account,
        checked: checked ?? this.checked,
      );
}

class BackupController extends StateNotifier<BackupSignInState> {
  BackupController(this._service, this._prefs)
      : super(const BackupSignInState()) {
    _bootstrap();
  }

  final BackupService _service;
  final SharedPreferences _prefs;

  Future<void> _bootstrap() async {
    try {
      final acc = await _service.signInSilently();
      state = BackupSignInState(account: acc, checked: true);
    } catch (_) {
      state = const BackupSignInState(checked: true);
    }
  }

  Future<void> signIn() async {
    final acc = await _service.signIn();
    state = state.copyWith(account: acc, checked: true);
  }

  Future<void> signOut() async {
    await _service.signOut();
    state = const BackupSignInState(checked: true);
  }

  Future<BackupResult> backupNow({String? password}) async {
    final r = await _service.backupNow(password: password);
    await _prefs.setString(_lastBackupKey, DateTime.now().toIso8601String());
    return r;
  }

  Future<List<BackupFile>> listBackups() => _service.listBackups();

  Future<void> restore({required String fileId, String? password}) =>
      _service.restore(fileId: fileId, password: password);

  Future<void> deleteBackup(String id) => _service.deleteBackup(id);

  // ---- Manual file export / import ----
  Future<File> exportToFile({String? password}) =>
      _service.exportToFile(password: password);

  Future<void> importFromFile({required String path, String? password}) =>
      _service.importFromFile(path: path, password: password);

  Future<bool> fileIsEncrypted(String path) =>
      _service.fileIsEncrypted(path);

  // ---- New-device recovery detection ----
  Future<bool> hasLocalData() => _service.hasLocalData();

  /// After a fresh sign-in on a new/empty device, returns the most recent
  /// cloud backup if one exists and there's nothing to lose locally — so the
  /// UI can offer a one-tap restore. Returns null when not applicable.
  Future<BackupFile?> findRestorableBackup() async {
    if (!_service.isSignedIn) return null;
    if (await hasLocalData()) return null; // don't clobber real local data
    try {
      final backups = await listBackups();
      return backups.isEmpty ? null : backups.first;
    } catch (_) {
      return null;
    }
  }

  bool get autoBackupEnabled => _prefs.getBool(_autoBackupKey) ?? false;
  Future<void> setAutoBackup(bool v) async {
    await _prefs.setBool(_autoBackupKey, v);
    state = state.copyWith(); // bump
  }

  DateTime? get lastBackupAt {
    final s = _prefs.getString(_lastBackupKey);
    return s == null ? null : DateTime.tryParse(s);
  }

  /// Trigger an auto-backup if it has been more than 24h since the last one.
  Future<void> maybeRunDailyBackup({String? password}) async {
    if (!autoBackupEnabled) return;
    if (!_service.isSignedIn) return;
    final last = lastBackupAt;
    if (last != null && DateTime.now().difference(last).inHours < 24) {
      return;
    }
    try {
      await backupNow(password: password);
    } catch (_) {
      // Silent failure — surfaced in backup screen status next time.
    }
  }
}

final backupControllerProvider =
    StateNotifierProvider<BackupController, BackupSignInState>((ref) {
  return BackupController(
    ref.watch(backupServiceProvider),
    ref.watch(sharedPrefsProvider),
  );
});
