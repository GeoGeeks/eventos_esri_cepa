# Plan de trabajo — `esri_eventos`

> Punto de partida: [`01-estado-actual.md`](./01-estado-actual.md)
> Objetivo: [`02-comparativo-figma.md`](./02-comparativo-figma.md)
> Rama actual: `a-develop` · commit **`4fbd7a4`** · árbol limpio

## Progreso

| Fase | Estado |
|---|---|
| 0 — Desbloqueos | ⏳ MCP de Figma sigue limitado; Q1, Q2 y Q4 resueltas |
| 1 — Defectos bloqueantes | 🟡 **1.1 hecha** (+ D19, D20, D21 descubiertos y resueltos); 1.2–1.9 pendientes |
| 2 — Cablear lo que existe | 🟡 **login completo** (2.1–2.3); 2.4–2.7 pendientes |
| 3 — Modal `Credencial` | ⬜ pendiente |
| 4 — Fidelidad visual | ⬜ pendiente (A8–A14 del login ya identificadas) |
| 5 — Consolidación | ⬜ pendiente |
| 6 / 7 — Productos B y C | ⛔ bloqueadas por Q2′ y Q3′ |

**Entregado:** `feat(auth): connect login flow and fix broken login assets` (`4fbd7a4`) —
flujo de login conectado, 4 assets corregidos, botón inalcanzable arreglado, 4 tests nuevos.

---

## 0. Reglas de trabajo — cómo NO romper nada

Estas reglas aplican a **todas** las fases. Son el contrato entre nosotros.

### 0.1 Lo que no hago sin preguntarte

| Regla | Detalle |
|---|---|
| **No borro código** | Si algo parece muerto o duplicado, lo reporto y espero. `git rm`, borrar archivos o eliminar clases enteras **siempre** requiere tu OK explícito. |
| **No hago commit ni push** | Preparo los cambios, te muestro el diff, y **tú** decides cuándo se commitea. Si me lo pides, commiteo — pero no por iniciativa propia. |
| **No toco `base-aplicacion` ni `develop`** | Trabajo en ramas de fase. Los merges a las ramas compartidas los haces tú o me los pides explícitamente. |
| **No abro PRs** | Salvo que me lo pidas. |
| **No renombro ni muevo archivos masivamente** | Un rename rompe imports en cadena. Lo propongo antes. |
| **No refactorizo "de paso"** | Si estoy arreglando el asset del QR, arreglo el asset del QR. Lo demás que vea lo anoto, no lo toco. |
| **No cambio decisiones de producto** | El orden login/onboarding, el cluster "Gobierno", el escritorio: son tuyas. Ver §4. |

### 0.2 Lo que sí hago en cada fase

1. Creo la rama de fase desde `a-develop`.
2. Hago los cambios **acotados al alcance de la fase**, nada más.
3. Corro `flutter analyze` — no dejo errores nuevos.
4. Te muestro un **resumen del diff** y qué verificar a mano.
5. **Paro y espero tu aprobación** antes de pasar a la siguiente fase.

### 0.3 Red de seguridad

- **Árbol limpio antes de empezar cada fase.** Si hay cambios sin commitear, paro y te aviso.
- **Una rama por fase** → si algo sale mal, `git checkout a-develop` y no pasó nada.
- **Commits atómicos** con mensaje descriptivo — cada uno revertible por separado.
- **Antes de sobrescribir cualquier archivo, lo leo primero.**
- Si a mitad de una fase descubro que el alcance era más grande de lo estimado, **paro y te lo digo** en vez de seguir tirando.

### 0.4 Cómo leer las prioridades

🔴 rompe algo en ejecución · 🟡 desvía del diseño o del flujo · 🟢 cosmético o de calidad interna

---

## Fase 0 — Desbloqueos (antes de escribir código)

**No es trabajo de código. Son cosas que necesito de ti.**

