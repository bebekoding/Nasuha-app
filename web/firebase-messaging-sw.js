// Service Worker untuk Firebase Cloud Messaging (FCM Web Push).
// Ini SW terpisah dari flutter_service_worker.js (Flutter default handle
// caching). Firebase SDK menuntut SW terdaftar di `/firebase-messaging-sw.js`.
//
// PENTING: config di bawah harus MATCH dengan yang di web/index.html supaya
// SDK bisa join session. Kalau config diganti di satu tempat, ganti juga
// yang lain.
//
// PLACEHOLDER — user isi setelah Firebase Console setup (lihat
// docs/SETUP-FCM-Push.md).

importScripts(
    'https://www.gstatic.com/firebasejs/10.13.0/firebase-app-compat.js');
importScripts(
    'https://www.gstatic.com/firebasejs/10.13.0/firebase-messaging-compat.js');

firebase.initializeApp({
  apiKey: 'PLACEHOLDER_FIREBASE_API_KEY',
  authDomain: 'nasuha-500606.firebaseapp.com',
  projectId: 'nasuha-500606',
  storageBucket: 'nasuha-500606.appspot.com',
  messagingSenderId: 'PLACEHOLDER_SENDER_ID',
  appId: 'PLACEHOLDER_APP_ID',
});

const messaging = firebase.messaging();

// Background handler — jalan saat tab Nasuha closed / minimized.
// FCM SDK secara default sudah tampilkan notification bila payload
// punya `notification` field. Handler ini custom-override supaya bisa
// tag & badge sesuai design Nasuha.
messaging.onBackgroundMessage((payload) => {
  const title = (payload.notification && payload.notification.title) ||
      'Nasuha';
  const body = (payload.notification && payload.notification.body) || '';
  const options = {
    body: body,
    icon: '/icons/Icon-192.png',
    badge: '/icons/Icon-192.png',
    tag: (payload.data && payload.data.tag) || 'nasuha-adhan',
    // renotify: kalau prayer sama fire lagi, replace notif lama.
    renotify: true,
    data: payload.data || {},
  };
  return self.registration.showNotification(title, options);
});

// Klik notif → buka halaman Jadwal Sholat di Nasuha PWA.
self.addEventListener('notificationclick', (event) => {
  event.notification.close();
  const targetUrl = '/#/prayer';
  event.waitUntil(
    self.clients.matchAll({type: 'window', includeUncontrolled: true})
        .then((clientList) => {
          // Kalau tab Nasuha sudah terbuka, focus + navigate.
          for (const client of clientList) {
            if (client.url.indexOf(self.location.origin) === 0) {
              client.focus();
              if ('navigate' in client) client.navigate(targetUrl);
              return;
            }
          }
          // Belum ada tab → buka baru.
          return self.clients.openWindow(targetUrl);
        }),
  );
});
