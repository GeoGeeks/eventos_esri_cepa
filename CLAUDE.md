# CLAUDE.md — `esri_eventos`

App **Flutter** de eventos para Esri Colombia. Diseño de referencia en Figma:
[Aplicación Eventos](https://www.figma.com/design/re1N5rv6AMTbhiH0OADIIV/Aplicaci%C3%B3n-Eventos?node-id=54686-28030) · página `Pantallas Flujo completo` (`54686:28030`).

---

## ⚠️ Directriz obligatoria: la carpeta `docs/` es la fuente de verdad

**Al inicio de cada sesión, antes de tocar código, LEE los tres documentos:**

| Documento | Qué contiene |
|---|---|
| [`docs/01-estado-actual.md`](docs/01-estado-actual.md) | Estado del proyecto: stack, estructura, pantallas, defectos (D1–D18) |
| [`docs/02-comparativo-figma.md`](docs/02-comparativo-figma.md) | Comparación pantalla por pantalla contra Figma, con node-ids y hallazgos (T1–T15) |
| [`docs/03-plan-de-trabajo.md`](docs/03-plan-de-trabajo.md) | Plan por fases, reglas de no-destrucción y puntos de aprobación |

**No empieces a implementar sin haberlos leído.** Contienen los node-ids de Figma, la
numeración de defectos y hallazgos que se usa para referirse a las tareas, y el orden
de fases acordado. Improvisar sobre ellos genera trabajo duplicado o contradictorio.

### Y al terminar cualquier trabajo, ACTUALÍZALOS

Estos documentos **se degradan si no se mantienen**. Después de cada cambio relevante:

| Si hiciste… | Actualiza… |
|---|---|
| Corregir un defecto (D*, T*, A*, E*, …) | Márcalo como resuelto en `01` y/o `02`, no lo borres |
| Completar una fase o un ítem | Marca el estado en `03` |
| Verificar una pantalla contra Figma | Sube su nivel de evidencia en `02` (📋 → 🌲 → 🖼️) |
| Descubrir un defecto o desviación nueva | Añádelo con número nuevo en la tabla correspondiente |
| Resolver una pregunta abierta (Q*) | Márcala resuelta en `02` §6 **y** quita el bloqueo en `03` |
| Añadir o cambiar una pantalla | Actualiza el inventario de `01` §6 y el mapa de `02` §2 |

**Regla de consistencia:** los tres documentos se referencian entre sí. Si corriges algo
en `02`, revisa si `03` dependía de esa afirmación. La revisión 2 de `02` corrigió cinco
errores de la revisión 1 y obligó a reescribir tres secciones de `03` — deja registro de
esos cambios en el «Registro de cambios» de `02` en vez de sobrescribir en silencio.

**No borres hallazgos resueltos.** Márcalos. El historial de qué estaba mal y se arregló
es parte del valor de estos documentos.

---

## Cómo trabajar en este repo

### Reglas de no-destrucción (acordadas con la usuaria)

Están completas en `docs/03-plan-de-trabajo.md` §0. Resumen:

- **No borrar código** sin OK explícito, aunque parezca muerto o duplicado. Reportar y esperar.
- **No hacer commit ni push** por iniciativa propia. Preparar los cambios, mostrar el diff, dejar que ella decida.
- **No tocar `base-aplicacion` ni `develop`.** Trabajar en ramas de fase desde `a-develop`.
- **No abrir PRs** salvo petición explícita.
- **No renombrar ni mover archivos en masa** — rompe imports en cadena. Proponer antes.
- **No refactorizar «de paso».** Lo que se ve de más se anota, no se toca.
- **Parar entre fases** y esperar aprobación.
- Si a mitad de una fase el alcance resulta mayor de lo estimado, **parar y avisar**.

### Verificación

```bash
flutter analyze --no-pub    # línea base: 0 errores, 18 avisos info
```

No dejar errores nuevos. Los 18 avisos existentes están catalogados en `01` §9.

---

## Contexto técnico esencial

- **Estado:** prototipo de UI de alta fidelidad. **Sin backend**: todos los datos son mocks hardcodeados; nada persiste al navegar.
- **Gestión de estado:** `flutter_bloc` **solo** en `onboarding`; el resto es `setState` local (71 usos en 21 archivos).
- **Navegación:** sin rutas con nombre; todo es `Navigator.push` con `MaterialPageRoute` inline.
- **Tres productos en el Figma**, no uno:
  - **A.** App de asistente (móvil, 33 pantallas) — María López · lo único implementado
  - **B.** App de staff/admin (móvil, 4 pantallas) — Ricardo Pérez, Administrador · 0 %
  - **C.** Panel de escritorio 1440×1024 (3 pantallas) · 0 %
  - B y C son **el mismo módulo** («Listas de asistentes») y exigen autenticación, sesión y roles que el proyecto no tiene.
- **Convenciones de carpeta mezcladas:** unas features usan `presentation/`+`data/`, otras un `.dart` plano. Al añadir código, seguir la convención de la feature en la que estás.
- **Tipografía:** Avenir Next LT Pro, 7 pesos, expuestos como `Fonts.regular`, `Fonts.bold`, … **Ojo:** `fontFamily: 'AvenirNext'` (sin sufijo) **no existe** y cae a la fuente del sistema — es el defecto T2.
- **Idioma:** Figma usa **«usted»** de forma consistente. Mantenerlo (ver Q7).

## MCP de Figma

El asiento actual es **View en plan Organization**, con **límite bajo de llamadas**. Se agota rápido.

- Antes de gastar llamadas, comprobar si el árbol de nodos ya descargado alcanza — está en `docs/02` y cubre 36 de 40 pantallas.
- El dump de `get_metadata` de la página raíz pesa ~134 k caracteres: **no pedirlo entero**, satura el contexto. Ir por node-id concreto.
- Los nodos `<symbol>` no expanden sus hijos en el dump de la página; hay que consultarlos individualmente.
- Si el MCP corta, **decirlo explícitamente** y marcar el nivel de evidencia en `02` (📋 / 🌲 / 🖼️) en vez de inferir en silencio.