| # | Qué | Por qué |
|---|---|---|
| 0.1 | **Liberar el límite del MCP de Figma** (upgrade de asiento) o exportarme los frames como PNG | Falta color, tipografía y espaciado de 36 pantallas, y el interior de 4 (`Invitados`, `Agenda`, `Post-Evento`, `Calificación paso 2`) |
| 0.2 | **Responder Q1, Q6, Q7** del comparativo (§6) | Definen qué texto y qué tratamiento va en la Fase 1 |
| 0.3 | **Responder Q2′ y Q3′** | Dimensionan los Productos B y C (staff/admin y escritorio) |
| 0.4 | Confirmar que trabajo sobre **`a-develop`** | Es la rama actual, pero quiero confirmarlo |

**Sin 0.1 puedo avanzar igual las Fases 1 y 2** (son defectos y cableado, no diseño nuevo). A partir de la Fase 4 sí lo necesito.

> **Q2 y Q4 ya están resueltas** por la auditoría del comparativo (revisión 2): el cluster "Gobierno" es un módulo de staff/admin, y `soporte_screen.dart` es el archivo correcto para el frame "Correo".

---

## Fase 1 — Defectos bloqueantes 🔴

**Rama:** `fix/assets-y-fuentes` · **Riesgo: muy bajo** — solo arregla cosas rotas, no cambia comportamiento correcto.

> **Estado:** 1.1 ✅ hecha en la rama `fix/flujo-login`. El resto sigue pendiente.

| # | Cambio | Archivo | Ref. |
|---|---|---|---|
| ~~1.1~~ | ✅ **HECHA** — declarada `assets/images/login/`; además se descubrió que 2 de esos «SVG» eran PNG en base64 que `flutter_svg` no dibuja, y se extrajeron a PNG reales | `pubspec.yaml`, `images.dart` | D1 / A3 / A6 / T16 |
| 1.2 | Corregir `Images.logoqr` → `assets/images/profile/logo_qr.png` | `images.dart:61` | D3 / P1 |
| 1.3 | Resolver `Images.videoCover`: el archivo `video_cover.png` no existe → **te pregunto si lo exportas de Figma o si uso un placeholder** | `images.dart:58` | D2 / PE1 |
| 1.4 | Reemplazar `fontFamily: 'AvenirNext'` por la familia real (10 usos) | `invitados.dart` ×6, `info_card.dart` ×4 | T2 / V2 |
| 1.5 | Añadir `Images.galeria6` y usarla en la galería | `images.dart`, `post_evento_screen.dart` | PE2 |
| 1.6 | 🆕 **Quitar los placeholders `"Combobox item 1..4"`** del filtro y poner las opciones reales de Figma (Lugar 4, Tipo de Actividad 4, Temática 5, Nivel 4, Producto 4) | `filtro_panel.dart:41-69` | **F1 / T12** |
| 1.7 | 🆕 Corregir el **tema de la página 3 del onboarding** ("Agenda personalizada" → "Soporte y alertas") y las 3 descripciones | `onboarding_data.dart` | **O1 / O2** |
| 1.8 | 🆕 Pasar a **"usted"** los textos que tutean | `empty_notifications.dart`, 3 archivos de valoración | **T11** |
| 1.9 | 🆕 Renombrar `"Actividad"` → `"Tipo de Actividad"` | `filtro_modal.dart:18` | F2 |
| **1.10** | 🆕 **Auditar todos los `.svg` del proyecto** buscando `<image …base64…>`: `flutter_svg` no los dibuja y no avisa. Ya confirmado en 2 de los 3 de `login/` | `assets/**/*.svg` | **D19 / T16** |
| **1.11** | 🆕 **Medir cada pantalla a 412×917** buscando desbordes. El patrón `Column` + `Spacer` sin scroll está repetido; en login dejó un botón inalcanzable | todas | **D20 / T17** |

**Criterio de aceptación:**
- `flutter analyze` sin errores nuevos.
- Las 3 pantallas de login renderizan sus SVG (verificable forzando la ruta temporalmente).
- El QR de la e-card muestra el logo embebido.
- La pestaña de video del Post-Evento abre sin excepción.
- Los textos de Invitados e InfoCard usan Avenir, no la fuente del sistema.
- **El filtro de Agenda/Favoritos no muestra ni una etiqueta "Combobox item".**
- **Ningún texto de la app tutea al usuario.**

