import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constants/fonts.dart';
import '../utils/formato_fecha.dart';

class EventCard extends StatelessWidget {
  final String title;
  final String date;
  final String location;
  final String image;
  final VoidCallback onViewMore;
  final VoidCallback onCredential;
  final bool isLoading; // Para .card-loading
  final bool isDisabled; // Para .card-disabled

  const EventCard({
    super.key,
    required this.title,
    required this.date,
    required this.location,
    required this.image,
    required this.onViewMore,
    required this.onCredential,
    this.isLoading = false,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    // .card — el alto lo marca el contenido: si el título ocupa 2 o 3 líneas
    // la tarjeta crece en vez de recortarlo. El carrusel iguala las alturas.
    return SizedBox(
      width: 237,
      child: Stack(
        children: [
          // .card-container
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Container(
              width: 237,
              color: const Color(0xFFFFFFFF), // background: #FFFFFF
              // Sin mainAxisSize.min: así el blanco llega hasta abajo cuando
              // el carrusel estira esta tarjeta para igualarla con la más alta.
              child: Column(
                children: [
                  // IMAGE (.card-image)
                  Image.asset(
                    image,
                    width: 237,
                    height: 131,
                    fit: BoxFit.cover,
                  ),

                  // CONTENT (.card-content)
                  SizedBox(
                    width: 237,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // HEADER (.card-header / .card-header-content)
                        SizedBox(
                          width: 237,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(12, 8, 12, 4), // padding: 8px 12px 4px
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Title (.card-title)
                                Text(
                                  title,
                                  style: const TextStyle(
                                    fontFamily: Fonts.medium,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF141414),
                                    height: 24 / 20,
                                  ),
                                ),

                                const SizedBox(height: 2), // gap: 2px

                                // Info Column (.card-info)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _InfoRow(
                                      iconPath: 'assets/icons/date-time.svg',
                                      // El mes va siempre abreviado, venga
                                      // como venga en los datos.
                                      text: FormatoFecha.mesCorto(date),
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
                        ),

                        // FOOTER (.card-footer)
                        SizedBox(
                          width: 237,
                          height: 52,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                // .card-footer-actions (gap: 8px)
                                _OutlineButton(
                                  label: "Ver más",
                                  onPressed: isDisabled || isLoading ? () {} : onViewMore,
                                ),
                                const SizedBox(width: 8),
                                _PrimaryButton(
                                  label: "Mi credencial",
                                  onPressed: isDisabled || isLoading ? () {} : onCredential,
                                ),
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

          // DISABLED MASK (.card-disabled)
          if (isDisabled && !isLoading)
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Container(
                  color: const Color(0xFFFFFFFF).withOpacity(0.5), // rgba(255,255,255,.5)
                ),
              ),
            ),

          // LOADER OVERLAY (.card-loading)
          if (isLoading)
            Positioned(
              top: 1,
              left: 1,
              right: 1,
              bottom: 1, // inset: 1px
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Container(
                  color: const Color(0xFFFFFFFF),
                  child: const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF007AC2)),
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

class _InfoRow extends StatelessWidget {
  final String iconPath;
  final String text;

  const _InfoRow({
    required this.iconPath,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      // El texto puede ocupar varias líneas; el ícono se alinea con la primera.
      crossAxisAlignment: CrossAxisAlignment.start,
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
        width: 82,
        height: 36,
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
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Color(0xFF007AC2),
            height: 20 / 16,
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
        width: 123,
        height: 36,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: Color(0xFF007AC2),
          borderRadius: BorderRadius.zero,
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontFamily: Fonts.regular,
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.white,
            height: 20 / 16,
          ),
        ),
      ),
    );
  }
}
