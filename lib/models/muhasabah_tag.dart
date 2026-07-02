import 'package:isar/isar.dart';

part 'muhasabah_tag.g.dart';

@collection
class MuhasabahTag {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String slug;

  late String name;
  late int score;

  @Enumerated(EnumType.name)
  late TagKind kind;

  /// Material icon codepoint (optional)
  int? iconCodePoint;

  late bool isDefault;
  late DateTime createdAt;

  MuhasabahTag();

  MuhasabahTag.create({
    required this.slug,
    required this.name,
    required this.score,
    required this.kind,
    this.iconCodePoint,
    this.isDefault = true,
  }) : createdAt = DateTime.now();
}

enum TagKind { positive, negative }