**⚠️ Puntos de decisión de esta fase:**
- **1.3** — ¿exportas `video_cover.png` de Figma, o pongo un placeholder temporal?
- **1.6** — necesito **las opciones reales** de los 5 grupos de filtro. En el árbol de Figma los `Combobox Item` no llevan nombre propio, así que **no puedo leerlas**: o me las das, o hace falta el render (Fase 0.1).
- **1.7 (Q6)** — ¿manda el texto de Figma o el del código? Si manda Figma, la página 3 cambia de tema.
- **1.8 (Q7)** — ¿confirmas "usted" en toda la app?

**🛑 PARO. Te muestro el diff y espero tu OK.**

---

## Fase 2 — Cablear lo que ya existe 🔴🟡

**Rama:** `feat/conectar-flujos` · **Riesgo: medio** — cambia comportamiento en ejecución. Aquí es donde más te pido que revises.

**Q1 resuelta:** login → Onboarding 1. **Los ítems de login (2.1–2.3) ya están hechos** en la rama `fix/flujo-login`; el resto de la fase sigue pendiente.

| # | Cambio | Ref. |
|---|---|---|
| ~~2.1~~ | ✅ **HECHA** — flujo conectado: arranque en Iniciar Sesión, 1→Onboarding / 1→2→3→1, validación con mensaje en línea | A1 |
| ~~2.2~~ | ❌ **RETIRADA** — el hallazgo A2 era erróneo: `ingresar() → Onboarding` ya era correcto | A2 |
| ~~2.3~~ | ✅ **HECHA** — retirado el botón `"Simular error"` | A4 |
| 2.3b | 🆕 Sustituir el **mock de validación** (`login_mock_data.dart`) por la regla o endpoint real | A7 |
| 2.4 | En Reservados: cambiar "Registrarse" por **"Mi credencial"** (usar `EventCard` o parametrizar `UpcomingEventCard`) | R1 |
| 2.5 | Implementar "Compartir" y "Guardar" de la e-card con `share_plus` + `screenshot` + `path_provider` (ya están en `pubspec`) | P2 |
| 2.6 | Notificaciones: añadir sección **"Semana pasada"** + ícono `gear` | N1, N2 |
| 2.7 | Eventos: agrupar por nombre de mes completo ("Octubre" en vez de "Oct") | E4 |

**Criterio de aceptación:** cada flujo recorrido a mano en emulador; sin regresiones en la navegación existente.

**⚠️ Punto de decisión 2.4:** dos caminos —
- **(a)** usar `EventCard` en Reservados → cambio mínimo, pero el layout de la tarjeta es el del carrusel de Inicio, no el vertical de Reservados.
- **(b)** añadir un parámetro `secondaryAction` a `UpcomingEventCard` → más limpio, pero toca un widget usado en 4 pantallas.

Mi recomendación: **(b)**, con el parámetro opcional y valor por defecto "Registrarse", para no alterar las otras 3 pantallas. **Tú decides.**

**🛑 PARO.**

---

## Fase 3 — Modal `Credencial` y piezas faltantes 🔴

**Rama:** `feat/modal-credencial` · **Riesgo: bajo** — casi todo es código nuevo.

**⛔ Necesita Fase 0.1** (verificación visual del frame `54805:9056`).

> **Corrección respecto de la revisión 1 de este plan:** `Credencial` **no es una pantalla**, es un **modal sobre `InvitadosScreen`** (en Figma: `instance: Invitados` + scrim + panel). Se construye con `showDialog`/`showModalBottomSheet`, **no** con una ruta nueva. Esto simplifica la fase.

| # | Cambio | Ref. |
|---|---|---|
| 3.1 | Implementar el **modal** `Credencial` sobre `InvitadosScreen`: "Credencial digital" / "Utilice este código para acceder al evento" + QR + "Conferencia de Usuarios Esri 2026" | V1 |
| 3.2 | Cablear "Mi credencial" desde Inicio (`inicio.dart:119`) y Reservados | I1, T4 |
| 3.3 | Implementar los **dos** `Alert`: `star-f` "¡Ha guardado una actividad!" y `check-circle-f` "¡Gracias por tu opinión!" / "Se ha descargado su certificado." | V3 |
| 3.4 | 🆕 Variante `notificación/Eliminar` (`55149:10443`) | W1 / T14 |
| 3.5 | 🆕 Variante `Horario/Desglozado` (`54910:13665`, 617 px vs 187 px) — confirmar si `AgendaItemCard` ya la soporta | W2 / T14 |

