import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class ValoracionSuccessDialog extends StatelessWidget {
  const ValoracionSuccessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            // línea verde superior
            Container(
              height: 4,
              color: const Color(0xFF288835),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Row(
                    children: [

                      const Icon(
                        Icons.check_circle_outline,
                        color: Color(0xFF288835),
                        size: 18,
                      ),

                      const SizedBox(width: 8),

                      const Expanded(
                        child: Text(
                          '¡Gracias por tu valoración!',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textTitle,
                          ),
                        ),
                      ),

                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.close,
                          size: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  RichText(
                    text: const TextSpan(
                      style: TextStyle(
                        color: AppColors.textTitle,
                        fontSize: 16,
                        height: 1.4,
                      ),
                      children: [

                        TextSpan(
                          text:
                              'Ya tienes tu lugar asegurado en ',
                        ),

                        TextSpan(
                          text: 'Planeta Esri Bogotá',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        TextSpan(
                          text:
                              '. Te hemos enviado un correo con todos los detalles del evento.',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      width: 120,
                      height: 40,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: const RoundedRectangleBorder(),
                        ),
                        onPressed: () {

                          // cerrar popup
                          Navigator.pop(context);

                          // cerrar paso2
                          Navigator.pop(context);

                          // cerrar paso1
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Ir a mis eventos',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}