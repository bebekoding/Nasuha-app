class PrayerSchedule {
  final DateTime fajr;
  final DateTime sunrise;
  final DateTime dhuhr;
  final DateTime asr;
  final DateTime maghrib;
  final DateTime isha;
  final double latitude;
  final double longitude;
  final String methodName;

  /// Human-readable location from reverse geocoding, e.g. "Jakarta, Indonesia".
  /// Null if geocoding is unavailable (no internet / device unsupported).
  final String? locationName;

  const PrayerSchedule({
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
    required this.latitude,
    required this.longitude,
    required this.methodName,
    this.locationName,
  });

  List<({String name, DateTime time, String icon})> get allTimes => [
        (name: 'Subuh', time: fajr, icon: '🌅'),
        (name: 'Terbit', time: sunrise, icon: '☀️'),
        (name: 'Dzuhur', time: dhuhr, icon: '🌤'),
        (name: 'Ashar', time: asr, icon: '⛅'),
        (name: 'Maghrib', time: maghrib, icon: '🌇'),
        (name: 'Isya', time: isha, icon: '🌙'),
      ];

  ({String name, DateTime time, String icon}) get next {
    final now = DateTime.now();
    for (final t in allTimes) {
      if (t.time.isAfter(now)) return t;
    }
    return allTimes.first;
  }
}
