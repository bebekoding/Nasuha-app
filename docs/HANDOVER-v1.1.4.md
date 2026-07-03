# Handover — Nasuha `v1.2.1` → `v1.1.4`

> **Target sesi berikutnya:** v1.1.4
> **Kondisi saat ini:** `pubspec.yaml` `version: 1.2.1+3`
> ⚠️ Ada divergensi penomoran — lihat [Versioning Note](#versioning-note) di bawah.
> **Live PWA:** https://nasuha-app.vercel.app
> **Repo:** https://github.com/bebekoding/Nasuha-app (public)

---

## 1. Ringkasan Pekerjaan v1.2.1

Sesi PWA foundation → hasil: aplikasi Nasuha jalan di 3 platform (Android, iOS simulator, Web PWA) dari 1 codebase Flutter.

### 1.1 Migrasi Isar → Drift (selesai)
- 9/9 collections berhasil di-migrasi ke Drift (sqlite native mobile + sqlite-wasm web)
- Isar & isar_flutter_libs **dihapus** dari `pubspec.yaml`
- `IsarService.dart` **dihapus** total
- Mobile APK turun **74.1 MB → 70.6 MB** (tanpa Isar libs)
- Skema Drift v5, migrasi bertahap onUpgrade untuk installasi Android existing

| Collection | Migrated | Notes |
|---|---|---|
| QuranBookmark | ✅ | `@DataClassName('QuranBookmarkRow')` |
| UserSettings | ✅ | Singleton id=1, `insertOnConflictUpdate` pakai id explicit |
| CharityRecord | ✅ | Index `dateKey` |
| MuhasabahTag | ✅ | slug UNIQUE |
| MuhasabahEntry | ✅ | Index `dateKey`, kind=`TagKind.name` string |
| DailyScore | ✅ | dateKey UNIQUE (upsert manual, bukan insertOnConflictUpdate) |
| Streak | ✅ | key UNIQUE (upsert manual) |
| Achievement | ✅ | code UNIQUE, seeded via `seedDrift(db)` |
| CachedSurah | ❌ **DROPPED** | Dead code — tak dipakai di manapun |

### 1.2 CI/CD & Deploy PWA (selesai)
- GitHub Actions workflow (`.github/workflows/deploy-web.yml`) — Flutter build + Vercel deploy
- Vercel project: `nasuha-app` di akun `bercoding1`
- 3 GitHub Secrets tersimpan: `VERCEL_TOKEN`, `VERCEL_ORG_ID`, `VERCEL_PROJECT_ID`
- Pola build: **Vercel CLI native** (`npm i -g vercel@latest` + `vercel deploy --prod --archive=tgz`) — bukan `amondnet/vercel-action` (versi CLI-nya outdated)
- `sqlite3.wasm` + `drift_worker.js` didownload di CI dari `simolus3/*` releases (tidak commit ke repo)

### 1.3 PC Landing Page (selesai)
- File: `lib/features/landing/**` (7 widget + data + entry)
- Design blueprint: `docs/LANDING-DESIGN.md`
- Struktur: sticky nav (72→56 shrink) · hero (headline solid + emblem parallax) · **bento grid** 3 baris asimetris · value 3-pilar · CTA banner · footer espresso
- 7 micro-interactions ala apple.com/mac (scroll reveal, nav shrink, card lift, arrow slide, parallax, stagger, dst)
- Routing: `/` = gate (`kIsWeb && width≥900` → landing, else `HomeScreen`) · `/home` = dashboard directly
- Palette **tidak ada hex baru**: extend existing `AppColors` warm cream & brown

### 1.4 Impeccable design review (selesai)
- Fix 2 absolute-ban violations: gradient text di headline + eyebrow above every section
- Fix WCAG kontras: body taupe `#897866` (3.6:1) → `#6E5D4A` (5.1:1); "Pelajari →" ochre → primary
- Bento asymmetric restructure grid (menghindari SaaS-cliché identical card grid)

### 1.5 Web-specific bug fixes (dalam sesi ini)
Semua sudah di-fix & di-deploy:
1. **Vercel CLI outdated** (v25 vs endpoint ≥47) → ganti ke `npm i -g vercel@latest`
2. **Splash HTML nyangkut** — `flutter_local_notifications.init()` throw di web → `kIsWeb` guard + try-catch. Plus `flutter-first-frame` listener untuk hapus splash HTML
3. **Splash tetap nyangkut** — `driftDatabase()` di web butuh URL wasm/worker explicit → `DriftWebOptions(sqlite3Wasm: Uri.parse('sqlite3.wasm'), driftWorker: Uri.parse('drift_worker.js'))`
4. **`Bad state: Too many elements`** — `SettingsController.watchSingleOrNull()` throw karena row duplikat di `user_settings` (IndexedDB). Fix: `_ensureSingleton()` di bootstrap + ganti ke `watch().first`. Plus defensive `.limit(1)` di 3 tempat lain
5. **`SqliteException(2067) UNIQUE constraint failed`** — `insertOnConflictUpdate` resolusi konflik-nya cek PK (id), sedangkan UNIQUE column-nya `date_key`/`key`. Fix: upsert manual (SELECT → UPDATE bila ada, INSERT bila tidak) di 4 tempat:
   - `MuhasabahRepository._recalcDailyScore` + `_updateStreak`
   - `prayer_confirm._recalcWithin` + `_updateStreakWithin`
6. **`On web path is unavailable`** — `file_picker.PlatformFile.path = null` di web → foto profil di web pakai **base64 data URL** (`data:image/png;base64,...`) tersimpan di kolom `photoPath`. `_AvatarInner` deteksi prefix `data:` → `MemoryImage`, kalau path → `FileImage`
7. **Blank screen tanpa error visible** — `runZonedGuarded` + `_FatalErrorApp` render stack trace kalau `main()` crash (tak lagi silent blank)

### 1.6 Fitur baru di v1.2.1
- **Edit foto profil** — sudah jalan mobile & web (base64 di web, file path di mobile)
- **Landing page PC** — public URL sekarang punya marketing surface

---

## 2. Commits terpenting sesi ini (paling baru dulu)

| Commit | Ringkas |
|---|---|
| `c250a1e` | polish(landing): fix 2 absolute bans + WCAG kontras + bento grid |
| `15b5e78` | feat(landing): PC marketing page ala fore.coffee + apple.com animasi |
| `67123fb` | fix(web): foto profil pakai data URL base64 |
| `8504552` | fix(web): user_settings row duplikat → "Bad state: Too many elements" |
| `fd8442c` | fix(db): UNIQUE constraint pada daily_scores.date_key + streaks.key |
| `5dbe73e` | fix(web): explicit DriftWebOptions + defensive main() bootstrap |
| `d152c55` | fix(web): guard NotificationService init + hilangkan splash HTML |
| `5786986` | ci: use Vercel CLI directly for reliable deploy |
| `c94e4ea` | feat(db): FINAL — migrate Achievement + drop Isar sepenuhnya |
| `6326e13` | feat(db): migrate paket besar Muhasabah (Tag+Entry+DailyScore+Streak) |
| `6cba96d` | feat(db): migrate CharityRecord + SedekahRepository ke Drift |
| `bdaebd6` | feat(db): migrate UserSettings ke Drift |
| `90a2ffc` | feat(db): pondasi Drift + migrate QuranBookmark ke Drift |

---

## 3. Bug **belum** teratasi (backlog v1.1.4)

### 3.1 Prioritas MEDIUM

#### 3.1.1 Migrasi data Isar → Drift untuk user Android existing
- **Impact**: user mobile yang upgrade dari v1.1.3 (Isar) ke v1.2.1+ (Drift) akan **kehilangan data**: preferensi (nama, kota, metode kalkulasi), tags custom, entries muhasabah, sedekah, streaks, achievements progress
- **Root cause**: tak ada migration script yang baca Isar → tulis Drift
- **Path**: sebelum wide release, tulis one-time script `services/database/migrate_from_isar.dart` yang:
  1. Cek existence Isar `.isar` file di `getApplicationDocumentsDirectory()`
  2. Buka Isar sekali dengan minimal schema
  3. Iterasi setiap koleksi → tulis ke Drift equivalents
  4. Rename `.isar` → `.isar.migrated` (jangan hapus dulu; safe rollback)
  5. Set flag prefs `migration_v1_2_1_done = true`
- **Blocker**: butuh temporary `isar` + `isar_flutter_libs` deps kembali di pubspec _khusus_ untuk migrator (kondisional import? conditional dep?). Alternatif: pakai file `.isar` binary reader tanpa Isar dep (kompleks).

#### 3.1.2 Font Arab di Dzikir & Sholat Sunnah screens
- **Status current**: sudah pakai `Scheherazade New` (bagus). Tapi ini terjadi via passed constant di `_arabicFont` di beberapa tempat — belum semua konsisten. Cek: `dzikir_detail_screen.dart`, `sholat_sunnah_detail_screen.dart`, semua Arabic text.

#### 3.1.3 Konten Dzikir perlu verifikasi ustadz/mushaf
- Header Dzikir sudah ada ⚠️ note yang saya tambah sebelumnya
- Arabic harakat + translations belum verified oleh sumber terpercaya
- Action: sebelum wide release, minta review dari ustadz (bukan kerja teknis Claude)

### 3.2 Prioritas LOW (nice-to-have)

#### 3.2.1 Web-native Notifications API
- **Current**: `NotificationService.init()` di-skip di web (kIsWeb guard)
- **Missing**: adzan reminders + "Sudah sholat" background confirm tak jalan di PWA
- **Path**: implement `NotificationServiceWeb` pakai `dart:html Notification`/`js_interop` — subscribe ke Service Worker `push` event untuk PWA push. Butuh setup FCM Web atau alternatif open-source push.
- **Trade-off**: PWA push notification butuh backend (FCM/OneSignal/self-hosted VAPID) — bukan lagi 100% offline-first. Alternatif ringan: local reminders lewat `Notification.requestPermission()` + `setTimeout` di window (tidak bekerja saat tab tutup).

#### 3.2.2 Arah Kiblat di web
- **Current**: `flutter_compass` tak ada implementasi web → screen error/blank di PWA
- **Path**: pakai `dart:html DeviceOrientationEvent` (alpha/beta/gamma) untuk hitung bearing kiblat. Butuh permission di iOS Safari (`DeviceOrientationEvent.requestPermission()`).
- **Alternative**: sembunyikan menu Kiblat di web (`if (kIsWeb) ...` guard di home menu grid).

#### 3.2.3 Biometric Lock di web
- **Current**: `local_auth` tak ada implementasi web
- **Path**: `WebAuthn` (`navigator.credentials`) — kompleks setup, mungkin skip di web dan hide toggle.

#### 3.2.4 Google Sign-In di web (untuk Drive backup)
- **Current**: `google_sign_in` di web belum di-setup
- **Path**: 
  1. Buat OAuth Client tipe **Web application** di Google Cloud Console project `nasuha-500606` (reuse consent screen + Drive API)
  2. Add JavaScript origins: `http://localhost:8080` + `https://nasuha-app.vercel.app`
  3. Tempel Client ID Web di `web/index.html` sbg `<meta name="google-signin-client_id" content="…">`
  4. Add `google_sign_in_web: ^0.12.4` (atau versi kompatibel) ke `pubspec.yaml`
- SHA-1 untuk Android OAuth client: `6D:55:DF:94:4E:20:FB:BB:B1:C4:BE:17:E2:13:89:22:3A:AE:EF:04` (sudah didaftarkan)

#### 3.2.5 OAuth Publish untuk Publik
- Current: Testing mode. Cuma test user (email Anda) yang bisa login Google.
- Untuk buka ke semua akun: **Publish App** di Google Auth Platform → butuh **verifikasi** karena `drive.appdata` = sensitive scope
- Butuh: privacy policy URL + verified domain (Vercel domain bisa via Search Console)

#### 3.2.6 Layout responsive polish app screens (di luar landing)
- **Current**: landing sudah responsive/desktop-optimized. Tapi begitu klik "Mulai", masuk `HomeScreen` yg mobile-first — di desktop viewport 1440px terlihat kaku (max-width kartu terlalu lebar, dsb)
- **Options**:
  - (A) Batasi max-width per screen ke 480-560px + center di desktop (simpel)
  - (B) Full responsive dengan sidebar navigation (besar effort, ~3-5 sesi)
  - (C) Ignore — user desktop mostly cuma untuk lihat landing, actual usage di mobile

#### 3.2.7 Landing page: keyboard nav, focus states, scroll-restoration
- Flutter Web default focus ring biasanya kurang, action button perlu explicit `Focus` handling
- Not urgent, tapi audit sebelum wide launch

#### 3.2.8 Landing page: konten section tambahan (opsional)
- Blueprint sudah punya 5 section (hero, features, value, CTA, footer). Section tambahan yg bisa ditambah kalau mau lebih naratif:
  - FAQ (nav link "FAQ" sudah ada tapi belum ada section-nya — sekarang scroll ke value section sebagai fallback)
  - Screenshots app carousel
  - Ceritamu di sini (testimonial-like tanpa promotional)

### 3.3 Tidak-bug (sudah bekerja, dokumentasi supaya jelas)
- Login Google di **mobile** sudah jalan (Testing mode, hanya test user yg didaftarkan)
- Backup Google Drive (via Android app) jalan setelah OAuth client Android setup
- Backup file lokal (AES-256 opsional password) jalan di semua platform
- Mobile APK release ready-to-sideload di `~/Documents/Nasuha App/Nasuha-v1.1.3.apk` (**pubspec sudah 1.2.1+3 tapi APK terbaru masih diberi nama v1.1.3** — perlu update saat release next)

---

## 4. Peraturan/pattern penting untuk v1.1.4

### 4.1 Drift upsert pattern
Jangan pakai `insertOnConflictUpdate` untuk tabel dengan UNIQUE column yang **bukan** PK.
```dart
// ❌ SALAH kalau dateKey UNIQUE (bukan PK):
await db.into(db.dailyScoresTable).insertOnConflictUpdate(companion);

// ✅ BENAR — upsert manual:
final existing = await (db.select(db.dailyScoresTable)
      ..where((t) => t.dateKey.equals(dateKey))..limit(1))
    .getSingleOrNull();
if (existing != null) {
  await (db.update(db.dailyScoresTable)..where((t) => t.id.equals(existing.id)))
      .write(DailyScoresTableCompanion(total: Value(...), ...));
} else {
  await db.into(db.dailyScoresTable).insert(DailyScoresTableCompanion.insert(...));
}
```

### 4.2 Web-only guard pattern
```dart
if (!kIsWeb) {
  try { await service.init(); }
  catch (e, s) { print('non-fatal: $e\n$s'); }
}
```

### 4.3 file_picker di web
```dart
final res = await FilePicker.platform.pickFiles(
  type: FileType.image,
  withData: kIsWeb, // wajib untuk web
);
final picked = res?.files.single;
if (kIsWeb) {
  final bytes = picked?.bytes;
  // simpan base64 data URL di kolom String
} else {
  final path = picked?.path;
  // simpan filesystem path
}
```

### 4.4 Absolute bans (dari impeccable review)
Jangan ada di landing page atau produk-sifat design lainnya:
- Gradient text (`ShaderMask` + `LinearGradient` on Text)
- Eyebrow tracked-uppercase label di atas SETIAP section (satu kali di hero OK sebagai brand voice; global scaffold = AI grammar)
- Numbered section markers (01/02/03) sebagai default scaffolding
- Nested cards
- Side-stripe borders sebagai accent

### 4.5 WCAG kontras
- Body text ≥4.5:1, large text (≥18px atau bold ≥14px) ≥3:1
- Cek dulu sebelum shipping — `#897866` on `#F4ECDD` gagal (3.6:1), `#6E5D4A` on `#F4ECDD` lolos (5.1:1)

---

## 5. Setup / DevOps notes

### 5.1 Build local
```bash
# Mobile APK
flutter build apk --release

# Web (butuh sqlite3.wasm + drift_worker.js di web/ folder — auto ignored via .gitignore, CI download otomatis)
[ -f web/sqlite3.wasm ] || curl -sL -o web/sqlite3.wasm \
  "https://github.com/simolus3/sqlite3.dart/releases/latest/download/sqlite3.wasm"
[ -f web/drift_worker.js ] || curl -sL -o web/drift_worker.js \
  "https://github.com/simolus3/drift/releases/latest/download/drift_worker.js"
flutter build web --release --no-tree-shake-icons
```

### 5.2 Codegen (Drift + gen)
```bash
# Sekali setelah tambah/ubah table:
echo "y" | dart run build_runner build --delete-conflicting-outputs
```
> **Catatan**: `--delete-conflicting-outputs` menghapus semua `.g.dart` termasuk yang bukan Drift. Aman selama Isar sudah tidak dipakai (as of v1.2.1).

### 5.3 Environment
- Flutter channel: `stable`
- Dart SDK: ^3.12.1
- Xcode: 26.5 (iOS build)
- CocoaPods: 1.16.2 via Homebrew (system Ruby 2.6 tidak bisa)
- Android SDK: 35 (compileSdk 36, targetSdk 36)
- AVD emulator: `nasuha_review` (Pixel 7, Android 15, swiftshader GPU)
- Node.js: **TIDAK terpasang** di sistem — beberapa impeccable scripts butuh, sekarang skip

### 5.4 iOS deployment status
- Simulator: ✅ build & jalan (verified)
- Physical iPhone: ⏳ **terblokir** — USB port di Mac ini dikunci **Trend Micro Endpoint Security Device Control**. Bukan hardware; enterprise security agent.
- Opsi lanjut: (A) Mac pribadi lain dgn USB normal + Xcode + Apple ID, (B) TestFlight ($99/th Apple Developer)

### 5.5 Google Cloud OAuth (Nasuha project)
- Project ID: **nasuha-500606**
- Org: `ivanfadillah1996-org`
- Android OAuth Client sudah dibuat: package `com.nasuha.app` + SHA-1 debug keystore
- SHA-1: `6D:55:DF:94:4E:20:FB:BB:B1:C4:BE:17:E2:13:89:22:3A:AE:EF:04`
- SHA-256: `41:ED:77:98:BC:4D:0A:6F:A1:09:55:83:35:D4:A7:4F:CB:1A:F3:5A:AD:45:D3:52:0A:C2:DD:04:CF:8E:FF:CA`
- Consent screen: mode **Testing** (test user = email pribadi user)
- Drive API: **enabled**
- Scope: `https://www.googleapis.com/auth/drive.appdata`
- **Web OAuth client**: ⏳ **belum dibuat** (untuk PWA Drive login)

---

## 6. Struktur Direktori

```
lib/
├── config/theme/                  # AppColors, AppTheme, fonts
├── core/                          # constants, extensions
├── features/
│   ├── achievements/              # AchievementEngine (Drift)
│   ├── analytics/                 # SpiritualCurve, HeatmapCalendar, streak provider
│   ├── dzikir/                    # 34+ dzikir items, detail screen w/ "Tandai selesai" button
│   ├── home/                      # HomeScreen (mobile dashboard)
│   ├── landing/                   # ⭐ BARU v1.2.1: PC landing page
│   │   ├── data/landing_features.dart
│   │   └── presentation/
│   │       ├── landing_screen.dart
│   │       └── widgets/{landing_nav,landing_hero,landing_features,
│   │           landing_value,landing_cta,landing_footer,
│   │           reveal_on_scroll}.dart
│   ├── muhasabah/                 # MuhasabahRepository (Drift), autolog, auto-missed prayers
│   ├── onboarding/                # SplashScreen (route decision), LockScreen (biometric)
│   ├── prayer_time/               # PrayerRepository (Drift settings), notification scheduler
│   ├── profile/                   # ProfileScreen w/ edit photo (data URL di web)
│   ├── qibla/                     # flutter_compass — belum web-ready
│   ├── quran/                     # DriftQuranRepository, dual-mode reader
│   ├── rank/                      # 24 tier system
│   ├── sedekah/                   # SedekahRepository (Drift), radial dial input
│   ├── settings/                  # SettingsController (Drift), backup screen
│   └── sholat_sunnah/             # Data + detail screens
├── models/                        # Plain Dart data classes (dulu @collection Isar)
└── services/
    ├── backup/                    # BackupService, BackupSerializer, DriveBackupClient, crypto
    ├── database/                  # ⭐ Drift AppDatabase (v1.2.1)
    │   ├── app_database.dart
    │   ├── seed.dart
    │   └── tables/*.dart          # 8 tabel Drift
    ├── dev/dummy_seeder.dart      # DEV-only 45-day sample data
    ├── location/
    └── notification/              # NotificationService, prayer_confirm background handler

web/                               # PWA assets (index.html, manifest.json, favicon, icons)
docs/
├── LANDING-DESIGN.md              # ⭐ Blueprint landing page (source of truth)
└── HANDOVER-v1.1.4.md             # ⭐ Dokumen ini
```

---

## 7. Backlog Prioritized (untuk v1.1.4)

Rekomendasi urutan (paling tinggi impact/blocker dulu):

| # | Task | Effort | Blocker/Impact |
|---|---|---|---|
| 1 | **Klarifikasi versioning** (v1.1.4 vs v1.2.2) & update pubspec | 5 min | Blocker release |
| 2 | **Migration script Isar → Drift** untuk user Android existing | ~1 sesi | Blocker wide release |
| 3 | Verifikasi konten Dzikir dgn ustadz | External | Blocker rilis publik |
| 4 | Google OAuth Web Client + `google_sign_in_web` | ~1-2 jam | Enable backup Drive di PWA |
| 5 | Update APK nama file: `Nasuha-v1.1.3.apk` → `Nasuha-v<next>.apk` di `~/Documents/Nasuha App/` | 5 min | Cleanliness |
| 6 | Rename `HANDOVER-v1.1.4.md` sesuai versi final | 1 min | — |
| 7 | Web Notification API (adzan reminders di PWA) | ~1-2 jam | Nice-to-have |
| 8 | Arah Kiblat di web (DeviceOrientation) atau hide | ~30 min - 2 jam | Nice-to-have |
| 9 | Layout responsive polish untuk app screens desktop | ~1-3 sesi | Kalau desktop usage penting |
| 10 | iOS deploy — pilih jalur (Mac lain / TestFlight) | External decision | Kalau iPhone jadi target |
| 11 | OAuth Publish + verifikasi domain (public release) | ~1 jam + review Google 1-4 minggu | Wide-release blocker |
| 12 | Test suite (widget test untuk landing page + Drift repositories) | ~2-3 jam | Quality bar |

---

## 8. Testing catatan (untuk v1.1.4)

### Yang sudah teruji di v1.2.1
- ✅ Mobile: catat muhasabah, sedekah, buka Quran, dzikir, jadwal sholat, kiblat, analitik, edit nama, edit foto (data URL di web)
- ✅ Web PWA: same as mobile MINUS notifications, kiblat, biometric, Google Sign-In
- ✅ Data persist di IndexedDB (verified via F5 reload)
- ✅ Migrasi Drift onCreate + onUpgrade schema

### Belum teruji sistematis
- ⚠️ iOS di device fisik (blocked USB)
- ⚠️ Multi-device sync via Drive backup (butuh Google login web)
- ⚠️ Load test dengan 1+ tahun data (heatmap performance)
- ⚠️ Landing page di viewport 900-1200px (breakpoint edge case)
- ⚠️ Screen reader / keyboard nav landing page

---

## <a id="versioning-note"></a>9. Versioning Note (PENTING)

**Divergensi versi saat handover:**
- `pubspec.yaml` sekarang: `version: 1.2.1+3`
- Target sesi berikutnya (per instruksi user): `v1.1.4`

Kemungkinan interpretasi:
- (A) `v1.1.4` = typo, maksudnya `v1.2.2` (next patch dari v1.2.1) → **update `pubspec` tidak perlu**
- (B) `v1.1.4` sengaja — mobile release track terpisah dari PWA dev cycle. Mobile stable = v1.1.x, PWA = v1.2.x → butuh **branching strategy** atau roll back pubspec ke `1.1.4+X` untuk mobile release, PWA di branch sendiri
- (C) `v1.1.4` = release berikut Android APK yang publik-ready (misal setelah verifikasi dzikir + migration script) → pubspec dibalik ke 1.1.4, PWA jalan di branch dev

**Rekomendasi:** klarifikasi di awal sesi berikutnya. Kalau A, rename dokumen ini ke `HANDOVER-v1.2.2.md`. Kalau B/C, atur branching Git.

---

## 10. Links & Access

- **Repo**: https://github.com/bebekoding/Nasuha-app
- **PWA Live**: https://nasuha-app.vercel.app
- **Vercel Dashboard**: (login akun `bercoding1` — GitHub connect)
- **Google Cloud Console**: project `nasuha-500606`
- **APK download local**: `~/Documents/Nasuha App/Nasuha-v1.1.3.apk`
- **Design blueprint**: `docs/LANDING-DESIGN.md`
- **Memory memory Claude Code**: `/Users/960075/.claude/projects/-Users-960075/memory/project_nasuha_status.md`

---

## Ringkas 1 baris

> **v1.2.1 shipped**: Isar→Drift complete, PWA live, landing page done, 7 web-bugs fixed. **v1.1.4 fokus**: klarifikasi versioning, migration script mobile users, Google web OAuth, verifikasi konten agama.
