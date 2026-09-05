/// El número de documento no tiene ninguna inscripción registrada en
/// `eventosdb` (401 de `POST /auth/login`). Caso distinto de un error de
/// conexión: aquí el backend respondió, solo que no encontró el registro.
class DocumentoNoEncontradoException implements Exception {
  const DocumentoNoEncontradoException();
}

/// No se pudo completar la petición por un problema de red/backend (sin
/// internet, timeout, backend caído, 5xx, etc.) - distinto de
/// [DocumentoNoEncontradoException], que es una respuesta válida del
/// backend diciendo "no encontrado".
class ErrorConexionException implements Exception {
  const ErrorConexionException(this.mensaje);

  final String mensaje;

  @override
  String toString() => 'ErrorConexionException: $mensaje';
}
