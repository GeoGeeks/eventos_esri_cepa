import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/fonts.dart';

/// Ventana informativa de **Laboratorios** — explica el pre-registro antes
/// de que el asistente intente reservar un cupo. `InvitadosScreen` la
/// muestra la primera vez que se entra a la pestaña "Laboratorios" en cada
/// visita a la pantalla (ver `_cambiarTab`).
///
/// ⚠️ Sin ícono propio: el diseño trae un círculo con "i" que todavía no
/// está entre los SVG de `assets/icons/` (los demás, como
/// `SvgIcon.checkCirculo`, son para confirmación/error, no para
/// información) — se usa el ícono de información de Material mientras
/// tanto, mismo criterio de "no inventar el asset" que otros gaps
/// documentados de esta app.
class LaboratoriosInfoModal extends StatelessWidget {
  const LaboratoriosInfoModal({super.key});

  static const double ancho = 358;

  static Future<void> mostrar(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierColor: AppColors.modalOverlay,
      builder: (_) => const LaboratoriosInfoModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    const estiloCuerpo = TextStyle(
      fontFamily: Fonts.regular,
      fontSize: Fonts.textSm,
      fontWeight: Fonts.wRegular,
      height: 18 / 14,
      letterSpacing: 0,
      color: AppColors.textTitle,
    );
    const estiloFuerte = TextStyle(
      fontFamily: Fonts.bold,
      fontWeight: Fonts.wBold,
    );

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 27),
      child: Container(
        width: ancho,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(4),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 8, 16),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: AppColors.primary,
                    size: 22,
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Laboratorios de entrenamiento',
                      style: TextStyle(
                        fontFamily: Fonts.medium,
                        fontSize: 18,
                        fontWeight: Fonts.wMedium,
                        height: 22 / 18,
                        letterSpacing: 0,
                        color: AppColors.textTitle,
                      ),
                    ),
                  ),
                  GestureDetector(
                    key: const Key('laboratorios-info-cerrar'),
                    behavior: HitTestBehavior.opaque,
                    onTap: () => Navigator.of(context).pop(),
                    child: const SizedBox(
                      width: 32,
                      height: 32,
                      child: Icon(
                        Icons.close,
                        size: 18,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(height: 1, color: AppColors.surface3),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '¡Acceda primero a los laboratorios!',
                    style: TextStyle(
                      fontFamily: Fonts.medium,
                      fontSize: Fonts.text0h,
                      fontWeight: Fonts.wMedium,
                      height: 20 / 16,
                      letterSpacing: 0,
                      color: AppColors.textTitle,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Realice su pre-registro y asegure con anticipación su '
                    'cupo en el laboratorio de su interés.',
                    style: estiloCuerpo,
                  ),
                  const SizedBox(height: 12),
                  Text.rich(
                    TextSpan(
                      style: estiloCuerpo,
                      children: [
                        TextSpan(
                          text: 'IMPORTANTE: ',
                          style: estiloCuerpo.merge(estiloFuerte),
                        ),
                        const TextSpan(text: 'Si no alcanzó a reservar, '),
                        TextSpan(
                          text: 'aún puede participar',
                          style: estiloCuerpo.merge(estiloFuerte),
                        ),
                        const TextSpan(text: '. Acérquese al '),
                        TextSpan(
                          text: 'Salón EFG',
                          style: estiloCuerpo.merge(estiloFuerte),
                        ),
                        const TextSpan(text: ' a la hora del laboratorio, y '),
                        TextSpan(
                          text: 'si hay cupos disponibles, podrá ingresar.',
                          style: estiloCuerpo.merge(estiloFuerte),
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
    );
  }
}
