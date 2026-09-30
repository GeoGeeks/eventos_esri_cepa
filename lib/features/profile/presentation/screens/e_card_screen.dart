import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/fonts.dart';
import '../../../../core/constants/icons.dart';
import '../../../../core/utils/area_segura.dart';
import '../../../../core/utils/descarga_navegador.dart';
import '../../../../core/widgets/app_icons.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../login/presentation/bloc/auth_cubit.dart';
import '../../../login/presentation/bloc/auth_state.dart';
import '../../data/ecard_visibility_config.dart';
import '../widgets/e_card_action_button.dart';
import '../widgets/e_card_config_modal.dart';
import '../widgets/e_card_widget.dart';

class ECardScreen extends StatefulWidget {
  final VoidCallback onBack;

  /// Qué hacer con la imagen PNG de la tarjeta al tocar "Compartir" y
  /// "Guardar". Por defecto, ambos abren el menú de compartir del sistema
  /// (que en iPhone trae "Guardar imagen" y en Android "Guardar en
  /// Archivos"), sin librerías ni permisos de galería extra; los tests pasan
  /// dobles para no abrirlo.
  final Future<void> Function(Uint8List png)? compartirImagen;
  final Future<void> Function(Uint8List png)? guardarImagen;

  const ECardScreen({
    super.key,
    required this.onBack,
    this.compartirImagen,
    this.guardarImagen,
  });

  @override
  State<ECardScreen> createState() => _ECardScreenState();
}

class _ECardScreenState extends State<ECardScreen> {
  /// `y` de la fila de botones en Figma. El título va 24 px más abajo del
  /// borde inferior de los botones, o sea en 96.
  static const double _topBotones = 36;

  bool _showNotification = false;

  ECardVisibilityConfig _visibilityConfig = const ECardVisibilityConfig();

  /// Envuelve la tarjeta para poder capturarla como imagen al compartir.
  final GlobalKey _claveTarjeta = GlobalKey();

  /// Evita capturas simultáneas si se toca dos veces.
  bool _generandoImagen = false;

  /// "Compartir": la tarjeta tal como se ve (con los datos que el asistente
  /// eligió mostrar y su QR vCard). Quien la recibe puede escanear el QR
  /// para guardar el contacto.
  Future<void> _compartir() => _enviarImagen(
    destino: widget.compartirImagen ?? _compartirConSistema,
    mensajeError: 'No se pudo compartir la e-card. Intente de nuevo.',
  );

  /// "Guardar": la misma imagen, para que el asistente la conserve.
  Future<void> _guardar() => _enviarImagen(
    destino: widget.guardarImagen ?? _guardarConSistema,
    mensajeError: 'No se pudo guardar la e-card. Intente de nuevo.',
  );

  /// Captura la tarjeta como PNG y se la entrega a [destino]; si algo falla,
  /// avisa con [mensajeError].
  Future<void> _enviarImagen({
    required Future<void> Function(Uint8List png) destino,
    required String mensajeError,
  }) async {
    if (_generandoImagen) return;
    setState(() => _generandoImagen = true);
    try {
      final limite =
          _claveTarjeta.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;
      if (limite == null) throw StateError('Tarjeta no disponible');
      final imagen = await limite.toImage(pixelRatio: 3);
      final datos = await imagen.toByteData(format: ui.ImageByteFormat.png);
      if (datos == null) throw StateError('No se pudo generar la imagen');
      await destino(datos.buffer.asUint8List());
    } catch (_) {
      if (mounted) mostrarSnackBar(context, mensajeError);
    } finally {
      if (mounted) setState(() => _generandoImagen = false);
    }
  }

  static Future<void> _compartirConSistema(Uint8List png) =>
      _abrirMenuDelSistema(png, titulo: 'Mi e-card');

  static Future<void> _guardarConSistema(Uint8List png) =>
      _abrirMenuDelSistema(png, titulo: 'Guardar mi e-card');

