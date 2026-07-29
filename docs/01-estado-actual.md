# Estado actual del proyecto — `esri_eventos`

> Rama `a-develop` · commit **`4fbd7a4`** · última actualización **2026-07-29**.
> Describe **lo que hay hoy en el código**, sin juicios sobre lo que debería haber.
> La comparación contra Figma vive en [`02-comparativo-figma.md`](./02-comparativo-figma.md).

> **Revisión 2** — recoge el trabajo de `feat(auth): connect login flow and fix broken
> login assets` (`4fbd7a4`), ya integrado en `a-develop`. Lo que cambió respecto de la
> revisión 1 está marcado con ✅ (resuelto) o 🆕 (hallazgo nuevo).

---

## 1. Identidad del proyecto

| Dato | Valor |
|---|---|
| Nombre del paquete | `esri_eventos` |
| Tipo | Aplicación **Flutter** (móvil) |
| SDK Dart | `^3.11.5` |
| Versión | `1.0.0+1` |
| Plataformas con carpeta generada | `android`, `ios`, `web`, `windows` |
| Repositorio | `GeoGeeks/...` — rama base `base-aplicacion` |
| Ramas activas | `base-aplicacion` (base), `develop`, `a-develop`, `d-develop` |
| Total de código Dart | **~8.900 líneas** en 63 archivos |
| `flutter analyze` | ✅ **0 errores**, 18 avisos `info` (línea base estable) |
| Tests | ✅ **4 tests** del flujo de login, todos en verde (`test/widget_test.dart`) |
| README | Plantilla por defecto de Flutter, sin personalizar |
| Verificado en dispositivo | Emulador Android `sdk gphone64 x86 64` |

### Dependencias

```yaml
flutter_bloc: ^9.1.1     # gestión de estado (usada solo en onboarding)
flutter_svg: ^2.2.0      # íconos SVG
google_fonts: ^8.1.0     # declarada, no usada (las fuentes son locales)
qr_flutter: ^4.1.0       # QR de la e-card
screenshot: ^3.0.0       # captura de la e-card
path_provider: ^2.1.5    # guardado temporal de la captura
share_plus: ^11.0.0      # compartir la e-card
cupertino_icons: ^1.0.8
```

---

## 2. Arquitectura y organización

El proyecto sigue una organización **feature-first**, pero **no de forma uniforme**: conviven dos convenciones.

```
lib/
├── main.dart                  # entry point; MaterialApp + MultiBlocProvider
├── app.dart                   # ⚠️ ARCHIVO VACÍO
├── navigation/
│   └── menu.dart              # shell con bottom nav (5 tabs)
├── core/
│   ├── constants/             # app_colors, fonts, icons, images
│   ├── theme/                 # ⚠️ app_theme.dart y text_styles.dart VACÍOS
│   └── widgets/               # 11 widgets compartidos
└── features/                  # 12 features
```

### Las dos convenciones que conviven

| Convención | Features que la usan |
|---|---|
| **Completa** — `feature/data/`, `feature/presentation/{screens,widgets,bloc}/` | `onboarding`, `notifications`, `profile`, `post_evento`, `historial` |
| **Plana** — un `.dart` suelto por pantalla dentro de `feature/` | `agenda`, `eventos`, `favoritos`, `inicio`, `invitados`, `reservas`, `login` |

Esto no rompe nada hoy, pero significa que no existe una regla única para saber dónde poner un archivo nuevo.

---

## 3. Punto de entrada y flujo de navegación

`main.dart` levanta `MaterialApp` con `home: LoginScreen()` ✅. **No hay rutas con nombre**: toda la navegación es `Navigator.push` con `MaterialPageRoute` inline.

### Grafo de navegación real

