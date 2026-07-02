/// Streak (hari beruntun) untuk kategori tertentu — mis. 'muhasabah'.
///
/// Plain Dart — persisted via tabel Drift `StreaksTable`. `key` unik.
class Streak {
  Streak({
    this.id = 0,
    this.key = '',
    this.current = 0,
    this.longest = 0,
    this.lastDateKey = '',
  });

  int id;
  String key;
  int current;
  int longest;
  String lastDateKey;
}
