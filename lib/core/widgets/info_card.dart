import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final String imagenAsset;
  final String titulo;
  final String subtitulo;
  final String? descripcion;
  final VoidCallback? onExpandir;
  final VoidCallback? onAgendar;

  const InfoCard({
    super.key,
    required this.imagenAsset,
    required this.titulo,
    required this.subtitulo,
    this.descripcion,
    this.onExpandir,
    this.onAgendar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 104),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFF2F2F2)),
        borderRadius: BorderRadius.circular(4),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipOval(
            child: Image.asset(
              imagenAsset,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(
                    fontFamily: 'AvenirNext',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF141414),
                    height: 24 / 18,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitulo,
                  style: const TextStyle(
                    fontFamily: 'AvenirNext',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF6B6B6B),
                    height: 16 / 14,
                  ),
                ),
                if (descripcion != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    descripcion!,
                    style: const TextStyle(
                      fontFamily: 'AvenirNext',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.italic,
                      color: Color(0xFF141414),
                      height: 16 / 14,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 8),
                if (onAgendar != null)
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton.icon(
                      onPressed: onAgendar,
                      icon: const Icon(Icons.add, size: 16, color: Colors.white),
                      label: const Text(
                        'Agendar',
                        style: TextStyle(
                          fontFamily: 'AvenirNext',
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF091F44),
                        elevation: 0,
                        padding:
                            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  )
                else if (onExpandir != null)
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: onExpandir,
                      child: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Color(0xFF6B6B6B),
                        size: 24,
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
