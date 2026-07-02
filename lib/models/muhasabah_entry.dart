import 'package:isar/isar.dart';

import 'muhasabah_tag.dart';

part 'muhasabah_entry.g.dart';

@collection
class MuhasabahEntry {
  Id id = Isar.autoIncrement;

  /// Date bucket in yyyy-MM-dd form, indexed for fast aggregation.
  @Index()
  late String dateKey;

  late DateTime createdAt;

  /// Snapshot of tag slug at time of entry — so future tag edits/removal don't
  /// distort history.
  late String tagSlug;
  late String tagName;
  late int tagScore;

  @Enumerated(EnumType.name)
  late TagKind kind;

  String? note;

  MuhasabahEntry();
}
