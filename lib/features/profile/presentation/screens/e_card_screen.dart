import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/fonts.dart';
import '../widgets/e_card_action_button.dart';
import '../widgets/e_card_config_modal.dart';
import '../widgets/e_card_widget.dart';

class ECardScreen extends StatefulWidget {
  const ECardScreen({super.key});

  @override
  State<ECardScreen> createState() => _ECardScreenState();
}

class _ECardScreenState extends State<ECardScreen> {
  bool _showNotification = false;

  Future<void> _openConfig() async {
    final result = await showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (_) => const ECardConfigModal(),
    );
    if (result == true && mounted) {
      setState(() => _showNotification = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // ── Botones flotantes ──
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: const BoxDecoration(
                            color: Color(0xFF1A2B4A),
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
                            color: Color(0xFF1A2B4A),
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

                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 16),

                        const Text(
                          'E-card',
                          style: TextStyle(
                            fontFamily: Fonts.regular,
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

                        const ECardWidget(),

                        const SizedBox(height: 28),

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

            // ── Banner notificación ──
            if (_showNotification)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  margin: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF6FFED),
                    border: Border.all(color: const Color(0xFF52C41A)),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.check_circle_outline,
                        color: Color(0xFF52C41A),
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Configuración actualizada.',
                              style: TextStyle(
                                fontFamily: Fonts.regular,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF135200),
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Los cambios ya están disponibles al escanear el código QR.',
                              style: TextStyle(
                                fontFamily: Fonts.regular,
                                fontSize: 12,
                                color: Color(0xFF135200),
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () =>
                            setState(() => _showNotification = false),
                        child: const Icon(
                          Icons.close,
                          size: 16,
                          color: Color(0xFF135200),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}