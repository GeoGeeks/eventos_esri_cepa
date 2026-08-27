import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constants/fonts.dart';
import '../utils/formato_fecha.dart';

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

  // Estados de carga y deshabilitado
  final bool isLoading;
  final bool isDisabled;

  final String secondaryLabel;
  final double actionsGap;
  final double? viewMoreWidth;
  final double? secondaryWidth;

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
    this.secondaryLabel = 'Registrarse',
    this.actionsGap = 8,
    this.viewMoreWidth,
    this.secondaryWidth,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 360,
      child: Stack(
        children: [
          // Card Container
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Container(
              color: const Color(0xFFFFFFFF),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // IMAGE - Ancho fijo según CSS (138px)
                    SizedBox(
                      width: 138,
                      child: Image.asset(
                        image,
                        fit: BoxFit.cover,
                      ),
                    ),

                    // CONTENT CONTAINER - Ocupa todo el espacio disponible sin desbordar
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // HEADER
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 12,
                              top: 8,
                              right: 12,
                              bottom: 4,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Título + Chip
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      // Sin maxLines ni ellipsis: el título
                                      // crece en líneas antes que recortarse.
                                      child: Text(
                                        title,
                                        style: const TextStyle(
                                          fontFamily: Fonts.medium,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF141414),
                                          height: 24 / 18,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    _ModeChip(label: mode),
                                  ],
                                ),
                                const SizedBox(height: 6),

                                // Filas de Información (Fecha y Ubicación)
                                _InfoRow(
                                  iconPath: 'assets/icons/date-time.svg',
                                  // Mismo criterio que EventCard: el mes se
                                  // abrevia aquí, no en los datos.
                                  text: FormatoFecha.mesCorto(date),
                                ),
                                const SizedBox(height: 4),
                                _InfoRow(
                                  iconPath: 'assets/icons/lugar.svg',
                                  text: location,
                                ),
                              ],
                            ),
                          ),

                          // FOOTER
                          Padding(
                            padding: const EdgeInsets.only(
                              right: 12,
                              bottom: 8,
                              left: 12,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Estado Historial alineado abajo según CSS (align-items: flex-start con flex-direction: column / justify-content: flex-end equivalente)
                                if (isHistorial)
                                  SizedBox(
                                    height: 32,
                                    child: Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 14,
                                            height: 14,
                                            child: SvgPicture.asset(
                                              'assets/icons/vector.svg',
                                              colorFilter: const ColorFilter.mode(
                                                Color(0xFFDA7C0B),
                                                BlendMode.srcIn,
                                              ),
                                              placeholderBuilder: (_) =>
                                                  const Icon(
                                                Icons.error_outline,
                                                size: 14,
                                                color: Color(0xFFDA7C0B),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            estado ?? 'Finalizado',
                                            style: const TextStyle(
                                              fontFamily: Fonts.regular,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color: Color(0xFFDA7C0B),
                                              height: 16 / 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                else
                                  const SizedBox.shrink(),

                                // Botones según el modo
                                if (isHistorial)
                                  _PrimaryButton(
                                    label: "Ver más",
                                    onPressed: isDisabled || isLoading
                                        ? () {}
                                        : onViewMore,
                                  )
                                else
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      _OutlineButton(
                                        label: "Ver más",
                                        width: viewMoreWidth,
                                        onPressed: isDisabled || isLoading
                                            ? () {}
                                            : onViewMore,
                                      ),
                                      SizedBox(width: actionsGap),
                                      _PrimaryButton(
                                        label: secondaryLabel,
                                        width: secondaryWidth,
                                        onPressed: isDisabled || isLoading
                                            ? () {}
                                            : onRegister,
                                      ),
                                    ],
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

          // LOADER STATE
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
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFF007AC2),
                        ),
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
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
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
    return Row(
      // La fecha y el lugar pueden ocupar varias líneas; el ícono se queda
      // alineado con la primera.
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
        const SizedBox(width: 4),
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
  final double? width;

  const _OutlineButton({
    required this.label,
    required this.onPressed,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: width,
        height: 32,
        padding: width == null
            ? const EdgeInsets.symmetric(horizontal: 12)
            : EdgeInsets.zero,
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
            letterSpacing: 0,
          ),
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final double? width;

  const _PrimaryButton({
    required this.label,
    required this.onPressed,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: width,
        height: 32,
        padding: width == null
            ? const EdgeInsets.symmetric(horizontal: 12)
            : EdgeInsets.zero,
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
            letterSpacing: 0,
          ),
        ),
      ),
    );
  }
}
