import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/fonts.dart';

class ValoracionModal extends StatefulWidget {
  const ValoracionModal({super.key});

  @override
  State<ValoracionModal> createState() => _ValoracionModalState();
}

class _ValoracionModalState extends State<ValoracionModal> {
  int estrellasSeleccionadas = 0;
  final TextEditingController comentarioController =
      TextEditingController();

  @override
  void dispose() {
    comentarioController.dispose();
    super.dispose();
  }

  Widget _estrella(int index) {
    final bool seleccionada = index <= estrellasSeleccionadas;

    return GestureDetector(
      onTap: () {
        setState(() {
          estrellasSeleccionadas = index;
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 6),
        child: Icon(
          seleccionada ? Icons.star : Icons.star_border,
          size: 30,
          color: AppColors.textSubtle,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 430,
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(
                Icons.close,
                size: 14,
                color: AppColors.textSubtle,
              ),
            ),
          ),

          const SizedBox(height: 4),

          const Center(
            child: Text(
              'Queremos saber tu opinión',
              style: TextStyle(
                fontFamily: Fonts.avenir,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.modalSubtitle,
              ),
            ),
          ),

          const SizedBox(height: 6),

          const Center(
            child: Text(
              'Charla Educación y SIG',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: Fonts.avenir,
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: AppColors.textTitle,
              ),
            ),
          ),

          const SizedBox(height: 22),

          RichText(
            text: const TextSpan(
              style: TextStyle(
                fontFamily: Fonts.avenir,
                fontSize: 14,
                color: AppColors.textTitle,
              ),
              children: [
                TextSpan(text: '¿Qué te pareció? '),
                TextSpan(
                  text: '*',
                  style: TextStyle(
                    color: AppColors.requiredField,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              _estrella(1),
              _estrella(2),
              _estrella(3),
              _estrella(4),
              _estrella(5),
            ],
          ),

          const SizedBox(height: 20),

          const Text(
            'Cuéntanos más (Opcional)',
            style: TextStyle(
              fontFamily: Fonts.avenir,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.textTitle,
            ),
          ),

          const SizedBox(height: 8),

          SizedBox(
            height: 90,
            child: TextField(
              controller: comentarioController,
              maxLines: 5,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(12),
                hintText: 'Escribe tu comentario aquí...',
                hintStyle: TextStyle(
                  fontFamily: Fonts.avenir,
                  fontSize: 14,
                  color: AppColors.textSubtle,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                  borderSide: BorderSide(
                    color: AppColors.inputBorder,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                  borderSide: BorderSide(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ),

          const Spacer(),

          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: AppColors.primary,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Enviar valoración',
                style: TextStyle(
                  fontFamily: Fonts.avenir,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}