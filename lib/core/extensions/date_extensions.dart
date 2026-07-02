extension DateOnly on DateTime {
  DateTime get dateOnly => DateTime(year, month, day);

  String get isoDate =>
      '$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';

  bool isSameDay(DateTime other) =>
      year == other.year && month == other.month && day == other.day;
}
