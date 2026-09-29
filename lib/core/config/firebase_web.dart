import 'package:firebase_core/firebase_core.dart';

/// Configuración de la app Web del proyecto Firebase `eventos-esri-cepa`,
/// solo para la PWA (en Android/iOS Firebase se configura con los archivos
/// nativos). Estos valores no son secretos: la web los necesita en el
/// navegador. Deben coincidir con `web/firebase-messaging-sw.js`.
const FirebaseOptions opcionesFirebaseWeb = FirebaseOptions(
  apiKey: 'AIzaSyBj-C-rgVidirMWsOoMYeSSHMuZyvtSprs',
  authDomain: 'eventos-esri-cepa.firebaseapp.com',
  projectId: 'eventos-esri-cepa',
  storageBucket: 'eventos-esri-cepa.firebasestorage.app',
  messagingSenderId: '679067320386',
  appId: '1:679067320386:web:ce8727e0a1422bb3516ddb',
  measurementId: 'G-TJWC4YFBEK',
);

/// Clave pública VAPID (Firebase → Cloud Messaging → Certificados de push
/// web). Es pública por diseño: el navegador la usa para pedir el token de
/// push. Se puede reemplazar al compilar con `--dart-define=VAPID_KEY=...`.
const String clavePublicaVapid = String.fromEnvironment(
  'VAPID_KEY',
  defaultValue:
      'BJ_uu-hW5OdAcndgyQRl7WsNj4OQcqnpfdxhIHvrq2vPZ3N4OM3zanfV5zQPmQNgGAwGJJ-YNVXWCxyOamEmGTg',
);