  static Future<void> _abrirMenuDelSistema(
    Uint8List png, {
    required String titulo,
  }) async {
    if (kIsWeb) {
      // PWA: sin carpeta temporal ni hoja de compartir del sistema; la
      // imagen se entrega como descarga del navegador (mismo mecanismo que
      // el certificado).
      descargarEnNavegador(
        png,
        nombreArchivo: 'mi-e-card.png',
        tipo: 'image/png',
      );
      return;
    }
    final carpeta = await getTemporaryDirectory();
    final archivo = File('${carpeta.path}/mi-e-card.png');
    await archivo.writeAsBytes(png, flush: true);
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(archivo.path, mimeType: 'image/png')],
        title: titulo,
      ),
    );
  }

  Future<void> _openConfig() async {
    final result = await showDialog<ECardVisibilityConfig>(
      context: context,
      barrierColor: Colors.black54,
      builder: (_) => ECardConfigModal(
        initialConfig: _visibilityConfig,
      ),
    );

    if (result != null && mounted) {
      setState(() {
        _visibilityConfig = result;
        _showNotification = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Figma: los dos botones arrancan en y=36 y el título «E-card» en y=96.
    // Solo bajan si la barra de estado llegara a taparlos.
    final double topBotones = AreaSegura.top(context, _topBotones);

    // Perfil real del asistente autenticado - `null` deja `ECardWidget` en
    // su comportamiento mock de siempre (`EcardMockData`), ver el
    // doc-comment de `ECardWidget.perfil`.
    final estadoAuth = context.watch<AuthCubit>().state;
    final perfil = estadoAuth is AuthAutenticado ? estadoAuth.perfil : null;

    return Container(
      color: AppColors.lightGray,
      // top:false — la posición la fija AreaSegura, no el SafeArea.
      child: SafeArea(
        top: false,
        child: Stack(
          children: [
            Column(
              children: [
                /// Appbar superior con botones (36x36, círculo azul)
                Padding(
                  padding: EdgeInsets.fromLTRB(26, topBotones, 26, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      /// Botón atrás
                      GestureDetector(
                        onTap: widget.onBack,
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: const AppIcon(
                            SvgIcon.back,
                            width: 8.414,
                            height: 14,
                            color: AppColors.white,
                          ),
                        ),
                      ),

                      /// Botón configuración
                      GestureDetector(
                        onTap: _openConfig,
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: const AppIcon(
                            SvgIcon.configuracion,
                            width: 16,
                            height: 16,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                /// Contenido escroleable
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        // 36 + 36 de los botones + 24 = 96, la y del título.
                        const SizedBox(height: 24),

                        /// Sección Título
                        SizedBox(
                          width: 360,
                          child: Column(
                            children: const [
                              Text(
                                'E-card',
                                style: TextStyle(
                                  fontFamily: Fonts.medium,
                                  fontWeight: Fonts.wMedium,
                                  fontSize: Fonts.text3h,
                                  height: 32 / 26,
                                  color: AppColors.textTitle,
                                ),
                              ),
                              SizedBox(height: 14),
                              Text(
                                'Utilice este código para identificarse y conectar con otros asistentes.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: Fonts.regular,
                                  fontWeight: Fonts.wRegular,
                                  fontSize: Fonts.text0h,
                                  height: 20 / 16,
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        /// Tarjeta E-Card Widget
                        RepaintBoundary(
                          key: _claveTarjeta,
                          child: ECardWidget(
                            visibilityConfig: _visibilityConfig,
                            perfil: perfil,
                          ),
                        ),

                        const SizedBox(height: 24),

                        /// Botones de acción
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ECardActionButton(
                              iconAsset: SvgIcon.compartir,
                              label: 'Compartir',
                              onTap: _compartir,
                            ),
                            const SizedBox(width: 24),
                            ECardActionButton(
                              iconAsset: SvgIcon.guardar,
                              label: 'Guardar',
                              onTap: _guardar,
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            /// Notification Toast Flotante (Calcite Notice Component Spec Exacto)
            if (_showNotification)
              Positioned(
                top: 48,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    width: 372,
                    height: 92,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: const Color.fromRGBO(53, 172, 70, 0.5),
                        width: 1,
                      ),
                    ),
                    foregroundDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      gradient: const LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Color.fromRGBO(53, 172, 70, 0.05),
                          Color.fromRGBO(53, 172, 70, 0.05),
                        ],
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        /// ICONO IZQUIERDO (Check circle: vector 14.6px x 14.6px)
                        const SizedBox(
                          width: 36,
                          child: Center(
                            child: AppIcon(
                              SvgIcon.ecard1,
                              width: 14.6,
                              height: 14.6,
                              color: Color(0xFF288835),
                            ),
                          ),
                        ),

                        /// CONTENIDO DE TEXTO
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 11),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Text(
                                  'Configuración actualizada.',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: Fonts.medium,
                                    fontWeight: Fonts.wMedium,
                                    fontSize: 16,
                                    height: 20 / 16,
                                    color: Color(0xFF141414),
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Los cambios ya están disponibles al escanear el código QR.',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: Fonts.regular,
                                    fontWeight: Fonts.wRegular,
                                    fontSize: 14,
                                    height: 16 / 14,
                                    color: Color(0xFF4A4A4A),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        /// BOTÓN DE CIERRE (X: vector exacto Figma 8.04px x 8.02px)
                        SizedBox(
                          width: 44,
                          height: 32,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _showNotification = false;
                              });
                            },
                            child: const Center(
                              child: AppIcon(
                                SvgIcon.x,
                                width: 8.04,
                                height: 8.02,
                                color: Color(0xFF6B6B6B),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
