// lib/features/login/verificacion_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/fonts.dart';
import '../../../core/constants/icons.dart';
import '../../../core/constants/images.dart';

import 'soporte_screen.dart';

class VerificacionScreen extends StatefulWidget {
  const VerificacionScreen({super.key});

  @override
  State<VerificacionScreen> createState() => _VerificacionScreenState();
}

class _VerificacionScreenState extends State<VerificacionScreen> {
  final TextEditingController documentoController = TextEditingController();

  @override
  void dispose() {
    documentoController.dispose();
    super.dispose();
  }

  void contactarSoporte() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const SoporteScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          Positioned.fill(
            child: SvgPicture.asset(
              Images.backgroundInicio,
              fit: BoxFit.cover,
            ),
          ),

          SafeArea(
            child: Column(
              children: [

                const SizedBox(height: 28),

                SvgPicture.asset(
                  Images.logoApp,
                  width: 72,
                ),

                const SizedBox(height: 18),

                Text(
                  'Eventos Esri',
                  style: TextStyle(
                    fontFamily: Fonts.bold,
                    fontSize: 40,
                    height: 48 / 40,
                    color: AppColors.white,
                  ),
                ),

                const Spacer(),

                Container(
                  width: 360,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      SvgPicture.asset(
                        SvgIcon.avisoRojo,
                        width: 46,
                      ),

                      const SizedBox(height: 18),

                      Text(
                        'Verificación',
                        style: TextStyle(
                          fontFamily: Fonts.medium,
                          fontSize: 26,
                          color: AppColors.textTitle,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        'No encontramos un registro asociado al número de identificación ingresado.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: Fonts.regular,
                          fontSize: 14,
                          color: AppColors.textSubtle,
                        ),
                      ),

                      const SizedBox(height: 28),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Número de identificación',
                          style: TextStyle(
                            fontFamily: Fonts.regular,
                            fontSize: 14,
                            color: AppColors.textTitle,
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      TextField(
                        controller: documentoController,
                        decoration: InputDecoration(

                          prefixIcon: const Icon(
                            Icons.person_outline,
                            color: AppColors.textSubtle,
                          ),

                          hintText: '00000000',

                          hintStyle: TextStyle(
                            fontFamily: Fonts.regular,
                            color: AppColors.textSubtle,
                          ),

                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.inputBorder,
                            ),
                          ),

                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 18),

                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xffFFF4F4),
                          border: Border.all(
                            color: AppColors.requiredField,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            SvgPicture.asset(
                              SvgIcon.avisoBorde,
                              width: 22,
                            ),

                            const SizedBox(width: 10),

                            Expanded(
                              child: Text(
                                'No encontramos este número de identificación. '
                                'Verifica la información o comunícate con soporte.',
                                style: TextStyle(
                                  fontFamily: Fonts.regular,
                                  fontSize: 13,
                                  color: AppColors.requiredField,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      SizedBox(
                        width: double.infinity,
                        height: 44,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: const RoundedRectangleBorder(),
                          ),
                          onPressed: contactarSoporte,
                          child: Text(
                            'Contactar a soporte',
                            style: TextStyle(
                              fontFamily: Fonts.medium,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                SvgPicture.asset(
                  Images.esriBlanco,
                  width: 158,
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}