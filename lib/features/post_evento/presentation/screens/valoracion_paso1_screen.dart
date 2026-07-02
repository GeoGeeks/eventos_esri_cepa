import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/fonts.dart';
import 'valoracion_paso2_screen.dart';

class ValoracionPaso1Screen extends StatefulWidget {
  const ValoracionPaso1Screen({super.key});

  @override
  State<ValoracionPaso1Screen> createState() =>
      _ValoracionPaso1ScreenState();
}

class _ValoracionPaso1ScreenState
    extends State<ValoracionPaso1Screen> {

  int rating = 0;

  bool dia1 = false;
  bool dia2 = false;
  bool dia3 = false;

  String? laboratorio;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 12,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// BOTON ATRAS
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.chevron_left,
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 18),

              /// TITULO PEQUEÑO
              const Center(
                child: Text(
                  'Queremos saber tu opinión',
                  style: TextStyle(
                    fontFamily: Fonts.regular,
                    fontSize: Fonts.body,
                    color: AppColors.modalSubtitle,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              /// TITULO
              const Center(
                child: Text(
                  'CUE 2026',
                  style: TextStyle(
                    fontFamily: Fonts.regular,
                    fontSize: 26,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textTitle,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// STEPPER
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 2,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      height: 2,
                      color: AppColors.lightGray,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              /// ¿QUE TE PARECIO?
              RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontFamily: Fonts.regular,
                    fontSize: Fonts.body,
                    color: AppColors.textTitle,
                  ),
                  children: [
                    TextSpan(text: '¿Qué te pareció?'),
                    TextSpan(
                      text: ' *',
                      style: TextStyle(
                        color: AppColors.requiredField,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: List.generate(
                  5,
                  (i) => IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      setState(() {
                        rating = i + 1;
                      });
                    },
                    icon: Icon(
                      rating > i
                          ? Icons.star
                          : Icons.star_border,
                      size: 36,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              /// CUENTANOS
              const Text(
                'Cuéntanos más (Opcional)',
                style: TextStyle(
                  fontFamily: Fonts.regular,
                  fontSize: Fonts.body,
                ),
              ),

              const SizedBox(height: 8),

              SizedBox(
                height: 120,
                child: TextField(
                  maxLines: null,
                  expands: true,
                  decoration: InputDecoration(
                    hintText:
                        'Escribe tu comentario aquí...',
                    hintStyle: const TextStyle(
                      fontFamily: Fonts.regular,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.inputBorder,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// LABORATORIOS
              RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontFamily: Fonts.regular,
                    fontSize: Fonts.body,
                    color: AppColors.textTitle,
                  ),
                  children: [
                    TextSpan(
                      text:
                          'Participó en los Laboratorios de entrenamiento',
                    ),
                    TextSpan(
                      text: ' *',
                      style: TextStyle(
                        color: AppColors.requiredField,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              DropdownButtonFormField<String>(
                value: laboratorio,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                hint: const Text(
                  'Seleccione',
                  style: TextStyle(
                    fontFamily: Fonts.regular,
                  ),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'si',
                    child: Text('Sí'),
                  ),
                  DropdownMenuItem(
                    value: 'no',
                    child: Text('No'),
                  ),
                ],
                onChanged: (v) {
                  setState(() {
                    laboratorio = v;
                  });
                },
              ),

              const SizedBox(height: 20),

              /// CUENTANOS
              const Text(
                'Cuéntanos más (Opcional)',
                style: TextStyle(
                  fontFamily: Fonts.regular,
                  fontSize: Fonts.body,
                ),
              ),

              const SizedBox(height: 8),

              SizedBox(
                height: 120,
                child: TextField(
                  maxLines: null,
                  expands: true,
                  decoration: InputDecoration(
                    hintText:
                        'Escribe tu comentario aquí...',
                    hintStyle: const TextStyle(
                      fontFamily: Fonts.regular,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.inputBorder,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// DIAS
              RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontFamily: Fonts.regular,
                    fontSize: Fonts.body,
                    color: AppColors.textTitle,
                  ),
                  children: [
                    TextSpan(
                      text:
                          'Seleccione los días en los que participó',
                    ),
                    TextSpan(
                      text: ' *',
                      style: TextStyle(
                        color: AppColors.requiredField,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              CheckboxListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                value: dia1,
                onChanged: (v) {
                  setState(() {
                    dia1 = v!;
                  });
                },
                title: const Text(
                  'Día 1',
                  style: TextStyle(
                    fontFamily: Fonts.regular,
                  ),
                ),
                controlAffinity:
                    ListTileControlAffinity.leading,
              ),

              CheckboxListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                value: dia2,
                onChanged: (v) {
                  setState(() {
                    dia2 = v!;
                  });
                },
                title: const Text(
                  'Día 2',
                  style: TextStyle(
                    fontFamily: Fonts.regular,
                  ),
                ),
                controlAffinity:
                    ListTileControlAffinity.leading,
              ),

              CheckboxListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                value: dia3,
                onChanged: (v) {
                  setState(() {
                    dia3 = v!;
                  });
                },
                title: const Text(
                  'Día 3',
                  style: TextStyle(
                    fontFamily: Fonts.regular,
                  ),
                ),
                controlAffinity:
                    ListTileControlAffinity.leading,
              ),

              const SizedBox(height: 30),

              /// BOTON
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        AppColors.primary,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const ValoracionPaso2Screen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Continuar',
                    style: TextStyle(
                      fontFamily: Fonts.regular,
                      fontSize: Fonts.body,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}