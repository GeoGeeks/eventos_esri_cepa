import 'package:flutter/foundation.dart';

import '../agenda/data/agenda_mock_data.dart';
import '../invitados/data/invitados_mock_data.dart';

/// Favoritos que el usuario marca con la estrella fuera de Agenda —hoy solo los
/// laboratorios de la pestaña **Laboratorios**— para que la pantalla de
/// Favoritos los muestre junto a los que ya trae la agenda.
///
/// Vive en memoria: cuando entre el backend, este mismo API se sustituye por el
/// repositorio sin tocar las pantallas. La clave es el **título** de la sesión,
/// que es lo único que ambas listas comparten.
class FavoritosStore {
  FavoritosStore._();

  static final ValueNotifier<List<Actividad>> actividades =
      ValueNotifier<List<Actividad>>(const []);

  static bool contiene(String titulo) =>
      actividades.value.any((a) => a.titulo == titulo);

  /// Marca o desmarca la sesión y devuelve el estado en que queda.
  static bool alternar(SesionEvento sesion) {
    if (contiene(sesion.titulo)) {
      actividades.value = [
        for (final a in actividades.value)
          if (a.titulo != sesion.titulo) a,
      ];
      return false;
    }
    actividades.value = [...actividades.value, _comoActividad(sesion)];
    return true;
  }

  static Actividad _comoActividad(SesionEvento sesion) => Actividad(
    titulo: sesion.titulo,
    // En Laboratorios la fecha ya incluye la hora; es lo que la tarjeta de
    // Favoritos pinta arriba a la derecha.
    horario: sesion.fecha,
    ponente: sesion.ponente,
    lugar: sesion.lugar,
    aforo: sesion.aforo,
    etiquetas: sesion.etiquetas,
    descripcion: sesion.descripcion,
    tituloObjetivos: sesion.tituloObjetivos,
    objetivos: sesion.objetivos,
    favorita: true,
  );
}
