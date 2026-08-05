import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../constants/app_colors.dart';
import '../constants/fonts.dart';
import '../constants/icons.dart';
import '../utils/area_segura.dart';

/// Ventana con un formulario web dentro — `assets/views/Ventana evento.svg`
/// y `assets/views/agendar con expertos.svg`, que comparten geometría.
///
/// Se superpone a la pantalla que la abre con un velo `#000000` al 50 % y un
/// panel de 358 × 673 en `top: 122`, `left: 27`, radio 4. El formulario es una
/// SPA que se pinta con JavaScript, así que va en un WebView en lugar de
/// reconstruirse en Flutter.
///
/// **No lleva botón «Siguiente» ni «Enviar»**: esos pasos los trae el propio
/// formulario.
class FormularioWebModal extends StatefulWidget {

  // ── Medidas del SVG (lienzo 412 × 917) ──
  static const double ancho = 358;
  static const double alto = 673;
  static const double top = 122;
  static const double margenLateral = 27;
  static const double radio = 4;

  /// Cabecera del panel: 358 × 69 con borde inferior de 1 px `#F2F2F2`.
  static const double altoCabecera = 69;

  /// El título vive en un subcontenedor de 322 × 68 a 18 px del borde.
  static const double margenTitulo = 18;

  /// Hueco entre la cabecera y el formulario (191 → 211 en el SVG).
  static const double margenFormulario = 20;

  /// Título de la cabecera: «Registro» o «Agendar».
  final String titulo;

  /// Dirección que se carga.
  final String enlace;

  const FormularioWebModal({
    super.key,
    required this.titulo,
    required this.enlace,
  });

  /// Abre la ventana sobre la pantalla actual.
  static Future<void> mostrar(
    BuildContext context, {
    required String titulo,
    required String url,
  }) {
    return showDialog<void>(
      context: context,
      // El velo del diseño: #000000 al 50 % (modalOverlay es 0x80).
      barrierColor: AppColors.modalOverlay,
      // Sin el SafeArea de showDialog: el panel se coloca en su y absoluta de
      // Figma (122), que ya cae muy por debajo de cualquier barra de estado.
      // Con él, la barra se sumaría a los 122 y el panel bajaría 48 px de más.
      useSafeArea: false,
      builder: (_) => FormularioWebModal(titulo: titulo, enlace: url),
    );
  }

  @override
  State<FormularioWebModal> createState() => _FormularioWebModalState();
}

class _FormularioWebModalState extends State<FormularioWebModal> {
  /// Nulo si la plataforma no trae WebView —escritorio, web o un test—. En ese
  /// caso el panel se dibuja igual y el hueco del formulario muestra el aviso
  /// de error, en vez de tumbar la ventana entera.
  WebViewController? _controlador;

