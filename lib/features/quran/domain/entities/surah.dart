class SurahSummary {
  final int number;
  final String nameArabic;
  final String nameLatin;
  final String nameTranslation;
  final int verseCount;
  final String revelation;

  const SurahSummary({
    required this.number,
    required this.nameArabic,
    required this.nameLatin,
    required this.nameTranslation,
    required this.verseCount,
    required this.revelation,
  });

  factory SurahSummary.fromJson(Map<String, dynamic> json) => SurahSummary(
        number: json['nomor'] as int,
        nameArabic: (json['nama'] ?? '') as String,
        nameLatin: (json['namaLatin'] ?? '') as String,
        nameTranslation: (json['arti'] ?? '') as String,
        verseCount: (json['jumlahAyat'] ?? 0) as int,
        revelation: (json['tempatTurun'] ?? '') as String,
      );
}

class Verse {
  final int number;
  final String arabic;
  final String latin;
  final String translation;

  const Verse({
    required this.number,
    required this.arabic,
    required this.latin,
    required this.translation,
  });

  factory Verse.fromJson(Map<String, dynamic> json) => Verse(
        number: json['nomorAyat'] as int,
        arabic: (json['teksArab'] ?? '') as String,
        latin: (json['teksLatin'] ?? '') as String,
        translation: (json['teksIndonesia'] ?? '') as String,
      );

  Map<String, dynamic> toJson() => {
        'nomorAyat': number,
        'teksArab': arabic,
        'teksLatin': latin,
        'teksIndonesia': translation,
      };
}

class SurahDetail {
  final SurahSummary summary;
  final List<Verse> verses;
  const SurahDetail({required this.summary, required this.verses});
}
