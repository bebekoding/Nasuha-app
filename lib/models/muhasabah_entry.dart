import 'muhasabah_tag.dart';

export 'muhasabah_tag.dart' show TagKind;

/// Catatan muhasabah harian — plain Dart (menggantikan @collection Isar).
class MuhasabahEntry {
  MuhasabahEntry({
    this.id = 0,
    this.dateKey = '',
    DateTime? createdAt,
    this.tagSlug = '',
    this.tagName = '',
    this.tagScore = 0,
    this.kind = TagKind.positive,
    this.note,
  }) : createdAt = createdAt ?? DateTime.now();

  int id;
  String dateKey;
  DateTime createdAt;

  /// Snapshot slug/name/score/kind saat entry dibuat — supaya edit tag tak
  /// mengganggu histori.
  String tagSlug;
  String tagName;
  int tagScore;
  TagKind kind;

  String? note;
}
