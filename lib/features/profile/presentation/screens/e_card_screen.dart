import 'package:flutter/material.dart';
import '../widgets/e_card_action_button.dart';
import '../widgets/e_card_config_modal.dart';
import '../widgets/e_card_widget.dart';
import 'e_card_notification_screen.dart';

class ECardScreen extends StatelessWidget {
  const ECardScreen({super.key});

  Future<void> _openConfig(BuildContext context) async {
    final result = await showDialog(
      context: context,
      builder: (_) => const ECardConfigModal(),
    );

    if (result == true && context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              const ECardNotificationScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 88,
              color: const Color(0xFF091F44),
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () =>
                        Navigator.pop(context),
                    child: const Icon(
                      Icons.chevron_left,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),

                  const Expanded(
                    child: Center(
                      child: Text(
                        'E-card',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight:
                              FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  GestureDetector(
                    onTap: () =>
                        _openConfig(context),
                    child: const Icon(
                      Icons.settings_outlined,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 40),

                    const ECardWidget(),

                    const SizedBox(height: 28),

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        ECardActionButton(
                          icon: Icons.share_outlined,
                          label: 'Compartir',
                          onTap: () {},
                        ),

                        const SizedBox(width: 16),

                        ECardActionButton(
                          icon: Icons.download_outlined,
                          label: 'Guardar',
                          onTap: () {},
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),

                    Padding(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 40,
                      ),
                      child: Text(
                        'Presenta este código para compartir tu información profesional durante el evento.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),
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