```
LoginScreen  (home) ✅
   ├── documento registrado    ──► OnboardingScreen   (pushReplacement)
   ├── documento no registrado ──► VerificacionScreen
   │        └── "Contactar a soporte" ──► SoporteScreen
   │                  └── "Enviar" ──► vuelve a LoginScreen (popUntil isFirst)
   └── campo vacío ─────────────► mensaje en línea, no navega

OnboardingScreen  (4 páginas con PageView)
   ├── "Continuar" en la última página ──► Menu
   └── "Omitir" ─────────────────────────► Menu

Menu  (shell con CustomBottomNav, 5 tabs)
   ├── 0  InicioApp
   │      ├── card reservada  ──► InvitadosScreen
   │      ├── "Ver todos"     ──► EventosScreen
   │      └── card próxima    ──► InvitadosScreen
   ├── 1  HistorialScreen
   │      ├── "Ver más"       ──► PostEventoScreen
   │      └── detalle         ──► DetalleEventoModal
   ├── 2  ReservasScreen      ──► InvitadosScreen
   ├── 3  NotificationsScreen
   └── 4  ProfileMenuScreen ⇄ ECardScreen   (toggle por flag `_showEcard`)
              └── ECardConfigModal

InvitadosScreen
   ├── "Agenda"       ──► AgendaScreen ──► FiltroModal / ValoracionModal
   └── "Mis Favoritos"──► FavoritosScreen ──► FiltroModal

EventosScreen ──► InvitadosScreen / DetalleEventoModal

PostEventoScreen ──► ValoracionPaso1Screen ──► ValoracionPaso2Screen ──► ValoracionSuccessDialog
```

### ✅ El flujo de login está conectado (antes huérfano)

En la revisión 1, `LoginScreen`, `VerificacionScreen` y `SoporteScreen` existían pero **ningún punto de la app navegaba hacia ellas**: la app arrancaba en `OnboardingScreen`. Resuelto en `4fbd7a4`:

- `main.dart` arranca en `LoginScreen`.
- Validación real en `ingresar()`: registrado → Onboarding, no registrado → Verificación, vacío → mensaje en línea (usa el `message-container` que Figma deja oculto, `54686:29827`).
- `SoporteScreen.enviarSolicitud()` hace `popUntil(isFirst)` para volver a la pantalla 1; antes hacía un `pop` simple y volvía a Verificación.
- Retirado el botón `"Simular error"` que estaba marcado `/// BORRAR LUEGO`.
- Las tres pantallas comparten ahora `FondoInicio`, que existía sin usarse mientras ellas duplicaban su contenido.

**Corrección de la revisión 1:** esa revisión afirmaba que `ingresar() → OnboardingScreen` estaba «invertido». **Era un hallazgo erróneo** — el flujo correcto sí es login → Onboarding 1. El único defecto real era que nadie llegaba al login.

⚠️ **La regla de validación es un mock** (`login/data/login_mock_data.dart`): solo los documentos `1234567890` y `0987654321` se consideran registrados. Pendiente de la regla o endpoint real.

### Otras observaciones de navegación

- El tab **Perfil** no usa `Navigator`: alterna entre `ProfileMenuScreen` y `ECardScreen` con un `bool _showEcard` en el estado de `Menu`. Funciona, pero la e-card no participa del back-stack del sistema.
- `AgendaScreen`, `FavoritosScreen`, `InvitadosScreen`, `PostEventoScreen` se abren con `Navigator.push` **por encima** del `Menu`, así que pierden la barra inferior mientras están abiertas.

---

## 4. Sistema de diseño

### Color — `lib/core/constants/app_colors.dart`

34 líneas, 17 constantes. Agrupadas por comentarios de uso (`// hover`, `// Valoración`, `// Filtro`).

