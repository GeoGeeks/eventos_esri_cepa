import 'package:flutter/material.dart';

class ECardWidget extends StatelessWidget {
  const ECardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      padding: const EdgeInsets.only(
        top: 18,
        left: 18,
        right: 18,
        bottom: 22,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(2),
      ),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            color: const Color(0xFFD9EEF8),
            child: const Text(
              'ML',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF4A4A4A),
              ),
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'María López',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF091F44),
            ),
          ),

          const SizedBox(height: 2),

          const Text(
            'Ingeniería Civil - Procalculo',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              color: Color(0xFF666666),
            ),
          ),

          const SizedBox(height: 18),

          Container(
            width: 170,
            height: 170,
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color(0xFFE6E6E6),
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: _QrPlaceholderPainter(),
                  ),
                ),

                Container(
                  width: 34,
                  height: 34,
                  decoration: const BoxDecoration(
                    color: Color(0xFF007AC2),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'esri',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QrPlaceholderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF007AC2)
      ..strokeWidth = 4;

    canvas.drawRect(
      const Rect.fromLTWH(10, 10, 28, 28),
      paint,
    );

    canvas.drawRect(
      Rect.fromLTWH(size.width - 38, 10, 28, 28),
      paint,
    );

    canvas.drawRect(
      Rect.fromLTWH(10, size.height - 38, 28, 28),
      paint,
    );

    for (double x = 50; x < size.width - 20; x += 12) {
      for (double y = 20; y < size.height - 20; y += 12) {
        canvas.drawCircle(
          Offset(x, y),
          2,
          Paint()..color = const Color(0xFF007AC2),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}