  bool _cargando = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    try {
      _controlador = _crearControlador();
    } catch (_) {
      _cargando = false;
      _error = 'El formulario no se puede mostrar en este dispositivo.';
    }
  }

  WebViewController _crearControlador() {
    return WebViewController()
      // El formulario se pinta con JavaScript: sin esto la página sale vacía.
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(AppColors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) {
            if (mounted) setState(() => _cargando = false);
          },
          onWebResourceError: (error) {
            // Solo interesa el fallo del documento principal; los recursos
            // sueltos que no cargan no deben tapar el formulario.
            if (error.isForMainFrame == false) return;
            if (mounted) {
              setState(() {
                _cargando = false;
                _error = 'No fue posible cargar el formulario. '
                    'Revise su conexión e intente de nuevo.';
              });
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.enlace));
  }

  void _reintentar() {
    final controlador = _controlador;
    if (controlador == null) return;
    setState(() {
      _cargando = true;
      _error = null;
    });
    controlador.loadRequest(Uri.parse(widget.enlace));
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    // 122 ya cae muy por debajo de cualquier barra de estado, así que en la
    // práctica no se mueve; se pasa por AreaSegura por coherencia con el resto.
    final double arriba = AreaSegura.top(context, FormularioWebModal.top);

    // El teclado tapa la parte de abajo del panel: se le resta para que el
    // formulario siga completo mientras se escribe.
    final double reservaInferior = math.max(
      media.viewInsets.bottom,
      media.viewPadding.bottom,
    );
    final double disponible =
        media.size.height - arriba - reservaInferior - FormularioWebModal.margenLateral;
    final double altoPanel = math.min(FormularioWebModal.alto, math.max(0, disponible));

    return Dialog(
      alignment: Alignment.topCenter,
      insetPadding: EdgeInsets.only(
        top: arriba,
        left: FormularioWebModal.margenLateral,
        right: FormularioWebModal.margenLateral,
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: SizedBox(
        key: const Key('registro-panel'),
        // En una pantalla de 412 el ancho disponible es exactamente 358; en una
        // más estrecha el panel se encoge en vez de desbordar.
        width: FormularioWebModal.ancho,
        height: altoPanel,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(FormularioWebModal.radio),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              _Cabecera(titulo: widget.titulo),
              Expanded(child: _cuerpo()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cuerpo() {
    final controlador = _controlador;
    if (_error != null || controlador == null) {
      return Padding(
        padding: const EdgeInsets.all(FormularioWebModal.margenFormulario),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _error ?? '',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: Fonts.regular,
                fontWeight: Fonts.wRegular,
                fontSize: Fonts.text0h,
                height: 20 / 16,
                letterSpacing: 0,
                color: AppColors.modalSubtitle,
              ),
            ),
            const SizedBox(height: 16),
            if (controlador != null)
              TextButton(
              onPressed: _reintentar,
              child: const Text(
                'Reintentar',
                style: TextStyle(
                  fontFamily: Fonts.medium,
                  fontWeight: Fonts.wMedium,
                  fontSize: Fonts.text0h,
                  letterSpacing: 0,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      // 20 a los lados y por arriba, igual que el SVG (47 y 211 absolutos).
      padding: const EdgeInsets.fromLTRB(
        FormularioWebModal.margenFormulario,
        FormularioWebModal.margenFormulario,
        FormularioWebModal.margenFormulario,
        14,
      ),
      child: Stack(
        children: [
          WebViewWidget(
            key: const Key('registro-webview'),
            controller: controlador,
          ),
          if (_cargando)
            const Center(
              child: SizedBox(
                width: 32,
                height: 32,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Cabecera de 358 × 69: título «Registro» a la izquierda y la X para cerrar.
class _Cabecera extends StatelessWidget {
  final String titulo;

  const _Cabecera({required this.titulo});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: FormularioWebModal.altoCabecera,
      padding: const EdgeInsets.symmetric(
        horizontal: FormularioWebModal.margenTitulo,
      ),
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(
          bottom: BorderSide(color: AppColors.surface3, width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              titulo,
              style: const TextStyle(
                fontFamily: Fonts.medium,
                fontWeight: Fonts.wMedium,
                fontSize: Fonts.text3h,
                height: 32 / 26,
                letterSpacing: 0,
                color: AppColors.textTitle,
              ),
            ),
          ),
          GestureDetector(
            key: const Key('registro-cerrar'),
            behavior: HitTestBehavior.opaque,
            onTap: () => Navigator.of(context).pop(),
            // Caja de 16 para el ícono, con 8 de margen de toque a cada lado.
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: SizedBox(
                width: 16,
                height: 16,
                child: Center(
                  child: _IconoCerrar(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _IconoCerrar extends StatelessWidget {
  const _IconoCerrar();

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      SvgIcon.x,
      // Medidas del vector en Figma dentro de su caja de 16.
      width: 8.041,
      height: 8.020,
      colorFilter: const ColorFilter.mode(
        AppColors.textMuted,
        BlendMode.srcIn,
      ),
    );
  }
}
