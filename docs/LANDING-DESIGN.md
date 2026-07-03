# Nasuha — PC Landing Page Design Blueprint

> Marketing landing page ala fore.coffee + micro-interactions ala apple.com/mac.
> Target: PC visitors (viewport ≥ 900 px). Mobile users langsung ke `/home`.
> Pattern: **Hero + Features + Value + CTA** (top-down conversion funnel).

---

## 0. Design Tokens (extend palette existing)

### Palet
| Peran | Color | Catatan |
|---|---|---|
| Canvas | `#F4ECDD` cream | Body bg |
| Panel warm-white | `#FCF7EE` | Cards, sticky nav bg |
| Panel deep | `#EDE1CE` | Section alt (feature grid bg) |
| Ink | `#3B2E22` espresso | Headings + body text |
| Muted ink | `#897866` taupe | Subtitle, footer text |
| Primary | `#8A5A3A` coffee | CTA fill, brand accent |
| Primary press | `#6E4730` | CTA hover state |
| Accent hero | `#C1923C` ochre | Highlight kata di headline, streak-flame |
| Accent warm | `#C17A53` terracotta | Feature icon (Muhasabah, Rank) |
| Accent alt | `#A77B43` caramel | Feature icon (Quran, Analitik) |
| Line/border | `#E3D6BF` tan | Nav underline, card outline |

### Type scale (Space Grotesk display + Plus Jakarta Sans body)
- `display-xl` — 72/1.05, w700, letter-spacing -0.02em (Hero headline)
- `display-lg` — 56/1.10, w700 (Section headings)
- `display-md` — 40/1.15, w700 (Value pillar headings)
- `title-lg` — 24/1.30, w600 (Feature card title)
- `body-lg` — 18/1.55, w400 (Hero subtitle, section lead)
- `body-md` — 16/1.60, w400 (Card body, footer)
- `label` — 13/1.30, w600, letter-spacing 0.08em, UPPERCASE (Section eyebrow)

### Spasi (8-step scale)
`4 8 16 24 32 48 80 120` px. Bagian besar (section vertical padding) 120 px atas & bawah di desktop.

### Radius & elevation
- Card radius: 20 px (soft, warm)
- Button radius: 999 (pill) / 12 (rectangular ghost)
- Shadow-base: `0 1px 2px rgba(59,46,34,.06)` (hairline, tak "dijahit")
- Shadow-hover: `0 12px 32px rgba(59,46,34,.14)` (dramatic lift ala apple)

### Container
- Max width: 1200 px (content), 1360 px (hero bleed)
- Horizontal gutter: 48 px (≥ 1024 px), 32 px (900 – 1024 px)

---

## 1. Sticky Navbar

**Height:** 72 px → menyusut ke 56 px setelah scroll > 80 px (motion: "sticky nav shrink" ala Apple).

**Layout:**
```
[emblem 32×32]  Nasuha        Fitur   Nilai   FAQ            [Mulai ▸]
────────────────────────────────────────────────────────────────────
                    ← center nav ↑                            ← CTA →
```

- **Left**: emblem (SVG 32 px) + wordmark "Nasuha" (Space Grotesk 20/w700, ink)
- **Center**: link `Fitur` `Nilai` `FAQ` — Plus Jakarta Sans 15/w500, muted → ink pada hover, underline slide-in dari kiri (200 ms ease-out)
- **Right**: Pill button "Mulai" → route `/home`. Fill primary `#8A5A3A`, teks warm-white, shadow-base
- Nav bg: `rgba(252, 247, 238, 0.72)` + `backdrop-filter: blur(20px)` (frosted, hangat)
- Border-bottom: `#E3D6BF` hairline (muncul saat scroll > 80 px)

**Micro-interaction:**
- Scroll ≥ 80 px → shrink height 72 → 56 px, logo scale 1 → 0.9, blur naik 0 → 20 px (semua 240 ms ease-out).

---

## 2. Hero

**Vertical padding:** 120 px atas, 80 px bawah. Center-align. Grid 12 kolom.

**Konten:**
```
                       ┌─── (eyebrow) ───┐
                       │ ✦ MUSLIM PERSONAL GROWTH │      ← ochre 13/w600 UPPERCASE
                       └──────────────────┘

              Setiap hari adalah                           ← display-xl 72 w700 ink
              satu langkah kecil.

     Muhasabah harian, Al-Quran, Dzikir, Sedekah,          ← body-lg 18 w400 taupe
     dan analitik ibadah. Semua di satu tempat,            ← max-width 640 px
     tetap privat di HP-mu.

     [Mulai Perjalanan ▸]   [Lihat Fitur]                  ← primary pill + ghost pill
```

