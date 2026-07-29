import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/fonts.dart';
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
      color: const Color(0xFFF5F5F5),
      child: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                /// App Bar superior / Header botones
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: widget.onBack,
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: const BoxDecoration(
                            color: Color(0xFF007AC2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.chevron_left,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: _openConfig,
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: const BoxDecoration(
                            color: Color(0xFF007AC2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.settings_outlined,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                /// Contenido principal escroleable
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        const SizedBox(height: 16),
                        const Text(
                          'E-card',
                          style: TextStyle(
                            fontFamily: Fonts.medium,
                            fontSize: 26,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textTitle,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 48),
                          child: Text(
                            'Utilice este código para identificarse y conectar con otros asistentes.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: Fonts.regular,
                              fontSize: 13,
                              color: AppColors.textSubtle,
                              height: 1.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),

                        /// Tarjeta QR con vCard dinámico
                        ECardWidget(
                          visibilityConfig: _visibilityConfig,
                        ),

                        const SizedBox(height: 28),

                        /// Botones de acción inferiores
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ECardActionButton(
                              icon: Icons.share_outlined,
                              label: 'Compartir',
                              onTap: () {},
                            ),
                            const SizedBox(width: 40),
                            ECardActionButton(
                              icon: Icons.download_outlined,
                              label: 'Guardar',
                              onTap: () {},
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            /// Notification Toast Flotante de confirmación
            if (_showNotification)
              Positioned(
                top: 25,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    width: 360,
                    height: 92,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: const Color(0x8035AC46),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 36,
                          height: 56,
                          child: Center(
                            child: Icon(
                              Icons.check_circle,
                              size: 16,
                              color: Color(0xFF288835),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 11),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Configuración actualizada.',
                                  style: TextStyle(
                                    fontFamily: Fonts.medium,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    height: 1.25,
                                    color: Color(0xFF141414),
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Los cambios ya están disponibles al escanear el código QR.',
                                  style: TextStyle(
                                    fontFamily: Fonts.regular,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    height: 16 / 14,
                                    color: Color(0xFF4A4A4A),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 44,
                          height: 32,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(2),
                            onTap: () {
                              setState(() {
                                _showNotification = false;
                              });
                            },
                            child: const Center(
                              child: Icon(
                                Icons.close,
                                size: 16,
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