| Token | Hex | Uso |
|---|---|---|
| `primary` | `#007AC2` | azul de marca, barra inferior, botones |
| `white` / `background` / `cardBg` | `#FFFFFF` / `#F7F7F7` / `#FFFFFF` | superficies |
| `textTitle` / `textSubtle` | `#141414` / `#949494` | tipografía |
| `notification` | `#E64B3C` | badge de alertas |
| `chipBg` | `#D6EFFF` | chips |
| `navActiveHighlight` | `#00619B4D` | tab activo |
| `navActiveReservas` | `#053D72` | botón central activo |
| `modalOverlay` / `modalSubtitle` | `#000000CC` / `#4A4A4A` | modales |
| `requiredField` | `#D83020` | validación |
| `inputBorder` / `lightGray` | `#CFCFCF` / `#EBEBEB` | bordes |
| `filterButtonText` | `#00619B` | filtros |
| `success` | `#288835` | confirmaciones |

**Consistencia:** buena en general, pero hay colores literales `Color(0xFF...)` incrustados en pantallas en lugar de usar el token (p. ej. `onboarding_screen.dart:66` usa `Color(0xFFF7F7F7)` en vez de `AppColors.background`, y `:130` usa `Color(0xFF007AC2)` en vez de `AppColors.primary`).

### Tipografía — `lib/core/constants/fonts.dart`

Familia **Avenir Next LT Pro**, 7 pesos declarados en `pubspec.yaml` y expuestos como constantes de string (`Fonts.regular`, `Fonts.bold`, `Fonts.demi`, …). El tema global fija `fontFamily: Fonts.regular`.

⚠️ **No hay escala tipográfica.** `Fonts` solo tiene una constante de tamaño (`body = 16`) que casi no se usa; los `fontSize`, `height` y `letterSpacing` se escriben a mano en cada widget. `core/theme/text_styles.dart` existe pero **está vacío** — el archivo donde debería vivir esa escala nunca se llenó.

### Tema — `lib/core/theme/app_theme.dart`

**Vacío.** El `ThemeData` se construye inline en `main.dart` con solo dos propiedades (`useMaterial3: true`, `fontFamily`). No hay `ColorScheme`, ni `TextTheme`, ni estilos de componente centralizados.

### Íconos e imágenes

- `SvgIcon` (`core/constants/icons.dart`): 22 rutas a `assets/icons/*.svg`.
- `Images` (`core/constants/images.dart`): 24 rutas a PNG/SVG.
- `AppIcon` (`core/widgets/app_icons.dart`): wrapper de `SvgPicture` con `width`/`height`/`color`.

---

## 5. Inventario de widgets compartidos (`lib/core/widgets/`)

| Widget | Líneas | Qué hace |
|---|---|---|
| `EventCard` | 287 | tarjeta de evento reservado (carrusel de Inicio) |
| `UpcomingEventCard` | 379 | tarjeta de evento próximo, con chip de modalidad |
| `AgendaItemCard` | 109 | ítem de sesión en agenda |
| `AgendaTabSelector` | 51 | selector de pestañas de agenda |
| `BottomNav` (`CustomBottomNav`) | 260 | barra inferior de 5 tabs con botón central flotante "Reservas" |
| `InfoCard` | 130 | tarjeta informativa genérica |
| `ButtonCards` (`AppButton`) | 78 | botón reutilizable |
| `FiltroChip` | 51 | chip de filtro |
| `FiltroModal` | 184 | modal de filtro (modalidad) |
| `FiltroPanel` | 73 | panel de filtro |
| `AppIcon` | 64 | wrapper de SVG |

**Duplicación detectada:** `EventCard` y `UpcomingEventCard` definen cada uno sus propias clases privadas `_InfoRow`, `_OutlineButton` y `_PrimaryButton` — código repetido entre los dos archivos (666 líneas combinadas). Además, la clase `_SplitFilterButton` está **triplicada** de forma idéntica en `eventos_screen.dart`, `historial_screen.dart` y `reservas_screen.dart`.

---

## 6. Inventario de pantallas implementadas

