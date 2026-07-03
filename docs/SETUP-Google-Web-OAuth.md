# Setup Google OAuth Web Client (untuk PWA backup Drive)

Panduan setup Web OAuth client di Google Cloud Console supaya user PWA
(https://nasuha-app.vercel.app) bisa login Google & backup ke Drive App
Folder.

**Reuse project yang sudah ada**: `nasuha-500606` (yang sudah dipakai untuk
Android client + OAuth consent + Drive API). Tidak perlu bikin project
baru — cukup tambah client tipe "Web".

---

## Prasyarat (sudah selesai dari sesi sebelumnya)

- ✅ Cloud project `nasuha-500606`
- ✅ Drive API enabled
- ✅ OAuth consent screen (External, scope `drive.appdata`, test user)
- ✅ Android OAuth client (package `com.nasuha.app` + SHA-1 debug)

## Langkah baru untuk Web

### 1. Buat OAuth Client tipe "Web application"

1. Buka https://console.cloud.google.com/apis/credentials?project=nasuha-500606
2. **Create Credentials** → **OAuth client ID** → **Application type: Web application**
3. **Name**: `Nasuha Web`
4. **Authorized JavaScript origins**:
   ```
   http://localhost:8080
   http://127.0.0.1:8080
   https://nasuha-app.vercel.app
   ```
   (Tambah domain custom kalau nanti dipakai.)
5. **Authorized redirect URIs** — untuk `google_sign_in_web` (GIS flow) **tidak wajib**, tapi kalau mau aman isi juga:
   ```
   https://nasuha-app.vercel.app
   http://localhost:8080
   ```
6. **Create** → catat **Client ID** (format `XXXXXXXX.apps.googleusercontent.com`).

### 2. Tempel Client ID ke `web/index.html`

Edit `web/index.html`, ganti placeholder:

```html
<meta name="google-signin-client_id"
      content="PLACEHOLDER_WEB_CLIENT_ID.apps.googleusercontent.com">
```

Jadi:

```html
<meta name="google-signin-client_id"
      content="XXXXXXXX.apps.googleusercontent.com">
```

Commit + push → GitHub Actions deploy ke Vercel otomatis.

### 3. Test login di PWA

1. Buka https://nasuha-app.vercel.app (atau `http://localhost:8080` lokal).
2. Pengaturan → **Akun & Pemulihan** → **Masuk dengan Google**.
3. Popup Google login muncul → pilih akun test user (yang sudah ditambahkan di consent screen).
4. Setelah login: tombol backup/restore Drive aktif.

### 4. Kalau ada error `redirect_uri_mismatch` / `origin not allowed`

- Cek origin yang dipakai browser (F12 → Console) sama persis dengan **Authorized JavaScript origins**.
- Perhatikan **http vs https**, **www vs bare**, port. Butuh **exact match**.

---

## Batasan `drive.appdata` scope

- Termasuk **sensitive scope**. Testing mode: cap ~100 user, warning "app unverified" saat login. Sudah cukup untuk internal / early users.
- Untuk publik (production) → butuh **OAuth verification** oleh Google (privacy policy URL + verified domain + kadang demo video). Proses review 1-4 minggu. Belum urgent untuk v1.2.2.

---

## Referensi

- google_sign_in_web docs: https://pub.dev/packages/google_sign_in_web
- Google Identity Services (GIS) migration: https://developers.google.com/identity/oauth2/web/guides/migration-to-gis
- Drive App Folder: https://developers.google.com/drive/api/guides/appdata
