import 'dart:async';
import 'dart:js_interop';
import 'dart:typed_data';

import 'package:web/web.dart' as web;

/// Entrega [bytes] como una descarga del navegador con [nombreArchivo],
/// usando un enlace temporal con `download`. En Safari de iPhone abre la
/// vista previa del PDF, desde donde se guarda o comparte.
void descargarEnNavegador(
  List<int> bytes, {
  required String nombreArchivo,
  required String tipo,
}) {
  final blob = web.Blob(
    [Uint8List.fromList(bytes).toJS].toJS,
    web.BlobPropertyBag(type: tipo),
  );
  final url = web.URL.createObjectURL(blob);
  final enlace = web.HTMLAnchorElement()
    ..href = url
    ..download = nombreArchivo
    ..style.display = 'none';
  web.document.body?.append(enlace);
  enlace.click();
  enlace.remove();
  // Liberar la URL enseguida puede cortar la descarga en algunos navegadores.
  Timer(const Duration(seconds: 30), () => web.URL.revokeObjectURL(url));
}
