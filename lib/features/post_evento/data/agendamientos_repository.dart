import 'package:dio/dio.dart';

import '../../../core/config/app_config.dart';

/// Experto de «Agendar con expertos» (`GET /eventos/:idEvento/agendamientos`).
/// Cada uno tiene su propio [enlace] de agenda externa, que carga el panel.
class ExpertoAgendamiento {
  const ExpertoAgendamiento({
    required this.id,
    required this.nombre,
    required this.enlace,
    this.cargo,
    this.imagenUrl,
  });

  final String id;
  final String nombre;
  final String? cargo;

  /// Agenda del experto (p. ej. Microsoft Bookings): la abre «Agendar».
  final String enlace;

  /// Foto subida desde el panel; `null` = se usa la de respaldo.
  final String? imagenUrl;

  factory ExpertoAgendamiento.fromJson(Map<String, dynamic> json) =>
      ExpertoAgendamiento(
        id: json['id'] as String,
        nombre: json['nombre'] as String,
        cargo: json['cargo'] as String?,
        enlace: json['enlace'] as String,
        imagenUrl: json['imagenUrl'] as String?,
      );
}

/// Expertos del evento. El endpoint no pide token (lo comparten la app y el
/// panel), así que este repositorio no usa `TokenStorage`.
class AgendamientosRepository {
  AgendamientosRepository({Dio? dio})
    : _dio = dio ?? Dio(BaseOptions(baseUrl: AppConfig.apiBaseUrl));

  final Dio _dio;

  Future<List<ExpertoAgendamiento>> listar(String idEvento) async {
    final respuesta = await _dio.get<List<dynamic>>(
      '/eventos/$idEvento/agendamientos',
    );
    return (respuesta.data ?? [])
        .map((e) => ExpertoAgendamiento.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
