/// Ringkasan skor harian (agregasi dari MuhasabahEntry).
///
/// Plain Dart — persisted via tabel Drift `DailyScoresTable`. `dateKey`
/// unik (yyyy-MM-dd).
class DailyScore {
  DailyScore({
    this.id = 0,
    this.dateKey = '',
    this.total = 0,
    this.positiveCount = 0,
    this.negativeCount = 0,
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? DateTime.now();

  int id;
  String dateKey;
  int total;
  int positiveCount;
  int negativeCount;
  DateTime updatedAt;
}