| # | Pantalla | Archivo | Líneas | Alcanzable desde la app |
|---|---|---|---|---|
| 1 | Onboarding (4 páginas) | `features/onboarding/.../onboarding_screen.dart` | 147 | ✅ home |
| 2 | Inicio | `features/inicio/inicio.dart` | 393 | ✅ tab 0 |
| 3 | Historial de Eventos | `features/historial/.../historial_screen.dart` | 302 | ✅ tab 1 |
| 4 | Eventos Reservados | `features/reservas/reservas_screen.dart` | 267 | ✅ tab 2 |
| 5 | Notificaciones | `features/notifications/.../notifications_screen.dart` | 260 | ✅ tab 3 |
| 6 | Menú de perfil | `features/profile/.../profile_menu_screen.dart` | 185 | ✅ tab 4 |
| 7 | E-card | `features/profile/.../e_card_screen.dart` | 215 | ✅ tab 4 → toggle |
| 8 | Eventos (listado) | `features/eventos/eventos_screen.dart` | 356 | ✅ Inicio → "Ver todos" |
| 9 | Invitados / detalle de evento | `features/invitados/invitados.dart` | 584 | ✅ desde cards |
| 10 | Agenda | `features/agenda/agenda.dart` | 303 | ✅ Invitados → Agenda |
| 11 | Favoritos del evento | `features/favoritos/favoritos.dart` | 287 | ✅ Invitados → Favoritos |
| 12 | Post-Evento | `features/post_evento/.../post_evento_screen.dart` | 552 | ✅ Historial → "Ver más" |
| 13 | Valoración paso 1 | `features/post_evento/.../valoracion_paso1_screen.dart` | 398 | ✅ Post-Evento |
| 14 | Valoración paso 2 | `features/post_evento/.../valoracion_paso2_screen.dart` | 301 | ✅ paso 1 |
| 15 | Iniciar sesión | `features/login/login_screen.dart` | 185 | ✅ **home** |
| 16 | Verificación | `features/login/verificacion_screen.dart` | 172 | ✅ desde login |
| 17 | Soporte | `features/login/soporte_screen.dart` | 170 | ✅ desde verificación |

**Modales y diálogos:** `DetalleEventoModal`, `FiltroModal`, `ValoracionModal`, `ECardConfigModal`, `ValoracionSuccessDialog`, `EmptyNotifications`, `ErrorBanner`.

**Total: 17 pantallas + 7 modales. Las 17 son alcanzables** navegando desde el arranque (antes eran 14).

**Archivo nuevo:** `features/login/data/login_mock_data.dart` — mock de documentos registrados.
**Widget que pasó a usarse:** `features/login/widgets/fondo_inicio.dart`, ahora contenedor real de las 3 pantallas de login. Siguen sin usarse `error_banner.dart` y `login_input.dart`.

---

## 7. Gestión de estado

Hay **tres mecanismos distintos** conviviendo:

1. **BLoC** (`flutter_bloc`) — usado en **una sola feature**: `onboarding` (`OnboardingBloc` / `OnboardingPageChanged` / `OnboardingState`). El bloc solo rastrea el índice de la página actual.
2. **`setState` local** — el mecanismo dominante: 71 ocurrencias en 21 archivos. Cada pantalla gestiona sus filtros, pestañas y selecciones en su propio `State`.
3. **Flag en el widget padre** — `Menu._showEcard` para la sub-vista de perfil.

**No hay estado compartido entre pantallas.** No existe sesión de usuario, ni carrito de reservas persistente, ni caché. Si el usuario marca un favorito en `FavoritosScreen` y vuelve atrás, el cambio se pierde.

---

## 8. Datos

**Todo es mock hardcodeado. No hay capa de red, ni API client, ni modelos serializables, ni persistencia.**

| Archivo | Contenido |
|---|---|
| `features/historial/data/eventos_data.dart` | clase `Evento` + `eventosMock` (3 ítems idénticos: "Planeta Esri") |
| `features/onboarding/data/onboarding_data.dart` | `onboardingItems` (4 páginas) |
| `features/profile/data/ecard_mock_data.dart` | `EcardMockData` (7 líneas) |
| `features/profile/data/ecard_visibility_config.dart` | `ECardVisibilityConfig` (toggles de visibilidad) |

