/// Catatan sedekah — plain Dart data class (menggantikan model Isar).
///
/// Disimpan lewat tabel Drift `CharityRecordsTable`; UI menggunakan class ini.
/// Class dibuat **mutable** biar drop-in dengan pola caller lama
/// `.. amount = x` / `.. category = y`.
class CharityRecord {
  CharityRecord({
    this.id = 0, // 0 = belum diinsert; Drift meng-assign via autoIncrement
    this.dateKey = '',
    DateTime? createdAt,
    this.amount = 0,
    this.note,
    this.category,
  }) : createdAt = createdAt ?? DateTime.now();

  int id;
  String dateKey;
  DateTime createdAt;
  double amount;
  String? note;
  String? category;
}
