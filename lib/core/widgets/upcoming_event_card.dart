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
    // Card principal (width: 360px, height: 122px) - CORREGIDO
    return SizedBox(
      width: 360,
      height: 122,
      child: Stack(
        children: [
          // card-container
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Container(
              width: 360,
              height: 122,
              color: const Color(0xFFFFFFFF), // background: #FFFFFF
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // IMAGE (.comunidad-pe-2 1)
                  Image.asset(
                    image,
                    width: 138,
                    height: 122, // CORREGIDO: era 146
                    fit: BoxFit.cover,
                  ),

                  // CONTENT CONTAINER (content-container)
                  Container(
                    width: 222,
                    height: 122, // CORREGIDO: era 146
                    color: const Color(0xFFFFFFFF),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // HEADER (header / header-text-container)
                        Container(
                          width: 222,
                          height: 82, // CORREGIDO: era 106
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), // padding: 8px 12px
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Frame 1461: Contiene Título y Chip en Fila
                              SizedBox(
                                width: 198,
                                height: 24, // CORREGIDO: era 48, solo 1 línea de título
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Card title - maxLines: 1
                                    SizedBox(
                                      width: 97, // Según CSS: 97px
                                      height: 24,
                                      child: Text(
                                        title,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontFamily: Fonts.medium,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF141414),
                                          height: 24 / 18, // line-height: 24px
                                        ),
                                      ),
                                    ),
                                    
                                    // Chip (.Frame 73)
                                    _ModeChip(label: mode),
                                  ],
                                ),
                              ),
                              
                              const SizedBox(height: 6), // gap: 6px

                              // Frame 1460 (Column de filas de info con gap de 4px)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _InfoRow(
                                    iconPath: 'assets/icons/date-time.svg',
                                    text: date,
                                  ),
                                  const SizedBox(height: 4), // gap: 4px
                                  _InfoRow(
                                    iconPath: 'assets/icons/lugar.svg',
                                    text: location,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // FOOTER (footer) - height: 40px
                        Container(
                          width: 222,
                          height: 40,
                          padding: const EdgeInsets.only(right: 12, bottom: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Si es historial, agregamos el estado a la izquierda
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

                              // Boton secundario "Ver más"
                              _OutlineButton(
                                label: "Ver más",
                                onPressed: isDisabled || isLoading ? () {} : onViewMore,
                              ),
                              
                              // Boton primario "Registrarse" (Sólo si no es historial)
                              if (!isHistorial) ...[
                                const SizedBox(width: 8), // gap: 8px entre botones
                                _PrimaryButton(
                                  label: "Registrarse",
                                  onPressed: isDisabled || isLoading ? () {} : onRegister,
                                ),
                              ],
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

          // DISABLED STATE MASK (disabled-state-mask)
          if (isDisabled && !isLoading)
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Container(
                  color: const Color(0xFFFFFFFF).withOpacity(0.5),
                ),
              ),
            ),

          // LOADER CONTAINER (loader-container)
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
    // Chip
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
      width: 182,
      height: 16,
      child: Row(
        children: [
          // SVG Icon (16x16)
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
          const SizedBox(width: 2), // gap: 2px
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
