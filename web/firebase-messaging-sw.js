// Service worker de Firebase Cloud Messaging para la PWA: recibe las
// notificaciones cuando la PWA está cerrada o en segundo plano y las muestra.
// Al tocarlas, el navegador abre el link que manda la API (webpush.fcmOptions).
//
// Vive en su propio alcance (/firebase-cloud-messaging-push-scope), separado
// del service worker de Flutter (/), así que no afecta cómo carga la PWA.
// La versión del SDK coincide con la que usa FlutterFire en web
// (firebase_core_web → supportedFirebaseJsSdkVersion), y la configuración con
// lib/core/config/firebase_web.dart.
importScripts('https://www.gstatic.com/firebasejs/12.19.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/12.19.0/firebase-messaging-compat.js');

firebase.initializeApp({
  apiKey: 'AIzaSyBj-C-rgVidirMWsOoMYeSSHMuZyvtSprs',
  authDomain: 'eventos-esri-cepa.firebaseapp.com',
  projectId: 'eventos-esri-cepa',
  storageBucket: 'eventos-esri-cepa.firebasestorage.app',
  messagingSenderId: '679067320386',
  appId: '1:679067320386:web:ce8727e0a1422bb3516ddb',
  measurementId: 'G-TJWC4YFBEK',
});

// Con el bloque "notification" del mensaje, el SDK muestra la notificación
// solo; no hace falta onBackgroundMessage.
firebase.messaging();
