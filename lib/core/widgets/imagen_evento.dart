import 'package:flutter/material.dart';

/// La imagen de un evento puede venir de dos fuentes distintas: un asset
/// local empaquetado en la app (los mocks, `Images.esriEventos`) o una URL
/// real subida por un administrador (`Evento.imagenUrl`, servida por
/// `eventos_esri_cepa_api` bajo `/uploads`). `EventCard`/`UpcomingEventCard`
/// reciben un solo `String image` para las dos pantallas migradas y las que
/// siguen en mock, así que este widget decide cuál `Image.*` usar mirando el
/// propio string en vez de agregar un flag nuevo a cada tarjeta.
class ImagenEvento extends StatelessWidget {
  final String url;
  final BoxFit fit;
  final double? width;
  final double? height;

  const ImagenEvento({
    super.key,
    required this.url,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
  });

  bool get _esRed => url.startsWith('http://') || url.startsWith('https://');

  @override
  Widget build(BuildContext context) {
    if (_esRed) {
      return Image.network(
        url,
        width: width,
        height: height,
        fit: fit,
        // Sin conexión, o la imagen se borró del servidor - no tumba la
        // tarjeta completa, deja un fondo neutro en su lugar.
        errorBuilder: (_, _, _) => ColoredBox(
          color: const Color(0xFFEBEBEB),
          child: SizedBox(width: width, height: height),
        ),
        loadingBuilder: (context, child, progreso) {
          if (progreso == null) return child;
          return ColoredBox(
            color: const Color(0xFFEBEBEB),
            child: SizedBox(width: width, height: height),
          );
        },
      );
    }
    return Image.asset(url, width: width, height: height, fit: fit);
  }
}
