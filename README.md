# Eventos Esri Colombia

App móvil (Flutter) para asistentes externos a eventos de Esri Colombia:
registro, agenda, laboratorios/reservas, favoritos, credencial e-card/QR,
encuesta y certificado post-evento.

Ver `CLAUDE.md` en esta carpeta para arquitectura interna a fondo, y
`../CLAUDE.md` (raíz de `sistema-cue`) para el contexto del sistema completo
(relación con `eventosdb`, el backend `eventos_esri_cepa_api`, decisiones de
producto). Este README cubre solo lo operativo: cómo correr, testear y
compilar el proyecto.

## Plataformas soportadas

**Solo Android e iOS.** El checkout trae carpetas `web/`/`windows/`
generadas por `flutter create`, pero no son objetivo de este proyecto — no
se prueban ni se publican.

## Stack

- Flutter (SDK Dart `^3.11.5`, ver `pubspec.yaml`) — desarrollado con
  Flutter 3.44.2 / Dart 3.12.2.
- Estado: `flutter_bloc` (Bloc para flujos de eventos discretos, Cubit para
  llamadas async imperativas — ver "State management" en `CLAUDE.md`) +
  `setState` local + stores `ValueNotifier` hechas a mano para estado que
  sobrevive a la navegación (`FavoritosStore`, `ValoracionStore`).
- Red: `dio` contra `eventos_esri_cepa_api` (JWT propio, sin contraseña —
  ver "Auth" en `CLAUDE.md`), sesión persistida con `flutter_secure_storage`.
- UI: `google_fonts`/tipografía Avenir Next embebida, `flutter_svg`,
  `qr_flutter` (credencial), `webview_flutter` (formulario de registro/
  agendar con expertos, SPA externa embebida).

## Requisitos

- [Flutter SDK](https://docs.flutter.dev/get-started/install) 3.44.x o
  compatible con `sdk: ^3.11.5` (`pubspec.yaml`).
- Android Studio (SDK + emulador o dispositivo Android) y/o Xcode + un Mac
  (simulador o dispositivo iOS) — según qué plataforma se vaya a correr.
- Acceso a `eventos_esri_cepa_api` corriendo (local o el de producción,
  ver "Configuración por entorno" abajo) para probar cualquier pantalla
  que dependa del login real.

## Setup

```bash
git clone https://github.com/GeoGeeks/eventos_esri_cepa.git
cd eventos_esri_cepa
flutter pub get
```

## Configuración por entorno

`AppConfig.apiBaseUrl` (`lib/core/config/app_config.dart`) apunta por
defecto a producción (`https://appmovilapi.esri.co/api`). Para apuntar a
otro backend (por ejemplo uno local) sin tocar código, se pasa por
`--dart-define` al correr o compilar:

```bash
flutter run --dart-define=API_BASE_URL=http://localhost:3001/api
```

Documento de prueba acordado para probar el login real (registrado en
`eventosdb`): `1007694735` — ver `CLAUDE.md` de este repo y de
`eventos_esri_cepa_api`.

## Correr la app

```bash
flutter run -d android      # dispositivo/emulador Android conectado
flutter run -d ios          # simulador/dispositivo iOS (requiere macOS)
flutter devices             # listar dispositivos/emuladores disponibles
```

(`flutter run -d windows` / `-d chrome` funcionan porque las carpetas
existen, pero no son plataformas soportadas de este proyecto — usarlas solo
para inspección rápida de UI, nunca para validar un cambio como bueno.)

## Tests

```bash
flutter test                                        # suite completa
flutter test test/agenda_layout_test.dart            # un archivo puntual
flutter test --plain-name "el título arranca en"     # por nombre de test
```

La suite es grande y pixel-estricta contra Figma (ver "Pixel-fidelity to
Figma" en `CLAUDE.md`) — antes de escribir un test de layout nuevo, revisar
esa sección: hay que fijar el viewport a `Size(412, 917)` y cargar las
fuentes reales (`cargarFuentesReales`), o las aserciones de posición/tamaño
van a fallar aunque el código esté bien.

## Análisis estático

```bash
flutter analyze --no-pub
```

Baseline: **0 errores/warnings**, solo lints de nivel `info` (mayormente
`deprecated_member_use` en `withOpacity`, ver `CLAUDE.md`). Cualquier
warning o error nuevo antes de abrir PR es una regresión a corregir, no a
ignorar.

## Compilar (release)

Requiere la keystore de subida configurada — ver
`android/key.properties.example` (copiar a `android/key.properties`, fuera
del repo, con la keystore real `esri-cepa-eventos.jks`). Sin ella, el build
de release sigue firmando con la keystore de debug (no sirve para subir a
Play Store, pero no bloquea probar el flujo de build).

```bash
flutter build appbundle --release   # Play Store (artefacto correcto para subir)
flutter build apk --release         # APK suelto (instalación directa/QA)
flutter build ios --release         # requiere macOS + Xcode, ver firma/perfiles en Xcode
```

## Íconos y splash de marca

Se regeneran a partir de `assets/icon/icon.png` (1024×1024, sin
transparencia) cuando cambie el ícono o el splash:

```bash
dart run flutter_launcher_icons        # íconos de launcher (Android) / app (iOS)
dart run flutter_native_splash:create  # splash nativo (Android + iOS)
```

## Estructura del proyecto

```
lib/
  core/          # constantes (colores, fuentes, iconos, imágenes), widgets
                 # compartidos, config, utils (AreaSegura, etc.)
  features/      # un folder por feature (login, inicio, agenda, favoritos,
                 # credencial, post_evento, perfil, ...) - convención de
                 # subcarpetas (data/presentation/widgets) varía por
                 # feature a propósito, ver "Feature folder layout" en
                 # CLAUDE.md
  navigation/    # Menu (shell de tabs inferiores)
  main.dart      # entry point real (EsriEventosApp, arranque con chequeo
                 # de sesión) - lib/app.dart existe pero está vacío, no usar
test/            # specs de layout (pixel-estrictos), lógica, widgets
```

Arquitectura interna completa (por qué `main.dart` y no `app.dart`,
convención Bloc-vs-Cubit, el seam de `ValueNotifier` para estado que no es
del backend todavía, el WebView del formulario externo, etc.) — ver
`CLAUDE.md`.

## Convenciones

- Copy, comentarios de UI y nombres de dominio en **español**, registro
  formal "usted", siguiendo la nomenclatura de Figma/`eventosdb` (no
  traducir a inglés) — ver `CLAUDE.md`.
- Convenciones de código y Git (documentación de código, patrones, tests
  obligatorios, ramas, Conventional Commits) — skill de cuenta
  `estandares-codigo-git`, no repetidas aquí ni en `CLAUDE.md`.

## Estado y pendientes

Login/sesión ya está conectado al backend real
(`eventos_esri_cepa_api`); el resto de la app (favoritos, valoración,
credencial) sigue sobre datos mock. El checklist completo de qué falta
para una versión publicable (política de privacidad, notificaciones push,
CI, etc.) vive en `CLAUDE.md`, sección "Pendientes para una versión
realmente estable" — no se duplica aquí para no desincronizarse.