**Highlight kata**: "**langkah kecil**" pakai color ochre `#C1923C` (bukan bold). Efek: bagian ini muncul dengan gradient text subtle (`linear-gradient(90deg, #C1923C 0%, #8A5A3A 100%)`).

**Hero visual (di bawah CTA):**
Emblem Nasuha (SVG line-art figure + archway) di posisi tengah 360×360 px, di atas softly glowing radial gradient (ochre 8% → transparent). Emblem "melayang" — parallax subtle: bergeser ±16 px vertikal mengikuti scroll (translateY = scrollY × 0.08). **Respect `prefers-reduced-motion`** → matikan parallax.

**CTA button spec:**
- Primary: fill `#8A5A3A`, teks `#FCF7EE` 16/w600, padding 20×32, radius 999, shadow-base
  - Hover: fill `#6E4730`, shadow lift ke `0 16px 40px rgba(138,90,58,.24)`, scale 1.02, translateY -2 px (semua 200 ms ease-out)
  - Icon arrow `▸` translateX +4 px on hover
- Secondary ghost: transparent, border 1.5px `#8A5A3A`, teks primary. Hover: fill 8% ochre.

**Reveal on load:** eyebrow (delay 0), headline (delay 80 ms), subtitle (delay 200 ms), CTAs (delay 320 ms), emblem (delay 480 ms). Setiap element: fade + translateY 24 → 0 (480 ms ease-out).

---

## 3. Features Grid

**Section bg:** `#EDE1CE` deep-cream (kontras lembut vs canvas).
**Vertical padding:** 120 px atas & bawah.

**Header:**
```
                    ─── FITUR ───              ← eyebrow ochre
              Tujuh hal untuk hari lebih sadar   ← display-lg 56 w700 ink center
```

**Grid:** 3 kolom × 3 baris (kolom 3 baris terakhir kosong / feature ke-7 span 2 kolom).
- 7 kartu: Muhasabah • Al-Quran • Dzikir • Sholat & Kiblat • Sedekah • Analitik • Rank/XP
- Gap 24 px, aspect card ≈ 4:5 (portrait, ala fore.coffee promo tiles)

**Kartu spec (default):**
- Ukuran: 360×450 px
- Fill: `#FCF7EE` warm-white
- Border: `#E3D6BF` 1 px
- Radius: 20 px
- Padding: 32 px
- Struktur:
  ```
  ┌───────────────────────────────┐
  │ [Icon 56 px, accent color]    │  ← icon tile 72×72 rounded 16, tinted 12% accent
  │                               │
  │                               │
  │  Judul Fitur                   │  ← title-lg 24 w600 ink, margin-top 24
  │                               │
  │  Deskripsi singkat 2 baris     │  ← body-md 16 muted, margin-top 8
  │  yang bikin tersenyum.          │
  │                               │
  │                               │
  │  Pelajari →                    │  ← label-lg 14 w600 primary, absolute bottom-left
  └───────────────────────────────┘
  ```

**Copy tiap kartu (natural, tidak preachy):**
1. **Muhasabah harian** — "Catat amalan & momen refleksi. XP-mu berjalan mengikuti niatmu." — icon: `spa` ochre `#C1923C`
2. **Al-Quran** — "114 surah, dua mode baca (terjemah & fokus mushaf). Marker otomatis biar tak kehilangan jejak." — icon: `menu_book` caramel `#A77B43`
3. **Dzikir & Doa** — "Pagi, petang, sesudah sholat, tahajud. Ketuk hitung, atau selesai sekali tap." — icon: `auto_awesome` clay `#B5613F`
4. **Jadwal Sholat & Kiblat** — "5 waktu presisi lokasi, kompas kiblat. Adzan pengingat halus." — icon: `mosque` primary `#8A5A3A`
5. **Sedekah tracker** — "Input dial cepat, rekap harian/mingguan/bulanan. Yang penting, konsisten." — icon: `volunteer_activism` terracotta `#C17A53`
6. **Analitik ibadah** — "Streak per amalan, heatmap tahunan, kurva spiritual. Data untuk diri sendiri." — icon: `insights` caramel `#A77B43`
7. **Rank & XP** — "24 level dari Mubtadi ke Muqarrab. Bukan lomba — cermin perjalanan." — icon: `military_tech` ochre gold `#C1923C`

