class SeedAchievement {
  final String code;
  final String title;
  final String description;
  final int target;

  const SeedAchievement({
    required this.code,
    required this.title,
    required this.description,
    required this.target,
  });
}

const List<SeedAchievement> kSeedAchievements = [
  SeedAchievement(
    code: 'prayer_7',
    title: '7 Days Consistent Prayer',
    description: 'Sholat 5 waktu selama 7 hari berturut-turut.',
    target: 7,
  ),
  SeedAchievement(
    code: 'quran_30',
    title: '30 Days Reading Quran',
    description: 'Baca Al-Quran 30 hari berturut-turut.',
    target: 30,
  ),
  SeedAchievement(
    code: 'muhasabah_100',
    title: '100 Days Muhasabah',
    description: 'Muhasabah harian selama 100 hari.',
    target: 100,
  ),
  SeedAchievement(
    code: 'no_smoking_30',
    title: '30 Days Without Smoking',
    description: '30 hari tanpa merokok.',
    target: 30,
  ),
  SeedAchievement(
    code: 'tahajud_7',
    title: '7 Days Tahajud',
    description: 'Tahajud 7 hari berturut-turut.',
    target: 7,
  ),
  SeedAchievement(
    code: 'charity_100',
    title: '100 Charity Acts',
    description: '100 kali bersedekah.',
    target: 100,
  ),
  SeedAchievement(
    code: 'muhasabah_365',
    title: '365 Days Consistent Muhasabah',
    description: 'Muhasabah harian selama 1 tahun penuh.',
    target: 365,
  ),
];
