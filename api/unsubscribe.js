// POST /api/unsubscribe — hapus FCM token dari registry.
// Body: { fcmToken: string }

import { kv } from '@vercel/kv';

export default async function handler(req, res) {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');
  if (req.method === 'OPTIONS') return res.status(204).end();
  if (req.method !== 'POST') return res.status(405).json({ error: 'method_not_allowed' });

  const { fcmToken } = req.body || {};
  if (!fcmToken) return res.status(400).json({ error: 'missing_token' });

  try {
    await kv.hdel('nasuha:subs', fcmToken);
    await kv.zrem('nasuha:subs:idx', fcmToken);
    return res.status(200).json({ ok: true });
  } catch (e) {
    console.error('[unsubscribe] kv error:', e);
    return res.status(500).json({ error: 'storage_failed' });
  }
}
