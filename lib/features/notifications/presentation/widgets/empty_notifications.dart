import 'package:flutter/material.dart';

import '../../../../core/constants/fonts.dart';

class EmptyNotifications extends StatelessWidget {
  const EmptyNotifications({super.key});

  static const Color _azulTexto = Color(0xFF1B8ADD);
  static const String _imagePath =
      'assets/images/notificaciones/notificaciones.png';


  static const double _imageTop = 197 - 80; // 117
  static const double _title1Top = 498 - 80; // 418
  static const double _title2Top = 538 - 80; // 458

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [

        Positioned(
          top: _imageTop,
          child: Image.asset(
            _imagePath,
            width: 249,
            height: 317,
            fit: BoxFit.contain,
          ),
        ),

        Positioned(
          top: _title1Top,
          child: const SizedBox(
            width: 275,
            child: Text(
              'No tiene notificaciones',
              textAlign: TextAlign.center,
              maxLines: 1,
              softWrap: false,
              overflow: TextOverflow.visible,
              style: TextStyle(
                fontFamily: Fonts.medium,
                fontWeight: Fonts.wMedium,
                fontSize: 26,
                height: 32 / 26,
                color: _azulTexto,
              ),
            ),
          ),
        ),

        // "Cuando reciba una notificación, la verá aquí."
        Positioned(
          top: _title2Top,
          child: const SizedBox(
            width: 290,
            child: Text(
              'Cuando reciba una notificación, la verá aquí.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: Fonts.regular,
                fontWeight: Fonts.wRegular,
                fontSize: 20,
                height: 24 / 20,
                color: _azulTexto,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
