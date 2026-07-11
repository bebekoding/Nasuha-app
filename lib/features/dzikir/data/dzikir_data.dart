import 'package:flutter/material.dart';

/// One dzikir/doa entry.
class DzikirItem {
  final String arabic;
  final String latin;
  final String translation;
  final int count; // berapa kali dibaca
  final String? note; // keutamaan / sumber (opsional)

  const DzikirItem({
    required this.arabic,
    required this.latin,
    required this.translation,
    this.count = 1,
    this.note,
  });
}

/// A group of dzikir (mis. "Dzikir Pagi").
class DzikirCategory {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final List<DzikirItem> items;

  const DzikirCategory({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.items,
  });
}

// ⚠️ CATATAN: Konten di bawah adalah kumpulan dzikir yang umum & masyhur.
// Mohon diverifikasi keakuratannya (teks Arab, harakat, jumlah) dengan sumber
// terpercaya sebelum rilis publik.

const List<DzikirCategory> kDzikirCategories = [
  // ─────────────────────────── DZIKIR PAGI ───────────────────────────
  DzikirCategory(
    id: 'pagi',
    title: 'Dzikir Pagi',
    subtitle: 'Dibaca setelah Subuh hingga terbit matahari',
    icon: Icons.wb_twilight,
    items: [
      DzikirItem(
        arabic:
            'أَعُوذُ بِاللَّهِ مِنَ الشَّيْطَانِ الرَّجِيمِ. اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ ۚ لَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ ۚ لَهُ مَا فِي السَّمَاوَاتِ وَمَا فِي الْأَرْضِ ۗ مَنْ ذَا الَّذِي يَشْفَعُ عِنْدَهُ إِلَّا بِإِذْنِهِ ۚ يَعْلَمُ مَا بَيْنَ أَيْدِيهِمْ وَمَا خَلْفَهُمْ ۖ وَلَا يُحِيطُونَ بِشَيْءٍ مِنْ عِلْمِهِ إِلَّا بِمَا شَاءَ ۚ وَسِعَ كُرْسِيُّهُ السَّمَاوَاتِ وَالْأَرْضَ ۖ وَلَا يَئُودُهُ حِفْظُهُمَا ۚ وَهُوَ الْعَلِيُّ الْعَظِيمُ',
        latin:
            'A\'ūżu billāhi minasy-syaiṭānir-rajīm. Allāhu lā ilāha illā huwal-ḥayyul-qayyūm, lā ta\'khużuhū sinatuw wa lā naum, lahū mā fis-samāwāti wa mā fil-arḍ, man żal-lażī yasyfa\'u \'indahū illā bi\'iżnih, ya\'lamu mā baina aidīhim wa mā khalfahum, wa lā yuḥīṭūna bisyai\'im min \'ilmihī illā bimā syā\', wasi\'a kursiyyuhus-samāwāti wal-arḍ, wa lā ya\'ūduhū ḥifẓuhumā, wa huwal-\'aliyyul-\'aẓīm',
        translation:
            'Allah, tidak ada Tuhan selain Dia, Yang Maha Hidup, Yang terus-menerus mengurus (makhluk-Nya). Dia tidak mengantuk dan tidak tidur. Milik-Nya apa yang ada di langit dan di bumi. Tidak ada yang dapat memberi syafaat di sisi-Nya tanpa izin-Nya. Dia mengetahui apa yang di hadapan mereka dan apa yang di belakang mereka, dan mereka tidak mengetahui sesuatu apa pun tentang ilmu-Nya kecuali apa yang Dia kehendaki. Kursi-Nya meliputi langit dan bumi, dan Dia tidak merasa berat memelihara keduanya. Dialah Yang Maha Tinggi lagi Maha Agung. (Ayat Kursi — Al-Baqarah: 255)',
        count: 1,
        note: 'Siapa membacanya di pagi hari, ia dijaga dari gangguan setan hingga sore.',
      ),
      DzikirItem(
        arabic:
            'قُلْ هُوَ اللَّهُ أَحَدٌ ۝ اللَّهُ الصَّمَدُ ۝ لَمْ يَلِدْ وَلَمْ يُولَدْ ۝ وَلَمْ يَكُن لَّهُ كُفُوًا أَحَدٌ',
        latin:
            'Qul huwallāhu aḥad. Allāhuṣ-ṣamad. Lam yalid wa lam yūlad. Wa lam yakul-lahū kufuwan aḥad',
        translation:
            'Katakanlah: Dialah Allah Yang Maha Esa. Allah tempat bergantung segala sesuatu. Dia tidak beranak dan tidak pula diperanakkan. Dan tidak ada sesuatu yang setara dengan Dia. (Surat Al-Ikhlas)',
        count: 3,
      ),
      DzikirItem(
        arabic:
            'قُلْ أَعُوذُ بِرَبِّ الْفَلَقِ ۝ مِنْ شَرِّ مَا خَلَقَ ۝ وَمِنْ شَرِّ غَاسِقٍ إِذَا وَقَبَ ۝ وَمِنْ شَرِّ النَّفَّاثَاتِ فِي الْعُقَدِ ۝ وَمِنْ شَرِّ حَاسِدٍ إِذَا حَسَدَ',
        latin:
            'Qul a\'ūżu bi rabbil-falaq. Min syarri mā khalaq. Wa min syarri ghāsiqin iżā waqab. Wa min syarrin-naffāṡāti fil-\'uqad. Wa min syarri ḥāsidin iżā ḥasad',
        translation:
            'Katakanlah: Aku berlindung kepada Tuhan yang menguasai subuh, dari kejahatan makhluk-Nya, dari kejahatan malam apabila telah gelap gulita, dari kejahatan (perempuan-perempuan) penyihir yang meniup pada buhul-buhul, dan dari kejahatan orang yang dengki apabila ia dengki. (Surat Al-Falaq)',
        count: 3,
      ),
      DzikirItem(
        arabic:
            'قُلْ أَعُوذُ بِرَبِّ النَّاسِ ۝ مَلِكِ النَّاسِ ۝ إِلَٰهِ النَّاسِ ۝ مِنْ شَرِّ الْوَسْوَاسِ الْخَنَّاسِ ۝ الَّذِي يُوَسْوِسُ فِي صُدُورِ النَّاسِ ۝ مِنَ الْجِنَّةِ وَالنَّاسِ',
        latin:
            'Qul a\'ūżu bi rabbin-nās. Malikin-nās. Ilāhin-nās. Min syarril-waswāsil-khannās. Allażī yuwaswisu fī ṣudūrin-nās. Minal-jinnati wan-nās',
        translation:
            'Katakanlah: Aku berlindung kepada Tuhan manusia, Raja manusia, Sembahan manusia, dari kejahatan (bisikan) setan yang biasa bersembunyi, yang membisikkan (kejahatan) ke dalam dada manusia, dari (golongan) jin dan manusia. (Surat An-Nas)',
        count: 3,
      ),
      DzikirItem(
        arabic:
            'أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لَا إِلَٰهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ',
        latin:
            'Aṣbaḥnā wa aṣbaḥal-mulku lillāh, wal-ḥamdu lillāh, lā ilāha illallāhu waḥdahū lā syarīka lah, lahul-mulku wa lahul-ḥamd, wa huwa \'alā kulli syai\'in qadīr',
        translation:
            'Kami telah memasuki waktu pagi dan kerajaan hanya milik Allah. Segala puji bagi Allah. Tiada Tuhan selain Allah Yang Esa, tiada sekutu bagi-Nya. Milik-Nya kerajaan dan pujian, dan Dia Maha Kuasa atas segala sesuatu.',
        count: 1,
      ),
      DzikirItem(
        arabic:
            'اللَّهُمَّ أَنْتَ رَبِّي لَا إِلَٰهَ إِلَّا أَنْتَ، خَلَقْتَنِي وَأَنَا عَبْدُكَ، وَأَنَا عَلَى عَهْدِكَ وَوَعْدِكَ مَا اسْتَطَعْتُ، أَعُوذُ بِكَ مِنْ شَرِّ مَا صَنَعْتُ، أَبُوءُ لَكَ بِنِعْمَتِكَ عَلَيَّ، وَأَبُوءُ بِذَنْبِي فَاغْفِرْ لِي فَإِنَّهُ لَا يَغْفِرُ الذُّنُوبَ إِلَّا أَنْتَ',
        latin:
            'Allāhumma anta rabbī lā ilāha illā anta, khalaqtanī wa ana \'abduka, wa ana \'alā \'ahdika wa wa\'dika mastaṭa\'tu, a\'ūżu bika min syarri mā ṣana\'tu, abū\'u laka bini\'matika \'alayya, wa abū\'u biżanbī faghfir lī fa\'innahū lā yaghfiruż-żunūba illā anta',
        translation:
            'Ya Allah, Engkau Tuhanku, tiada Tuhan selain Engkau. Engkau ciptakan aku dan aku adalah hamba-Mu. Aku akan setia pada perjanjian dan janji-Mu semampuku. Aku berlindung kepada-Mu dari keburukan perbuatanku. Aku mengakui nikmat-Mu kepadaku dan aku mengakui dosaku, maka ampunilah aku. Sebab tiada yang dapat mengampuni dosa kecuali Engkau. (Sayyidul Istighfar — penghulu istighfar)',
        count: 1,
        note: 'Siapa membacanya dengan yakin di pagi hari lalu wafat hari itu, ia masuk surga.',
      ),
      DzikirItem(
        arabic: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ',
        latin: 'Subḥānallāhi wa biḥamdih',
        translation: 'Maha Suci Allah dan segala puji bagi-Nya.',
        count: 100,
        note: 'Dihapuskan dosa-dosanya walau sebanyak buih di lautan.',
      ),
      DzikirItem(
        arabic:
            'لَا إِلَٰهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ، وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ',
        latin:
            'Lā ilāha illallāhu waḥdahū lā syarīka lah, lahul-mulku wa lahul-ḥamd, wa huwa \'alā kulli syai\'in qadīr',
        translation:
            'Tiada Tuhan selain Allah Yang Esa, tiada sekutu bagi-Nya. Milik-Nya kerajaan dan pujian, dan Dia Maha Kuasa atas segala sesuatu.',
        count: 10,
      ),
      DzikirItem(
        arabic:
            'بِسْمِ اللَّهِ الَّذِي لَا يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الْأَرْضِ وَلَا فِي السَّمَاءِ وَهُوَ السَّمِيعُ الْعَلِيمُ',
        latin:
            'Bismillāhillażī lā yaḍurru ma\'asmihī syai\'un fil-arḍi wa lā fis-samā\', wa huwas-samī\'ul-\'alīm',
        translation:
            'Dengan nama Allah yang bersama nama-Nya tidak ada sesuatu pun yang membahayakan, baik di bumi maupun di langit. Dialah Yang Maha Mendengar lagi Maha Mengetahui.',
        count: 3,
        note: 'Tidak akan ditimpa bahaya yang datang tiba-tiba.',
      ),
    ],
  ),

  // ─────────────────────────── DZIKIR PETANG ───────────────────────────
  DzikirCategory(
    id: 'petang',
    title: 'Dzikir Petang',
    subtitle: 'Dibaca setelah Ashar hingga matahari terbenam',
    icon: Icons.nightlight_round,
    items: [
      DzikirItem(
        arabic:
            'اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ ۚ لَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ ۚ لَهُ مَا فِي السَّمَاوَاتِ وَمَا فِي الْأَرْضِ ۗ مَنْ ذَا الَّذِي يَشْفَعُ عِنْدَهُ إِلَّا بِإِذْنِهِ ۚ يَعْلَمُ مَا بَيْنَ أَيْدِيهِمْ وَمَا خَلْفَهُمْ ۖ وَلَا يُحِيطُونَ بِشَيْءٍ مِنْ عِلْمِهِ إِلَّا بِمَا شَاءَ ۚ وَسِعَ كُرْسِيُّهُ السَّمَاوَاتِ وَالْأَرْضَ ۖ وَلَا يَئُودُهُ حِفْظُهُمَا ۚ وَهُوَ الْعَلِيُّ الْعَظِيمُ',
        latin:
            'Allāhu lā ilāha illā huwal-ḥayyul-qayyūm, lā ta\'khużuhū sinatuw wa lā naum, lahū mā fis-samāwāti wa mā fil-arḍ, man żal-lażī yasyfa\'u \'indahū illā bi\'iżnih, ya\'lamu mā baina aidīhim wa mā khalfahum, wa lā yuḥīṭūna bisyai\'im min \'ilmihī illā bimā syā\', wasi\'a kursiyyuhus-samāwāti wal-arḍ, wa lā ya\'ūduhū ḥifẓuhumā, wa huwal-\'aliyyul-\'aẓīm',
        translation:
            'Allah, tidak ada Tuhan selain Dia, Yang Maha Hidup, Yang terus-menerus mengurus (makhluk-Nya). Dia tidak mengantuk dan tidak tidur. Milik-Nya apa yang ada di langit dan di bumi. Tidak ada yang dapat memberi syafaat di sisi-Nya tanpa izin-Nya. Dia mengetahui apa yang di hadapan dan di belakang mereka, dan mereka tidak mengetahui sesuatu apa pun tentang ilmu-Nya kecuali apa yang Dia kehendaki. Kursi-Nya meliputi langit dan bumi, dan Dia tidak merasa berat memelihara keduanya. Dialah Yang Maha Tinggi lagi Maha Agung. (Ayat Kursi — Al-Baqarah: 255)',
        count: 1,
        note: 'Keutamaannya disepakati empat mazhab berdasarkan hadis shahih. Siapa membacanya di petang hari senantiasa dalam penjagaan Allah dan tidak didekati setan hingga pagi. (HR. Al-Bukhari)',
      ),
      DzikirItem(
        arabic:
            'قُلْ هُوَ اللَّهُ أَحَدٌ ۝ اللَّهُ الصَّمَدُ ۝ لَمْ يَلِدْ وَلَمْ يُولَدْ ۝ وَلَمْ يَكُن لَّهُ كُفُوًا أَحَدٌ',
        latin:
            'Qul huwallāhu aḥad. Allāhuṣ-ṣamad. Lam yalid wa lam yūlad. Wa lam yakul-lahū kufuwan aḥad',
        translation:
            'Katakanlah: Dialah Allah Yang Maha Esa. Allah tempat bergantung segala sesuatu. Dia tidak beranak dan tidak pula diperanakkan. Dan tidak ada sesuatu yang setara dengan Dia. (Surat Al-Ikhlas)',
        count: 3,
        note: 'Tiga surat perlindungan (Al-Ikhlas, Al-Falaq, An-Nas) dibaca 3× di pagi dan petang; cukup melindungimu dari segala sesuatu. (HR. Abu Dawud & At-Tirmidzi). Al-Ikhlas menegaskan keesaan Allah.',
      ),
      DzikirItem(
        arabic:
            'قُلْ أَعُوذُ بِرَبِّ الْفَلَقِ ۝ مِنْ شَرِّ مَا خَلَقَ ۝ وَمِنْ شَرِّ غَاسِقٍ إِذَا وَقَبَ ۝ وَمِنْ شَرِّ النَّفَّاثَاتِ فِي الْعُقَدِ ۝ وَمِنْ شَرِّ حَاسِدٍ إِذَا حَسَدَ',
        latin:
            'Qul a\'ūżu bi rabbil-falaq. Min syarri mā khalaq. Wa min syarri ghāsiqin iżā waqab. Wa min syarrin-naffāṡāti fil-\'uqad. Wa min syarri ḥāsidin iżā ḥasad',
        translation:
            'Katakanlah: Aku berlindung kepada Tuhan yang menguasai subuh, dari kejahatan makhluk-Nya, dari kejahatan malam apabila telah gelap gulita, dari kejahatan (perempuan-perempuan) penyihir yang meniup pada buhul-buhul, dan dari kejahatan orang yang dengki apabila ia dengki. (Surat Al-Falaq)',
        count: 3,
        note: 'Al-Falaq: memohon perlindungan dari berbagai keburukan. Dibaca 3× di petang bersama Al-Ikhlas dan An-Nas.',
      ),
      DzikirItem(
        arabic:
            'قُلْ أَعُوذُ بِرَبِّ النَّاسِ ۝ مَلِكِ النَّاسِ ۝ إِلَٰهِ النَّاسِ ۝ مِنْ شَرِّ الْوَسْوَاسِ الْخَنَّاسِ ۝ الَّذِي يُوَسْوِسُ فِي صُدُورِ النَّاسِ ۝ مِنَ الْجِنَّةِ وَالنَّاسِ',
        latin:
            'Qul a\'ūżu bi rabbin-nās. Malikin-nās. Ilāhin-nās. Min syarril-waswāsil-khannās. Allażī yuwaswisu fī ṣudūrin-nās. Minal-jinnati wan-nās',
        translation:
            'Katakanlah: Aku berlindung kepada Tuhan manusia, Raja manusia, Sembahan manusia, dari kejahatan (bisikan) setan yang biasa bersembunyi, yang membisikkan (kejahatan) ke dalam dada manusia, dari (golongan) jin dan manusia. (Surat An-Nas)',
        count: 3,
        note: 'An-Nas: memohon perlindungan dari godaan setan dan bisikan jahat. Keempat mazhab sepakat membacanya 3× pagi dan petang adalah sunnah yang kuat.',
      ),
      DzikirItem(
        arabic:
            'اللَّهُمَّ أَنْتَ رَبِّي لَا إِلَٰهَ إِلَّا أَنْتَ، خَلَقْتَنِي وَأَنَا عَبْدُكَ، وَأَنَا عَلَى عَهْدِكَ وَوَعْدِكَ مَا اسْتَطَعْتُ، أَعُوذُ بِكَ مِنْ شَرِّ مَا صَنَعْتُ، أَبُوءُ لَكَ بِنِعْمَتِكَ عَلَيَّ، وَأَبُوءُ بِذَنْبِي فَاغْفِرْ لِي فَإِنَّهُ لَا يَغْفِرُ الذُّنُوبَ إِلَّا أَنْتَ',
        latin:
            'Allāhumma anta rabbī lā ilāha illā anta, khalaqtanī wa ana \'abduka, wa ana \'alā \'ahdika wa wa\'dika mastaṭa\'tu, a\'ūżu bika min syarri mā ṣana\'tu, abū\'u laka bini\'matika \'alayya, wa abū\'u biżanbī faghfir lī fa\'innahū lā yaghfiruż-żunūba illā anta',
        translation:
            'Ya Allah, Engkau Tuhanku, tiada Tuhan selain Engkau. Engkau ciptakan aku dan aku adalah hamba-Mu. Aku akan setia pada perjanjian dan janji-Mu semampuku. Aku berlindung kepada-Mu dari keburukan perbuatanku. Aku mengakui nikmat-Mu kepadaku dan aku mengakui dosaku, maka ampunilah aku. Sebab tiada yang dapat mengampuni dosa kecuali Engkau. (Sayyidul Istighfar — penghulu istighfar)',
        count: 1,
        note: 'Penghulu istighfar. Siapa membacanya di petang dengan penuh keyakinan lalu wafat malam itu, ia termasuk penghuni surga. (HR. Al-Bukhari). Diamalkan ulama empat mazhab dalam kitab-kitab wirid.',
      ),
      DzikirItem(
        arabic: 'سُبْحَانَ اللَّهِ',
        latin: 'Subḥānallāh',
        translation: 'Maha Suci Allah.',
        count: 33,
        note: 'Tasbih. Empat mazhab sepakat atas keutamaan memperbanyak tasbih, tahmid, dan takbir pagi dan petang; kalimat yang ringan di lidah namun berat dalam timbangan amal. (HR. Al-Bukhari & Muslim)',
      ),
      DzikirItem(
        arabic: 'الْحَمْدُ لِلَّهِ',
        latin: 'Alḥamdulillāh',
        translation: 'Segala puji bagi Allah.',
        count: 33,
        note: 'Tahmid. Bersama tasbih dan takbir, termasuk dzikir yang sangat disukai Allah dan memenuhi timbangan kebaikan.',
      ),
      DzikirItem(
        arabic: 'اللَّهُ أَكْبَرُ',
        latin: 'Allāhu akbar',
        translation: 'Allah Maha Besar.',
        count: 33,
        note: 'Takbir. Memperbanyaknya di pagi dan petang dianjurkan dalam keempat mazhab.',
      ),
      DzikirItem(
        arabic:
            'بِسْمِ اللَّهِ الَّذِي لَا يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الْأَرْضِ وَلَا فِي السَّمَاءِ وَهُوَ السَّمِيعُ الْعَلِيمُ',
        latin:
            'Bismillāhillażī lā yaḍurru ma\'asmihī syai\'un fil-arḍi wa lā fis-samā\', wa huwas-samī\'ul-\'alīm',
        translation:
            'Dengan nama Allah yang bersama nama-Nya tidak ada sesuatu pun di bumi maupun di langit yang dapat memberi mudarat, dan Dialah Yang Maha Mendengar lagi Maha Mengetahui.',
        count: 3,
        note: 'Siapa membacanya 3× di pagi dan petang, tidak akan ada sesuatu pun yang memudaratkannya. (HR. Abu Dawud & At-Tirmidzi, hasan shahih). Sangat dianjurkan dalam mazhab Syafi\'i dan Hanbali.',
      ),
      DzikirItem(
        arabic:
            'رَضِيتُ بِاللَّهِ رَبًّا، وَبِالْإِسْلَامِ دِينًا، وَبِمُحَمَّدٍ ﷺ نَبِيًّا',
        latin:
            'Raḍītu billāhi rabbā, wa bil-islāmi dīnā, wa bi Muḥammadin (ṣallallāhu \'alaihi wa sallam) nabiyyā',
        translation:
            'Aku ridha Allah sebagai Tuhanku, Islam sebagai agamaku, dan Muhammad ﷺ sebagai nabiku.',
        count: 3,
        note: 'Siapa membacanya 3× pagi dan petang, Allah pasti meridhainya pada hari kiamat. (HR. Abu Dawud, At-Tirmidzi & An-Nasa\'i). Diamalkan ulama keempat mazhab.',
      ),
      DzikirItem(
        arabic:
            'لَا إِلَٰهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ',
        latin:
            'Lā ilāha illallāhu waḥdahū lā syarīka lah, lahul-mulku wa lahul-ḥamd, wa huwa \'alā kulli syai\'in qadīr',
        translation:
            'Tiada sesembahan yang berhak disembah selain Allah semata, tiada sekutu bagi-Nya. Milik-Nya kerajaan dan segala puji, dan Dia Maha Kuasa atas segala sesuatu.',
        count: 100,
        note: 'Siapa membacanya 100× dalam sehari: setara pahala memerdekakan 10 budak, dicatat 100 kebaikan, dihapus 100 keburukan, dan terlindung dari setan hingga petang. (HR. Al-Bukhari & Muslim)',
      ),
    ],
  ),

  // ──────────────────── DZIKIR SETELAH SHOLAT FARDHU ────────────────────
  DzikirCategory(
    id: 'fardhu',
    title: 'Dzikir Setelah Sholat Fardhu',
    subtitle: 'Dibaca selepas salam sholat lima waktu',
    icon: Icons.mosque,
    items: [
      DzikirItem(
        arabic: 'أَسْتَغْفِرُ اللَّهَ',
        latin: 'Astaghfirullāh',
        translation: 'Aku memohon ampun kepada Allah.',
        count: 3,
      ),
      DzikirItem(
        arabic:
            'اللَّهُمَّ أَنْتَ السَّلَامُ، وَمِنْكَ السَّلَامُ، تَبَارَكْتَ يَا ذَا الْجَلَالِ وَالْإِكْرَامِ',
        latin:
            'Allāhumma antas-salām, wa minkas-salām, tabārakta yā żal-jalāli wal-ikrām',
        translation:
            'Ya Allah, Engkau-lah As-Salam (Maha Sejahtera), dari-Mu kesejahteraan. Maha Berkah Engkau, wahai Pemilik Keagungan dan Kemuliaan.',
        count: 1,
      ),
      DzikirItem(
        arabic:
            'لَا إِلَٰهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ',
        latin:
            'Lā ilāha illallāhu waḥdahū lā syarīka lah, lahul-mulku wa lahul-ḥamd, wa huwa \'alā kulli syai\'in qadīr',
        translation:
            'Tiada Tuhan selain Allah Yang Esa, tiada sekutu bagi-Nya. Milik-Nya kerajaan dan pujian, dan Dia Maha Kuasa atas segala sesuatu.',
        count: 1,
      ),
      DzikirItem(
        arabic:
            'اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ ۚ لَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ ۚ لَهُ مَا فِي السَّمَاوَاتِ وَمَا فِي الْأَرْضِ ۗ مَنْ ذَا الَّذِي يَشْفَعُ عِنْدَهُ إِلَّا بِإِذْنِهِ ۚ يَعْلَمُ مَا بَيْنَ أَيْدِيهِمْ وَمَا خَلْفَهُمْ ۖ وَلَا يُحِيطُونَ بِشَيْءٍ مِنْ عِلْمِهِ إِلَّا بِمَا شَاءَ ۚ وَسِعَ كُرْسِيُّهُ السَّمَاوَاتِ وَالْأَرْضَ ۖ وَلَا يَئُودُهُ حِفْظُهُمَا ۚ وَهُوَ الْعَلِيُّ الْعَظِيمُ',
        latin:
            'Allāhu lā ilāha illā huwal-ḥayyul-qayyūm, lā ta\'khużuhū sinatuw wa lā naum, lahū mā fis-samāwāti wa mā fil-arḍ, man żal-lażī yasyfa\'u \'indahū illā bi\'iżnih, ya\'lamu mā baina aidīhim wa mā khalfahum, wa lā yuḥīṭūna bisyai\'im min \'ilmihī illā bimā syā\', wasi\'a kursiyyuhus-samāwāti wal-arḍ, wa lā ya\'ūduhū ḥifẓuhumā, wa huwal-\'aliyyul-\'aẓīm',
        translation:
            'Ayat Kursi (Al-Baqarah: 255). Siapa membacanya selepas sholat fardhu, tidak ada yang menghalanginya masuk surga selain kematian.',
        count: 1,
      ),
      DzikirItem(
        arabic: 'سُبْحَانَ اللَّهِ',
        latin: 'Subḥānallāh',
        translation: 'Maha Suci Allah.',
        count: 33,
      ),
      DzikirItem(
        arabic: 'الْحَمْدُ لِلَّهِ',
        latin: 'Alḥamdulillāh',
        translation: 'Segala puji bagi Allah.',
        count: 33,
      ),
      DzikirItem(
        arabic: 'اللَّهُ أَكْبَرُ',
        latin: 'Allāhu akbar',
        translation: 'Allah Maha Besar.',
        count: 33,
      ),
      DzikirItem(
        arabic:
            'لَا إِلَٰهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ',
        latin:
            'Lā ilāha illallāhu waḥdahū lā syarīka lah, lahul-mulku wa lahul-ḥamd, wa huwa \'alā kulli syai\'in qadīr',
        translation:
            'Tiada Tuhan selain Allah Yang Esa, tiada sekutu bagi-Nya. Milik-Nya kerajaan dan pujian, dan Dia Maha Kuasa atas segala sesuatu. (Penyempurna hitungan ke-100; diampuni dosa-dosanya walau sebanyak buih di lautan.)',
        count: 1,
      ),
    ],
  ),

  // ─────────────────────────── DZIKIR DHUHA ───────────────────────────
  DzikirCategory(
    id: 'dhuha',
    title: 'Dzikir & Doa Dhuha',
    subtitle: 'Dibaca setelah sholat Dhuha — waktu diijabahnya doa',
    icon: Icons.wb_sunny,
    items: [
      DzikirItem(
        arabic: 'أَسْتَغْفِرُ اللَّهَ الْعَظِيمَ وَأَتُوبُ إِلَيْهِ',
        latin: 'Astaghfirullāhal-\'aẓīm wa atūbu ilaih',
        translation:
            'Aku memohon ampun kepada Allah Yang Maha Agung dan bertaubat kepada-Nya.',
        count: 3,
        note:
            'Dianjurkan istighfar setelah setiap sholat. Nabi ﷺ istighfar 3× lalu membaca "Allāhumma antas-salām…" (HR. Muslim 591).',
      ),
      DzikirItem(
        arabic:
            'اللَّهُمَّ إِنِّي أَسْأَلُكَ مِنْ فَضْلِكَ',
        latin: 'Allāhumma innī as\'aluka min faḍlik',
        translation:
            'Ya Allah, sesungguhnya aku memohon kepada-Mu dari karunia-Mu.',
        count: 3,
        note:
            'Doa mustaka meminta rezeki halal dari karunia Allah. Selaras dengan Al-Jumu\'ah: 10 — "…dan carilah karunia Allah". Ibnu \'Abbas membacanya di waktu dhuha (atsar).',
      ),
      DzikirItem(
        arabic:
            'اللَّهُمَّ إِنِّي أَسْأَلُكَ رِزْقًا حَلَالًا طَيِّبًا مُبَارَكًا',
        latin:
            'Allāhumma innī as\'aluka rizqan ḥalālan ṭayyiban mubārakan',
        translation:
            'Ya Allah, sungguh aku memohon kepada-Mu rezeki yang halal, baik, lagi berkah.',
        count: 3,
        note:
            'Kombinasi doa Nabi ﷺ minta rezeki halal-thayyib (lihat HR. Ibnu Majah 925 tentang doa dhuha bermakna serupa).',
      ),
      DzikirItem(
        arabic:
            'اللَّهُمَّ إِنَّ الضُّحَاءَ ضُحَاؤُكَ، وَالْبَهَاءَ بَهَاؤُكَ، وَالْجَمَالَ جَمَالُكَ، وَالْقُوَّةَ قُوَّتُكَ، وَالْقُدْرَةَ قُدْرَتُكَ، وَالْعِصْمَةَ عِصْمَتُكَ. اللَّهُمَّ إِنْ كَانَ رِزْقِي فِي السَّمَاءِ فَأَنْزِلْهُ، وَإِنْ كَانَ فِي الْأَرْضِ فَأَخْرِجْهُ، وَإِنْ كَانَ مُعَسَّرًا فَيَسِّرْهُ، وَإِنْ كَانَ حَرَامًا فَطَهِّرْهُ، وَإِنْ كَانَ بَعِيدًا فَقَرِّبْهُ، بِحَقِّ ضُحَائِكَ وَبَهَائِكَ وَجَمَالِكَ وَقُوَّتِكَ وَقُدْرَتِكَ، آتِنِي مَا آتَيْتَ عِبَادَكَ الصَّالِحِينَ',
        latin:
            'Allāhumma innaḍ-ḍuḥā\'a ḍuḥā\'uka, wal-bahā\'a bahā\'uka, wal-jamāla jamāluka, wal-quwwata quwwatuka, wal-qudrata qudratuka, wal-\'iṣmata \'iṣmatuka. Allāhumma in kāna rizqī fis-samā\'i fa-anzilhu, wa in kāna fil-arḍi fa-akhrijhu, wa in kāna mu\'assiran fa-yassirhu, wa in kāna ḥarāman fa-ṭahhirhu, wa in kāna ba\'īdan fa-qarribhu, bi ḥaqqi ḍuḥā\'ika wa bahā\'ika wa jamālika wa quwwatika wa qudratika, ātinī mā ātaita \'ibādakaṣ-ṣāliḥīn',
        translation:
            'Ya Allah, sungguh waktu dhuha adalah dhuha-Mu, keindahan adalah keindahan-Mu, kekuatan adalah kekuatan-Mu, kemuliaan adalah kemuliaan-Mu, kekuasaan adalah kekuasaan-Mu, dan penjagaan adalah penjagaan-Mu. Ya Allah, jika rezekiku di langit, turunkanlah; jika di bumi, keluarkanlah; jika sulit, mudahkanlah; jika haram, sucikanlah; jika jauh, dekatkanlah — dengan hak dhuha-Mu, keindahan-Mu, kekuatan-Mu, dan kekuasaan-Mu, berikanlah aku sebagaimana Engkau memberi hamba-hamba-Mu yang saleh.',
        count: 1,
        note:
            'Doa dhuha yang populer, disebutkan dalam Ihya \'Ulumuddin (Al-Ghazali) dan diamalkan turun-temurun. Sanad marfu\'-nya tidak sampai derajat sahih, namun ulama membolehkan sebagai doa (bukan hadits) karena maknanya baik dan tidak menyalahi syariat.',
      ),
      DzikirItem(
        arabic:
            'رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ',
        latin:
            'Rabbanā ātinā fid-dun-yā ḥasanah wa fil-ākhirati ḥasanah wa qinā \'ażāban-nār',
        translation:
            'Ya Tuhan kami, berilah kami kebaikan di dunia dan di akhirat, serta peliharalah kami dari azab neraka. (QS. Al-Baqarah: 201)',
        count: 1,
        note: 'Doa paling sering diucapkan Nabi ﷺ (HR. Bukhari 6389, Muslim 2690).',
      ),
    ],
  ),

  // ─────────────────────────── DZIKIR TAHAJUD ───────────────────────────
  DzikirCategory(
    id: 'tahajud',
    title: 'Dzikir & Doa Tahajud',
    subtitle: 'Munajat malam — waktu paling ijabah',
    icon: Icons.bedtime,
    items: [
      DzikirItem(
        arabic: 'سُبْحَانَ الْمَلِكِ الْقُدُّوسِ',
        latin: 'Subḥānal-malikil-quddūs',
        translation: 'Maha Suci Raja Yang Maha Suci.',
        count: 3,
        note:
            'Dibaca setelah salam qiyamul lail; pada bacaan ketiga suara ditinggikan (HR. Nasa\'i 1699, Abu Dawud 1430 — sahih).',
      ),
      DzikirItem(
        arabic:
            'اللَّهُمَّ لَكَ الْحَمْدُ أَنْتَ نُورُ السَّمَاوَاتِ وَالْأَرْضِ وَمَنْ فِيهِنَّ، وَلَكَ الْحَمْدُ أَنْتَ قَيِّمُ السَّمَاوَاتِ وَالْأَرْضِ وَمَنْ فِيهِنَّ، وَلَكَ الْحَمْدُ أَنْتَ الْحَقُّ، وَوَعْدُكَ الْحَقُّ، وَلِقَاؤُكَ حَقٌّ، وَقَوْلُكَ حَقٌّ، وَالْجَنَّةُ حَقٌّ، وَالنَّارُ حَقٌّ، وَالنَّبِيُّونَ حَقٌّ، وَمُحَمَّدٌ ﷺ حَقٌّ، وَالسَّاعَةُ حَقٌّ. اللَّهُمَّ لَكَ أَسْلَمْتُ، وَبِكَ آمَنْتُ، وَعَلَيْكَ تَوَكَّلْتُ، وَإِلَيْكَ أَنَبْتُ، وَبِكَ خَاصَمْتُ، وَإِلَيْكَ حَاكَمْتُ، فَاغْفِرْ لِي مَا قَدَّمْتُ وَمَا أَخَّرْتُ، وَمَا أَسْرَرْتُ وَمَا أَعْلَنْتُ، أَنْتَ الْمُقَدِّمُ وَأَنْتَ الْمُؤَخِّرُ، لَا إِلَٰهَ إِلَّا أَنْتَ',
        latin:
            'Allāhumma lakal-ḥamdu anta nūrus-samāwāti wal-arḍi wa man fīhinn, wa lakal-ḥamdu anta qayyimus-samāwāti wal-arḍi wa man fīhinn, wa lakal-ḥamdu antal-ḥaqq, wa wa\'dukal-ḥaqq, wa liqā\'uka ḥaqq, wa qauluka ḥaqq, wal-jannatu ḥaqq, wan-nāru ḥaqq, wan-nabiyyūna ḥaqq, wa Muḥammadun ṣallallāhu \'alaihi wa sallam ḥaqq, was-sā\'atu ḥaqq. Allāhumma laka aslamtu, wa bika āmantu, wa \'alaika tawakkaltu, wa ilaika anabtu, wa bika khāṣamtu, wa ilaika ḥākamtu, faghfir lī mā qaddamtu wa mā akhkhartu, wa mā asrartu wa mā a\'lantu, antal-muqaddimu wa antal-mu\'akhkhir, lā ilāha illā anta',
        translation:
            'Ya Allah, bagi-Mu segala puji — Engkau cahaya langit & bumi dan siapa yang ada padanya. Bagi-Mu segala puji — Engkau penegaknya. Engkau-lah Al-Haqq (Yang Benar), janji-Mu benar, pertemuan dengan-Mu benar, firman-Mu benar, surga benar, neraka benar, para nabi benar, Muhammad ﷺ benar, dan hari kiamat benar. Ya Allah, kepada-Mu aku berserah, dengan-Mu aku beriman, kepada-Mu aku bertawakal, kepada-Mu aku kembali, dengan-Mu aku berhujjah, kepada-Mu aku mengadu — maka ampunilah dosaku yang telah lalu & yang akan datang, yang tersembunyi & yang terang. Engkau Yang Mendahulukan, Engkau Yang Mengakhirkan, tiada Tuhan selain Engkau.',
        count: 1,
        note:
            'Doa iftitah tahajud Nabi ﷺ ketika bangun malam (HR. Bukhari 1120 & Muslim 769 dari Ibnu \'Abbas — sanad muttafaq \'alaih, sanad tertinggi).',
      ),
      DzikirItem(
        arabic:
            'اللَّهُمَّ رَبَّ جِبْرَائِيلَ وَمِيكَائِيلَ وَإِسْرَافِيلَ، فَاطِرَ السَّمَاوَاتِ وَالْأَرْضِ، عَالِمَ الْغَيْبِ وَالشَّهَادَةِ، أَنْتَ تَحْكُمُ بَيْنَ عِبَادِكَ فِيمَا كَانُوا فِيهِ يَخْتَلِفُونَ، اهْدِنِي لِمَا اخْتُلِفَ فِيهِ مِنَ الْحَقِّ بِإِذْنِكَ، إِنَّكَ تَهْدِي مَنْ تَشَاءُ إِلَى صِرَاطٍ مُسْتَقِيمٍ',
        latin:
            'Allāhumma rabba Jibrā\'īla wa Mīkā\'īla wa Isrāfīl, fāṭiras-samāwāti wal-arḍ, \'ālimal-ghaibi wasy-syahādah, anta taḥkumu baina \'ibādika fīmā kānū fīhi yakhtalifūn, ihdinī limakhtulifa fīhi minal-ḥaqqi bi\'iżnika, innaka tahdī man tasyā\'u ilā ṣirāṭim mustaqīm',
        translation:
            'Ya Allah, Tuhan Jibril, Mikail, dan Israfil, Pencipta langit & bumi, Yang mengetahui yang gaib & yang tampak — Engkau menghukumi di antara hamba-Mu tentang apa yang mereka perselisihkan. Tunjukkanlah aku pada kebenaran dari apa yang diperselisihkan, dengan izin-Mu. Sungguh Engkau memberi petunjuk siapa yang Kau kehendaki menuju jalan yang lurus.',
        count: 1,
        note:
            'Doa Nabi ﷺ saat memulai qiyamul lail (HR. Muslim 770 dari Aisyah).',
      ),
      DzikirItem(
        arabic:
            'اللَّهُمَّ اغْفِرْ لِي، وَارْحَمْنِي، وَاهْدِنِي، وَعَافِنِي، وَارْزُقْنِي',
        latin:
            'Allāhummaghfir lī, warḥamnī, wahdinī, wa \'āfinī, warzuqnī',
        translation:
            'Ya Allah, ampunilah aku, rahmatilah aku, tunjuki aku, sehatkan aku, dan berilah aku rezeki.',
        count: 3,
        note:
            'Lima permintaan yang mencakup dunia & akhirat (HR. Muslim 2697 dari Thariq bin Asyyam).',
      ),
      DzikirItem(
        arabic:
            'أَسْتَغْفِرُ اللَّهَ الْعَظِيمَ الَّذِي لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ وَأَتُوبُ إِلَيْهِ',
        latin:
            'Astaghfirullāhal-\'aẓīm allażī lā ilāha illā huwal-ḥayyul-qayyūmu wa atūbu ilaih',
        translation:
            'Aku memohon ampun kepada Allah Yang Maha Agung, yang tiada Tuhan selain Dia, Yang Maha Hidup lagi Maha Mengurus, dan aku bertaubat kepada-Nya.',
        count: 3,
        note:
            'Waktu sahur adalah waktu istighfar utama — "…dan yang beristighfar di waktu sahur." (QS. Adz-Dzariyat: 18, Ali \'Imran: 17). Nabi ﷺ mengabarkan Allah turun ke langit dunia sepertiga malam terakhir memanggil hamba-Nya (HR. Bukhari 1145, Muslim 758).',
      ),
      DzikirItem(
        arabic:
            'رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ',
        latin:
            'Rabbanā ātinā fid-dun-yā ḥasanah wa fil-ākhirati ḥasanah wa qinā \'ażāban-nār',
        translation:
            'Ya Tuhan kami, berilah kami kebaikan di dunia dan akhirat, dan lindungi kami dari azab neraka. (QS. Al-Baqarah: 201)',
        count: 1,
        note: 'Doa terbanyak Nabi ﷺ (HR. Bukhari 6389, Muslim 2690).',
      ),
    ],
  ),

  // ──────────────────── DZIKIR SETELAH SHOLAT TAUBAT ────────────────────
  DzikirCategory(
    id: 'taubat',
    title: 'Dzikir Setelah Sholat Taubat',
    subtitle: 'Memohon ampun & kembali kepada Allah',
    icon: Icons.volunteer_activism,
    items: [
      DzikirItem(
        arabic: 'أَسْتَغْفِرُ اللَّهَ الْعَظِيمَ وَأَتُوبُ إِلَيْهِ',
        latin: 'Astaghfirullāhal-\'aẓīm wa atūbu ilaih',
        translation:
            'Aku memohon ampun kepada Allah Yang Maha Agung dan bertaubat kepada-Nya.',
        count: 100,
      ),
      DzikirItem(
        arabic:
            'اللَّهُمَّ أَنْتَ رَبِّي لَا إِلَٰهَ إِلَّا أَنْتَ، خَلَقْتَنِي وَأَنَا عَبْدُكَ، وَأَنَا عَلَى عَهْدِكَ وَوَعْدِكَ مَا اسْتَطَعْتُ، أَعُوذُ بِكَ مِنْ شَرِّ مَا صَنَعْتُ، أَبُوءُ لَكَ بِنِعْمَتِكَ عَلَيَّ، وَأَبُوءُ بِذَنْبِي فَاغْفِرْ لِي',
        latin:
            'Allāhumma anta rabbī lā ilāha illā anta, khalaqtanī wa ana \'abduka, wa ana \'alā \'ahdika wa wa\'dika mastaṭa\'tu, a\'ūżu bika min syarri mā ṣana\'tu, abū\'u laka bini\'matika \'alayya wa abū\'u biżanbī faghfir lī',
        translation:
            'Ya Allah, Engkau Tuhanku, tiada Tuhan selain Engkau. Engkau ciptakan aku dan aku adalah hamba-Mu. Aku akan setia pada perjanjian dan janji-Mu semampuku. Aku berlindung kepada-Mu dari keburukan perbuatanku. Aku mengakui nikmat-Mu kepadaku dan aku mengakui dosaku, maka ampunilah aku. (Sayyidul Istighfar)',
        count: 1,
      ),
      DzikirItem(
        arabic:
            'لَا إِلَٰهَ إِلَّا أَنْتَ سُبْحَانَكَ إِنِّي كُنْتُ مِنَ الظَّالِمِينَ',
        latin: 'Lā ilāha illā anta subḥānaka innī kuntu minaẓ-ẓālimīn',
        translation:
            'Tiada Tuhan selain Engkau, Maha Suci Engkau. Sesungguhnya aku termasuk orang-orang yang zalim. (Doa Nabi Yunus)',
        count: 3,
      ),
      DzikirItem(
        arabic:
            'رَبِّ اغْفِرْ لِي وَتُبْ عَلَيَّ إِنَّكَ أَنْتَ التَّوَّابُ الرَّحِيمُ',
        latin: 'Rabbighfir lī wa tub \'alayya innaka antat-tawwābur-raḥīm',
        translation:
            'Ya Tuhanku, ampunilah aku dan terimalah taubatku. Sesungguhnya Engkau Maha Penerima taubat lagi Maha Penyayang.',
        count: 3,
      ),
    ],
  ),
];