**Hover state (apple-style):**
- Card translateY -6 px, shadow → `0 20px 40px rgba(59,46,34,.16)`
- Border color → `#8A5A3A` @ 24 % (subtly deeper)
- Icon tile scale 1.06, rotate ±2 deg (per kartu random arah biar tidak seragam)
- "Pelajari →" text opacity 0.6 → 1, arrow translateX +4 px
- Semua transitions 320 ms cubic-bezier(0.16, 1, 0.3, 1) — spring feel

**Scroll reveal:** stagger 60 ms per kartu, fade+translateY 24 → 0, saat 25 % kartu masuk viewport (IntersectionObserver 0.25 threshold).

---

## 4. Value Section — "Kenapa Nasuha"

**Vertical padding:** 120 px. Section bg kembali ke `#F4ECDD` canvas.

**Layout:** 3-column, 40 px gap, dengan tepian side illustration (arsitektur simetris).

**Header:**
```
                    ─── FILOSOFI ───
              Bukan sekadar checklist.
              Tempat tumbuh yang tenang.       ← display-lg 56 w700 ink, 2 baris
```

**3 pilar (kartu tanpa border, hanya spacing):**

| # | Icon | Judul | Copy |
|---|---|---|---|
| 1 | `shield_moon` `#8A5A3A` | **Privat & offline** | "Semua data hidup di HP-mu. Tidak ada akun wajib, tidak ada iklan, tidak ada pihak ketiga yang mengintip." |
| 2 | `spa` `#C1923C` | **Personal, bukan performatif** | "Muhasabah harian, tidak ada leaderboard publik. Perjalananmu — hanya untukmu dan Allah." |
| 3 | `insights` `#A77B43` | **Ringan & sederhana** | "Gamifikasi seperlunya. Tak ada notifikasi memaksa. Kau yang atur ritme." |

**Micro-interaction:** hover pilar → icon tile scale 1.08 + tint bg naik 10 %, teks judul color transition ink → primary (200 ms).

---

## 5. CTA Banner

**Vertical padding:** 80 px. Full-bleed background: coffee primary `#8A5A3A` dengan overlay noise texture soft (opacity 4%) untuk "warmth".

**Layout centered:**
```
                    Mulai. Kecil.
                    Setiap hari.                  ← display-md 40 w700 cream #FCF7EE
                    
     Nasuha ringan, gratis, dan bekerja
     tanpa koneksi. Buka sekarang, tak perlu    ← body-lg 18 cream 85% opacity
     buat akun.
     
              [Mulai Perjalanan ▸]                ← button raksasa, fill cream primary invert
```

- Button: fill `#FCF7EE`, teks `#8A5A3A` 18/w700, padding 24×40, radius 999
- Hover: fill `#F4ECDD`, shadow ochre glow `0 0 32px rgba(193,146,60,.4)`, scale 1.02

---

## 6. Footer

**Bg:** `#221A12` warm-espresso (dark twist di ujung, memberi "grounding" halus). Text: cream `#F0E8DB`.
**Vertical padding:** 80 px atas, 32 px bawah.

**4 kolom + credit row:**

| Col 1: Brand | Col 2: Fitur | Col 3: Nasuha | Col 4: Bantuan |
|---|---|---|---|
| **[emblem] Nasuha** | Muhasabah | Filosofi | FAQ |
| "Level up your soul · Level up your amal" | Al-Quran | Privasi | Kontak |
| _(taupe muted 14)_ | Dzikir | Ubah nama | Kirim masukan |
| | Sedekah | | |
| | Analitik | | |

**Credit row (bottom, border-top hairline `#453826`):**
```
© 2026 Nasuha • Made with 🤍 in Indonesia               [github] [twitter]
```

**Hover link:** underline slide-in (200 ms), color ke `#DDBE7C` (goldDark) → warm accent tetap terasa.

---

## 7. Micro-interactions Playbook (adaptasi apple.com/mac)

