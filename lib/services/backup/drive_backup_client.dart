import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;

/// Wraps Google Drive's hidden "appDataFolder" — a per-user, per-app sandbox.
/// Files written here are invisible in the user's normal Drive UI and only
/// accessible to this app. Nothing this app does can read the user's other
/// Drive files.
class DriveBackupClient {
  DriveBackupClient({GoogleSignIn? signIn})
      : _signIn = signIn ??
            GoogleSignIn(scopes: const [
              drive.DriveApi.driveAppdataScope,
            ]);

  static const String fileNamePrefix = 'nasuha-backup-';
  static const String fileNameSuffix = '.json';
  static const String mimeType = 'application/json';
  static const int maxBackupsToKeep = 7;

  final GoogleSignIn _signIn;

  GoogleSignInAccount? _account;
  drive.DriveApi? _drive;

  GoogleSignInAccount? get currentAccount => _account;
  bool get isSignedIn => _account != null;

  Future<GoogleSignInAccount?> signIn() async {
    _account = await _signIn.signIn();
    await _refreshClient();
    return _account;
  }

  Future<GoogleSignInAccount?> signInSilently() async {
    _account = await _signIn.signInSilently();
    await _refreshClient();
    return _account;
  }

  Future<void> signOut() async {
    await _signIn.signOut();
    _account = null;
    _drive = null;
  }

  Future<void> _refreshClient() async {
    if (_account == null) {
      _drive = null;
      return;
    }
    final httpClient = await _signIn.authenticatedClient();
    if (httpClient == null) {
      throw StateError('Google sign-in tidak menghasilkan auth client.');
    }
    _drive = drive.DriveApi(httpClient);
  }

  drive.DriveApi get _client {
    final c = _drive;
    if (c == null) {
      throw StateError('Belum sign-in ke Google Drive.');
    }
    return c;
  }

  Future<BackupFile> upload({
    required String content,
    DateTime? now,
  }) async {
    final timestamp = (now ?? DateTime.now()).toUtc();
    final name = '$fileNamePrefix${_isoStamp(timestamp)}$fileNameSuffix';
    final bytes = Uint8List.fromList(utf8.encode(content));

    final media = drive.Media(
      Stream.value(bytes),
      bytes.length,
      contentType: mimeType,
    );

    final created = await _client.files.create(
      drive.File()
        ..name = name
        ..parents = ['appDataFolder']
        ..mimeType = mimeType,
      uploadMedia: media,
    );
    await _pruneOldBackups();
    return BackupFile(
      id: created.id!,
      name: created.name ?? name,
      createdAt: timestamp,
      sizeBytes: bytes.length,
    );
  }

  Future<List<BackupFile>> list() async {
    final result = await _client.files.list(
      spaces: 'appDataFolder',
      orderBy: 'createdTime desc',
      $fields: 'files(id,name,createdTime,size)',
      pageSize: 50,
    );
    return (result.files ?? [])
        .map((f) => BackupFile(
              id: f.id!,
              name: f.name ?? '',
              createdAt:
                  f.createdTime?.toUtc() ?? DateTime.now().toUtc(),
              sizeBytes: int.tryParse(f.size ?? '0') ?? 0,
            ))
        .toList();
  }

  Future<String> downloadContent(String fileId) async {
    final media = await _client.files.get(
      fileId,
      downloadOptions: drive.DownloadOptions.fullMedia,
    ) as drive.Media;
    final chunks = <List<int>>[];
    await for (final chunk in media.stream) {
      chunks.add(chunk);
    }
    final bytes = chunks.expand((c) => c).toList();
    return utf8.decode(bytes);
  }

  Future<void> delete(String fileId) async {
    await _client.files.delete(fileId);
  }

  Future<void> _pruneOldBackups() async {
    final all = await list();
    if (all.length <= maxBackupsToKeep) return;
    final toDelete = all.skip(maxBackupsToKeep).toList();
    for (final f in toDelete) {
      try {
        await delete(f.id);
      } catch (_) {
        // ignore — best effort
      }
    }
  }

  String _isoStamp(DateTime t) =>
      '${t.year.toString().padLeft(4, '0')}'
      '${t.month.toString().padLeft(2, '0')}'
      '${t.day.toString().padLeft(2, '0')}'
      '-${t.hour.toString().padLeft(2, '0')}'
      '${t.minute.toString().padLeft(2, '0')}'
      '${t.second.toString().padLeft(2, '0')}';
}

class BackupFile {
  final String id;
  final String name;
  final DateTime createdAt;
  final int sizeBytes;

  const BackupFile({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.sizeBytes,
  });
}
