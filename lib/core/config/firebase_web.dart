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
/// web). Sin ella no se puede pedir el token de push en el navegador: vacía,
/// la PWA simplemente no ofrece activar notificaciones.
const String clavePublicaVapid = String.fromEnvironment(
  'VAPID_KEY',
  defaultValue: '',
);
