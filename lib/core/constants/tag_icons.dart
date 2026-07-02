import 'package:flutter/material.dart';

/// Pemetaan codePoint → [IconData] **konstan** untuk semua ikon tag.
///
/// Ikon tag disimpan di Isar sebagai `iconCodePoint` (int). Membuat
/// `IconData(codePoint, fontFamily: 'MaterialIcons')` secara dinamis akan
/// mematikan tree-shaking ikon (build release gagal tanpa
/// `--no-tree-shake-icons`). Dengan menyimpan referensi `Icons.x` yang konstan
/// di sini, tree-shaker tetap bisa memangkas font ikon yang tak terpakai.
///
/// Semua ikon di [kDefaultTags] (seed_tags.dart) + ikon seed migrasi harus
/// terdaftar di sini. Tag custom buatan user punya `iconCodePoint == null`
/// sehingga memakai fallback yang juga konstan.
const List<IconData> _kKnownTagIcons = <IconData>[
  // Positif (sholat & amalan)
  Icons.wb_twilight,
  Icons.wb_sunny,
  Icons.wb_cloudy,
  Icons.brightness_4,
  Icons.nightlight,
  Icons.groups,
  Icons.bedtime,
  Icons.light_mode,
  Icons.menu_book,
  Icons.wb_sunny_outlined,
  Icons.no_food,
  Icons.volunteer_activism,
  Icons.auto_stories,
  Icons.work,
  Icons.family_restroom,
  Icons.fitness_center,
  Icons.handshake,
  Icons.school,
  Icons.remove_red_eye,
  Icons.record_voice_over,
  // Negatif
  Icons.alarm_off,
  Icons.timer_off,
  Icons.forum,
  Icons.error_outline,
  Icons.local_fire_department,
  Icons.smoking_rooms,
  Icons.hourglass_empty,
  Icons.visibility_off,
  Icons.block,
  // Fallback yang mungkin tersimpan
  Icons.add_circle_outline,
  Icons.remove_circle_outline,
  Icons.check_circle_outline,
  Icons.cancel_outlined,
];

final Map<int, IconData> _kTagIconByCodePoint = {
  for (final i in _kKnownTagIcons) i.codePoint: i,
};

/// Ikon konstan untuk sebuah tag. [codePoint] dari `tag.iconCodePoint`;
/// bila null atau tak dikenal, pakai [fallback].
IconData tagIconFor(int? codePoint, {required IconData fallback}) {
  if (codePoint == null) return fallback;
  return _kTagIconByCodePoint[codePoint] ?? fallback;
}
