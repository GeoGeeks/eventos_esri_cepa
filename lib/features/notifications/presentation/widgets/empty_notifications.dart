import 'package:flutter/material.dart';

class EmptyNotifications extends StatelessWidget {
  const EmptyNotifications({super.key});

  // Color exacto del CSS de "Sin Notificaciones"
  static const _azulTexto = Color(0xFF1B8ADD);
  static const _fontFamily = 'Avenir Next LT Pro';

  static const _imagePath =
      'assets/images/notificaciones/notificaciones.png';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // tarjeta_no_notications 1 -> 249x317
            Image.asset(
              _imagePath,
              width: 249,
              height: 317,
              fit: BoxFit.contain,
            ),

            const SizedBox(height: 24),

            // "No tiene notificaciones" -> 26px / 32 / weight 500 / #1B8ADD
            const SizedBox(
              width: 275,
              child: Text(
                'No tiene notificaciones',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: _fontFamily,
                  fontSize: 26,
                  fontWeight: FontWeight.w500,
                  height: 32 / 26,
                  color: _azulTexto,
                ),
              ),
            ),

            const SizedBox(height: 8),

            // "Cuando reciba una notificación, la verá aquí." -> 20px / 24 / weight 400 / #1B8ADD
            const SizedBox(
              width: 290,
              child: Text(
                'Cuando reciba una notificación,\nla verá aquí.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: _fontFamily,
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  height: 24 / 20,
                  color: _azulTexto,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
