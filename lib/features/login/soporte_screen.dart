import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/fonts.dart';

import 'widgets/fondo_inicio.dart';

class SoporteScreen extends StatefulWidget {
  const SoporteScreen({super.key});

  @override
  State<SoporteScreen> createState() => _SoporteScreenState();
}

class _SoporteScreenState extends State<SoporteScreen> {
  final correoController = TextEditingController();
  final documentoController = TextEditingController();
  final mensajeController = TextEditingController();

  @override
  void dispose() {
    correoController.dispose();
    documentoController.dispose();
    mensajeController.dispose();
    super.dispose();
  }

  void enviarSolicitud() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Solicitud enviada correctamente')),
    );

    Navigator.popUntil(context, (route) => route.isFirst);
  }

  InputDecoration inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        fontFamily: Fonts.regular,
        color: AppColors.textSubtle,
      ),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.inputBorder),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.primary),
      ),
    );
  }

  Widget tituloCampo(String texto) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        texto,
        style: TextStyle(
          fontFamily: Fonts.regular,
          fontSize: 14,
          color: AppColors.textTitle,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: FondoInicio(
        child: Container(
          width: 360,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(2),
          ),
         
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Contactar a soporte',
                style: TextStyle(
                  fontFamily: Fonts.medium,
                  fontSize: 26,
                  color: AppColors.textTitle,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                'Completa la siguiente información para ayudarte con el acceso a la aplicación.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: Fonts.regular,
                  fontSize: 14,
                  color: AppColors.textSubtle,
                ),
              ),

              const SizedBox(height: 28),

              tituloCampo('Correo electrónico'),

              const SizedBox(height: 8),

              TextField(
                controller: correoController,
                keyboardType: TextInputType.emailAddress,
                decoration: inputDecoration('correo@ejemplo.com'),
              ),

              const SizedBox(height: 20),

              tituloCampo('Número de identificación'),

              const SizedBox(height: 8),

              TextField(
                controller: documentoController,
                keyboardType: TextInputType.number,
                decoration: inputDecoration('000000000'),
              ),

              const SizedBox(height: 20),

              tituloCampo('Describe el inconveniente'),

              const SizedBox(height: 8),

              TextField(
                controller: mensajeController,
                maxLines: 5,
                decoration: inputDecoration('Escribe aquí tu mensaje...'),
              ),

              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: const RoundedRectangleBorder(),
                  ),
                  onPressed: enviarSolicitud,
                  child: Text(
                    'Enviar',
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
      ),
    );
  }
}