**Criterio de aceptación:** "Mi credencial" deja de ser un callejón sin salida en las dos pantallas.

**🛑 PARO.**

---

## Fase 4 — Fidelidad visual pantalla por pantalla 🟡

**Rama:** una por pantalla — `fix/figma-<pantalla>` · **Riesgo: bajo por pantalla, pero es la fase más larga.**

**⛔ Bloqueada por Fase 0.1.**

Trabajo **una pantalla a la vez**, en este orden (las verificadas visualmente primero, porque de esas sí sé qué corregir):

1. Eventos — E1 (botón atrás de más), E3 (color del filtro)
2. Reservados — R2 (filtro no funcional)
3. Inicio — I2 (mocks)
4. Pasados — textos inconsistentes
5. …resto, conforme se vayan verificando

**Y la decisión grande de esta fase:**

**⚠️ T3 — las pantallas internas pierden el bottom nav.** En Figma, `Eventos`, `Invitados`, `Agenda`, `Favoritos` y `Post-Evento` conservan la barra inferior; en el código se abren con `Navigator.push` **encima** del `Menu` y la barra desaparece. Arreglarlo bien implica **rediseñar la navegación** (`Navigator` anidado por tab, o rutas con nombre y shell persistente).

Es un cambio estructural que toca 5 pantallas. **No lo hago sin que lo apruebes explícitamente**, y si lo apruebas, lo hago en su propia rama y en su propio paso.

**🛑 PARO entre cada pantalla.**

---

## Fase 5 — Consolidación interna 🟡🟢

**Rama:** una por ítem · **Riesgo: ALTO — esta fase toca código que hoy funciona bien.**

Nada de esto cambia lo que el usuario ve. Todo es para que el código deje de pelearse consigo mismo. **Cada ítem es opcional y va por separado.**

| # | Cambio | Riesgo | Ref. |
|---|---|---|---|
| 5.1 | Llenar `text_styles.dart` con la escala tipográfica y migrar pantallas **de a una** | medio | T6 |
| 5.2 | Mover los colores hardcodeados a `AppColors` (`#091F44`, `#1A2B4A`, `#6B6B6B`…) | bajo | T5 |
| 5.3 | Llenar `app_theme.dart` con `ColorScheme` + `TextTheme` y sacar el `ThemeData` inline de `main.dart` | medio | D7 |
| 5.4 | Unificar el modelo de dominio: un solo `Evento` en vez de `Evento` + `_ReservedEvent` ×2 + `_UpcomingEvent` | **alto** | T7, D13 |
| 5.5 | Extraer `_SplitFilterButton` (triplicado) a `core/widgets/` | bajo | D11 |
| 5.6 | Extraer `_InfoRow` / `_OutlineButton` / `_PrimaryButton` (duplicados entre las dos cards) | medio | D12 |
| 5.7 | Rutas con nombre en vez de `MaterialPageRoute` inline | **alto** | D14 |
| 5.8 | Unificar convención de carpetas (plana vs. `presentation/data`) | **alto** — muchos renames | D15 |
| 5.9 | Migrar los 18 avisos de `flutter analyze` (`withOpacity` ×8, etc.) | bajo | §9 |
| 5.10 | Unificar textos: "No hay eventos" / "No se encontraron eventos", `·` vs `-` | bajo | T9 |
| 5.11 | Decidir qué hacer con `lib/app.dart` vacío, `google_fonts` sin usar, `contactenos.svg` sin usar, `hs_err_pid21188.log` versionado | bajo | D6, D7, D10 |

**Mi recomendación de orden:** 5.9 → 5.5 → 5.2 → 5.10 → 5.1 → 5.6 → 5.3, y **dejar 5.4, 5.7 y 5.8 para el final** o para cuando entre el backend (ahí el refactor se justifica solo).

