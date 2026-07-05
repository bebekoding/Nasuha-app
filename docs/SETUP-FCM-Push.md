# Setup FCM Push Notification untuk Nasuha PWA

Push notif adzan tetap muncul walau tab Nasuha ditutup — pakai Firebase
Cloud Messaging (FCM) + Vercel serverless backend + Vercel KV storage.

**Waktu setup total: ~30 menit.** Kamu hanya sekali setup, setelah itu
subscriber tinggal toggle di Settings.

Arsitektur:

```
Client (Flutter web)         Google FCM         Backend (Vercel)
    │                          │                     │
    │─ subscribe (get token) ─►│                     │
    │─ POST /api/subscribe ──────────────────────────►│ simpan sub
    │                          │                     │  ke Vercel KV
    │                          │                     │
    │                          │◄─ every 1 min ──────│ cron cek jadwal
    │                          │                     │  → kirim FCM push
    │◄─ SW receive push ───────│                     │  ke token yg cocok
    │  showNotification()      │                     │
```

---

## 1. Enable Firebase Cloud Messaging

**Project reuse:** `nasuha-500606` yang sudah dipakai untuk Google Drive
backup OAuth.

1. Buka [Firebase Console](https://console.firebase.google.com/) → pilih
   project `nasuha-500606`.
2. Kalau belum "Firebase project" (masih GCP-only), klik **Add Firebase
   to Google Cloud project** → pilih project → confirm.
3. Di sidebar: **Project Overview** → ikon roda (Settings) → **Project
   settings**.

### 1a. Register Web App (kalau belum)

4. Di **Project settings** → tab **General** → scroll ke bawah **Your apps**.
5. Klik ikon `</>` **Web** → nickname `Nasuha PWA` → **Register app**.
6. Copy `firebaseConfig` object yang muncul. Ada field: `apiKey`,
   `authDomain`, `projectId`, `storageBucket`, `messagingSenderId`, `appId`.

### 1b. Generate VAPID key (Web Push certificate)

7. Di **Project settings** → tab **Cloud Messaging** → scroll ke **Web
   configuration** → **Web Push certificates**.
8. Klik **Generate key pair**. Copy string panjang (bakal jadi VAPID
   public key).

---

## 2. Tempel config ke Nasuha (2 file)

### `web/index.html`

Ganti placeholder di block script `Firebase Cloud Messaging`:

```js
var NASUHA_FIREBASE_CONFIG = {
  apiKey: 'AIzaSy...',              // dari step 6
  authDomain: 'nasuha-500606.firebaseapp.com',
  projectId: 'nasuha-500606',
  storageBucket: 'nasuha-500606.appspot.com',
  messagingSenderId: '123456789',   // dari step 6
  appId: '1:123456789:web:abc...',  // dari step 6
};
var NASUHA_VAPID_PUBLIC_KEY = 'BJ...';  // dari step 8
```

### `web/firebase-messaging-sw.js`

Ganti placeholder yang sama (config-nya harus identik dengan index.html):

```js
firebase.initializeApp({
  apiKey: 'AIzaSy...',
  authDomain: 'nasuha-500606.firebaseapp.com',
  projectId: 'nasuha-500606',
  storageBucket: 'nasuha-500606.appspot.com',
  messagingSenderId: '123456789',
  appId: '1:123456789:web:abc...',
});
```

**Note VAPID key TIDAK perlu di SW** — VAPID cuma dipakai di client saat
`getToken()`. SW cukup Firebase config.

---

## 3. Enable Vercel KV storage

1. Buka [Vercel Dashboard](https://vercel.com/dashboard) → pilih project
   Nasuha.
2. Tab **Storage** → **Create Database** → **KV** (Upstash Redis).
3. Nama: `nasuha-push` → region: `sin1` (Singapore, kalau target Asia)
   atau region terdekat.
4. Klik **Create** → **Connect Project** ke Nasuha-app.

Setelah connect, Vercel otomatis inject 4 env var ke project:
`KV_URL`, `KV_REST_API_URL`, `KV_REST_API_TOKEN`, `KV_REST_API_READ_ONLY_TOKEN`.
Backend `api/subscribe.js` + `api/cron/send-adhan.js` pakai `@vercel/kv`
package yang read env vars ini otomatis.

---

## 4. Generate Firebase Admin Service Account

Backend butuh service account credential untuk kirim FCM push.

1. Firebase Console → **Project settings** → tab **Service accounts**.
2. Klik **Generate new private key** → download file JSON.
3. Copy **seluruh isi JSON** file itu (satu baris atau formatted).

## 5. Set env vars di Vercel

1. Vercel Dashboard → project Nasuha → **Settings** → **Environment Variables**.
2. Tambah 2 env var berikut (scope: **Production** + **Preview**):

| Name | Value |
|---|---|
| `FIREBASE_SERVICE_ACCOUNT_JSON` | (paste seluruh JSON dari step 4.3) |
| `CRON_SECRET` | (random string, mis. `openssl rand -hex 32`) |

3. **Redeploy** project supaya env vars ke-load. Biasanya Vercel prompt
   auto-redeploy setelah env change.

---

## 6. Cron scheduler — Vercel plan check

Backend butuh trigger `/api/cron/send-adhan` tiap **1 menit**. Ada 3 opsi:

### Opsi A: Vercel Cron (paling clean, tapi butuh plan)

Config sudah ada di `vercel.json`:
```json
"crons": [{ "path": "/api/cron/send-adhan", "schedule": "* * * * *" }]
```

- **Vercel Hobby (free)**: max 1 cron per project, **daily only** (`0 0 * * *`).
  Cukup untuk test 1 push/hari, tapi TIDAK cukup untuk semua 5 waktu sholat.
- **Vercel Pro ($20/mo)**: unlimited crons, **granularity 1 menit** — pas
  untuk requirement kita.

Kalau Hobby: ubah schedule di `vercel.json` ke daily + skip cron, pakai
external service di bawah.

### Opsi B: External cron (free, works dengan Hobby)

Gunakan [cron-job.org](https://cron-job.org) atau [EasyCron](https://www.easycron.com/).

1. Signup → create new cron.
2. URL: `https://nasuha-app.vercel.app/api/cron/send-adhan`
3. Schedule: `* * * * *` (every minute)
4. **Headers**: tambah `Authorization: Bearer <CRON_SECRET>` (sama dgn env var step 5).
5. Save + enable.

External cron akan hit endpoint tiap menit → backend proses → kirim push.

### Opsi C: Skip auto-cron, manual trigger only

Untuk test/dev, bisa curl manual:
```bash
curl -H "Authorization: Bearer $CRON_SECRET" \
  https://nasuha-app.vercel.app/api/cron/send-adhan
```

---

## 7. Deploy + test

1. **Commit + push** Nasuha repo. Vercel auto-deploy.
2. Buka Nasuha PWA di browser (Chrome desktop atau HP).
3. Grant izin lokasi (supaya `settings.lastLatitude/lastLongitude` ada).
4. Pengaturan → toggle **"Notifikasi adzan"** ON.
5. Browser prompt → allow → snackbar "Notif adzan aktif. Push muncul walau tab tertutup."
6. **Tutup tab Nasuha** — biarkan browser tetap aktif.
7. Tunggu waktu adzan berikut.
8. Notifikasi muncul di system tray (Windows) / Notification Center
   (macOS) / status bar (Android) walau Nasuha tab tak dibuka.

### Debug kalau notif tak muncul

**Client**:
- DevTools → Console — cek error `[Nasuha FCM]` prefix.
- DevTools → Application → Service Workers — pastikan `firebase-messaging-sw.js` aktif.
- DevTools → Application → Storage → Notifications — cek permission = "granted".

**Backend**:
- Vercel Dashboard → project → **Logs** — filter `/api/subscribe` dan
  `/api/cron/send-adhan`.
- Response cron: `{ sent: N, checked: M }` — kalau `checked=0`, sub belum
  tersimpan; kalau `sent=0` tapi `checked>0`, waktu adzan tak match
  window ±30s (cron mungkin belum aktif atau time drift).

**FCM**:
- Firebase Console → **Cloud Messaging** → **Send test message** →
  masukin FCM token yang di-log client → send. Kalau notif muncul, FCM +
  SW jalan; masalah di backend logic.

---

## 8. Cost estimate (untuk skala < 1000 user)

| Service | Free tier | Kalau melebihi |
|---|---|---|
| **Firebase FCM** | Unlimited push | Gratis selamanya untuk web push |
| **Vercel KV (Upstash)** | 30k req/hari | Upgrade $10/mo untuk 1M req |
| **Vercel Cron (Pro)** | — | $20/mo project plan |
| **cron-job.org** | 3 cron 60s min | Gratis, hobbyist friendly |
| **Vercel functions** | 100 GB-hours/mo | $20/mo Pro plan |

Untuk komunitas kecil (< 500 subscriber), **fit di free tier** kalau
pakai external cron (cron-job.org).

---

## 9. iOS PWA support (bonus)

iOS 16.4+ (Safari) sekarang support Web Push untuk PWA yang di-**Add to
Home Screen**. User iOS perlu:
1. Buka nasuha-app.vercel.app di Safari
2. Share → **Add to Home Screen**
3. Buka Nasuha dari home screen (bukan Safari)
4. Toggle notif adzan → grant permission
5. Notif akan muncul di lock screen walau app closed

Kalau user buka dari Safari (bukan homescreen), FCM subscribe akan gagal
di iOS < 16.4. Client sudah handle (return null token, snackbar error).
