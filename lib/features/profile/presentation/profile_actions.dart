import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import '../../settings/presentation/providers/settings_providers.dart';

/// Edit display name via AlertDialog.
Future<void> editProfileName(
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

/// Change profile photo — pick from gallery or remove existing.
Future<void> changeProfilePhoto(BuildContext context, WidgetRef ref) async {
  final current = ref.read(settingsControllerProvider).photoPath;
  final hasPhoto =
      current != null && current.isNotEmpty && _photoExists(current);

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

/// Check whether a photoPath still points at a valid asset.
bool photoExists(String? p) => p != null && p.isNotEmpty && _photoExists(p);

bool _photoExists(String p) {
  if (p.startsWith('data:')) return true;
  if (kIsWeb) return false;
  try {
    return File(p).existsSync();
  } catch (_) {
    return false;
  }
}

void _deleteIfExists(String? path, {String? keep}) {
  if (path == null || path == keep) return;
  if (path.startsWith('data:')) return;
  if (kIsWeb) return;
  try {
    final f = File(path);
    if (f.existsSync()) f.deleteSync();
  } catch (_) {
    // ignore
  }
}

String _mimeFromExt(String ext) {
  switch (ext) {
    case 'png':
      return 'image/png';
    case 'gif':
      return 'image/gif';
    case 'webp':
      return 'image/webp';
    case 'jpg':
    case 'jpeg':
    default:
      return 'image/jpeg';
  }
}

String profileInitials(String? name) {
  final s = (name ?? '').trim();
  if (s.isEmpty) return '';
  final parts = s.split(RegExp(r'\s+'));
  final letters = parts.take(2).map((p) => p.isEmpty ? '' : p[0]).join();
  return letters.toUpperCase();
}
