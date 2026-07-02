# Design

Visual system for **Nasuha** — warm **cream & brown**, soft / earthy / calming,
light-first. Implemented in `lib/config/theme/` (`app_colors.dart`, `app_theme.dart`).
(User explicitly chose cream+brown; the usual "avoid cream" guideline is overridden
by an explicit brand request — executed as a committed, cohesive warm palette.)

## Theme

Light-first. Warm cream surfaces, coffee-brown primary, espresso ink. Earthy
accents (caramel / terracotta / ochre / clay / taupe). No green, no pure black,
no stark white. A warm-espresso dark variant exists but is secondary.

## Color (light — primary)

| Role | Hex | Use |
|---|---|---|
| `bg` | `#F4ECDD` | Warm cream background |
| `surface` | `#FCF7EE` | Cards, sheets (warm white) |
| `surfaceHi` | `#EDE1CE` | Raised / input fills |
| `line` | `#E3D6BF` | Hairline borders |
| `primary` | `#8A5A3A` | Coffee brown — primary actions (white text ~5.5:1) |
| `ink` | `#3B2E22` | Primary text — espresso, not black |
| `muted` | `#897866` | Secondary text — warm taupe |
| `gold/ochre` | `#C1923C` | Streak / level / accent |
| `negative` | `#B5613F` | Rust / clay (Muhasabah minus, destructive) |

Category accents (menu tiles): coffee `#8A5A3A`, caramel `#A77B43`, terracotta
`#C17A53`, clay `#B5613F`, ochre `#C1923C`, taupe `#A6785F`.

**Menu tiles read distinctly against cream**: tinted fill (hue @ ~20%) + a **firm
same-hue outline** (hue @ 65%, 1.5px) + a soft hue-tinted shadow. Outline does the
heavy lifting for separation so the fill can stay calm.

## Typography

Contrast-axis pairing (geometric display + humanist body), via `google_fonts`:

- **Display / numbers** — `Space Grotesk`. Headings, the score/level "HUD" numbers.
  Tight tracking (-0.02em), weights 600–700.
- **Body / UI** — `Plus Jakarta Sans` (humanist, Indonesian heritage). 400/500/600/700.
- **Arabic** — keep a proper Arabic face for Quran/dzikir (RTL), not the Latin body.

Scale: display 40/32, title 20/17, body 15/13, label 11 (caps tracking +0.08em used
sparingly, NOT as an eyebrow on every section).

## Components

- **Cards**: `surface` fill + 1px `line` border, radius 20. No uniform tinted-card
  grids; vary size/treatment by importance. Never nested cards, never side-stripe borders.
- **Hero / status (home)**: a "power" panel — level rank + score + streak as a HUD,
  energy gradient + faint glow, the one place intensity is allowed.
- **Level ring**: circular progress (score → next level) using `gold`, with the rank
  name; replaces the plain number card.
- **Buttons**: filled = energy gradient, radius 14, weight 700; outline = 1px primary.
  Pressed state scales 0.96 (tactile).
- **Inputs**: `surfaceHi` fill, 1px `line`, focus = primary border.
- **Radius scale**: sm 12 · md 16 · lg 20 · xl 28 (intentional, not all-20).

## Motion

Ease-out (quart/expo), 150–300ms. Staggered list entrances (already on home).
Level/score count-up + streak-flame pulse. Every animation has a
`prefers-reduced-motion` static fallback. No bounce/elastic, no neon glow loops.

## Anti-slop guardrails

No: seed-only ColorScheme, default Roboto, identical tinted card grids, side-stripe
borders, gradient text, per-section uppercase eyebrows, glassmorphism-by-default,
cream/sand backgrounds.