Además hay **datos hardcodeados directamente dentro de las pantallas**, no en `data/`:

- `inicio.dart`: `_reservedEvents` (2 ítems "CUE 2026") y `_upcomingEvents` (3 ítems "Planeta Esri"), con clases privadas `_ReservedEvent` / `_UpcomingEvent`.
- `reservas_screen.dart`: su propia clase privada `_ReservedEvent` — **duplicada** respecto de la de `inicio.dart`.
- `invitados.dart`: clase `_Sesion` y listas de sesiones inline.
- `agenda.dart`, `favoritos.dart`, `post_evento_screen.dart`: listas inline.

**Consecuencia:** los mismos conceptos de dominio (evento, sesión) están modelados 3–4 veces con formas distintas y sin un tipo común.

---

## 9. Defectos y deuda detectados

### 🔴 Bloqueantes en tiempo de ejecución

| # | Problema | Ubicación | Efecto |
|---|---|---|---|
| ~~D1~~ | ✅ **RESUELTO** en `4fbd7a4` — `assets/images/login/` declarada en `pubspec.yaml` | `pubspec.yaml` | — |
| D2 | `Images.videoCover` → `assets/images/post_evento/video_cover.png` **no existe** | `images.dart`, usado en `post_evento_screen.dart:408` | Error de asset al abrir la pestaña de video del Post-Evento. **Sigue abierto.** |
| D3 | `Images.logoqr` → `assets/images/post_evento/logo_qr.png` **no existe** (el archivo real está en `assets/images/profile/logo_qr.png`) | `images.dart`, usado en `e_card_widget.dart:119` | El logo embebido del QR de la e-card falla. **Sigue abierto.** |
| **D19** | 🆕 ✅ **RESUELTO** — **SVG que en realidad son PNG.** `background_inicio.svg` (814 KB) y `esri_blanco.svg` (340 KB) contenían `<image xlink:href="data:image/png;base64,…">`. `flutter_svg` ignora los `<image>`, así que **no dibujaban nada** y aun así parseaban 1,15 MB en el hilo principal → frames de 31 s y 4156 frames saltados en emulador. Se extrajeron a PNG reales (`background_inicio.png` 412×917, `esri_blanco.png` 4096×674); los `.svg` se conservan. `logo_app.svg` sí es vector. | `assets/images/login/`, `images.dart`, `fondo_inicio.dart` | ⚠️ **El resto de los `.svg` del proyecto no está auditado** — el patrón puede repetirse en silencio. |
| **D20** | 🆕 ✅ **RESUELTO** — **Paneles que desbordan a 412×917.** Soporte desbordaba 117 px y su botón "Enviar" quedaba en y=938, fuera de pantalla y **sin forma de pulsarlo**; Verificación desbordaba 24 px. Corregido en `FondoInicio` con cabecera y pie fijos más área desplazable. | `fondo_inicio.dart` | ⚠️ **Ninguna otra pantalla se ha medido**: el patrón `Column` + `Spacer` sin scroll está repetido en el proyecto. |
| **D21** | 🆕 **Assets sobredimensionados.** `esri_blanco.png` mide 4096×674 para mostrarse a 158 px (26× más grande). Mitigado con `cacheWidth`, pero convendría reexportar. | `assets/images/login/` | ~11 MB de mapa de bits por pantalla sin `cacheWidth`. |

### 🟡 Referencias muertas y huecos

