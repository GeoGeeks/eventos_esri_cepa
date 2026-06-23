import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final String imagenAsset;
  final String titulo;
  final String subtitulo;
  final String descripcion;
  final VoidCallback? onExpandir;

  const InfoCard({
    super.key,
    required this.imagenAsset,
    required this.titulo,
    required this.subtitulo,
    required this.descripcion,
    this.onExpandir,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 128,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFF2F2F2)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: ClipOval(
              child: Image.asset(
                imagenAsset,
                width: 92,
                height: 92,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        titulo,
                        style: const TextStyle(
                          fontFamily: 'AvenirNext',
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
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
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 2, 12, 0),
                  child: Text(
                    descripcion,
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
                ),
                const Spacer(),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: onExpandir,
                    child: const Padding(
                      padding: EdgeInsets.only(right: 12, bottom: 2),
                      child: Icon(
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