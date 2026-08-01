import 'package:flutter/material.dart';
import '../constants/fonts.dart';

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
      width: 360,
      constraints: const BoxConstraints(minHeight: 114),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        border: Border.all(color: const Color(0xFFF2F2F2)),
        borderRadius: BorderRadius.circular(4),
      ),
      padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // comunidad-pe-2 2 (92x92, border-radius 100px)
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Image.asset(
              imagenAsset,
              width: 92,
              height: 92,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          // content-container
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // header (header-text-container: padding 8px 12px 0px)
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 12, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        titulo,
                        style: const TextStyle(
                          fontFamily: Fonts.medium,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          height: 24 / 18,
                          color: Color(0xFF141414),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitulo,
                        style: const TextStyle(
                          fontFamily: Fonts.regular,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          height: 16 / 14,
                          color: Color(0xFF6B6B6B),
                        ),
                      ),
                      if (descripcion != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          descripcion!,
                          style: const TextStyle(
                            fontFamily: Fonts.regular,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.italic,
                            height: 16 / 14,
                            color: Color(0xFF141414),
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                // footer
                if (onAgendar != null || onExpandir != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8, 12, 0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: onAgendar != null
                          ? SizedBox(
                              width: 109,
                              height: 32,
                              child: ElevatedButton.icon(
                                onPressed: onAgendar,
                                icon: const Icon(Icons.add, size: 16, color: Colors.white),
                                label: const Text(
                                  'Agendar',
                                  style: TextStyle(
                                    fontFamily: Fonts.regular,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF007AC2),
                                  elevation: 0,
                                  padding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0.001),
                                  ),
                                ),
                              ),
                            )
                          : GestureDetector(
                              onTap: onExpandir,
                              child: const Icon(
                                Icons.keyboard_arrow_down,
                                color: Color(0xFF6B6B6B),
                                size: 24,
                              ),
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