| # | Problema |
|---|---|
| D4 | `Images.iconHeader` → `assets/images/inicio/icon_header.png` no existe; la constante tampoco se usa. |
| D5 | `assets/images/post_evento/galeria_6.png` existe en disco pero no tiene constante ni uso. |
| D6 | `assets/icons/contactenos.svg` existe en disco pero no se referencia desde el código. |
| D7 | Tres archivos **vacíos**: `lib/app.dart`, `lib/core/theme/app_theme.dart`, `lib/core/theme/text_styles.dart`. |
| ~~D8~~ | ✅ **RESUELTO** — flujo de login conectado. La parte de «`pushReplacement` invertido» era un **hallazgo erróneo** y queda retirada. |
| ~~D9~~ | ✅ **RESUELTO** — retirado el botón `"Simular error"`. |
| D10 | `google_fonts` declarada en `pubspec.yaml` pero nunca importada. |
| **D22** | 🆕 `assets/icons/perfil.svg` existe sin usar y podría ser el ícono `user` que Figma pone en el campo de identificación; hoy se usa `Icons.person_outline` de Material. |

### 🟢 Calidad de código (18 avisos de `flutter analyze`)

- 8 × `withOpacity` deprecado → migrar a `withValues()`.
- 5 × `unnecessary_underscores`.
- 2 × `DropdownButtonFormField.value` deprecado → `initialValue`.
- 1 × `Switch.activeColor` deprecado → `activeThumbColor`.
- 1 × `use_null_aware_elements`.
- 1 × `hs_err_pid21188.log` (crash dump de la JVM) versionado en `android/`.

### 🔵 Deuda estructural

| # | Problema |
|---|---|
| D11 | `_SplitFilterButton` triplicado (eventos / historial / reservas). |
| D12 | `_InfoRow`, `_OutlineButton`, `_PrimaryButton` duplicados entre `EventCard` y `UpcomingEventCard`. |
| D13 | `_ReservedEvent` duplicado entre `inicio.dart` y `reservas_screen.dart`. |
| D14 | Sin rutas con nombre — navegación acoplada con `MaterialPageRoute` inline. |
| D15 | Dos convenciones de carpetas conviviendo (plana vs. `presentation/data`). |
| D16 | Sin escala tipográfica centralizada; `fontSize`/`height` escritos a mano en cada widget. |
| D17 | Un único smoke test; sin tests de widget por pantalla. |
| D18 | README sin personalizar. |

---

## 10. Resumen ejecutivo

El proyecto es un **prototipo de UI de alta fidelidad**, no una aplicación funcional:

- ✅ **17 pantallas** construidas con cuidado visual, la mayoría fieles a un diseño de referencia (los commits citan explícitamente "to match Figma design"). **Todas alcanzables** desde el arranque.
- ✅ Sistema de color y tipografía definido y mayormente respetado; compila limpio.
- ✅ El **flujo de autenticación está conectado y verificado** con 4 tests y en emulador.
- ⚠️ **Cero backend**: todos los datos son mocks hardcodeados, muchos duplicados dentro de las pantallas. La validación del login también es un mock.
- ⚠️ **Cero estado compartido**: nada persiste al navegar. No hay sesión de usuario.
- ⚠️ Tres capas de infraestructura previstas pero **vacías**: `app.dart`, `app_theme.dart`, `text_styles.dart`.

### Lección de la primera intervención

Los dos defectos más graves del flujo de login **no se veían leyendo el código**: un asset que parecía SVG y era un PNG que el renderizador ignora en silencio, y un botón fuera de pantalla a la altura real del dispositivo. Ambos aparecieron solo al **ejecutar la app y correr tests con el lienzo fijado a 412×917**.

Conclusión práctica para las fases siguientes: **medir cada pantalla a 412×917 y verificar que cada asset se dibuje**, no dar por bueno lo que compila. Ver **D19**, **D20** y los hallazgos **T16**/**T17** de [`02-comparativo-figma.md`](./02-comparativo-figma.md): ambos patrones pueden estar repetidos en el resto del proyecto sin haberse detectado.

### Siguiente paso natural

Cerrar **D2** y **D3** (los dos assets inexistentes que quedan), auditar el resto de los `.svg` buscando el patrón de **D19**, y unificar el modelo de datos antes de agregar pantallas nuevas.
