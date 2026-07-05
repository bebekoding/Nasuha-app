# Handover — Nasuha `v1.2.2` → `v1.2.3`

> **Sesi ini:** v1.2.3 (pubspec bumped ke `1.2.3+5`)
> **Live PWA:** https://nasuha-app.vercel.app
> **Repo:** https://github.com/bebekoding/Nasuha-app (public)
> **Latest commit:** `0ae7383` (FCM push stack shipped)

---

## Konteks singkat

v1.2.2 shipped: PWA infrastructure lengkap, 21 route dgn desktop layout 100%, splash polish, Jadwal Sholat bubble di home, tier ladder viewport, Rank auto-scroll.

v1.2.3 dimulai fokus **PWA push notification (FCM)** untuk adzan yang muncul walau tab tertutup. Kode sudah 100% ready, tapi butuh setup Cloud Console + Vercel dari user (~30 menit manual work).

---

## 1. Yang sudah shipped di v1.2.2 (recap)

### 1.1 Desktop coverage 100%
Semua 21 route Nasuha punya desktop layout — 14 deep-custom + 7 chromeless wrap.

| Kategori | Screens |
|---|---|
| **Deep-custom (14)** | Home, Muhasabah, Al-Quran, Sedekah, Analitik, Rank, Dzikir, Sholat Sunnah, Jadwal Sholat, Achievements, Profile, Settings, Backup, Kiblat |
| **Chromeless wrap (7)** | sedekah/history, sedekah/recap, muhasabah/history, muhasabah/intro, dzikir/:idx, sholat-sunnah/:idx, quran/:num |

Reusable widgets shipped:
- `lib/core/widgets/desktop_page_shell.dart` — top nav + eyebrow + back + max-width 1240 + sunburst backdrop + `bodyIsScrollable` flag
- `HoverLiftCard` — apple-style hover (translateY + scale + shadow bloom)
- Router helper `_desktopOr` + `_desktopWrapOr` (chromeless pattern)

### 1.2 Home page enhancements
- **Jadwal Sholat bubble** (`_JadwalNextHero`): countdown detik (`FontFeature.tabularFigures`), state "SUDAH MASUK WAKTU [X]" caramel warna window 15 menit, roll otomatis ke next prayer setelah window habis. Live tick 1 detik.
- Nav lengkap: Beranda (active) + Al-Quran + Jadwal Sholat + Analitik + Rank + Pemulihan
- Order stagger reveal: 0-4 (Hero → HUD → JadwalHero → SectionPrioritas → SectionFitur)

### 1.3 Splash polish
- Icon fg (tanpa background box cream), 280px desktop / 180px mobile
- Title 56px desktop, tagline 20px, letter-spacing -1.0
- Skip onboarding walkthrough di desktop (kIsWeb && width >= 800): auto-mark done + go '/'

### 1.4 Rank tier ladder viewport
- 27 tier tak render sekaligus — viewport 7 rows (580px)
- Auto-scroll: current tier di posisi ke-4 → 3 di atas + saat ini + 3 di bawah
- `ScrollConfiguration.dragDevices` untuk mouse+trackpad
- Copy: "Scroll ke atas atau bawah untuk cek tier lain"

### 1.5 Push notif (setTimeout foreground path)
- Settings toggle "Notifikasi adzan" instant call `scheduleNext48h()` + snackbar konfirmasi
- Splash bootstrap re-schedule di setiap app load
- Web: skip `requestPermissions()` di splash (bukan user-gesture); minta di Settings toggle only

**Commits v1.2.2**: `3d17ccb`, `7ea8734`, `179e1cb`, `a25194b`, `11e52c0`, `5b35fc2`, `4cb5b5f`, `27d92d2`, `dee92fa`, `d5c99a6`, `599e181`, `ac01ad6`, `c057994`, `7b70d4f`, `b621688`, `2c79f12`, `24eb9d4`.

---

## 2. Yang sudah code-ready di v1.2.3 tapi belum aktif — **FCM Push Stack**

Latest commit **`0ae7383`** ship 15 file untuk FCM (Firebase Cloud Messaging) push notification stack. Push notif adzan muncul di device walau tab tertutup. Semua kode selesai — tinggal setup Cloud Console + Vercel (~30 menit user work).

