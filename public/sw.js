const CACHE_NAME = 'app-cache-v1';
const OFFLINE_URL = '/offline';

const PRECACHE = [
  '/offline',
  '/images/icons/icon-192x192.png'
];
console.log('install script loaded, buttons found:', installButtons.length);

window.addEventListener('beforeinstallprompt', () => {
    console.log('beforeinstallprompt FIRED');
});

window.addEventListener('appinstalled', () => {
    console.log('appinstalled');
});
self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(CACHE_NAME).then((cache) =>
      Promise.allSettled(
        PRECACHE.map((url) =>
          cache.add(url).catch((err) => console.warn('Не закэшировано:', url, err))
        )
      )
    )
  );
  self.skipWaiting();
});

self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches.keys().then((keys) =>
      Promise.all(
        keys.filter((k) => k !== CACHE_NAME).map((k) => caches.delete(k))
      )
    )
  );
  self.clients.claim();
});

self.addEventListener('fetch', (event) => {
  if (event.request.method !== 'GET') return;

  // Pages: network first, fall back to offline page
  if (event.request.mode === 'navigate') {
    event.respondWith(
      fetch(event.request).catch(() => caches.match(OFFLINE_URL))
    );
    return;
  }

  // Assets: cache first, then network
  event.respondWith(
    caches.match(event.request).then((cached) => {
      return (
        cached ||
        fetch(event.request).then((response) => {
          const copy = response.clone();
          caches.open(CACHE_NAME).then((cache) => cache.put(event.request, copy));
          return response;
        })
      );
    })
  );
});