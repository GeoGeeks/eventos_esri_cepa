import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constants/fonts.dart';

class UpcomingEventCard extends StatelessWidget {
  final String title;
  final String date;
  final String location;
  final String image;
  final String mode;
  final VoidCallback onViewMore;
  final VoidCallback onRegister;

  // Modo historial
  final bool isHistorial;
  final String? estado;
  
  // Estados de carga y deshabilitado según CSS
  final bool isLoading;
  final bool isDisabled;

  const UpcomingEventCard({
    super.key,
    required this.title,
    required this.date,
    required this.location,
    required this.image,
    required this.mode,
    required this.onViewMore,
    required this.onRegister,
    this.isHistorial = false,
    this.estado,
    this.isLoading = false,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    // Card con altura DINÁMICA - se ajusta al contenido
    return SizedBox(
      width: 360,
      child: Stack(
        children: [
          // card-container con IntrinsicHeight para que imagen se estire dinámicamente
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Container(
              width: 360,
              color: const Color(0xFFFFFFFF),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // IMAGE - SE ESTIRA a la altura total del card (align-self: stretch)
                    Image.asset(
                      image,
                      width: 138,
                      fit: BoxFit.cover,
                    ),

                    // CONTENT CONTAINER - altura dinámica
                    Container(
                      width: 222,
                      color: const Color(0xFFFFFFFF),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // HEADER - altura dinámica según contenido
                          Container(
                            width: 222,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Frame 1461: Título + Chip (altura se ajusta al título)
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Card title - FLEXIBLE, se ajusta al contenido
                                    Expanded(
                                      child: Text(
                                        title,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontFamily: Fonts.medium,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF141414),
                                          height: 24 / 18,
                                        ),
                                      ),
                                    ),
                                    
                                    const SizedBox(width: 6),
                                    
                                    // Chip - tamaño fijo
                                    _ModeChip(label: mode),
                                  ],
                                ),
                                
                                const SizedBox(height: 6),

                                // Frame 1460: Info rows - FIJO (width: 182px, height: 36px)
                                SizedBox(
                                  width: 182,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _InfoRow(
                                        iconPath: 'assets/icons/date-time.svg',
                                        text: date,
                                      ),
                                      const SizedBox(height: 4),
                                      _InfoRow(
                                        iconPath: 'assets/icons/lugar.svg',
                                        text: location,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // FOOTER - altura: 40px, padding: 0px 12px 8px 0px, gap: 11px
                          SizedBox(
                            width: 222,
                            height: 40,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 12, bottom: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Estado (historial)
                                  if (isHistorial && estado != null) ...[
                                    Expanded(
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.info_outline,
                                            size: 13,
                                            color: Color(0xFFF39C12),
                                          ),
                                          const SizedBox(width: 4),
                                          Expanded(
                                            child: Text(
                                              estado!,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontFamily: Fonts.regular,
                                                fontSize: 12,
                                                color: Color(0xFFF39C12),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                  ],

                                  // Button: Ver más
                                  _OutlineButton(
                                    label: "Ver más",
                                    onPressed: isDisabled || isLoading ? () {} : onViewMore,
                                  ),
                                  
                                  const SizedBox(width: 11), // gap: 11px según CSS
                                  
                                  // Button: Registrarse (solo si no es historial)
                                  if (!isHistorial) ...[
                                    _PrimaryButton(
                                      label: "Registrarse",
                                      onPressed: isDisabled || isLoading ? () {} : onRegister,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // DISABLED MASK
          if (isDisabled && !isLoading)
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Container(
                  color: const Color(0xFFFFFFFF).withOpacity(0.5),
                ),
              ),
            ),

          // LOADER
          if (isLoading)
            Positioned(
              top: 1,
              left: 1,
              right: 1,
              bottom: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Container(
                  color: const Color(0xFFFFFFFF),
                  child: const Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF007AC2)),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ModeChip extends StatelessWidget {
  final String label;
  const _ModeChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      height: 24,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFEBEBEB),
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontFamily: Fonts.medium,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Color(0xFF6B6B6B),
          height: 16 / 12,
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String iconPath;
  final String text;
  
  const _InfoRow({
    required this.iconPath,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 16,
      child: Row(
        children: [
          // SVG Icon
          SizedBox(
            width: 16,
            height: 16,
            child: SvgPicture.asset(
              iconPath,
              colorFilter: const ColorFilter.mode(
                Color(0xFF949494),
                BlendMode.srcIn,
              ),
            ),
          ),
          const SizedBox(width: 2),
          Expanded(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: Fonts.regular,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFF949494),
                height: 16 / 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OutlineButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _OutlineButton({
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: 75,
        height: 32,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF),
          border: Border.all(
            color: const Color(0xFF007AC2),
            width: 1,
          ),
          borderRadius: BorderRadius.zero,
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontFamily: Fonts.regular,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xFF007AC2),
            height: 16 / 14,
          ),
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _PrimaryButton({
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: 95,
        height: 32,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: Color(0xFF007AC2),
          borderRadius: BorderRadius.zero,
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontFamily: Fonts.regular,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.white,
            height: 16 / 14,
          ),
        ),
      ),
    );
  }
}

