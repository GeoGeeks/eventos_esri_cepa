# Informe comparativo — Código vs. Figma

> **Figma:** [Aplicación Eventos](https://www.figma.com/design/re1N5rv6AMTbhiH0OADIIV/Aplicaci%C3%B3n-Eventos?node-id=54686-28030) · página **`Pantallas Flujo completo`** (`54686:28030`)
> **Código:** rama `a-develop`, commit **`4fbd7a4`**
> **Fecha:** 2026-07-29 · **Revisión 3** (auditada + flujo de login implementado)
> Estado del código descrito en [`01-estado-actual.md`](./01-estado-actual.md).

---

## Registro de cambios de esta revisión

La revisión 1 contenía **cinco errores** que esta auditoría corrigió. Los dejo listados porque cambian decisiones:

| # | Revisión 1 decía | Corrección |
|---|---|---|
| **C1** | «`FiltroModal` solo tiene Modalidad: Virtual/Presencial» | **Falso.** `FiltroModal` sí implementa las 5 categorías de `Filtro Agenda`. Confundí dos filtros distintos que existen por separado en Figma y en el código. Ver §2.9. |
| **C2** | «Onboarding: las 4 páginas ✅ fieles» | **Falso.** La página 3 trata un tema **distinto** (código: "Agenda personalizada"; Figma: "Soporte y alertas") y 3 de 4 descripciones no coinciden. Ver §2.2. |
| **C3** | «`Credencial` es una pantalla no implementada» | **Impreciso.** Es un **modal sobre `Invitados`**, no una ruta. Sigue sin implementarse, pero la forma correcta de construirlo es otra. Ver §2.9. |
| **C4** | «Cluster "Gobierno": ¿variante de marca, rediseño o descarte?» (Q2 abierta) | **Resuelto.** Es un **módulo de administración/staff** con su propio login y su propio usuario. No es variante de marca ni rediseño. Ver §2.12. |
| **C5** | «"Iniciar Sesión / Correo" vs `soporte_screen.dart`» (Q4 abierta) | **Resuelto.** El panel de ese frame se titula literalmente **"Contactar a Soporte"**. El archivo es correcto. |

Y añadió **9 hallazgos nuevos**, el más grave: **`FiltroPanel` muestra texto de maqueta al usuario** (§2.9, F1).

---

## 1. Cómo se verificó cada cosa

El MCP de Figma sigue bloqueado (*"tool call limit for your View seat on the Organization plan"*), así que solo pude tomar **4 capturas de pantalla** antes del corte. Para el resto usé el **dump completo del árbol de nodos** que alcancé a descargar: 1.549 líneas con nombre, tipo, jerarquía, tamaño y estado de visibilidad de cada capa de las 40 pantallas.

| Nivel | Qué significa | Alcance |
|---|---|---|
| 🖼️ **Visual** | Comparé el render contra el código | **4** pantallas: Inicio, Eventos, Reservados, Pasados |
| 🌲 **Estructural** | Comparé el árbol de nodos contra el código: jerarquía, textos de capa, tamaños, capas ocultas | **30** pantallas |
| 📋 **Inventario** | Solo conozco el nodo por fuera; sus hijos no vienen expandidos en el dump | **6** pantallas |

Las 6 en 📋 son las que Figma guarda como **componentes** (`<symbol>`), cuyos hijos el dump no expande: `Inicio`, `Eventos`, `Invitados`, `Agenda`, `Post-Evento`, `Calificación paso 2`. De esas, **`Inicio` y `Eventos` sí están verificadas 🖼️** por captura, así que solo **4 quedan sin verificar**: `Invitados`, `Agenda`, `Post-Evento` y `Calificación paso 2`.

**Lo que el nivel 🌲 no puede detectar:** color, tipografía, espaciado fino y estados interactivos. Para eso hace falta el render. Está pedido como Fase 0 del [plan](./03-plan-de-trabajo.md).

**Cobertura de la auditoría: 36 de 40 pantallas (90 %).**

---

## 2. Inventario y comparación

La página tiene **40 pantallas/estados** y 15 componentes sueltos, repartidos en **tres productos distintos** — algo que la revisión 1 no había identificado:

| Producto | Pantallas | Usuario | Implementado |
|---|---|---|---|
| **A. App de asistente** (móvil) | 33 | María López, Ingeniera Civil | 32 con código, 14 fieles |
| **B. App de staff/admin** (móvil) | 4 | **Ricardo Pérez, Administrador** | **0** |
| **C. Panel admin** (escritorio 1440×1024) | 3 | Administrador | **0** |

### Cobertura real

| Métrica | Valor |
|---|---|
| Pantallas con algo de código | **32 / 40 = 80 %** |
| Pantallas **fieles** al diseño | **14 / 40 = 35 %** |
| App de asistente: con código | 32 / 33 = 97 % |
| App de asistente: fieles | **17 / 33 = 52 %** (antes 14) |
| App de asistente: **alcanzables navegando** | **33 / 33 = 100 %** (antes 30) |
| Staff/admin móvil | 0 / 4 = 0 % |
| Escritorio | 0 / 3 = 0 % |

> La revisión 1 reportaba «61 % de cobertura». Era engañoso: mezclaba "existe código" con "coincide con el diseño". **Casi todo el flujo de asistente tiene código; menos de la mitad coincide.**

---

### 2.1 Autenticación 🌲

| Figma | node-id | Código | Estado |
|---|---|---|---|
| Iniciar Sesión | `54686:29805` | `login_screen.dart` | ⚠️ |
| Iniciar Sesión / Verificacion | `54686:29836` | `verificacion_screen.dart` | ⚠️ |
| Iniciar Sesión / Correo → **"Contactar a Soporte"** | `54686:29988` | `soporte_screen.dart` | ⚠️ |

Estructura de Figma confirmada: fondo `background-inicio-sesionf`, `logo_app_bl`, texto "Eventos Esri", `logo_Esri_CO_blanco`, panel con `Input` de "Número de Identificación" (ícono `user`) y `Button`. `Verificacion` añade `instance: Notice 360x114` (banner) y un segundo botón. `Correo` es un panel "Contactar a Soporte" con 2 bloques colapsables y un `Text Area`.

> **Estado: flujo implementado** en la rama `fix/flujo-login` (commits `d15fc07`…`de56394`), verificado con 4 tests y en emulador Android. Ver detalle abajo.

- **A1 ✅ RESUELTO** El flujo estaba desconectado (la app arrancaba en Onboarding y nada navegaba a `LoginScreen`). Ahora `main.dart` arranca en `LoginScreen`.
- **A2 ❌ HALLAZGO ERRÓNEO — retirado.** La revisión 1 y 2 decían que `LoginScreen.ingresar() → OnboardingScreen` estaba «invertido». **Es falso:** el flujo correcto **es** login → Onboarding 1, confirmado por la usuaria y por la posición en el canvas. Ese código ya estaba bien; el único defecto real era A1.
- **A3 ✅ RESUELTO** `assets/images/login/` declarada en `pubspec.yaml` (defecto **D1**).
- **A6 ✅ RESUELTO** 🆕 **Los assets no eran SVG.** `background_inicio.svg` (814 KB) y `esri_blanco.svg` (340 KB) son un **PNG en base64 embebido** dentro de una cáscara SVG (`<image xlink:href="data:image/png;base64,…">`). `flutter_svg` ignora los elementos `<image>`, así que **no dibujaba nada** —fondo y logo salían en blanco— y aun así parseaba 1,15 MB de texto en el hilo principal (frames de 31 s, 4156 frames saltados en emulador). Se extrajo ese mismo base64 a PNG reales; los `.svg` se conservan en disco. `logo_app.svg` sí es vector y nunca falló.
  - `esri_blanco.png` mide **4096×674** para mostrarse a 158 px → se decodifica con `cacheWidth` para no reservar ~11 MB por pantalla.
  - **Deuda:** convendría pedir a diseño un SVG vectorial real para ambos.
- **A4 ✅ RESUELTO** Retirado el botón `"Simular error"` (marcado `/// BORRAR LUEGO`), reemplazado por la validación real.
- **A5 🟢** ~~Q4: ¿"Correo" es soporte?~~ **Resuelto:** sí. `soporte_screen.dart` es el archivo correcto.
- **S1 ✅ RESUELTO** 🆕 **El paso 3 era imposible de completar.** A 412×917 —tamaño del diseño y de un Pixel 7— el panel de Soporte desbordaba **117 px** y su botón "Enviar" quedaba en y=938, fuera de pantalla y sin forma de pulsarlo; Verificación desbordaba 24 px. Se corrigió en `FondoInicio`, que existía sin usarse mientras las tres pantallas duplicaban su contenido.
- **A7 🟡 PENDIENTE** La regla de validación es un **mock** (`login/data/login_mock_data.dart`, documentos `1234567890` y `0987654321`). Falta la regla o el endpoint real.

**Desviaciones visuales aún sin resolver** (necesitan el render de Figma o decisión de diseño):

| # | Figma | Código |
|---|---|---|
| A8 🟡 | Pantalla 2 titulada **"Iniciar sesión"** | dice **"Verificación"** |
| A9 🟡 | 2 botones en pantalla 2 (288×44 + 288×40) | 1 botón |
| A10 🟡 | `Notice 360×114` como banner | caja roja dentro del panel |
| A11 🟡 | ícono `user` del sistema de diseño | `Icons.person_outline` de Material (existe `assets/icons/perfil.svg` sin usar) |
| A12 🟢 | contenido interno de 288 px | panel de 360 con padding 24 → 312 |
| A13 🟡 | pantalla 3 con cabecera y botón de cerrar | sin botón de cerrar |
| A14 🟡 | «usted» | pantallas 2 y 3 tutean ("Verifica la información", "Completa… para ayudarte") — ver **T11** |

---

### 2.2 Onboarding 🌲 — ⚠️ corrección importante

| Figma | node-id | Estado |
|---|---|---|
| Onboarding 1 | `54830:6828` | ✅ |
| Onboarding 2 | `54830:7246` | ⚠️ descripción |
| Onboarding 3 | `54830:7259` | 🔴 **tema equivocado** |
| Onboarding 4 | `54877:3456` | ⚠️ descripción |

Comparación literal de `onboarding_data.dart` contra los nodos de texto de Figma:

| # | Título Figma | Título código | |
|---|---|---|---|
| 1 | Eventos Esri | Eventos Esri | ✅ |
| 2 | Credencial digital | Credencial digital | ✅ |
| 3 | **Soporte y alertas** | **Agenda personalizada** | 🔴 |
| 4 | Información del evento | Información del evento | ✅ |

| # | Descripción Figma | Descripción código | |
|---|---|---|---|
| 1 | "Consulte próximos eventos de Esri y acceda a toda la información desde un solo lugar." | idéntica | ✅ |
| 2 | "Acceda a su **e-card** y presente su credencial para ingresar a los eventos registrados." | "Acceda a su credencial digital para ingresar de manera rápida y segura a sus eventos." | ⚠️ |
| 3 | "**Reciba notificaciones en tiempo real** sobre cambios y novedades de sus eventos." | "Visualice horarios, sesiones y actividades programadas para cada evento." | 🔴 |
| 4 | "Consulte detalles del evento como agenda, ubicación y contenido relacionado." | "Encuentre ubicación, detalles importantes y contenido relacionado con cada evento." | ⚠️ |

- **O1 🔴** **La página 3 promete algo distinto.** Figma vende *notificaciones y soporte*; el código vende *agenda*. No es un matiz de redacción: es otra funcionalidad. Y como el tema "agenda" ya lo cubre la página 4 ("agenda, ubicación y contenido"), el onboarding actual **nunca menciona las notificaciones**, que son un tab completo de la app.
- **O2 🟡** 3 de 4 descripciones reescritas. Si el texto de Figma es el aprobado, hay que reponerlo.
- **O3 🟢** Literales `Color(0xFFF7F7F7)` / `Color(0xFF007AC2)` en vez de tokens.

✅ Coinciden: 4 dots, 2 botones por página, estructura `Título` (32 px + 40 px).

---

### 2.3 Inicio 🖼️

| Figma | node-id | Código | Estado |
|---|---|---|---|
| Inicio | `54695:4400` | `inicio.dart` | ✅ Fiel |

| Elemento | Figma | Código |
|---|---|---|
| Header azul con curva | "Bienvenida" / "María López" / "Ingeniera Civil - Procalculo" + campana con badge | ✅ |
| "Eventos reservados" | carrusel, **"Ver más" + "Mi credencial"** | ✅ `EventCard` |
| "Próximos eventos" + chip "Ver todos" | ✅ | ✅ |
| Cards de próximos | chip "Presencial", **"Ver más" + "Registrarse"** | ✅ `UpcomingEventCard` |
| Bottom nav | 5 tabs, "Reservas" central flotante | ✅ |

- **I1 🟡** **"Mi credencial" no hace nada** (`inicio.dart:119`, `onCredential: () {}`). El destino es el modal `Credencial` (`54805:9056`), no implementado.
- **I2 🟢** Mocks distintos: Figma "Planeta Esri Villavicencio" (Ago 20) + "Planeta Esri Bogotá" (Sept 10); código tiene Villavicencio + dos "Planeta Esri" de octubre.

---

### 2.4 Eventos 🖼️ / Ventana evento 🌲

| Figma | node-id | Código | Estado |
|---|---|---|---|
| Eventos | `54784:3813` | `eventos_screen.dart` | ⚠️ |
| Ventana evento | `54778:4874` | `detalle_evento_modal.dart` | ✅ **confirmado** |

`Ventana evento` **es un modal sobre `Eventos`** (contiene `instance: Eventos` + scrim `Rectangle 9` + `panel-container`): título "Planeta Esri Bogotá", filas `calendar` / `clock` / `pin-tear`, descripción larga y `footer` con botón. Corresponde a `DetalleEventoModal` — en la revisión 1 estaba como "probable", ahora confirmado.

- **E1 🟡** **Botón de retroceso de más.** Figma no lo muestra; el código añade un círculo azul con `chevron_left` (`eventos_screen.dart:67-82`).
- **E2 🟡** **Falta el bottom nav.** El árbol de Figma incluye `instance: menu 412x70` en `Eventos`, `Experiencias`, `Stands`, `Laboratorios`, `Favoritos`, `Post-Evento/*` y `Notificaciones`. El código las abre con `Navigator.push` sobre `Menu`, así que la barra desaparece. Ver **T3**.
- **E3 🟡** **Color del filtro sin confirmar.** El código usa `#091F44`; el render sugiere el azul de marca. Necesita `get_variable_defs` (bloqueado).
- **E4 🟡** **Mes abreviado.** Figma agrupa "Agosto / Septiembre / Octubre"; el código hace `e.fecha.split(' ').first` → "Oct". Con los 3 mocks en la misma fecha, sale un único grupo con 3 tarjetas iguales.
- **E5 🟢** Mocks distintos.

✅ Coinciden **exactos**: título, subtítulo *"Encuentre aquí toda la información sobre los eventos en los que se encuentra registrado."*, buscador "Buscar", filtro dividido con dropdown, cards con chip y dos botones.

---

### 2.5 Reservados 🖼️

| Figma | node-id | Código | Estado |
|---|---|---|---|
| Reservados | `54686:28097` | `reservas_screen.dart` | ⚠️ |

- **R1 🔴 Botón equivocado.** Figma pide **"Ver más" + "Mi credencial"**. El código reutiliza `UpcomingEventCard`, cuyo segundo botón dice **"Registrarse"** y tiene callback vacío (`:194`). En eventos *ya reservados*, "Registrarse" no tiene sentido.
- **R2 🟡** `_SplitFilterButton` se instancia sin callback → filtro decorativo. Figma lo muestra operativo (`instance: Frame 1403` = buscador + filtro).

✅ Coincide **exacto** el subtítulo: *"Encuentre la información sobre los eventos en los que se ha registrado."*

---

### 2.6 Pasados / Historial 🖼️

| Figma | node-id | Código | Estado |
|---|---|---|---|
| Pasados | `54737:18650` | `historial_screen.dart` | ✅ Fiel |

Coincide: título "Historial de Eventos", subtítulo **exacto** *"Encuentre la información sobre los eventos pasados en los que ha participado."*, buscador + filtro, 3 cards de 122 px, indicador **"Finalizado"** naranja con ícono, un solo botón "Ver más". Implementado con `UpcomingEventCard(isHistorial: true, estado: …)`.

- **H1 🟢** Mensaje de lista vacía: `"No hay eventos"` aquí vs `"No se encontraron eventos"` en Eventos y Reservados.

---

### 2.7 Notificaciones 🌲

| Figma | node-id | Código | Estado |
|---|---|---|---|
| Notificaciones | `54721:13147` | `notifications_screen.dart` | ⚠️ |
| Sin Notificaciones | `54910:12168` | `empty_notifications.dart` | ⚠️ |

Árbol de Figma:

```
Título → text "Notificaciones" + instance "gear" + instance "Chip"
text "Hoy"            → notificación ×2
text "Semana pasada"  → notificación ×4   (Frame 1449)
```

- **N1 🟡 Falta "Semana pasada".** El código pone las 5 notificaciones bajo "Hoy".
- **N2 🟡 Falta el ícono `gear`** junto al título (presente en ambos estados de Figma).
- **N3 🟡 Vacío sin ilustración.** Figma usa `tarjeta_no_notications 1` (249×317) e `image 6`; el código usa `Icons.notifications_none_outlined` gris de Material.
- **N4 🟡 Tuteo.** Figma: *"No tiene notificaciones"* / *"Cuando reciba una notificación, la verá aquí."* Código: *"No tienes notificaciones"* / *"Cuando recibas una notificación, la verás aquí."* Ver **T11**.
- **N5 🟡 El vacío pierde el encabezado.** En Figma el estado vacío **conserva** título + gear + Chip; `EmptyNotifications` es solo una columna centrada.
- **N6 🟢** Datos como `List<Map<String, dynamic>>` sin modelo — sin fecha real no hay dónde apoyar la agrupación de N1.

✅ Coinciden: título, chip "Borrar todo", ítems de 88 px con título/descripción/fecha/marca de nuevo. El componente `notificación` (`55149:10394`) tiene 3 variantes en Figma — `Notificación`, `Nueva`, `Eliminar` — y el código cubre las dos primeras vía `isNew`.

---

### 2.8 Perfil y e-card 🌲

| Figma | node-id | Código | Estado |
|---|---|---|---|
| Menú-perfil | `54686:28120` | `profile_menu_screen.dart` | ✅ Fiel |
| e-card | `54714:11921` | `e_card_screen.dart` | ⚠️ |
| e-card/config | `55490:6781` | `e_card_config_modal.dart` | ⚠️ |
| e-card/notificación | `55527:5291` | banner en `e_card_screen.dart:149+` | ✅ |

**Menú-perfil** — Figma pide 3 secciones × 3 ítems + botón + logo. El código entrega exactamente eso:

| Sección | Código |
|---|---|
| Perfil | Configuración, E-card, Notificaciones ✅ |
| Eventos | Reservas, Mis favoritos, Mis Encuestas ✅ |
| Soporte | Contáctanos, Chat por WhatsApp, Preguntas frecuentes ✅ |
| Button + logo | `LogoutButton` + "esri Colombia" ✅ |

*(Los `List Item` de Figma no llevan nombre propio, así que las 9 etiquetas no son verificables sin el render.)*

**e-card** — estructura correcta: `Título` (32+40), `Avatar` 74×74 con iniciales, "María López" / "Ingeniera Civil - Procalculo", `QR Code` 232×232 con logo embebido, `botones` "Compartir" / "Guardar", back + gear de 36×36.

- **P1 🔴 El QR no carga su logo.** `Images.logoqr` → `assets/images/post_evento/logo_qr.png`, **inexistente**; el archivo real está en `assets/images/profile/logo_qr.png` (defecto **D3**).
- **P2 🟡 "Compartir" y "Guardar" no hacen nada** (`:130`, `:136`), teniendo `share_plus` + `screenshot` + `path_provider` ya en `pubspec.yaml` para eso.
- **P3 🟡 Falta el `Input Time Zone`** que Figma pone arriba de la lista de toggles en `e-card/config` (`55490:7342`).
- **P4 🟢** El código añade un texto descriptivo *"Seleccione qué información desea mostrar…"* que en Figma está **oculto** (`Panel description [HIDDEN]`).
- **P5 🟢** Back/gear con `Color(0xFF1A2B4A)` hardcodeado, sin token.
- **P6 🟢** La e-card no participa del back-stack (flag `bool` en `Menu`, no ruta).

✅ Los 4 toggles del código (`cargo`, `empresa`, `correo`, `telefono`) cuadran con los 4 `List Item` con `Switch` de Figma, de los que 2 están sin renombrar y 2 dicen "Correo electrónico" y "Número de télefono".

---

### 2.9 Detalle de evento, filtros y credencial 🌲

| Figma | node-id | Código | Estado |
|---|---|---|---|
| Invitados | `54899:3629` | `invitados.dart` | ✅ 📋 |
| Experiencias | `54798:8571` | tab 1 de `invitados.dart` | ✅ |
| Stands | `54930:23578` | tab 2 de `invitados.dart` | ✅ |
| Laboratorios | `54930:23774` | tab 3 de `invitados.dart` | ✅ |
| Agenda | `54910:15460` | `agenda.dart` | ✅ 📋 |
| Favoritos | `54838:3737` | `favoritos.dart` | ✅ |
| **Filtro Agenda** | `54838:4951` | `core/widgets/filtro_modal.dart` | 🔴 **placeholder** |
| *filtro* (componente) | `54798:6383` | filtro inline en Eventos/Historial/Reservas | ✅ |
| Valoración Encuesta | `54897:4204` | `agenda/valoracion_modal.dart` | ⚠️ |
| **Credencial** | `54805:9056` | — | ❌ **no implementado** |
| Alert (guardado) | `54838:4637` | — | ❌ |

#### C1 — Corrección: hay **dos** filtros, y ambos están implementados

La revisión 1 decía que `FiltroModal` solo tenía "Modalidad: Virtual/Presencial". **Es falso.** Figma define dos filtros distintos y el código implementó los dos, cada uno en su lugar:

| Figma | Contenido | Código | Se usa en |
|---|---|---|---|
| `filtro` `54798:6383` (componente suelto) | **Modalidad** + 2 Combobox Items | bloque inline `if (_showFilter)` | Eventos, Historial, Reservas ✅ |
| `Filtro Agenda` `54838:4951` (modal sobre Agenda) | **5 grupos**: Lugar, Tipo de Actividad, Temática, Nivel, Producto + chips + 2 botones | `core/widgets/filtro_modal.dart` | Agenda, Favoritos ✅ |

`FiltroModal` reproduce bien la estructura: columna de 5 chips, panel derecho, botones "Limpiar filtros" / "Aplicar".

#### F1 🔴 — Hallazgo nuevo: el filtro muestra **texto de maqueta al usuario**

`core/widgets/filtro_panel.dart:41-69` genera **4 checkboxes fijos** con etiqueta literal **`"Combobox item 1"`, `"Combobox item 2"`, `"Combobox item 3"`, `"Combobox item 4"`** — el nombre del componente de Figma copiado tal cual —, todos con `value: false` y `onChanged: (_) {}`.

Consecuencia: el modal de filtro de Agenda y Favoritos **se ve correcto pero es completamente inerte**, y le muestra al usuario texto de diseño. Es el defecto más visible que la revisión 1 no detectó.

Figma sí define opciones reales: 4 en Lugar, 4 en Tipo de Actividad, **5** en Temática, 4 en Nivel, 4 en Producto (21 en total, no 20 uniformes).

- **F2 🟢** Etiqueta: Figma dice **"Tipo de Actividad"**, el código dice **"Actividad"**.

#### C3 — Corrección: `Credencial` es un **modal**, no una pantalla

```
Credencial 54805:9056
├── instance: Invitados          ← pantalla de fondo
├── vector: Rectangle 11         ← scrim
└── frame: filtro → Frame 1436 → Iniciar sesión
    ├── text: "Credencial digital"
    ├── text: "Utilice este código para acceder al evento"
    └── frame: qr → "María López" / "Ingeniera Civil - Procalculo"
        └── QR Code 253×260 + "Conferencia de Usuarios Esri 2026"
```

- **V1 🔴** No implementado. Es el destino de "Mi credencial" en Inicio y Reservados — hoy ambos botones son callejones sin salida. **Se construye como modal sobre `InvitadosScreen`, no como ruta nueva** (esto corrige el plan).
- **V2 🔴 Fuente inexistente.** `invitados.dart` (6 usos) e `info_card.dart` (4 usos) declaran `fontFamily: 'AvenirNext'`, familia **no declarada en `pubspec.yaml`** (las reales son `AvenirNextRegular`, `AvenirNextMedium`, …). Esos textos caen a la fuente del sistema → desviación tipográfica visible en toda la pantalla de detalle.
- **V3 🟡 Dos `Alert` distintos**, ninguno implementado:
  - `54838:4637` → ícono `star-f`, *"¡Ha guardado una actividad!"* + un `Link`
  - `54930:23310` → ícono `check-circle-f`, *"¡Gracias por tu opinión!"* + *"Se ha descargado su certificado."*
- **V4 🟢** `favoritos.dart` usa `10:00 · 11:00` (punto medio); Figma y `agenda.dart` usan `10:00 - 11:00`.

✅ Confirmado: los 4 tabs de `Invitados` tienen contenido real, no placeholders (`invitados.dart:104-145`). El `qr-code 40x40` del encabezado de Figma **sí está** implementado (`Icons.qr_code`, `invitados.dart:289`). Los 2 botones del header (`Frame 1425`) corresponden a `_BotonesAccion` ("Agenda" / "Mis Favoritos").

---

### 2.10 Post-evento y valoración 🌲

| Figma | node-id | Código | Estado |
|---|---|---|---|
| Post-Evento | `54930:23390` | `post_evento_screen.dart` | ✅ 📋 |
| Post-Evento/video | `54930:22690` | `_showVideo` | 🔴 **roto** |
| Post-Evento/agendar con expertos | `54930:22560` | `_ExpertosTab` | ✅ |
| Calificación paso 1 | `54789:5461` | `valoracion_paso1_screen.dart` | ⚠️ |
| Calificación paso 2 | `54805:9481` | `valoracion_paso2_screen.dart` | ⚠️ 📋 |
| Calificación / Exito | `54791:7074` | `valoracion_success_dialog.dart` | ✅ |

- **PE1 🔴 La vista de video está rota.** `post_evento_screen.dart:408` carga `Images.videoCover` → `assets/images/post_evento/video_cover.png`, **inexistente** (defecto **D2**). En Figma la imagen es `55227734391_c3251b3b2d_w 1` (360×240) con un botón `play-f` encima.
- **PE2 🟡** `galeria_6.png` existe en disco pero sin constante ni uso: la galería muestra 5 de 6.
- **PE3 🟡 Tuteo.** Figma: *"Queremos saber **su** opinión"*. Código: *"Queremos saber **tu** opinión"* en los **3** archivos de valoración. Ver **T11**.

✅ Confirmado: **4 expertos** en el código = **4 Cards** en Figma. `Calificación / Exito` es un **dialog sobre paso 2** (`instance: Calificación evento / paso 2` + scrim + `dialog 360x198`), que es exactamente cómo lo hace `ValoracionSuccessDialog`. El stepper de Figma tiene 6 barras con **2 visibles** → flujo de 2 pasos, coincide.

⚠️ El paso 1 de Figma lleva `Rating` + `Text Area` + `Input Time Zone` + `Text Area` + lista de 3 `List Item`; el código tiene 2 `TextField`, 3 dropdowns y 3 checkboxes. **Estructuralmente parecido pero no verificable campo por campo sin el render.**

---

### 2.11 Textos de las tres pantallas de detalle 🌲

Los encabezados de `Experiencias`, `Stands`, `Laboratorios` y `Post-Evento/*` comparten bloque, y el código lo reproduce **literal**:

| Figma | Código |
|---|---|
| "Octubre 02, 2026" | ✅ idéntico |
| "8:00 - 11:00" | ✅ idéntico |
| "Universidad Central Cra 36 # 24 - 45" | ✅ idéntico |
| "Es un evento presencial gratuito donde podrá conocer historias, soluciones e innovaciones en el campo de la tecnología y los SIG." | ✅ idéntico |
| "Información sujeta a cambios sin aviso.*" | ✅ idéntico |

Es la parte más fiel de todo el proyecto.

---

### 2.12 🆕 Producto B — App de staff/admin (móvil) 🌲

**Esto resuelve Q2.** El cluster de `x ≈ 7183–8500` que la revisión 1 no supo clasificar **no es** una variante de marca ni un rediseño: es un **módulo de administración de accesos** para personal del evento, con su propio login y su propio usuario.

| Figma | node-id | Qué es |
|---|---|---|
| Iniciar Sesión | `55979:5315` | Login **email + contraseña** + "¿Has olvidado la contraseña?" y el rótulo **"Administrador"** bajo "Eventos Esri" |
| Menú-perfil | `55980:5360` | "Bienvenido / **Ricardo Pérez**" + "Listas de asistentes" + 2 `AdminCard` |
| Laboratorios | `55982:10446` | Lista de inscritos: Carlos Méndez, Luis García, María Rodríguez, Pedro Sánchez, Sofía Castro — con "ArcGIS Pro", horario y Chip de estado |
| Gobierno | `55982:10576` | "Evento Gobierno" · *"Encuentre aquí las personas inscritas en el evento de gobierno."* — con Catastro / Planeación / Sostenibilidad |

Las dos `AdminCard` del menú describen la función con precisión:

> **Laboratorios** — *"Control de accesos, gestión de aforo e inscritos a las actividades prácticas y laboratorios de tecnología."*
> **Evento Gobierno** — *"Supervisión de acreditación para la cumbre pública, mesas de trabajo institucionales y plenarias gubernamentales."*

**Diferencias de fondo con la app de asistente:**

| | Asistente | Staff/admin |
|---|---|---|
| Login | Nº de Identificación | email + contraseña + recuperación |
| Usuario | María López, Ingeniera Civil | Ricardo Pérez, Administrador |
| Función | consultar y registrarse | controlar accesos y aforo |
| Bottom nav | sí, 5 tabs | **no** |

**Implicación:** es **funcionalidad nueva, no un reemplazo** — riesgo mucho menor de lo que asumí. Pero introduce **roles y autenticación real**, que el proyecto hoy no tiene (no hay sesión, ni usuario, ni permisos). No es "4 pantallas más": es un segundo perfil de aplicación.

**❓ Queda por decidir (Q2′):** ¿misma app con login que bifurca por rol, o app aparte? Es decisión de producto.

---

### 2.13 🆕 Producto C — Panel de escritorio 🌲

| Figma | node-id | Qué es |
|---|---|---|
| Login-admin | `56014:6468` | Login de escritorio (sin hijos en el dump) |
| Laboratorios | `56014:6161` | `Menu` + `Título` "Listas de asistentes" + `FAB` + `Button` + `Tabs 1328x686` |
| Gobierno | `56025:14463` | Estructura idéntica |
| *laboratorios* (componente) | `56021:8470` | tabla 1344×599 |
| *Frame 69* | `56025:11985` | botones de fila: **editar** (`edit`) y **borrar** (`trash`) |

**El escritorio es la misma función que el Producto B, en otro formato:** ambos se titulan "Listas de asistentes". Es decir, **B y C son el mismo módulo de administración**, responsive.

Los `Frame 69` con `edit` / `trash` implican **CRUD sobre asistentes**, no solo consulta.

- **T10 🟡** El proyecto tiene `web/` y `windows/` generados pero **cero layout responsive**: todo asume 412 px, con `SizedBox(width: 360)` hardcodeado en varias pantallas.

**❓ Q3 (refinada):** ya no es "¿qué es esto?" sino **"¿el módulo de administración se construye en este proyecto Flutter (móvil + escritorio) o como app web aparte?"**

---

### 2.14 Componentes sueltos

| Figma | node-id | Código |
|---|---|---|
| menu (5 variantes) | `54762:7078` | `bottom_nav.dart` ✅ |
| Card (Default / historial) | `55179:11094` | `UpcomingEventCard` ✅ |
| Card (Default / agendar / Variant2) | `54925:18419` | `InfoCard` / `_Experto` ✅ |
| Card 237×257 | `55179:9886` | `EventCard` ✅ |
| filtro (Modalidad) | `54798:6383` | filtro inline ✅ |
| tab-nav (primero/segundo/ultimo) | `54910:17205` | `AgendaTabSelector` / `_TabBar` ✅ |
| Horario (Default / **Desglozado**) | `54737:17448` | `AgendaItemCard` ⚠️ ¿tiene estado desglosado? |
| notificación (Notificación / Nueva / **Eliminar**) | `55149:10394` | `NotificationItem` ⚠️ falta variante Eliminar |
| laboratorios (2 variantes) | `55149:6078` | `InfoCard` ⚠️ |
| Alert ×2 | `54838:4637`, `54930:23310` | ❌ |
| Patron_1 / Patron_3 / image 4 | varios | decorativos |

- **W1 🟡** El componente `notificación` tiene variante **`Eliminar`** (`55149:10443`) que el código no implementa — probablemente el swipe-to-delete o el estado tras "Borrar todo".
- **W2 🟡** `Horario` tiene variante **`Desglozado`** de 617 px (vs 187 px la normal) → tarjeta expandible en Agenda. Hay que confirmar si `AgendaItemCard` lo soporta.

---

## 3. Código sin contraparte en esta página

Nada sobra. La app no inventó pantallas. `valoracion_modal.dart` corresponde a `Valoración Encuesta` (`54897:4204`) — confirmado por estructura: *"Queremos saber su opinión"* + *"Charla Educación y SIG"* + `Rating` + `Text Area` + botón.

---

## 4. Hallazgos transversales

| # | Hallazgo | Alcance | Sev. |
|---|---|---|---|
| **T1** | **Assets rotos o no declarados** — ~~`assets/images/login/` sin declarar~~ ✅ resuelto; `video_cover.png` y `logo_qr.png` inexistentes ⏳ pendientes | Post-Evento, e-card | 🔴 |
| **T16** | 🆕 **SVG que son PNG disfrazados.** Al menos 2 assets son `<image>` base64 en cáscara SVG y `flutter_svg` no los dibuja. **Revisar el resto de `.svg` del proyecto antes de darlos por buenos** — el mismo patrón puede estar en otras carpetas | `assets/images/login/` ✅ resuelto; resto sin auditar | 🔴 |
| **T17** | 🆕 **Paneles que desbordan a 412×917.** Encontrado y corregido en las 3 pantallas de login (Soporte 117 px, Verificación 24 px). **Ninguna otra pantalla se ha medido**: el `Column` + `Spacer` sin scroll es un patrón repetido en el proyecto | login ✅; resto sin medir | 🟡 |
| **T2** | **`fontFamily: 'AvenirNext'` no existe** — 10 usos caen a la fuente del sistema | `invitados.dart`, `info_card.dart` | 🔴 |
| **T11** | 🆕 **Tuteo vs. usted.** Figma usa **usted** de forma consistente. El código tutea en `EmptyNotifications` y en los **3** archivos de valoración | 4 archivos | 🟡 |
| **T12** | 🆕 **Placeholders de diseño visibles al usuario** — `"Combobox item 1..4"` en el filtro de Agenda/Favoritos | `filtro_panel.dart` | 🔴 |
| **T13** | 🆕 **Ilustraciones no exportadas** — el vacío de notificaciones usa un ícono de Material donde Figma tiene una ilustración | `empty_notifications.dart` | 🟡 |
| **T3** | **Pantallas internas pierden el bottom nav** — Figma incluye `instance: menu` en 7+ frames | Eventos, Invitados, Agenda, Favoritos, Post-Evento | 🟡 |
| **T4** | **"Mi credencial" es un callejón sin salida** — el modal `Credencial` no existe | Inicio, Reservados | 🔴 |
| **T14** | 🆕 **Variantes de componente sin implementar** — `notificación/Eliminar`, `Horario/Desglozado` | 2 componentes | 🟡 |
| **T5** | **Colores hardcodeados fuera de `AppColors`** — `#091F44` ×6, `#1A2B4A`, `#6B6B6B`, `#F7F7F7`, `#007AC2` | transversal | 🟡 |
| **T6** | **Sin escala tipográfica** — `text_styles.dart` vacío | transversal | 🟡 |
| **T7** | **Modelos de dominio duplicados** — `Evento`, `_ReservedEvent` ×2, `_UpcomingEvent`, `_Sesion` | transversal | 🟡 |
| **T15** | 🆕 **Sin sesión ni roles** — los Productos B y C exigen autenticación real y permisos; hoy no hay ni usuario | arquitectura | 🟡 |
| **T8** | **Mocks que no coinciden con Figma** | transversal | 🟢 |
| **T9** | **Textos inconsistentes** — "No hay eventos" vs "No se encontraron eventos"; `·` vs `-` | transversal | 🟢 |
| **T10** | **Cero soporte de escritorio** — anchos 360/412 hardcodeados | Producto C | 🟡 |

---

## 5. Distancia al objetivo

1. **Correcciones puntuales** — T1, T2, T12, T13, O1/O2, N1–N5, PE1, PE2, E4, F1, F2, T11. Defectos con arreglo acotado. **Horas.**
2. **Conectar lo que existe** — A1–A4, P2, P3, R1, R2, E2. Código construido pero desconectado. **Días.**
3. **Piezas nuevas del flujo de asistente** — modal `Credencial`, 2 `Alert`, variantes `notificación/Eliminar` y `Horario/Desglozado`. **Días.**
4. **Consolidación transversal** — T5–T7, T9. Toca código que hoy funciona → **aquí está el riesgo real de romper cosas. Semanas.**
5. **Producto B (staff/admin móvil)** — 4 pantallas + **sesión y roles** (T15). **Proyecto propio.**
6. **Producto C (escritorio)** — 3 pantallas + responsive + CRUD. **Proyecto propio.**

Con las Fases 1–3 el flujo de asistente queda **completo y fiel**. Los Productos B y C son alcance nuevo que hay que dimensionar aparte.

---

## 6. Preguntas abiertas

| # | Pregunta | Estado | Bloquea |
|---|---|---|---|
| ~~Q2~~ | ¿Qué es el cluster "Gobierno"? | ✅ **Resuelto** — módulo de staff/admin (§2.12) | — |
| ~~Q4~~ | ¿"Correo" = `soporte_screen.dart`? | ✅ **Resuelto** — el panel dice "Contactar a Soporte" | — |
| ~~Q1~~ | ¿El **login va antes del onboarding**? | ✅ **Resuelto** — sí: login → Onboarding 1. Implementado. | — |
| **Q2′** | El módulo admin: ¿**misma app con login que bifurca por rol**, o app separada? | abierta | Productos B y C |
| **Q3′** | El escritorio: ¿**este proyecto Flutter** (responsive) o **app web aparte**? | abierta | Producto C |
| **Q5** | ¿Se puede **liberar el límite del MCP de Figma**? Faltan color, tipografía y espaciado de 36 pantallas, y el interior de 4. | abierta | Verificación fina |
| **Q6** | 🆕 Los textos de **onboarding**: ¿manda Figma o manda el código? Afecta al tema de la página 3 (O1). | abierta | Fase 1 |
| **Q7** | 🆕 ¿Tratamiento **"usted"** en toda la app, como en Figma? | abierta | Fase 1 |

---

## 7. Qué sigue sin verificar

Para ser explícito sobre los límites de este informe:

| Qué | Por qué | Cómo se cierra |
|---|---|---|
| **Color, tipografía y espaciado** de las 36 pantallas | El árbol de nodos no lleva estilos | `get_design_context` / `get_variable_defs` |
| **Interior de 4 pantallas**: `Invitados`, `Agenda`, `Post-Evento`, `Calificación paso 2` | Son `<symbol>`; el dump no expande sus hijos | `get_metadata` por nodo |
| **Las 9 etiquetas del menú de perfil** | Los `List Item` de Figma no tienen nombre propio | render |
| **Campo por campo del paso 1 de valoración** | Estructura parecida, correspondencia incierta | render |
| **E3** — color del botón de filtro (`#091F44` vs azul de marca) | Necesita los tokens | `get_variable_defs` |
| **Login-admin** (`56014:6468`) | Sin hijos en el dump | `get_metadata` |
