import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/fonts.dart';
import '../../../core/constants/icons.dart';
import '../../../core/widgets/app_icons.dart';
import '../../invitados/invitados.dart';

class CabeceraActividades extends StatelessWidget {
  final String titulo;
  final VoidCallback onVolver;

  const CabeceraActividades({
    super.key,
    required this.titulo,
    required this.onVolver,
  });

  @override
  Widget build(BuildContext context) {
    // Mínimo de 36 —el alto del botón de volver—, pero la cabecera crece si el
    // título necesita más de un renglón.
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 36),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          BotonVolver(onTap: onVolver),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              titulo,
              style: const TextStyle(
                fontFamily: Fonts.medium,
                fontSize: Fonts.text3h,
                fontWeight: Fonts.wMedium,
                height: 32 / 26,
                letterSpacing: 0,
                color: AppColors.textTitle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BuscadorActividades extends StatelessWidget {
  final ValueChanged<String> onBuscar;
  final VoidCallback onFiltrar;

  const BuscadorActividades({
    super.key,
    required this.onBuscar,
    required this.onFiltrar,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 32,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  border: Border.all(color: AppColors.textSubtle),
                ),
                padding: const EdgeInsets.only(left: 12, right: 12),
                child: Row(
                  children: [
                    const AppIcon(
                      SvgIcon.search,
                      width: 16,
                      height: 16,
                      color: AppColors.textMuted,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        onChanged: onBuscar,
                        cursorColor: AppColors.primary,
                        textAlignVertical: TextAlignVertical.center,
                        style: const TextStyle(
                          fontFamily: Fonts.regular,
                          fontSize: Fonts.textSm,
                          fontWeight: Fonts.wRegular,
                          height: 20 / 14,
                          letterSpacing: 0,
                          color: AppColors.textTitle,
                        ),
                        decoration: const InputDecoration(
                          isCollapsed: true,
                          border: InputBorder.none,
                          hintText: 'Buscar',
                          hintStyle: TextStyle(
                            fontFamily: Fonts.regular,
                            fontSize: Fonts.textSm,
                            fontWeight: Fonts.wRegular,
                            height: 20 / 14,
                            letterSpacing: 0,
                            color: Color(0x80141414),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            key: const Key('boton-filtro'),
            onTap: onFiltrar,
            child: Container(
              width: 32,
              height: 32,
              color: AppColors.primary,
              alignment: Alignment.center,
              child: const AppIcon(
                SvgIcon.filtro,
                width: 16,
                height: 16,
                color: AppColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
