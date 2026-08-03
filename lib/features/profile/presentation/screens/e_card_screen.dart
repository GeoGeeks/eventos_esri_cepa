import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/fonts.dart';
import '../../../../core/constants/icons.dart';
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
    return Container(
      color: AppColors.lightGray,
      child: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                /// Appbar superior con botones (36x36, círculo azul)
                Padding(
                  padding: const EdgeInsets.fromLTRB(26, 16, 26, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      /// Botón atrás: mismo icono/patrón usado en el
                      /// resto de la app (SvgIcon.back), no chevron
                      /// genérico de Material.
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

                      /// Botón configuración: icono real 16x16 (spec),
                      /// no 20x20 de Material.
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
                        const SizedBox(height: 16),

                        /// Sección Título (360x86px con gap: 14px del spec)
                        SizedBox(
                          width: 360,
                          child: Column(
                            children: const [
                              /// "E-card" -> Avenir Medium 26px, no 24px
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
                              SizedBox(height: 14), // gap: 14px del CSS
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

                        /// Botones de acción (gap: 24px entre ellos del CSS)
                        /// Iconos reales: compartir.svg / guardar.svg
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

            /// Notification Toast Flotante
            if (_showNotification)
              Positioned(
                top: 15,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    width: 360,
                    height: 92,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF6FBF6), // sin constante equivalente
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: const Color(0x8035AC46), // verde con opacidad, sin constante
                        width: 1,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        /// Icono Check
                        Container(
                          width: 36,
                          height: 56,
                          padding: const EdgeInsets.fromLTRB(12, 12, 8, 12),
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.check_circle,
                            size: 16,
                            color: AppColors.success,
                          ),
                        ),

                        /// Textos
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 11),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Configuración actualizada.',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: Fonts.medium,
                                    fontWeight: Fonts.wMedium,
                                    fontSize: 16,
                                    height: 1.25,
                                    color: AppColors.textTitle,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Los cambios ya están disponibles al escanear el código QR.',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: Fonts.regular,
                                    fontWeight: Fonts.wRegular,
                                    fontSize: 14,
                                    height: 16 / 14,
                                    color: AppColors.modalSubtitle,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        /// Botón Cerrar (X)
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _showNotification = false;
                            });
                          },
                          behavior: HitTestBehavior.opaque,
                          child: Container(
                            width: 44,
                            height: 32,
                            padding: const EdgeInsets.only(right: 6),
                            alignment: Alignment.center,
                            child: AppIcon(
                              SvgIcon.x,
                              width: 16,
                              height: 16,
                              color: AppColors.textMuted,
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
