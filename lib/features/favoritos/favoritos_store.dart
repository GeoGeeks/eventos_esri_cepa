import 'package:flutter/foundation.dart';

import 'data/favorito_enriquecido.dart';
import 'data/favoritos_repository.dart';

/// Estados de carga de `FavoritosStore` - mismo espíritu que `EventosStore`
/// (sellado, `ValueNotifier` en vez de Bloc, ver
/// `../../../CLAUDE.md`).
sealed class FavoritosEstado {
  const FavoritosEstado();
}

class FavoritosSinCargar extends FavoritosEstado {
  const FavoritosSinCargar();
}

class FavoritosCargando extends FavoritosEstado {
  const FavoritosCargando();
}

class FavoritosCargados extends FavoritosEstado {
  const FavoritosCargados(this.favoritos);
  final List<FavoritoEnriquecido> favoritos;
}

class FavoritosError extends FavoritosEstado {
  const FavoritosError(this.mensaje);
  final String mensaje;
}

/// Favoritos reales del asistente logueado (charlas y laboratorios), leídos
/// de `GET /favoritos` - Agenda, Laboratorios (dentro de Invitados) y la
/// pantalla de Favoritos leen todos del mismo estado, para que marcar o
/// desmarcar una estrella en cualquiera de las tres se refleje en las
/// otras sin recargar la app.
///
/// A diferencia de `EventosStore`, acá SÍ se vuelve a pedir todo el listado
/// después de cada `alternar()` en vez de tratar de editar la lista a mano
/// - son pocos favoritos por evento, y así no hay que duplicar la lógica de
/// "cuál era el estado anterior si falla" en dos sitios.
class FavoritosStore {
  FavoritosStore._();

  static final ValueNotifier<FavoritosEstado> estado = ValueNotifier(
    const FavoritosSinCargar(),
  );

  /// Marcas puramente locales (sin red) - para pantallas en modo mock/de
  /// prueba, donde la sesión/actividad todavía no tiene un id real que se
  /// pueda mandar a `/favoritos` (ver `InvitadosScreen._alternarFavorito`).
  /// Viven aparte de [estado] a propósito: no deben mezclarse con la lista
  /// que sí vino del backend.
  static final Set<String> _marcadosLocal = {};

  static bool contiene(String itemId) {
    if (_marcadosLocal.contains(itemId)) return true;
    final actual = estado.value;
    if (actual is! FavoritosCargados) return false;
    return actual.favoritos.any((f) => f.itemId == itemId);
  }

  /// Alterna una marca local (sin red) identificada por [clave] - para modo
  /// mock, donde no hay un `itemId`/`tipo` real que mandar al backend.
  /// Devuelve el nuevo estado (`true` = quedó marcada).
  static bool alternarLocal(String clave) {
    if (_marcadosLocal.remove(clave)) return false;
    _marcadosLocal.add(clave);
    return true;
  }

  static Future<void> cargar({
    FavoritosRepository? repository,
    bool forzar = false,
  }) async {
    if (!forzar &&
        (estado.value is FavoritosCargando ||
            estado.value is FavoritosCargados)) {
      return;
    }

    estado.value = const FavoritosCargando();
    final repo = repository ?? FavoritosRepository();
    try {
      final favoritos = await repo.listar();
      estado.value = FavoritosCargados(favoritos);
    } catch (_) {
      estado.value = const FavoritosError(
        'No se pudieron cargar los favoritos. Verifica tu conexión e intenta de nuevo.',
      );
    }
  }

  /// Marca o desmarca `itemId` y recarga el listado completo - ver el
  /// doc-comment de la clase. Silencioso ante un error (ej. intentar quitar
  /// una charla privada, que el backend rechaza): la estrella simplemente
  /// no cambia de estado, no hay dónde mostrar el mensaje desde acá.
  static Future<void> alternar({
    required String itemId,
    required String tipo,
    FavoritosRepository? repository,
  }) async {
    final repo = repository ?? FavoritosRepository();
    try {
      if (contiene(itemId)) {
        await repo.quitar(itemId: itemId, tipo: tipo);
      } else {
        await repo.marcar(itemId: itemId, tipo: tipo);
      }
      await cargar(repository: repo, forzar: true);
    } catch (_) {
      // Ver comentario del método.
    }
  }
}
