/// Credencial digital real, tal como la devuelve
/// `GET /eventos/:idEvento/credencial` en `eventos_esri_cepa_api` - `id` es
/// la PK interna (usada para validar/aprobar en la puerta); `codigoQr` es lo
/// que hay que codificar en el QR (ver `CredencialModal`).
class Credencial {
  const Credencial({
    required this.id,
    required this.idEvento,
    required this.estado,
    required this.codigoQr,
  });

  final String id;
  final String idEvento;

  /// 'pendiente' | 'aprobado' | 'rechazado' - estado EN SITIO, decidido por
  /// el staff de logística en la puerta (no tiene relación con el estado de
  /// inscripción en `eventosdb`).
  final String estado;

  /// JSON `{id, nombre, apellido, cedula}` acordado con el proveedor de
  /// logística (2026-09-18) - lo necesitan legible para imprimir el sticker
  /// de la escarapela. Es lo que se codifica en el QR, no `id` a secas.
  final String codigoQr;

  factory Credencial.fromJson(Map<String, dynamic> json) {
    return Credencial(
      id: json['id'] as String,
      idEvento: json['idEvento'] as String,
      estado: json['estado'] as String,
      codigoQr: json['codigoQr'] as String,
    );
  }
}
