'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "dc16b6e3fbfa9a408e71d27449d16414",
"assets/AssetManifest.bin.json": "711c2e8743d50b1dd0e8c6837b2eccc1",
"assets/AssetManifest.json": "2ca33430d291ccdfcdda3b7b0c254ef0",
"assets/assets/9mobile.png": "98f5cef448f4097498840267f4f542d3",
"assets/assets/9modile.svg": "48d0fdbc8e1d62a01859397cee028cb3",
"assets/assets/airtel.png": "e84cf642febb1c7cc970aeca375f2b99",
"assets/assets/airtel.svg": "1e29f4288343f19e18bb9232b2f0d389",
"assets/assets/alert-circle-down.svg": "14f3e574ba235bb59470543520d4724b",
"assets/assets/alert-circle-up.svg": "0c68ba8e3a4abd6aa71b9f24840014b7",
"assets/assets/alert-circle.svg": "e1f66e09d6ce7980ce623258f7d23ee9",
"assets/assets/arrow-down.svg": "d716a0a5e3e9a70ad5b6ec59b283016a",
"assets/assets/arrow-up.svg": "d85f0a68595491802ada2a16c3242521",
"assets/assets/background.svg": "e6d8f7db945fb8c0927904d6cdd0b6e2",
"assets/assets/backgroundescrow.png": "63332f4a68125ce97f74e02ded9bac01",
"assets/assets/bag.svg": "9dc61338ec9be80a289fc36af2c4a02a",
"assets/assets/ball.svg": "9122a93ef4a7be72ec90cad37cd52044",
"assets/assets/bell.svg": "94cf56b5dcda835d1b27bc161d3628ab",
"assets/assets/biometric.png": "53a795af7eb5703bef63ff0c0fbde0bd",
"assets/assets/brownCircle.svg": "626394b52aec80f3ea97ebbef06e203b",
"assets/assets/bulb.svg": "1a34d8d3fe801cd9be31924085ea39fc",
"assets/assets/call-ringing.svg": "cd1d1c9e59555e293a703cf2d6f2e815",
"assets/assets/camera.svg": "a991dd3795ba678630f45e26489de0b3",
"assets/assets/card.svg": "6dbed4cc755ca753876d7b22c1abb913",
"assets/assets/check-circle.svg": "998c487ded19f27452c8b00d2752f332",
"assets/assets/chevron-right.svg": "79c0802a90d7b1dbb9d8298f0f309225",
"assets/assets/cloud-upload.png": "98ea2cac5a4d1831a5fe23626fb96c26",
"assets/assets/cloud-upload.svg": "1e9f4b3daff7168a10650c562282f335",
"assets/assets/confetti.svg": "ced26bc9ba0ee9af2e8a50ee9ab92428",
"assets/assets/copy.svg": "df28e07206ff279d0db4b31a0ac72ff8",
"assets/assets/divider.png": "fa69575819da0afa5285f05023d12146",
"assets/assets/DSTV.jpg": "9542f3cee7feedb84a54184ea7b8a56d",
"assets/assets/DSTV.svg": "274831e01bf42e401c9d57211b6ad9cc",
"assets/assets/eye-slash.svg": "921b40348cc6d6babf23c0a064582253",
"assets/assets/file.svg": "b96dfb6bf55ca93307e519a10fb818bc",
"assets/assets/flashpay.svg": "a9f7d41ec785df3572743919e68fd255",
"assets/assets/glo.jpeg": "7c51e108057d1f37ee27551f560a3464",
"assets/assets/glo.png": "bc759f08a5a132a22b8dc22e1e8f4802",
"assets/assets/glo.svg": "844b891da0a88550322feba5d083dcbd",
"assets/assets/go.jpg": "7d087cbc80a8bf1639bb0df2960e1517",
"assets/assets/good.jpeg": "f1474650beccf4bbf49bd9a991685088",
"assets/assets/GOtv.png": "c417ce67a51d9d980eb776311c0ee032",
"assets/assets/GOtv.svg": "66b0eed49bcacbfa1f6a9f58e1c64522",
"assets/assets/headset.svg": "576b11d076c6c6c2763b4a8ba6c09d89",
"assets/assets/home.svg": "5c819245f150c38d3c59ac72f85864e5",
"assets/assets/homebackground.svg": "50b2b26103d9ed246f404ac20ceec259",
"assets/assets/icons.png": "9c55daf8297fce5f564044665dce93a3",
"assets/assets/lock.svg": "d1d80565ce0b399c696e62104728f337",
"assets/assets/message-alt.svg": "b8adf9428ffe1acf71d6950b5dc5f8c5",
"assets/assets/mtn.png": "b38fb91eaf15608ca13c8bdaa18c69ce",
"assets/assets/mtn.svg": "2f390d2da49dc15c3c4a82d377d5b88d",
"assets/assets/nearme.gif": "8653c84f7427d7c7383a89cc8cbadd7b",
"assets/assets/nearme.png": "5730bf38c591f63bd34f8cfebdbc244d",
"assets/assets/oneplug.svg": "ff85e1c478af631355fb6b518d78dd73",
"assets/assets/oneplugpaylogo.svg": "62e708a5abe926451158e7e02d869ffb",
"assets/assets/pic.jpg": "fa0363168588af9b30940df72928f7d5",
"assets/assets/pic.svg": "3cf69ede3227c01a727b4f9f3dd66444",
"assets/assets/pindot.svg": "e719299b536dce12cfb88d61c77b143f",
"assets/assets/pindotactive.svg": "f8bd091bc5f324be374765ee8f24ad92",
"assets/assets/plus.svg": "621399de374e3a99ff51504b7d4b06a1",
"assets/assets/Portraitwoman.png": "618ebf58bc20117b49abea11bcd3d46c",
"assets/assets/profile.png": "d0265dd4448b9f25881dd3b7f27c890c",
"assets/assets/radio-button-active.svg": "c4a536e2d148517c19dfeb747ec042c2",
"assets/assets/radio-button.svg": "76599021691d28f8fc6686032e847f5f",
"assets/assets/scan.svg": "f15a7e006be0eedc2525108dc43adb8d",
"assets/assets/send-alt.svg": "24a41d0631d67db826d3707d3c71b392",
"assets/assets/shadow.png": "380fae2007cc4cc0e4f341cfded53575",
"assets/assets/share.svg": "e7b0bb75ebd1a7227306329aad7a9955",
"assets/assets/shield-tick.svg": "58951293fc363b41565a5aaa582b497b",
"assets/assets/sign-out.svg": "1d099eb6bfd897635c7a0e71e2194b3f",
"assets/assets/startime.png": "93af562626db9f341a3f673045200514",
"assets/assets/switch-diagonal.svg": "2488ea80aa926cab90f310dfadcce699",
"assets/assets/switch-horizontal.svg": "93fd0ee0f01a3c90ff81759804941cd3",
"assets/assets/tabler_wifi.svg": "7edab4e496044cded39d10e5a19187e3",
"assets/assets/tv.jpg": "2778974a89a18e030b58fd8d0b2ae157",
"assets/assets/tv.svg": "1ca4de5a26063dd7f5a9dd50ca873ec1",
"assets/assets/user.svg": "d7c5012f409c7765288d82bba52fa556",
"assets/assets/Visa.svg": "64d75a39f548428cc619c28ac39451da",
"assets/assets/wallet.svg": "f2ec083eddcdbc489e1da326d7eb2f7b",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/fonts/MaterialIcons-Regular.otf": "e7069dfd19b331be16bed984668fe080",
"assets/NOTICES": "9af7cb3dd0debb36bfe401f8609b772b",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "6d342eb68f170c97609e9da345464e5e",
"assets/packages/flutter_chat_ui/assets/2.0x/icon-arrow.png": "8efbd753127a917b4dc02bf856d32a47",
"assets/packages/flutter_chat_ui/assets/2.0x/icon-attachment.png": "9c8f255d58a0a4b634009e19d4f182fa",
"assets/packages/flutter_chat_ui/assets/2.0x/icon-delivered.png": "b6b5d85c3270a5cad19b74651d78c507",
"assets/packages/flutter_chat_ui/assets/2.0x/icon-document.png": "e61ec1c2da405db33bff22f774fb8307",
"assets/packages/flutter_chat_ui/assets/2.0x/icon-error.png": "5a59dc97f28a33691ff92d0a128c2b7f",
"assets/packages/flutter_chat_ui/assets/2.0x/icon-seen.png": "10c256cc3c194125f8fffa25de5d6b8a",
"assets/packages/flutter_chat_ui/assets/2.0x/icon-send.png": "2a7d5341fd021e6b75842f6dadb623dd",
"assets/packages/flutter_chat_ui/assets/3.0x/icon-arrow.png": "3ea423a6ae14f8f6cf1e4c39618d3e4b",
"assets/packages/flutter_chat_ui/assets/3.0x/icon-attachment.png": "fcf6bfd600820e85f90a846af94783f4",
"assets/packages/flutter_chat_ui/assets/3.0x/icon-delivered.png": "28f141c87a74838fc20082e9dea44436",
"assets/packages/flutter_chat_ui/assets/3.0x/icon-document.png": "4578cb3d3f316ef952cd2cf52f003df2",
"assets/packages/flutter_chat_ui/assets/3.0x/icon-error.png": "872d7d57b8fff12c1a416867d6c1bc02",
"assets/packages/flutter_chat_ui/assets/3.0x/icon-seen.png": "684348b596f7960e59e95cff5475b2f8",
"assets/packages/flutter_chat_ui/assets/3.0x/icon-send.png": "8e7e62d5bc4a0e37e3f953fb8af23d97",
"assets/packages/flutter_chat_ui/assets/icon-arrow.png": "678ebcc99d8f105210139b30755944d6",
"assets/packages/flutter_chat_ui/assets/icon-attachment.png": "17fc0472816ace725b2411c7e1450cdd",
"assets/packages/flutter_chat_ui/assets/icon-delivered.png": "b064b7cf3e436d196193258848eae910",
"assets/packages/flutter_chat_ui/assets/icon-document.png": "b4477562d9152716c062b6018805d10b",
"assets/packages/flutter_chat_ui/assets/icon-error.png": "4fceef32b6b0fd8782c5298ee463ea56",
"assets/packages/flutter_chat_ui/assets/icon-seen.png": "b9d597e29ff2802fd7e74c5086dfb106",
"assets/packages/flutter_chat_ui/assets/icon-send.png": "34e43bc8840ecb609e14d622569cda6a",
"assets/packages/flutter_inappwebview/assets/t_rex_runner/t-rex.css": "5a8d0222407e388155d7d1395a75d5b9",
"assets/packages/flutter_inappwebview/assets/t_rex_runner/t-rex.html": "16911fcc170c8af1c5457940bd0bf055",
"assets/packages/youtube_player_flutter/assets/speedometer.webp": "50448630e948b5b3998ae5a5d112622b",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "738255d00768497e86aa4ca510cce1e1",
"canvaskit/canvaskit.js.symbols": "74a84c23f5ada42fe063514c587968c6",
"canvaskit/canvaskit.wasm": "9251bb81ae8464c4df3b072f84aa969b",
"canvaskit/chromium/canvaskit.js": "901bb9e28fac643b7da75ecfd3339f3f",
"canvaskit/chromium/canvaskit.js.symbols": "ee7e331f7f5bbf5ec937737542112372",
"canvaskit/chromium/canvaskit.wasm": "399e2344480862e2dfa26f12fa5891d7",
"canvaskit/skwasm.js": "5d4f9263ec93efeb022bb14a3881d240",
"canvaskit/skwasm.js.symbols": "c3c05bd50bdf59da8626bbe446ce65a3",
"canvaskit/skwasm.wasm": "4051bfc27ba29bf420d17aa0c3a98bce",
"canvaskit/skwasm.worker.js": "bfb704a6c714a75da9ef320991e88b03",
"favicon.png": "e27bf091099bc4e9dac4642b37547db1",
"flutter.js": "383e55f7f3cce5be08fcf1f3881f585c",
"flutter_bootstrap.js": "9c325c1ff7da5d4275e836ab81bd45fd",
"icons/Icon-192.png": "59c747262f88aa2a1930a1d560307fd3",
"icons/Icon-512.png": "9f1d7b436292afd081fb37baa409c8e8",
"icons/Icon-maskable-192.png": "59c747262f88aa2a1930a1d560307fd3",
"icons/Icon-maskable-512.png": "9f1d7b436292afd081fb37baa409c8e8",
"index.html": "0874c2aa0fe53a004460ac8100980ae2",
"/": "0874c2aa0fe53a004460ac8100980ae2",
"main.dart.js": "64d34995152eaa821d287c3642bc19c1",
"manifest.json": "533ad42e6d9bf5ee08ab60c99909e414",
"version.json": "ed1e7119eec9e653d463931f5ee595f6"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