**⚠️ 5.11 incluye borrados.** No borro nada de eso sin tu OK explícito, uno por uno.

**🛑 PARO entre cada ítem.**

---

## Fase 6 — Producto B: app de staff/admin 📱🔐

**⛔ Bloqueada por Q2′.** Ya sabemos **qué es** (la auditoría lo resolvió): un módulo de control de accesos para personal del evento, con login propio (email + contraseña) y usuario propio (Ricardo Pérez, Administrador). Lo que falta decidir es **dónde vive**.

Alcance conocido: 4 pantallas (`55979:5315`, `55980:5360`, `55982:10446`, `55982:10576`).

**Pero el coste real no son las 4 pantallas.** Es lo que exigen:

| Requisito | Estado hoy |
|---|---|
| Autenticación real (email + contraseña + recuperación) | ❌ no existe |
| Sesión de usuario persistente | ❌ no existe |
| Roles y permisos (asistente vs. administrador) | ❌ no existe |
| Backend de asistentes | ❌ no existe (todo mock) |

**Esto no es una fase, es un proyecto.** No lo puedo estimar hasta que se responda Q2′ (misma app con bifurcación por rol, o app separada) y se defina el backend.

---

## Fase 7 — Producto C: panel de escritorio 🖥️

**⛔ Bloqueada por Q3′.**

Es **la misma función que el Producto B** en formato escritorio — ambos se titulan "Listas de asistentes". Alcance: 3 pantallas de 1440×1024 (`56014:6468`, `56014:6161`, `56025:14463`) + tabla + botones de fila `edit` / `trash` → implica **CRUD sobre asistentes**, no solo consulta.

Además requiere hacer responsive un código que hoy tiene 360/412 px hardcodeados en todas partes (**T10**).

**Depende de la Fase 6:** comparten autenticación, roles y backend. No tiene sentido abordarlo antes.

---

## Resumen de dependencias

```
Fase 0 (desbloqueos) ──┬──► Fase 1 (defectos + textos)   ← puedo empezar YA (*)
                       │        │
                       │        ▼
                       ├──► Fase 2 (cablear)              ← necesita Q1
                       │        │
                       │        ▼
    necesita 0.1 ──────┼──► Fase 3 (modal Credencial)
                       │        │
    necesita 0.1 ──────┼──► Fase 4 (fidelidad visual)
                       │        │
                       │        ▼
                       ├──► Fase 5 (consolidación)        ← opcional, riesgo alto
                       │
                       │    ── PRODUCTO DE ASISTENTE COMPLETO ──
                       │
    necesita Q2′ ──────┼──► Fase 6 (staff/admin móvil)    ← proyecto aparte
                       │        │  requiere auth + roles + backend
                       │        ▼
    necesita Q3′ ──────┴──► Fase 7 (escritorio)           ← depende de Fase 6
```

**(*)** Los ítems 1.6 y 1.7 de la Fase 1 necesitan que respondas Q6/Q7 o que me des las opciones de filtro; el resto de la Fase 1 lo puedo hacer ya.

---

## Qué necesito de ti para arrancar

**Mínimo para empezar la Fase 1 hoy mismo:**

1. ¿Arranco con la Fase 1? (ahora son **9 ítems**, no 5 — la auditoría añadió 1.6–1.9)
2. **1.3** — `video_cover.png`: ¿lo exportas de Figma o pongo placeholder?
3. **1.6** — las **opciones reales de los 5 grupos de filtro**: no están en el árbol de Figma, necesito que me las pases (o el render).
4. **1.7 (Q6)** — textos de onboarding: ¿manda Figma o el código?
5. **1.8 (Q7)** — ¿"usted" en toda la app?
6. Confirmar que trabajo sobre `a-develop` con ramas de fase.

Si prefieres no esperar, puedo hacer **1.1–1.5 + 1.9 ya** (defectos puros, sin decisiones de contenido) y dejar 1.6–1.8 para cuando respondas.

**Para desbloquear el resto:** Q1, Q2′, Q3′, Q5 del [comparativo §6](./02-comparativo-figma.md#6-preguntas-abiertas).

**No voy a tocar ni un archivo hasta que me digas.**
