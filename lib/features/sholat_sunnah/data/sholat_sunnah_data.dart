import 'package:flutter/material.dart';

class NiatDoa {
  final String arabic;
  final String latin;
  final String translation;
  const NiatDoa({
    required this.arabic,
    required this.latin,
    required this.translation,
  });
}

class SholatSunnah {
  final String id;
  final String title;
  final String rakaat;
  final String waktu;
  final String hukum; // sunnah muakkad / ghairu muakkad
  final IconData icon;
  final NiatDoa? niat;
  final List<String> tataCara;
  final String keutamaan;
  final String? catatan;

  const SholatSunnah({
    required this.id,
    required this.title,
    required this.rakaat,
    required this.waktu,
    required this.hukum,
    required this.icon,
    required this.tataCara,
    required this.keutamaan,
    this.niat,
    this.catatan,
  });
}

// ⚠️ CATATAN: Tata cara di bawah disusun ringkas berdasarkan rujukan umum.
// Mohon diverifikasi (teks niat, jumlah takbir, urutan) dengan sumber/ustadz
// terpercaya sebelum rilis publik. Perbedaan mazhab mungkin ada.

const List<SholatSunnah> kSholatSunnah = [
  // ─────────────────────────── DHUHA ───────────────────────────
  SholatSunnah(
    id: 'dhuha',
    title: 'Sholat Dhuha',
    rakaat: '2 – 12 rakaat (kelipatan 2)',
    waktu:
        'Sejak matahari naik ± setinggi tombak (±15 menit setelah terbit) hingga menjelang Dzuhur',
    hukum: 'Sunnah',
    icon: Icons.wb_sunny,
    niat: NiatDoa(
      arabic: 'أُصَلِّي سُنَّةَ الضُّحَى رَكْعَتَيْنِ لِلَّهِ تَعَالَى',
      latin: 'Ushallī sunnataḍ-ḍuḥā rak\'ataini lillāhi ta\'ālā',
      translation:
          'Aku berniat sholat sunnah Dhuha dua rakaat karena Allah Ta\'ala.',
    ),
    tataCara: [
      'Berniat sholat Dhuha (boleh dalam hati).',
      'Takbiratul ihram, lalu membaca doa iftitah.',
      'Membaca Al-Fatihah dilanjutkan surat — dianjurkan Asy-Syams pada rakaat pertama.',
      'Ruku, i\'tidal, sujud dua kali sebagaimana sholat biasa.',
      'Rakaat kedua: Al-Fatihah lalu surat — dianjurkan Adh-Dhuha.',
      'Tasyahud akhir lalu salam.',
      'Boleh diulang hingga total 12 rakaat (salam tiap 2 rakaat).',
      'Setelah salam terakhir: istighfar 3× "Astaghfirullāhal-\'aẓīm wa atūbu ilaih" (HR. Muslim 591).',
      'Perbanyak "Allāhumma innī as\'aluka min faḍlik" (memohon karunia rezeki).',
      'Tutup dengan doa Dhuha: "Allāhumma innaḍ-ḍuḥā\'a ḍuḥā\'uka…" — bacaan lengkap ada di menu Dzikir → Dzikir & Doa Dhuha.',
    ],
    keutamaan:
        'Setiap pagi setiap persendian manusia wajib bersedekah; dua rakaat Dhuha mencukupi sedekah itu (HR. Muslim 720). Siapa rutin mengerjakannya, dibangunkan rumah di surga (HR. Tirmidzi 473 — hasan).',
    catatan:
        'Bacaan dzikir & doa lengkap setelah Dhuha tersedia di menu Dzikir → "Dzikir & Doa Dhuha".',
  ),

  // ─────────────────────────── TAHAJUD ───────────────────────────
  SholatSunnah(
    id: 'tahajud',
    title: 'Sholat Tahajud',
    rakaat: '2 rakaat (minimal), boleh lebih dengan salam tiap 2 rakaat',
    waktu:
        'Setelah Isya hingga sebelum Subuh, dikerjakan setelah tidur. Paling utama di sepertiga malam terakhir',
    hukum: 'Sunnah muakkad',
    icon: Icons.bedtime,
    niat: NiatDoa(
      arabic: 'أُصَلِّي سُنَّةَ التَّهَجُّدِ رَكْعَتَيْنِ لِلَّهِ تَعَالَى',
      latin: 'Ushallī sunnatat-tahajjudi rak\'ataini lillāhi ta\'ālā',
      translation:
          'Aku berniat sholat sunnah Tahajud dua rakaat karena Allah Ta\'ala.',
    ),
    tataCara: [
      'Bangun dari tidur, berwudhu, lalu berniat sholat Tahajud.',
      'Iftitah dianjurkan: "Allāhumma lakal-ḥamdu anta nūrus-samāwāti wal-arḍ…" (doa Nabi ﷺ, HR. Bukhari 1120).',
      'Membaca Al-Fatihah dan surat apa saja (boleh memanjangkan bacaan).',
      'Ruku, i\'tidal, dua kali sujud seperti sholat biasa.',
      'Kerjakan rakaat kedua dengan cara yang sama, lalu tasyahud dan salam.',
      'Boleh menambah rakaat (2-2) sesuai kemampuan.',
      'Setelah salam terakhir: "Subḥānal-malikil-quddūs" 3× (HR. Nasa\'i 1699 — sahih), lalu istighfar 3×.',
      'Perbanyak doa & munajat — waktu ini Allah turun ke langit dunia (HR. Bukhari 1145, Muslim 758).',
      'Dianjurkan menutup malam dengan sholat Witir.',
    ],
    keutamaan:
        'Sholat malam adalah kebiasaan orang-orang saleh, sebab dosa diampuni, dan pendekat diri kepada Allah (HR. Tirmidzi 3549). "Dan pada sebagian malam, bertahajudlah…" (QS. Al-Isra: 79).',
    catatan:
        'Bacaan iftitah, dzikir, dan doa Nabi ﷺ untuk qiyamul lail tersedia lengkap di menu Dzikir → "Dzikir & Doa Tahajud".',
  ),

  // ─────────────────────────── WITIR ───────────────────────────
  SholatSunnah(
    id: 'witir',
    title: 'Sholat Witir',
    rakaat: '1, 3, 5, 7, 9, atau 11 rakaat (ganjil)',
    waktu:
        'Setelah Isya hingga sebelum Subuh. Bagi yang biasa bangun malam, paling utama di sepertiga malam terakhir setelah Tahajud',
    hukum: 'Sunnah muakkad',
    icon: Icons.nights_stay,
    niat: NiatDoa(
      arabic: 'أُصَلِّي سُنَّةَ الْوِتْرِ رَكْعَةً لِلَّهِ تَعَالَى',
      latin: 'Ushallī sunnatal-witri rak\'atan lillāhi ta\'ālā',
      translation:
          'Aku berniat sholat sunnah Witir satu rakaat karena Allah Ta\'ala. (Ganti "rak\'atan" → "ṡalāṡa raka\'āt" untuk 3 rakaat, dst.)',
    ),
    tataCara: [
      'Berniat sholat Witir dengan jumlah rakaat yang diinginkan (minimal 1, paling banyak 11).',
      'Format 3 rakaat — cara populer: 2 rakaat + salam, lalu 1 rakaat + salam (mengikuti Ibnu \'Umar, HR. Bukhari 991).',
      'Boleh juga 3 rakaat langsung dengan 1 salam tanpa tasyahud awal (HR. Nasa\'i, Hakim — sahih).',
      'Rakaat pertama dianjurkan surat Al-A\'lā, kedua Al-Kāfirūn, ketiga (Witir) Al-Ikhlāṣ + Al-Falaq + An-Nās (HR. Tirmidzi 463, Nasa\'i 1729 — sahih).',
      'Pada rakaat terakhir (setelah ruku\' i\'tidal, sebelum sujud) dianjurkan Doa Qunut Witir — bacaan di bawah.',
      'Sempurnakan dengan sujud, tasyahud akhir, dan salam.',
      'Setelah salam baca "Subḥānal-malikil-quddūs" 3× — pada bacaan ketiga suara ditinggikan dan dipanjangkan (HR. Nasa\'i 1699, Abu Dawud 1430 — sahih).',
      'Doa Qunut Witir: "Allāhummahdinī fīman hadait, wa \'āfinī fīman \'āfait, wa tawallanī fīman tawallait, wa bārik lī fīmā a\'ṭait, wa qinī syarra mā qaḍait, fa innaka taqḍī wa lā yuqḍā \'alaik, wa innahū lā yażillu man wālait, wa lā ya\'izzu man \'ādait, tabārakta rabbanā wa ta\'ālait" — "Ya Allah, tunjukilah aku bersama orang yang Engkau tunjuki, sehatkan aku bersama orang yang Engkau sehatkan, urusi aku bersama orang yang Engkau urusi, berkahi apa yang Engkau berikan, lindungi aku dari kejahatan yang Engkau tetapkan. Sungguh Engkau menetapkan dan tak ada yang bisa menetapkan atas-Mu; tidak akan hina orang yang Engkau tolong, tidak akan mulia orang yang Engkau musuhi. Maha Berkah Engkau, Tuhan kami, dan Maha Tinggi." (HR. Abu Dawud 1425, Tirmidzi 464, Nasa\'i 1745 — sahih dari Al-Ḥasan bin \'Alī).',
    ],
    keutamaan:
        '"Sesungguhnya Allah itu Witir (ganjil) dan menyukai yang ganjil, maka berwitirlah wahai ahli Al-Quran." (HR. Abu Dawud 1416, Tirmidzi 453 — sahih). Nabi ﷺ tidak pernah meninggalkan Witir baik dalam safar maupun mukim (HR. Ahmad, Baihaqi). Witir adalah penutup sholat malam.',
    catatan:
        'Kalau khawatir tidak bangun malam, kerjakan Witir sebelum tidur. Kalau yakin bisa bangun, akhirkan setelah Tahajud — itu lebih utama (HR. Muslim 755). Tidak ada dua Witir dalam satu malam (HR. Abu Dawud 1439, Tirmidzi 470 — sahih).',
  ),

  // ─────────────────────────── TAUBAT ───────────────────────────
  SholatSunnah(
    id: 'taubat',
    title: 'Sholat Taubat',
    rakaat: '2 rakaat',
    waktu:
        'Kapan saja saat ingin bertaubat (hindari waktu terlarang). Lebih utama di malam hari',
    hukum: 'Sunnah',
    icon: Icons.volunteer_activism,
    niat: NiatDoa(
      arabic: 'أُصَلِّي سُنَّةَ التَّوْبَةِ رَكْعَتَيْنِ لِلَّهِ تَعَالَى',
      latin: 'Ushallī sunnatat-taubati rak\'ataini lillāhi ta\'ālā',
      translation:
          'Aku berniat sholat sunnah Taubat dua rakaat karena Allah Ta\'ala.',
    ),
    tataCara: [
      'Berwudhu dengan sempurna, lalu berniat sholat Taubat.',
      'Takbiratul ihram dan doa iftitah.',
      'Membaca Al-Fatihah dan surat (mis. Al-Kafirun pada rakaat pertama).',
      'Sempurnakan rakaat pertama, lalu rakaat kedua (mis. Al-Ikhlas).',
      'Tasyahud akhir lalu salam.',
      'Setelah salam, perbanyak istighfar dan sayyidul istighfar.',
      'Menyesali dosa, bertekad tidak mengulangi, dan kembalikan hak bila terkait orang lain.',
    ],
    keutamaan:
        'Tidaklah seseorang berbuat dosa lalu berwudhu, sholat dua rakaat, dan memohon ampun kepada Allah, kecuali Allah mengampuninya (HR. Abu Dawud & Tirmidzi).',
    catatan:
        'Sambungkan dengan dzikir Taubat di menu Dzikir untuk bacaan istighfar setelahnya.',
  ),

  // ─────────────────────────── IDUL FITRI ───────────────────────────
  SholatSunnah(
    id: 'idul_fitri',
    title: 'Sholat Idul Fitri',
    rakaat: '2 rakaat (berjamaah)',
    waktu:
        'Pagi 1 Syawal, sejak matahari naik ± setinggi tombak hingga sebelum Dzuhur',
    hukum: 'Sunnah muakkad',
    icon: Icons.celebration,
    niat: NiatDoa(
      arabic: 'أُصَلِّي سُنَّةً لِعِيدِ الْفِطْرِ رَكْعَتَيْنِ لِلَّهِ تَعَالَى',
      latin: 'Ushallī sunnatan li\'īdil-fiṭri rak\'ataini lillāhi ta\'ālā',
      translation:
          'Aku berniat sholat sunnah Idul Fitri dua rakaat karena Allah Ta\'ala.',
    ),
    tataCara: [
      'Mandi, memakai wangi-wangian dan pakaian terbaik. Makan sebelum berangkat.',
      'Berniat sholat Id, takbiratul ihram, lalu doa iftitah.',
      'Rakaat pertama: takbir tambahan 7 kali (selain takbiratul ihram); di antara takbir membaca tasbih.',
      'Membaca Al-Fatihah lalu surat (mis. Al-A\'la), ruku, sujud seperti biasa.',
      'Rakaat kedua: berdiri lalu takbir tambahan 5 kali sebelum Al-Fatihah.',
      'Membaca Al-Fatihah lalu surat (mis. Al-Ghasyiyah), sempurnakan hingga salam.',
      'Setelah salam, imam menyampaikan dua khutbah Id — jamaah dianjurkan menyimak.',
    ],
    keutamaan:
        'Menyemarakkan syiar Islam dan kebersamaan umat di hari kemenangan setelah sebulan berpuasa.',
    catatan:
        'Bacaan tasbih di antara takbir: "Subhānallāh wal-ḥamdulillāh wa lā ilāha illallāh wallāhu akbar".',
  ),

  // ─────────────────────────── IDUL ADHA ───────────────────────────
  SholatSunnah(
    id: 'idul_adha',
    title: 'Sholat Idul Adha',
    rakaat: '2 rakaat (berjamaah)',
    waktu:
        'Pagi 10 Dzulhijjah, lebih awal dari Idul Fitri agar memberi waktu penyembelihan kurban',
    hukum: 'Sunnah muakkad',
    icon: Icons.mosque,
    niat: NiatDoa(
      arabic: 'أُصَلِّي سُنَّةً لِعِيدِ الْأَضْحَى رَكْعَتَيْنِ لِلَّهِ تَعَالَى',
      latin: 'Ushallī sunnatan li\'īdil-aḍḥā rak\'ataini lillāhi ta\'ālā',
      translation:
          'Aku berniat sholat sunnah Idul Adha dua rakaat karena Allah Ta\'ala.',
    ),
    tataCara: [
      'Mandi dan memakai pakaian terbaik. Disunnahkan TIDAK makan dulu hingga selesai sholat.',
      'Berniat sholat Id, takbiratul ihram, lalu doa iftitah.',
      'Rakaat pertama: takbir tambahan 7 kali, di antaranya membaca tasbih.',
      'Al-Fatihah lalu surat (mis. Qaf atau Al-A\'la), ruku dan sujud seperti biasa.',
      'Rakaat kedua: takbir tambahan 5 kali sebelum Al-Fatihah.',
      'Al-Fatihah lalu surat (mis. Al-Qamar atau Al-Ghasyiyah), sempurnakan hingga salam.',
      'Mendengarkan dua khutbah Id, dilanjutkan penyembelihan hewan kurban.',
    ],
    keutamaan:
        'Mengikuti sunnah Nabi Ibrahim & Nabi Muhammad ﷺ serta menghidupkan ibadah kurban di hari raya haji.',
  ),

  // ─────────────── QOBLIYAH & BA'DIYAH (RAWATIB) ───────────────
  SholatSunnah(
    id: 'rawatib',
    title: 'Qobliyah & Ba\'diyah (Rawatib)',
    rakaat: 'Masing-masing 2 rakaat (lihat rincian)',
    waktu: 'Mengiringi sholat fardhu — sebelum (qobliyah) & sesudah (ba\'diyah)',
    hukum: 'Sebagian muakkad, sebagian ghairu muakkad',
    icon: Icons.repeat,
    niat: NiatDoa(
      arabic: 'أُصَلِّي سُنَّةَ الصُّبْحِ رَكْعَتَيْنِ قَبْلِيَّةً لِلَّهِ تَعَالَى',
      latin: 'Ushallī sunnataṣ-ṣubḥi rak\'ataini qabliyyatan lillāhi ta\'ālā',
      translation:
          'Aku berniat sholat sunnah qobliyah Subuh dua rakaat karena Allah Ta\'ala. (Ganti nama sholat sesuai waktunya — mis. "ba\'diyyah" untuk sesudah.)',
    ),
    tataCara: [
      'Rincian rawatib muakkad (sangat dianjurkan):',
      '• 2 rakaat sebelum Subuh — paling utama, jangan ditinggalkan.',
      '• 2 atau 4 rakaat sebelum Dzuhur, dan 2 rakaat sesudahnya.',
      '• 2 rakaat sesudah Maghrib.',
      '• 2 rakaat sesudah Isya.',
      'Rawatib ghairu muakkad (tetap berpahala): 4 rakaat sebelum Ashar, 2 rakaat sebelum Maghrib, 2 rakaat sebelum Isya.',
      'Cara mengerjakan sama seperti sholat sunnah 2 rakaat biasa, salam tiap 2 rakaat.',
      'Dikerjakan sendiri-sendiri (tidak berjamaah).',
    ],
    keutamaan:
        'Siapa sholat 12 rakaat rawatib dalam sehari semalam, dibangunkan untuknya rumah di surga (HR. Muslim). Dua rakaat fajar (sebelum Subuh) lebih baik dari dunia dan seisinya.',
  ),
];