### 2.1 File yang di-code (semua sudah di repo)

**Frontend Flutter web:**
- `web/firebase-messaging-sw.js` — Service Worker Firebase Messaging, handle onBackgroundMessage + notificationclick
- `web/index.html` — Firebase SDK v10 compat + `nasuhaSubscribeToFcm()` + onMessage foreground
- `lib/services/notification/web_notifier.dart` — subscribeToFcm() + unsubscribeFromFcm() via `js_interop_unsafe`
- `lib/services/notification/fcm_backend.dart` — HTTP client POST subscribe ke backend
- `lib/services/notification/web_notifier_stub.dart` — no-op untuk mobile
- `lib/features/settings/.../settings_screen.dart` — auto-subscribe FCM + POST backend saat toggle ON

**Backend Vercel serverless:**
- `api/subscribe.js` — POST simpan sub ke KV `nasuha:subs` hash + sorted set index
- `api/unsubscribe.js` — POST hapus sub
- `api/cron/send-adhan.js` — cron endpoint, auth bearer CRON_SECRET, iterate subs, hitung PrayerTimes 3 hari (kemarin/today/besok), check ±30s window, kirim FCM push via firebase-admin, auto-cleanup token invalid
- `vercel.json` — cron `* * * * *`, rewrite api/*, Service-Worker-Allowed header
- `package.json` — deps `firebase-admin` + `@vercel/kv` + `adhan`

**Docs:**
- `docs/SETUP-FCM-Push.md` — 9-section walkthrough setup

### 2.2 On-progress di sesi ini — Setup step 1 (Firebase Console)

**Sudah dikerjakan user (progress):**
- ✅ Login Firebase Console dengan akun `ivanfadillah1996@gmail.com`
- ✅ Menemukan project **`Nasuha`** dengan project ID **`nasuha-500606`** di list Firebase — sudah Firebase-enabled

**Yang HARUS user lakukan berikutnya (v1.2.3 sesi baru):**

Ikuti [docs/SETUP-FCM-Push.md](docs/SETUP-FCM-Push.md) mulai dari section §1.1a (bukan dari awal).

**Section 1: Firebase Console**
1. Klik project **Nasuha** (`nasuha-500606`) di list
2. **Project settings** (roda kiri atas) → tab **General** → scroll **Your apps**
3. Klik ikon `</>` (Web) → nickname `Nasuha PWA` → **Register app**
4. Copy 6 field `firebaseConfig` (apiKey, authDomain, projectId, storageBucket, messagingSenderId, appId)
5. Tab **Cloud Messaging** → scroll **Web configuration** → **Web Push certificates** → **Generate key pair**
6. Copy VAPID public key (string panjang mulai `B...`)

**Section 2: Tempel config ke code**
1. Ganti PLACEHOLDER di `web/index.html` — `NASUHA_FIREBASE_CONFIG` + `NASUHA_VAPID_PUBLIC_KEY`
2. Ganti PLACEHOLDER di `web/firebase-messaging-sw.js` — sama config-nya (identical, tanpa VAPID)

**Section 3: Vercel KV**
1. Vercel Dashboard → project Nasuha-app → **Storage** → **Create Database** → **KV** (Upstash Redis)
2. Nama `nasuha-push` region `sin1` → Create → Connect Project

**Section 4-5: Firebase Admin + env vars**
1. Firebase → **Service accounts** → **Generate new private key** → download JSON
2. Vercel → **Settings** → **Environment Variables** →
   - `FIREBASE_SERVICE_ACCOUNT_JSON` = paste JSON
   - `CRON_SECRET` = `openssl rand -hex 32`
3. Redeploy project

**Section 6: Cron scheduler**
Pilih 1:
- **Vercel Pro** ($20/mo): config sudah ada di `vercel.json`
- **cron-job.org** (free): create cron URL `https://nasuha-app.vercel.app/api/cron/send-adhan` schedule `* * * * *` Bearer auth

**Section 7: Test**
1. Commit push (auto-deploy Vercel)
2. Buka Nasuha PWA → grant lokasi → Pengaturan → toggle Notifikasi adzan
3. Tutup tab → tunggu adzan → notif muncul walau tab tak dibuka

### 2.3 Estimasi waktu

Setup manual step 1-7 kalau lancar: **~30 menit**. Kalau nyangkut (Firebase Console UI berubah, Vercel KV error), tanyakan step berapa yang stuck — assistant bantu troubleshoot.

---

## 3. Backlog v1.2.3+ (belum dieksekusi, dari roadmap sebelumnya)

### 3.1 Wide-release blockers
| # | Task | Effort | Blocker untuk |
|---|---|---|---|
| 1 | **Real Isar→Drift bulk migrator** — recreate `.g.dart` schema, re-add isar mobile-only via `if (dart.library.io)`, tulis migrator baca 8 collections | ~1-2 sesi | Wide mobile release (Play Store). Current: legacy_isar_check.dart cuma rename file, user tanpa backup TETAP kehilangan data |
| 2 | **Verifikasi konten Dzikir** dengan ustadz/mushaf | External (1-2 minggu ulama) | Public release (moral) |
| 3 | **Push notif FCM** — user lanjut setup Cloud Console per §2.2 | External + 30 min user | User feature PWA-hardening |

### 3.2 Nice-to-have polish
| # | Task | Effort | Value |
|---|---|---|---|
| 4 | **iOS TestFlight/publish** — build sim sudah ada, belum ada jalur publish. Butuh Apple Developer account + provisioning | External + code | iOS distribution |
| 5 | **Keyboard focus states desktop** — GestureDetector cards belum ada visible focus ring untuk keyboard/screen-reader | ~1 jam | A11y (P2 dari impeccable review) |
| 6 | **OAuth publish + verifikasi domain** (Testing→Production di Cloud Console, review Google 1-4 minggu, butuh privacy policy URL + verified domain) | ~1 jam + review 1-4 minggu | Wide PWA release (>100 user Drive backup) |
| 7 | **iOS Web Push testing** — verify FCM push di iOS 16.4+ Safari via Add to Home Screen | ~30 min | iOS user coverage |
| 8 | **Muhasabah body full desktop refactor** — right panel di MuhasabahDesktopScreen currently reuse mobile chip sizes; wide layout bisa lebih optimal | ~1 sesi | Better desktop UX |
| 9 | **Quran surah reader — 2-col dgn ayah navigator sidebar** — currently pakai chromeless wrap (portrait mobile natural). Wide reader dgn sidebar TOC bisa lebih powerful | ~1 sesi | Better reader UX |
| 10 | **Firebase Analytics** — untuk track user retention + prayer notif engagement (opsional, reuse Firebase project) | ~1 sesi | Analytics |
| 11 | **PWA install prompt** — banner "Add to Home Screen" untuk iOS user supaya push notif jalan | ~30 min | iOS PWA install rate |

### 3.3 Tech debt / housekeeping
| # | Task | Effort |
|---|---|---|
| 12 | **APK lama cleanup** di `~/Documents/Nasuha App/` — hapus `Nasuha-v1.1.3.apk`, keep latest | 1 min user |
| 13 | **flutter_local_notifications 22.0.1 upgrade** — currently 18.0.1, ada breaking API di 22 | ~30 min |
| 14 | **Dependency audit** — 57 packages outdated (per `flutter pub outdated`). Sebagian minor, sebagian major (Riverpod 3, drift 2.34, go_router 17) | ~1-2 sesi migration |
| 15 | **Test coverage** — belum ada widget test untuk desktop screens (14 screen) + push notif flow | ~2-3 sesi |

---

## 4. Peraturan/pattern penting yang ditemukan v1.2.2

### 4.1 Dart Record types
`{name, time, icon}` — `PrayerSchedule.next` return Record 3-field. Kalau helper method return Record 2-field `{name, time}` dan pakai `condition ? active : next`, Dart type-unification error karena Record dgn shape beda tak compatible. Fix: match shape (return semua field).

### 4.2 Chromeless pattern
Reader/list screens mobile bisa dipakai ulang di desktop tanpa duplikasi kode dengan pattern:
```dart
class XScreen extends ... {
  const XScreen({super.key, this.chromeless = false});
  final bool chromeless;
  Widget build(ctx) {
    final body = ListView(shrinkWrap: chromeless, physics: chromeless ? NeverScrollableScrollPhysics() : null, ...);
    if (chromeless) return body;
    return Scaffold(appBar: ..., body: body);
  }
}
```
Router `_desktopWrapOr(build: (c) => XScreen(chromeless: c), ...)` pilih based on viewport.

### 4.3 DesktopPageShell.bodyIsScrollable
Kalau child punya CustomScrollView sendiri (mis. Al-Quran reader dgn cross-surah continuous slivers), pakai `bodyIsScrollable: true` supaya shell skip SingleChildScrollView + wrap Expanded biar child dapat sisa tinggi viewport.

### 4.4 FontFeature.tabularFigures
Untuk angka yang berubah tiap detik (countdown, timer), pakai `fontFeatures: [FontFeature.tabularFigures()]` supaya lebar digit konsisten — tak geser layout tiap detik.

### 4.5 Splash decision-tree responsive
- Desktop web: skip onboarding walkthrough (mark done + go /). Portrait mobile flow tak cocok viewport wide.
- Mobile/native: keep onboarding walkthrough.
- Web: JANGAN request permission di splash (bukan user-gesture, browser reject). Native OK.

### 4.6 setTimeout limits (setTimeout web)
- Max delay `WebNotifier.schedule()` = 24h (browser precision drops di >30 day)
- Kalau tab close → timer die
- Kalau tab background → throttle 1s minimum tapi masih fire
- **Solusi tab-closed**: Service Worker + Push Subscription + backend push server (FCM stack di v1.2.3)

---

## 5. File structure snapshot post v1.2.2 → v1.2.3

```
Projects/muhasabah/
├── api/                            # NEW — Vercel serverless (v1.2.3)
│   ├── subscribe.js
│   ├── unsubscribe.js
│   └── cron/
│       └── send-adhan.js
├── lib/
│   ├── config/
│   │   ├── routes/app_router.dart       # _desktopOr + _desktopWrapOr helpers
│   │   └── theme/                        # AppColors + AppFonts unchanged
│   ├── core/widgets/
│   │   ├── desktop_page_shell.dart      # DesktopPageShell + DesktopTopNav + HoverLiftCard + DesktopSunburstBackdrop
│   │   └── web_frame.dart               # WebFrame untuk mobile-in-desktop (fallback)
│   ├── features/
│   │   ├── home/presentation/
│   │   │   ├── home_screen.dart              # Mobile HomeScreen
│   │   │   └── desktop_home_screen.dart      # Desktop w/ Jadwal bubble live
│   │   ├── muhasabah/.../screens/            # + muhasabah_desktop_screen.dart
│   │   ├── quran/.../screens/                # + quran_desktop_screen.dart (bento 4-col)
│   │   ├── sedekah/.../screens/              # + sedekah_desktop_screen.dart
│   │   ├── analytics/.../screens/            # + analytics_desktop_screen.dart
│   │   ├── rank/.../screens/                 # + rank_desktop_screen.dart (viewport 7 tier)
│   │   ├── dzikir/.../screens/               # + dzikir_desktop_screen.dart (bento 3-col)
│   │   ├── sholat_sunnah/.../screens/        # + sholat_sunnah_desktop_screen.dart
│   │   ├── prayer_time/.../screens/          # + prayer_time_desktop_screen.dart
│   │   ├── achievements/.../screens/         # + achievements_desktop_screen.dart
│   │   ├── profile/presentation/             # + profile_desktop_screen.dart + profile_actions.dart
│   │   ├── settings/.../screens/             # + settings_desktop_screen.dart + backup_desktop_screen.dart
│   │   └── qibla/.../screens/                # + qibla_desktop_screen.dart
│   └── services/
│       ├── database/legacy_isar_check.dart   # v1.2.2 detector (NOT real migrator)
│       └── notification/
│           ├── notification_service.dart     # Base w/ kIsWeb branch
│           ├── web_notifier.dart             # + subscribeToFcm/unsubscribeFromFcm (v1.2.3)
│           ├── web_notifier_stub.dart        # Mobile no-op
│           └── fcm_backend.dart              # NEW — HTTP POST subscribe (v1.2.3)
├── web/
│   ├── index.html                            # Splash HTML + FCM SDK init + VAPID key (v1.2.3)
│   ├── firebase-messaging-sw.js              # NEW — FCM SW (v1.2.3)
│   ├── manifest.json
│   ├── favicon.png
│   ├── icons/
│   ├── sqlite3.wasm                          # Drift (gitignored, downloaded in CI)
│   └── drift_worker.js                       # (gitignored)
├── docs/
│   ├── HANDOVER-v1.2.2.md                    # sesi lalu
│   ├── HANDOVER-v1.2.3.md                    # ⭐ dokumen ini
│   ├── SETUP-Google-Web-OAuth.md
│   └── SETUP-FCM-Push.md                     # NEW (v1.2.3)
├── vercel.json                               # + crons + rewrite api/* (v1.2.3)
├── package.json                              # NEW — Node backend deps (v1.2.3)
├── pubspec.yaml                              # version: 1.2.3+5
└── .gitignore                                # + node_modules/ (v1.2.3)
```

---

## 6. Testing catatan untuk v1.2.3

### Yang sudah teruji di v1.2.2
- ✅ Mobile: semua fitur inti
- ✅ Web PWA: 21 route desktop coverage 100%
- ✅ Splash desktop skip onboarding + logo big
- ✅ Jadwal Sholat bubble state normal + "SUDAH MASUK WAKTU" (visual)
- ✅ Rank tier viewport 7 rows auto-scroll
- ✅ Nav 6-item lengkap
- ✅ Data persist di IndexedDB
- ✅ Migrasi Drift onCreate + onUpgrade schema
- ✅ Vercel auto-deploy CI

### Belum teruji sistematis (v1.2.3 backlog testing)
- ⚠️ FCM push saat tab closed (blocker: setup Cloud Console)
- ⚠️ iOS 16.4+ PWA push via Add to Home Screen
- ⚠️ Countdown detik smooth di real device (test di Safari mobile)
- ⚠️ Vercel cron rate limit + KV consumption di scale 100 user
- ⚠️ FCM token cleanup jika user pindah device (invalid token auto-remove di backend)
- ⚠️ Load test dengan 1+ tahun data (heatmap performance)
- ⚠️ Multi-device sync via Drive backup

---

## 7. Setup credentials sesi berikutnya perlu

Untuk lanjut FCM push setup di sesi v1.2.3, siapkan:

1. **Firebase Console access** — akun `ivanfadillah1996@gmail.com` yg punya project `Nasuha` (`nasuha-500606`) — sudah confirmed accessible
2. **Vercel Dashboard access** — akun yg punya project Nasuha-app deploy ke `nasuha-app.vercel.app`
3. **Terminal** — untuk generate `openssl rand -hex 32` CRON_SECRET
4. **Payment method** (optional) — cuma kalau pilih Vercel Pro $20/mo untuk cron per-minute. Alternative gratis: cron-job.org

---

## 8. Links & Access

- **Repo**: https://github.com/bebekoding/Nasuha-app
- **Live PWA**: https://nasuha-app.vercel.app
- **Firebase Console**: https://console.firebase.google.com/project/nasuha-500606
- **Google Cloud Console**: https://console.cloud.google.com/home/dashboard?project=nasuha-500606
- **Vercel Dashboard**: https://vercel.com/dashboard (login pakai akun yg punya nasuha-app)
- **cron-job.org**: https://cron-job.org (opsi gratis cron scheduler)

---

## 9. Ringkasan status singkat

| Aspect | Status |
|---|---|
| Desktop coverage 21 route | ✅ 100% |
| Mobile route | ✅ Unchanged |
| PWA infrastructure | ✅ Working (setTimeout foreground) |
| FCM push (background) | 🟡 Code shipped, awaiting user setup Cloud Console + Vercel KV |
| iOS PWA push | 🟡 Code compatible, belum teruji real device |
| Migration Isar→Drift | 🔴 Detector only, real migrator = v1.2.3+ |
| Verifikasi konten Dzikir | 🔴 Wait ustadz review, blocker publik release |
| iOS deploy publik | 🔴 Belum ada jalur |
| Test suite | 🔴 Belum ada widget test untuk desktop layouts |

**Recommended next-session first action**: user lanjut Firebase Console step 1a (Register Web App) → dapat `firebaseConfig` + VAPID key → paste ke `web/index.html` + `web/firebase-messaging-sw.js` (assistant bantu tempel). Sisanya Vercel KV + env vars + cron pilihan.
