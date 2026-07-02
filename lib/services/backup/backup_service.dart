import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:path_provider/path_provider.dart';

import 'package:drift/drift.dart' show countAll;

import '../database/app_database.dart';
import '../isar/isar_service.dart';
import 'backup_crypto.dart';
import 'backup_serializer.dart';
import 'drive_backup_client.dart';

class BackupResult {
  final BackupFile file;
  final bool encrypted;
  const BackupResult({required this.file, required this.encrypted});
}

class BackupService {
  BackupService({
    required IsarService isarService,
    required AppDatabase db,
    required DriveBackupClient drive,
    BackupCrypto? crypto,
  })  : _isar = isarService,
        _db = db,
        _serializer = BackupSerializer(isarService.isar, db),
        _drive = drive,
        _crypto = crypto ?? BackupCrypto();


  // ignore: unused_field
  final IsarService _isar; // legacy Isar; masih dipakai serializer via constructor
  final AppDatabase _db;
  final BackupSerializer _serializer;
  final DriveBackupClient _drive;
  final BackupCrypto _crypto;

  /// True when the device already has user-entered data (muhasabah entries or
  /// charity records). Used to decide whether a fresh sign-in on a new device
  /// should offer to restore a cloud backup.
  Future<bool> hasLocalData() async {
    final entriesQuery = _db.selectOnly(_db.muhasabahEntriesTable)
      ..addColumns([countAll()]);
    final entries =
        (await entriesQuery.map((row) => row.read(countAll())).getSingle()) ??
            0;
    final charityQuery = _db.selectOnly(_db.charityRecordsTable)
      ..addColumns([countAll()]);
    final charity =
        (await charityQuery.map((row) => row.read(countAll())).getSingle()) ?? 0;
    return entries > 0 || charity > 0;
  }

  DriveBackupClient get drive => _drive;
  bool get isSignedIn => _drive.isSignedIn;
  GoogleSignInAccount? get account => _drive.currentAccount;

  Future<GoogleSignInAccount?> signIn() => _drive.signIn();
  Future<GoogleSignInAccount?> signInSilently() => _drive.signInSilently();
  Future<void> signOut() => _drive.signOut();

  /// Serialize → optionally encrypt → upload to Drive App Folder.
  Future<BackupResult> backupNow({String? password}) async {
    final json = await _serializer.exportToJsonString();
    final hasPassword = password != null && password.isNotEmpty;
    final payload =
        hasPassword ? await _crypto.encrypt(json, password) : json;
    final file = await _drive.upload(content: payload);
    return BackupResult(file: file, encrypted: hasPassword);
  }

  Future<List<BackupFile>> listBackups() => _drive.list();

  /// Download → decrypt if needed → import. Caller must already have password
  /// (or know there isn't one).
  Future<void> restore({
    required String fileId,
    String? password,
  }) async {
    final raw = await _drive.downloadContent(fileId);
    String json;
    if (_crypto.isEnvelope(raw)) {
      if (password == null || password.isEmpty) {
        throw const FormatException(
            'Backup ini terenkripsi. Masukkan password untuk membuka.');
      }
      json = await _crypto.decrypt(raw, password);
    } else {
      json = raw;
    }
    await _serializer.importFromJsonString(json);
  }

  Future<void> deleteBackup(String fileId) => _drive.delete(fileId);

  // ---- Manual file export / import (no Google account needed) ----

  /// Serialize → optionally encrypt → write to a temp file. Returns the file
  /// so the caller can hand it to the OS share sheet. The user can then save
  /// it to Files, send to themselves via WhatsApp/email, etc.
  Future<File> exportToFile({String? password}) async {
    final json = await _serializer.exportToJsonString();
    final hasPassword = password != null && password.isNotEmpty;
    final payload =
        hasPassword ? await _crypto.encrypt(json, password) : json;

    final dir = await getTemporaryDirectory();
    final stamp = _fileStamp(DateTime.now());
    final ext = hasPassword ? 'mhsb' : 'json';
    final file = File('${dir.path}/Nasuha-backup-$stamp.$ext');
    await file.writeAsString(payload);
    return file;
  }

  /// Read a backup file's raw contents → decrypt if needed → import.
  Future<void> importFromFile({
    required String path,
    String? password,
  }) async {
    final raw = await File(path).readAsString();
    String json;
    if (_crypto.isEnvelope(raw)) {
      if (password == null || password.isEmpty) {
        throw const FormatException(
            'File backup ini terenkripsi. Masukkan password untuk membuka.');
      }
      json = await _crypto.decrypt(raw, password);
    } else {
      json = raw;
    }
    await _serializer.importFromJsonString(json);
  }

  /// Quick check whether a just-picked file is password-protected, so the UI
  /// can ask for a password before attempting the import.
  Future<bool> fileIsEncrypted(String path) async {
    final raw = await File(path).readAsString();
    return _crypto.isEnvelope(raw);
  }

  String _fileStamp(DateTime t) =>
      '${t.year.toString().padLeft(4, '0')}'
      '${t.month.toString().padLeft(2, '0')}'
      '${t.day.toString().padLeft(2, '0')}'
      '-${t.hour.toString().padLeft(2, '0')}'
      '${t.minute.toString().padLeft(2, '0')}';
}

final driveBackupClientProvider = Provider<DriveBackupClient>((ref) {
  return DriveBackupClient();
});

final backupServiceProvider = Provider<BackupService>((ref) {
  return BackupService(
    isarService: ref.watch(isarServiceProvider),
    db: ref.watch(appDatabaseProvider),
    drive: ref.watch(driveBackupClientProvider),
  );
});
