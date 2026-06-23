import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/fonts.dart';

class FiltroPanel extends StatelessWidget {
  final String titulo;

  const FiltroPanel({
    super.key,
    required this.titulo,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titulo,
          style: const TextStyle(
            fontFamily: Fonts.avenir,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.modalSubtitle,
          ),
        ),

        const SizedBox(height: 8),

        /// ÚNICA LÍNEA QUE DEBE APARECER
        const Divider(
          height: 1,
          thickness: 1,
          color: AppColors.lightGray,
        ),

        const SizedBox(height: 12),

        /// OPCIONES
        ...List.generate(
          4,
          (index) => Theme(
            data: Theme.of(context).copyWith(
              visualDensity: VisualDensity.compact,
            ),
            child: CheckboxListTile(
              value: false,
              onChanged: (_) {},
              dense: true,
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: AppColors.primary,
              side: const BorderSide(
                color: AppColors.textSubtle,
                width: 1,
              ),
              title: Text(
                'Combobox item ${index + 1}',
                style: const TextStyle(
                  fontFamily: Fonts.avenir,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textTitle,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}