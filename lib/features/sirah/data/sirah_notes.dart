/// Catatan riwayat & sanad untuk cerita di dalam chapter Sirah.
///
/// Dipisahkan dari body chapter supaya narasi tetap mengalir bersih.
/// Yang penasaran soal sanad / riwayat variasi bisa buka menu ini.
class SirahNote {
  final int chapterNumber;
  final String chapterTitle;
  final String subject; // topik dalam chapter (mis. "Tanggal kelahiran")
  final String body; // penjelasan lengkap
  const SirahNote({
    required this.chapterNumber,
    required this.chapterTitle,
    required this.subject,
    required this.body,
  });
}

/// Kumpulan catatan — disusun berdasarkan chapter yang dirujuk.
const List<SirahNote> kSirahNotes = [
  SirahNote(
    chapterNumber: 1,
    chapterTitle: 'Nasab & Kelahiran',
    subject: 'Tanggal kelahiran Rasulullah ﷺ',
    body:
        'Cerita menyebut tanggal 12 Rabi\'ul Awwal — ini adalah riwayat masyhur (pendapat mayoritas ulama sirah, termasuk Ibnu Ishaq) dan yang paling populer di Indonesia. Ibnu Hazm dan sebagian ulama lain menyebut tanggal 8 atau 9 Rabi\'ul Awwal. '
        'Yang disepakati semua ulama adalah hari Senin — berdasarkan sabda Nabi ﷺ sendiri (HR. Muslim 1162): "Itu adalah hari aku dilahirkan." Perbedaan tanggal terjadi karena kalender Arab Jahiliyah tidak seragam, dan sumber utama sejarah kelahiran ditulis lebih dari seabad setelahnya.',
  ),
  SirahNote(
    chapterNumber: 1,
    chapterTitle: 'Nasab & Kelahiran',
    subject: 'Tanda-tanda mengiringi kelahiran',
    body:
        'Runtuhnya empat belas balkon istana Kisra, padamnya api sesembahan Majusi Persia yang menyala seribu tahun, dan keringnya Danau Sawah — riwayat-riwayat ini terekam dalam Dala\'il An-Nubuwwah Al-Bayhaqi dan sirah tradisional (Ibnu Hisyam, Al-Wazir, dll). '
        'Sebagian muhaddits kontemporer (Al-Albani antaranya) menilai sanadnya lemah/tidak sahih. Ulama lain menerimanya sebagai bagian dari khabar tradisi sirah yang saling menguatkan (syawahid), meski tidak mencapai derajat hadits sahih. Cerita ini disebutkan dalam bab ini sebagai bagian dari khazanah tradisi sirah, bukan sebagai fakta yang diverifikasi melalui hadits sahih.',
  ),
  SirahNote(
    chapterNumber: 4,
    chapterTitle: 'Masa Muda & Al-Amin',
    subject: 'Kisah pertemuan dengan Rahib Buhaira',
    body:
        'Kisah ini diriwayatkan Tirmidzi (nomor 3620) dan sebagian sumber sirah lain. Al-Albani menilai isnadnya bermasalah dalam Silsilah Adh-Dha\'ifah. Sebagian ulama lain menerima dengan pertimbangan syawahid (dukungan riwayat lain). '
        'Yang disepakati: perjalanan Muhammad muda ke Syam bersama Abu Thalib adalah fakta dalam sirah. Detail pertemuan dengan Buhaira dan tanda-tanda spesifik (awan menaungi, ranting menunduk) adalah bagian yang sanadnya diperbincangkan.',
  ),
  SirahNote(
    chapterNumber: 5,
    chapterTitle: 'Pernikahan dengan Khadijah',
    subject: 'Usia Khadijah saat menikah',
    body:
        'Riwayat masyhur — dan yang paling sering disebut di sirah tradisional — menyatakan Khadijah berusia 40 tahun saat menikah dengan Muhammad ﷺ (25 tahun). Ini pendapat Ibnu Ishaq dan mayoritas awal ulama sirah. '
        'Sebagian ulama & sejarawan (mengutip riwayat dari Ibnu \'Abbas dan Ibnu Sa\'d dengan sanad tertentu) berpendapat usia Khadijah lebih muda — sekitar 28 atau 30 tahun — yang mereka anggap lebih konsisten dengan fakta beliau melahirkan enam anak Nabi ﷺ setelah pernikahan. '
        'Perantara yang disebutkan (Nafisah binti Munyah) berasal dari riwayat Ibnu Ishaq, bukan dari kitab hadits utama.',
  ),
  SirahNote(
    chapterNumber: 6,
    chapterTitle: 'Wahyu Pertama',
    subject: 'Tanggal turunnya wahyu pertama',
    body:
        'Tanggal 17 Ramadhan adalah pendapat mayoritas ulama Indonesia, berdasarkan riwayat dari Ibnu \'Abbas dan atsar sahabat. Namun **tidak ada hadits sahih yang secara spesifik menetapkan tanggal ini** — Al-Qur\'an sendiri hanya menyebut "malam Al-Qadar" tanpa spesifikasi tanggal. '
        'Ulama lain menyebut kemungkinan 21 atau 24 Ramadhan (berdasarkan hadits-hadits tentang malam Lailatul Qadar di sepuluh malam terakhir). Sebagian ulama modern lebih hati-hati: yang pasti adalah **bulan Ramadhan**, sedangkan tanggal spesifiknya masuk ranah ijtihad.',
  ),
  SirahNote(
    chapterNumber: 10,
    chapterTitle: 'Isra\' & Mi\'raj',
    subject: 'Tanggal peristiwa Isra\' Mi\'raj',
    body:
        'Riwayat masyhur di Indonesia menyebut malam 27 Rajab, dan hari itu dirayakan sebagai peringatan Isra\' Mi\'raj. Namun **tidak ada hadits sahih yang menetapkan tanggal spesifik** ini. '
        'Ulama besar seperti Ibnu Hajar, An-Nawawi, dan Ibnu Katsir menyebutkan beragam kemungkinan tanpa memastikan — sebagian menyebut Rabi\'ul Awwal, sebagian Rajab, sebagian lagi Ramadhan. Yang disepakati: peristiwa ini terjadi setelah Tahun Kesedihan (± tahun 10-11 kenabian) dan sebelum hijrah ke Madinah.',
  ),
  SirahNote(
    chapterNumber: 10,
    chapterTitle: 'Isra\' & Mi\'raj',
    subject: 'Persinggahan Buraq di 4 tempat suci',
    body:
        'Rincian bahwa Buraq berhenti di Madinah, Madyan, Thur Sina, dan Betlehem berasal dari riwayat Nasa\'i. Sanad detail persinggahan ini dinilai lemah oleh sebagian muhaddits kontemporer. '
        'Yang disepakati dari inti Isra\' (Muttafaq \'alaih di Bukhari & Muslim): titik awal Masjidil Haram di Makkah, titik akhir Isra\' di Masjidil Aqsha Yerusalem, kemudian Mi\'raj naik ke langit hingga Sidratul Muntaha, pertemuan dengan para nabi di setiap lapisan langit, dan penetapan sholat lima waktu.',
  ),
  SirahNote(
    chapterNumber: 11,
    chapterTitle: 'Bai\'at Aqabah & Hijrah',
    subject: 'Sarang laba-laba & merpati di Gua Tsur',
    body:
        'Kisah sarang laba-laba dan sarang burung merpati yang menutupi mulut Gua Tsur sangat populer di sirah tradisional dan diriwayatkan sebagian ulama tafsir. Namun **sanadnya diperbincangkan**: Al-Albani menilai lemah/tidak tsabit dalam Silsilah Adh-Dha\'ifah. Sebagian ulama menerima dengan syawahid. '
        'Yang **sahih** (Muttafaq \'alaih — Bukhari 3653 & Muslim 2381 dari Anas): dialog Abu Bakar melihat kaki pengejar dari bawah dan berbisik cemas — "Kalau salah satu melihat ke bawah kaki, ia akan melihat kita" — dan jawaban Rasulullah yang direkam Al-Qur\'an: "Jangan bersedih, sesungguhnya Allah bersama kita." (QS. At-Taubah: 40). Ini adalah bagian yang sanadnya kuat dan paling utama untuk diambil pelajarannya.',
  ),
  SirahNote(
    chapterNumber: 15,
    chapterTitle: 'Perang Khandaq',
    subject: 'Jumlah eksekusi Bani Quraidhah',
    body:
        'Angka yang disebut dalam bab (± 400-700) mencerminkan variasi antar riwayat. Ibnu Ishaq (dalam Sirah Ibnu Hisyam) menyebut 600-900 lelaki dewasa. Sebagian riwayat lain menyebut sekitar 400. '
        'Ulama sirah kontemporer memperdebatkan angka pastinya karena sumber-sumber berbeda dalam nominal, meski semua sepakat bahwa yang dieksekusi adalah lelaki dewasa yang telah berperang, sesuai hukum Taurat mereka sendiri (dipilih Sa\'ad bin Mu\'adz sebagai hakim atas permintaan Bani Quraidhah).',
  ),
  SirahNote(
    chapterNumber: 19,
    chapterTitle: 'Haji Wada\' & Khutbah Terakhir',
    subject: 'Umar menangis menafsirkan QS Al-Maidah 3',
    body:
        'Turunnya ayat QS Al-Ma\'idah 3 ("Pada hari ini telah Kusempurnakan agamamu…") di Arafah dalam kondisi Nabi ﷺ di atas untanya adalah **sahih** (Muttafaq \'alaih dari Umar bin Khaththab — Bukhari 45 & Muslim 3017). '
        'Kisah tambahan bahwa Umar menangis saat ayat itu turun dan berkata "Setelah kesempurnaan hanya ada kekurangan" (menafsirkan sebagai tanda ajal Rasulullah dekat) diriwayatkan dalam beberapa tafsir (Ibnu Katsir, Ibnu Jarir Ath-Thabari), namun sanadnya dinilai sebagian ulama sebagai mursal atau memiliki cacat. Bagaimanapun, sekitar 80 hari setelah Haji Wada\', Rasulullah memang wafat — sehingga penafsiran Umar kelak terbukti benar secara peristiwa.',
  ),
  SirahNote(
    chapterNumber: 20,
    chapterTitle: 'Wafatnya Rasulullah',
    subject: 'Tanggal wafat Rasulullah ﷺ',
    body:
        'Riwayat masyhur — dan yang paling sering dicantumkan di kalender Islam — menyebut hari Senin, 12 Rabi\'ul Awwal 11 H (± 8 Juni 632 M). Ibnu Hazm dan sebagian ulama lain menetapkan tanggal 1 atau 2 Rabi\'ul Awwal berdasarkan perhitungan haji wada\' dan durasi sakit beliau. '
        'Yang **disepakati** semua ulama: wafat pada hari Senin, di bulan Rabi\'ul Awwal 11 H, waktu Dhuha, di kamar Aisyah di Madinah. Umur beliau 63 tahun.',
  ),
];
