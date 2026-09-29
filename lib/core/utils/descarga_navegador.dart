/// Descarga de un archivo desde el navegador (PWA). En Android/iOS no aplica:
/// ahí el archivo se guarda en disco y se comparte con la hoja del sistema.
library;

export 'descarga_navegador_stub.dart'
    if (dart.library.js_interop) 'descarga_navegador_web.dart';
