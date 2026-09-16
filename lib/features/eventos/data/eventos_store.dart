import 'package:flutter/foundation.dart';

import 'evento.dart';
import 'eventos_repository.dart';

/// Estados de carga de `EventosStore` - mismo espiritu que `AuthState`
/// (sellado, un estado a la vez) pero con `ValueNotifier` en vez de Bloc,
/// siguiendo la convencion de este repo para estado que vive fuera de una
/// sola pantalla (ver `FavoritosStore`/`ValoracionStore`,
/// `../../../CLAUDE.md`).
sealed class EventosEstado {
  const EventosEstado();
}

/// Antes del primer `cargar()` - así arranca la app.
class EventosSinCargar extends EventosEstado {
  const EventosSinCargar();
}

class EventosCargando extends EventosEstado {
  const EventosCargando();
}

class EventosCargados extends EventosEstado {
  const EventosCargados({required this.reservados, required this.proximos});

  /// Eventos a los que la persona ya esta inscrita (`GET
  /// /eventos/mis-inscripciones`) - "Eventos reservados" en Inicio/Reservas.
  final List<Evento> reservados;

  /// El resto de eventos activos - "Próximos eventos" en Inicio/Eventos.
  /// Para un colaborador interno son TODOS los activos (nunca tiene
  /// inscripciones, ver `EventosRepository.listarIdsInscritos`).
  final List<Evento> proximos;
}

class EventosError extends EventosEstado {
  const EventosError(this.mensaje);
  final String mensaje;
}

/// Carga y cachea los eventos reales durante la sesion - las tres pantallas
/// que hoy muestran eventos (Inicio, Eventos, Reservas) leen de aca en vez
/// de repetir la llamada cada una. `cargar()` es idempotente: si ya esta
/// cargando o ya cargo, no vuelve a pedir nada salvo que se pida `forzar`.
class EventosStore {
  EventosStore._();

  static final ValueNotifier<EventosEstado> estado = ValueNotifier(
    const EventosSinCargar(),
  );

  static Future<void> cargar({
    EventosRepository? repository,
    bool forzar = false,
  }) async {
    if (!forzar &&
        (estado.value is EventosCargando || estado.value is EventosCargados)) {
      return;
    }

    estado.value = const EventosCargando();
    final repo = repository ?? EventosRepository();
    try {
      final activosFuture = repo.listarActivos();
      final idsInscritosFuture = repo.listarIdsInscritos();
      final activos = await activosFuture;
      final idsInscritos = await idsInscritosFuture;

      // "Activo" en eventosdb.Evento (IDEstadoEvento) no quiere decir
      // "todavía no pasó" - excluye aquí lo que ya terminó (ver
      // Evento.yaPaso), para las dos listas: un evento reservado que ya
      // pasó tampoco pertenece a "Eventos reservados" (ese es el dominio de
      // "Eventos asistidos"/post-evento, todavía no conectado).
      final vigentes = activos.where((e) => !e.yaPaso).toList();

      estado.value = EventosCargados(
        reservados: [
          for (final e in vigentes)
            if (idsInscritos.contains(e.id)) e,
        ],
        proximos: [
          for (final e in vigentes)
            if (!idsInscritos.contains(e.id)) e,
        ],
      );
    } catch (_) {
      estado.value = const EventosError(
        'No se pudieron cargar los eventos. Verifica tu conexión e intenta de nuevo.',
      );
    }
  }
}
