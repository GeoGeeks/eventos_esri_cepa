/// Fuera del navegador no hay descarga: quien llama debe usar `kIsWeb`
/// antes, así que llegar aquí es un error de programación.
void descargarEnNavegador(
  List<int> bytes, {
  required String nombreArchivo,
  required String tipo,
}) {
  throw UnsupportedError('descargarEnNavegador solo existe en web.');
}
