import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/fonts.dart';
import '../../../../core/constants/icons.dart';
import '../../../../core/utils/area_segura.dart';
import '../../../../core/widgets/app_icons.dart';
import '../../data/ecard_visibility_config.dart';
import '../widgets/e_card_action_button.dart';
import '../widgets/e_card_config_modal.dart';
import '../widgets/e_card_widget.dart';

class ECardScreen extends StatefulWidget {
  final VoidCallback onBack;

  const ECardScreen({
    super.key,
    required this.onBack,
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
                        ECardWidget(
                          visibilityConfig: _visibilityConfig,
                        ),

                        const SizedBox(height: 24),

                        /// Botones de acción
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ECardActionButton(
                              iconAsset: SvgIcon.compartir,
                              label: 'Compartir',
                              onTap: () {},
                            ),
                            const SizedBox(width: 24),
                            ECardActionButton(
                              iconAsset: SvgIcon.guardar,
                              label: 'Guardar',
                              onTap: () {},
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
