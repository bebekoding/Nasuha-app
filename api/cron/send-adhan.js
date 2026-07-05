// GET /api/cron/send-adhan
//
// Cron endpoint yang di-trigger tiap 1 menit (Vercel Cron atau external
// scheduler seperti cron-job.org). Untuk setiap user yang subscribe:
//   1. Hitung jadwal sholat hari ini via lib `adhan`
//   2. Cek apakah ada prayer time dalam window ±30 detik dari sekarang
//   3. Kalau iya → kirim FCM push dgn title 'Waktu Sholat [X]'
//
// Auth: bearer token dari env CRON_SECRET (Vercel auto-set kalau pakai
// Vercel Cron, atau set manual di dashboard kalau pakai external cron).
//
// Env vars:
//   CRON_SECRET                    — token auth
//   FIREBASE_SERVICE_ACCOUNT_JSON  — raw JSON string dari Firebase Admin
//   KV_REST_API_URL / KV_REST_API_TOKEN — auto-set oleh Vercel KV

import { kv } from '@vercel/kv';
import admin from 'firebase-admin';
import { Coordinates, CalculationMethod, PrayerTimes } from 'adhan';

// Init Firebase Admin sekali per cold start.
if (!admin.apps.length) {
  const raw = process.env.FIREBASE_SERVICE_ACCOUNT_JSON;
  if (!raw) {
    console.error('[cron] FIREBASE_SERVICE_ACCOUNT_JSON missing');
  } else {
    admin.initializeApp({
      credential: admin.credential.cert(JSON.parse(raw)),
    });
  }
}

const CALC_METHODS = {
  muslimWorldLeague: () => CalculationMethod.MuslimWorldLeague(),
  egyptian: () => CalculationMethod.Egyptian(),
  karachi: () => CalculationMethod.Karachi(),
  ummAlQura: () => CalculationMethod.UmmAlQura(),
  dubai: () => CalculationMethod.Dubai(),
  qatar: () => CalculationMethod.Qatar(),
  kuwait: () => CalculationMethod.Kuwait(),
  singapore: () => CalculationMethod.Singapore(),
  turkey: () => CalculationMethod.Turkey(),
  tehran: () => CalculationMethod.Tehran(),
  northAmerica: () => CalculationMethod.NorthAmerica(),
};

const PRAYER_LABELS = {
  fajr: 'Subuh',
  dhuhr: 'Dzuhur',
  asr: 'Ashar',
  maghrib: 'Maghrib',
  isha: 'Isya',
};

// Window: fire kalau |now - prayerTime| <= 30 detik (matches cron 1min tick).
const WINDOW_MS = 30 * 1000;

function methodFor(name) {
  const fn = CALC_METHODS[name] || CALC_METHODS.muslimWorldLeague;
  return fn();
}

async function sendPush({ token, prayerKey, prayerLabel }) {
  try {
    await admin.messaging().send({
      token,
      notification: {
        title: `Waktu Sholat ${prayerLabel}`,
        body: `Sudah masuk waktu ${prayerLabel}. Segeralah menunaikan.`,
      },
      data: {
        tag: `nasuha-adhan-${prayerKey}`,
        prayer: prayerKey,
      },
      webpush: {
        headers: { Urgency: 'high' },
        fcmOptions: { link: 'https://nasuha-app.vercel.app/#/prayer' },
        notification: {
          icon: '/icons/Icon-192.png',
          badge: '/icons/Icon-192.png',
          tag: `nasuha-adhan-${prayerKey}`,
          renotify: true,
        },
      },
    });
    return { ok: true };
  } catch (e) {
    // Token invalid / expired → cleanup registry.
    const invalid =
      e.code === 'messaging/registration-token-not-registered' ||
      e.code === 'messaging/invalid-registration-token';
    if (invalid) {
      await kv.hdel('nasuha:subs', token);
      await kv.zrem('nasuha:subs:idx', token);
    }
    return { ok: false, error: e.code || e.message, invalid };
  }
}

export default async function handler(req, res) {
  // Auth (Vercel Cron sets Authorization: Bearer <CRON_SECRET>).
  const auth = req.headers.authorization || '';
  const secret = process.env.CRON_SECRET || '';
  if (secret && auth !== `Bearer ${secret}`) {
    return res.status(401).json({ error: 'unauthorized' });
  }

  const startedAt = Date.now();
  const now = new Date();

  // Iterate semua subscriber. Untuk skala kecil (<10k user) langsung
  // hgetall aman. Untuk skala besar perlu batching/queue.
  const subs = (await kv.hgetall('nasuha:subs')) || {};
  const entries = Object.entries(subs);
  if (entries.length === 0) {
    return res.status(200).json({ sent: 0, checked: 0, elapsedMs: Date.now() - startedAt });
  }

  const results = { sent: 0, checked: 0, failures: 0, invalidCleaned: 0 };

  for (const [token, subJson] of entries) {
    results.checked++;
    let sub;
    try {
      sub = typeof subJson === 'string' ? JSON.parse(subJson) : subJson;
    } catch (_) {
      continue;
    }
    if (!sub || typeof sub.lat !== 'number' || typeof sub.lng !== 'number') continue;

    const coords = new Coordinates(sub.lat, sub.lng);
    const method = methodFor(sub.calcMethod);

    // Hitung untuk hari ini (UTC). Prayer time yang dekat tengah malam
    // waktu user bisa berada di hari UTC lain — cek juga besok/kemarin
    // supaya edge case timezone tak lewat.
    const days = [
      new Date(now.getTime() - 24 * 3600 * 1000),
      now,
      new Date(now.getTime() + 24 * 3600 * 1000),
    ];

    for (const day of days) {
      const times = new PrayerTimes(coords, day, method);
      for (const [key, label] of Object.entries(PRAYER_LABELS)) {
        const t = times[key];
        if (!t) continue;
        const diffMs = t.getTime() - now.getTime();
        if (Math.abs(diffMs) <= WINDOW_MS) {
          const r = await sendPush({ token, prayerKey: key, prayerLabel: label });
          if (r.ok) results.sent++;
          else {
            results.failures++;
            if (r.invalid) results.invalidCleaned++;
          }
        }
      }
    }
  }

  res.status(200).json({
    ...results,
    elapsedMs: Date.now() - startedAt,
    now: now.toISOString(),
  });
}
