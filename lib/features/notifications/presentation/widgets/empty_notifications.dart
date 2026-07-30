import 'package:flutter/material.dart';

class EmptyNotifications extends StatelessWidget {
  const EmptyNotifications({super.key});

  static const _fontFamily = 'Avenir Next LT Pro';
  static const _azul = Color(0xFF1B8ADD);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Imagen central del diseño (tarjeta_no_notications.png)
          Image.asset(
            'assets/images/cards/tarjeta_no_notications.png',
            width: 249,
            height: 317,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              // Fallback en caso de que la imagen aún no esté vinculada en pubspec.yaml
              return Container(
                width: 249,
                height: 317,
                alignment: Alignment.center,
                child: const Icon(
                  Icons.notifications_off_outlined,
                  size: 100,
                  color: _azul,
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          const Text(
            'No tiene notificaciones',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: _fontFamily,
              fontSize: 26,
              fontWeight: FontWeight.w500,
              height: 32 / 26,
              color: _azul,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Cuando reciba una notificación,\nla verá aquí.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: _fontFamily,
              fontSize: 20,
              fontWeight: FontWeight.w400,
              height: 24 / 20,
              color: _azul,
            ),
          ),
        ],
      ),
    );
  }
}
