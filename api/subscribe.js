// POST /api/subscribe
//
// Register FCM token + jadwal user. Dipanggil dari client (Flutter web
// via lib/services/notification/fcm_backend.dart) setelah user aktifkan
// "Notifikasi adzan" di Settings.
//
// Body: {
//   fcmToken: string,
//   lat: number,
//   lng: number,
//   calcMethod: string,   // 'muslimWorldLeague' | 'singapore' | ...
//   timezone: string,     // 'UTC+07:00' atau IANA name
//   subscribedAt: string  // ISO8601
// }
//
// Storage: Vercel KV (Upstash Redis di bawahnya).
//   nasuha:subs      → hash {fcmToken → JSON.stringify(sub)}
//   nasuha:subs:idx  → sorted set (score=timestamp) untuk iterasi cron

import { kv } from '@vercel/kv';

const REQUIRED_FIELDS = ['fcmToken', 'lat', 'lng', 'calcMethod'];

export default async function handler(req, res) {
  // CORS — biar Flutter web bisa POST dari browser.
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');
  if (req.method === 'OPTIONS') return res.status(204).end();
  if (req.method !== 'POST') return res.status(405).json({ error: 'method_not_allowed' });

  const body = req.body || {};
  for (const f of REQUIRED_FIELDS) {
    if (body[f] === undefined || body[f] === null) {
      return res.status(400).json({ error: `missing_field:${f}` });
    }
  }
  const { fcmToken, lat, lng, calcMethod, timezone, subscribedAt } = body;
  if (typeof fcmToken !== 'string' || fcmToken.length < 20) {
    return res.status(400).json({ error: 'invalid_token' });
  }
  const latNum = Number(lat);
  const lngNum = Number(lng);
  if (Number.isNaN(latNum) || Number.isNaN(lngNum)) {
    return res.status(400).json({ error: 'invalid_coords' });
  }

  const record = {
    fcmToken,
    lat: latNum,
    lng: lngNum,
    calcMethod: String(calcMethod || 'muslimWorldLeague'),
    timezone: String(timezone || 'UTC'),
    subscribedAt: subscribedAt || new Date().toISOString(),
    updatedAt: Date.now(),
  };

  try {
    await kv.hset('nasuha:subs', { [fcmToken]: JSON.stringify(record) });
    await kv.zadd('nasuha:subs:idx', { score: record.updatedAt, member: fcmToken });
    return res.status(200).json({ ok: true, fcmToken });
  } catch (e) {
    console.error('[subscribe] kv error:', e);
    return res.status(500).json({ error: 'storage_failed' });
  }
}
