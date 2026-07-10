import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

/// Bulat kecil, resolve gambar dari [photoPath] (file lokal / data URI web),
/// fallback ke [fallbackIcon] kalau kosong / file hilang.
///
/// Dipakai untuk badge profile di pojok home (mobile) & nav desktop —
/// ukuran mengikuti param [size], bukan pakai CircleAvatar (bakalan ganjil
/// karena background circle default). Foto meng-cover penuh.
class UserAvatar extends StatelessWidget {
  const UserAvatar({
    super.key,
    required this.photoPath,
    this.size = 40,
    this.fallbackIcon = Icons.person_outline,
    this.background,
    this.foreground,
  });

  final String? photoPath;
  final double size;
  final IconData fallbackIcon;
  final Color? background;
  final Color? foreground;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bg = background ?? scheme.primaryContainer;
    final fg = foreground ?? scheme.onPrimaryContainer;
    final img = _resolveImage();
    return SizedBox(
      width: size,
      height: size,
      child: ClipOval(
        child: img != null
            ? Image(
                image: img,
                width: size,
                height: size,
                fit: BoxFit.cover,
                gaplessPlayback: true,
              )
            : Container(
                color: bg,
                alignment: Alignment.center,
                child: Icon(fallbackIcon, size: size * 0.55, color: fg),
              ),
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
