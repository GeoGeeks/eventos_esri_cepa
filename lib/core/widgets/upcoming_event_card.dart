import 'package:flutter/material.dart';

class UpcomingEventCard extends StatelessWidget {
  final String title;
  final String date;
  final String location;
  final String image;
  final String mode;
  final VoidCallback onViewMore;
  final VoidCallback onRegister;

  const UpcomingEventCard({
    super.key,
    required this.title,
    required this.date,
    required this.location,
    required this.image,
    required this.mode,
    required this.onViewMore,
    required this.onRegister,
  });

  @override
  Widget build(BuildContext context) {
    const double cardHeight = 122.0;
    const double imageWidth = 138.0;

    return SizedBox(
      height: cardHeight,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Container(
          color: Colors.white,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              
              SizedBox(
                width: imageWidth,
                child: Image.asset(
                  image,
                  width: imageWidth,
                  height: cardHeight,
                  fit: BoxFit.cover,
                ),
              ),

              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                   
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: const TextStyle(
                                fontFamily: 'AvenirNext',
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF141414),
                                height: 24 / 18,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 6),
                          _ModeChip(label: mode),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Fecha
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: _InfoRow(
                        icon: Icons.access_time_outlined,
                        text: date,
                      ),
                    ),
                    const SizedBox(height: 3),

                    // Ubicación
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: _InfoRow(
                        icon: Icons.location_on_outlined,
                        text: location,
                      ),
                    ),

                    const Spacer(),

                    // Botones — alineados a la derecha, dentro del margen
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 12, right: 12, bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          _CardButton(
                            label: 'Ver más',
                            filled: false,
                            onPressed: onViewMore,
                          ),
                          const SizedBox(width: 8),
                          _CardButton(
                            label: 'Mi credencial',
                            filled: true,
                            onPressed: onRegister,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class _CardButton extends StatelessWidget {
  final String label;
  final bool filled;
  final VoidCallback onPressed;

  const _CardButton({
    required this.label,
    required this.filled,
    required this.onPressed,
  });

  static const _textStyle = TextStyle(
    fontFamily: 'AvenirNext',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 16 / 14,
  );

  static const _shape = RoundedRectangleBorder(
    borderRadius: BorderRadius.zero,
  );

  static const _padding =
      EdgeInsets.symmetric(horizontal: 12, vertical: 8);

  @override
  Widget build(BuildContext context) {
    if (filled) {
      return SizedBox(
        height: 32,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF091F44),
            foregroundColor: Colors.white,
            elevation: 0,
            shadowColor: Colors.transparent,
            shape: _shape,
            padding: _padding,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            minimumSize: Size.zero,
          ),
          child: Text(label,
              style: _textStyle.copyWith(color: Colors.white)),
        ),
      );
    }
    return SizedBox(
      height: 32,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF091F44),
          side: const BorderSide(color: Color(0xFF091F44), width: 1),
          shape: _shape,
          padding: _padding,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          minimumSize: Size.zero,
        ),
        child: Text(label,
            style: _textStyle.copyWith(color: const Color(0xFF091F44))),
      ),
    );
  }
}

// ─── Chip ────────────────────────────────────────────────────────────────────
class _ModeChip extends StatelessWidget {
  final String label;
  const _ModeChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFEBEBEB),
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontFamily: 'AvenirNext',
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Color(0xFF6B6B6B),
          height: 16 / 12,
        ),
      ),
    );
  }
}

// ─── Fila info ───────────────────────────────────────────────────────────────
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFF949494)),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: 'AvenirNext',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF949494),
              height: 16 / 14,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}