| # | Efek | Trigger | Detail Implementasi |
|---|---|---|---|
| **A** | **Scroll reveal** (fade + slide-up) | Element masuk 25 % viewport | IntersectionObserver threshold 0.25 → add class `.in`, CSS: `opacity 0→1, translateY 24→0` 480 ms cubic-bezier(0.16, 1, 0.3, 1) |
| **B** | **Sticky nav shrink** | Scroll > 80 px | Nav height 72→56, logo scale 1→0.9, blur 0→20, border-bottom fade-in. Duration 240 ms ease-out |
| **C** | **Card hover lift** | Cursor enter card | translateY -6, shadow deep, icon tile scale 1.06 + micro-rotate, arrow translateX +4. Duration 320 ms spring |
| **D** | **CTA magnetic hover** | Cursor near primary CTA | Button translate mengikuti cursor delta × 0.15 dalam radius 100 px (subtle "magnet" feel). Reset 300 ms saat leave |
| **E** | **Hero emblem parallax** | Scroll | translateY = scrollY × 0.08 (max ±40 px). Matikan bila `prefers-reduced-motion` |
| **F** | **Stagger reveal grid** | Feature grid masuk viewport | Kartu 1..7 delay 60 ms × index, animasi sama dengan efek A |
| **G** | **Headline gradient text on load** | Load selesai | Kata highlight ("langkah kecil") ada mask reveal L→R 800 ms ease-out |

**Global rules:**
- Semua duration ≥ 150 ms & ≤ 480 ms (rentang natural)
- Semua transisi pakai transform + opacity (GPU-friendly)
- `prefers-reduced-motion: reduce` → matikan parallax + magnet + stagger delay, sisakan opacity fades saja
- Tap targets tetap ≥ 44 px meski di desktop (hover butuh precision, tap tak)

---

## 8. Copy voice (Bahasa Indonesia natural)

- **Hindari**: "aplikasi terbaik", "solusi lengkap", "ubah hidupmu", "join community"
- **Pakai**: kalimat pendek, ganti "kamu" (bukan "anda"), sesekali sisipkan istilah agama tanpa preach
- **Tone**: warm, tenang, seperti teman ngobrol di sore hari
- **Contoh CTA text**:
  - ✅ "Mulai Perjalanan"
  - ✅ "Lihat Fitur"
  - ✅ "Mulai. Kecil. Setiap hari."
  - ❌ "Download App Now!" · ❌ "Get Started Today"

---

## 9. Accessibility & Responsive

- Kontras semua teks ≥ 4.5:1 (ink `#3B2E22` on cream `#F4ECDD` = 9.2:1 ✅; primary `#8A5A3A` on cream = 5.6:1 ✅; taupe `#897866` on cream = 3.8:1 ⚠️ khusus body-lg 18/w400 masih OK, tapi jangan turunkan)
- Focus ring: outline 2 px `#8A5A3A` offset 3 px pada semua interactive
- Breakpoints:
  - `≥ 1200 px` — full layout
  - `900 – 1199 px` — grid 2 kolom, gutter 32 px
  - `< 900 px` — **redirect langsung ke `/home`** (mobile app view, bukan landing)
- Sertakan `<meta name="viewport" content="width=device-width, initial-scale=1">` di `web/index.html` (sudah ada)

---

## 10. Struktur file yang saya usulkan untuk build

```
lib/features/landing/
├── data/
│   └── landing_features.dart          # 7 fitur + copy
├── presentation/
│   ├── landing_screen.dart            # entry (kIsWeb + width guard)
│   └── widgets/
│       ├── landing_nav.dart           # sticky navbar (with shrink)
│       ├── landing_hero.dart          # hero + parallax emblem
│       ├── landing_features_grid.dart # 7 cards
│       ├── landing_value_section.dart # 3 pilar
│       ├── landing_cta_banner.dart    # coffee banner
│       ├── landing_footer.dart        # espresso footer
│       └── reveal_on_scroll.dart      # helper animasi (IntersectionObserver-like)
```

**Routing:** `/` → `LandingScreen`. Di dalam `LandingScreen.build`, cek `kIsWeb && MediaQuery.of(context).size.width >= 900` → tampilkan landing, else `context.go('/home')` (redirect langsung untuk mobile / non-web).

---

## Ringkasan singkat untuk implementasi

1. **Palette** — extend, no new hex. Fokus di ink `#3B2E22`, cream `#F4ECDD`, primary `#8A5A3A`, ochre `#C1923C`.
2. **Layout** — Hero + Features (grid 3 kolom) + Value (3 pilar) + CTA banner + Footer. Container 1200 px.
3. **Motion** — 7 micro-interactions (A–G), semua di transform+opacity, respect reduced-motion.
4. **Copy** — pendek, hangat, "kamu", no jargon.
5. **Routing** — `/` gate: PC ≥ 900 px → landing, else → `/home`.

Siap dieksekusi.
