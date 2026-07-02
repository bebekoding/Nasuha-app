/// Kategori tag muhasabah (positif = amalan, negatif = dosa/kekurangan).
enum TagKind { positive, negative }

/// Tag yang bisa dicatat user setiap hari (sholat, sedekah, tahajud, ghibah dsb).
///
/// Plain Dart data class (bukan lagi @collection Isar) — jalan di web.
/// Persisted via tabel Drift `MuhasabahTagsTable`. **Mutable** biar drop-in
/// dengan pola caller lama.
class MuhasabahTag {
  MuhasabahTag({
    this.id = 0,
    this.slug = '',
    this.name = '',
    this.score = 0,
    this.kind = TagKind.positive,
    this.iconCodePoint,
    this.isDefault = true,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  int id;
  String slug;
  String name;
  int score;
  TagKind kind;
  int? iconCodePoint;
  bool isDefault;
  DateTime createdAt;

  /// Named constructor lama — dipertahankan untuk kompatibilitas seeder.
  MuhasabahTag.create({
    required this.slug,
    required this.name,
    required this.score,
    required this.kind,
    this.iconCodePoint,
    this.isDefault = true,
  })  : id = 0,
        createdAt = DateTime.now();
}
