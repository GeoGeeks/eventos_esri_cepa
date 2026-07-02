import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../widgets/valoracion_success_dialog.dart';

class ValoracionPaso2Screen extends StatefulWidget {
  const ValoracionPaso2Screen({super.key});

  @override
  State<ValoracionPaso2Screen> createState() => _ValoracionPaso2ScreenState();
}

class _ValoracionPaso2ScreenState extends State<ValoracionPaso2Screen> {
  String? deseaContacto;
  String? volveria1;
  String? laboratorio1;
  String? laboratorio2;
  String? volveria2;

  bool dia1 = false;
  bool dia2 = false;
  bool dia3 = false;

  bool acepta1 = false;
  bool acepta2 = false;

  final opciones = ['Sí', 'No'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// BOTON ATRAS
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.chevron_left, color: Colors.white),
                ),
              ),

              const SizedBox(height: 12),

              const Center(
                child: Text(
                  'Queremos saber tu opinión',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.modalSubtitle,
                  ),
                ),
              ),

              const SizedBox(height: 6),

              const Center(
                child: Text(
                  'CUE 2026',
                  style: TextStyle(fontSize: 34, fontWeight: FontWeight.w500),
                ),
              ),

              const SizedBox(height: 20),

              /// STEPPER
              Row(
                children: [
                  Expanded(
                    child: Container(height: 2, color: AppColors.primary),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(height: 2, color: AppColors.primary),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              /// Desea ser contactado
              _dropdown(
                titulo: 'Desea ser contactado',
                value: deseaContacto,
                onChanged: (v) {
                  setState(() {
                    deseaContacto = v;
                  });
                },
              ),

              const SizedBox(height: 18),

              /// Volvería a participar
              _dropdown(
                titulo: 'Volvería a participar',
                value: volveria1,
                onChanged: (v) {
                  setState(() {
                    volveria1 = v;
                  });
                },
              ),

              const SizedBox(height: 18),

              /// Laboratorio
              _dropdown(
                titulo: 'Participó en los Laboratorios de entrenamiento',
                value: laboratorio1,
                onChanged: (v) {
                  setState(() {
                    laboratorio1 = v;
                  });
                },
              ),

              const SizedBox(height: 18),

              /// Laboratorio 2
              _dropdown(
                titulo: 'Participó en los Laboratorios de entrenamiento',
                value: laboratorio2,
                onChanged: (v) {
                  setState(() {
                    laboratorio2 = v;
                  });
                },
              ),

              const SizedBox(height: 20),

              const Text(
                'Seleccione los días en los que participó',
                style: TextStyle(fontSize: 15),
              ),

              const SizedBox(height: 10),

              CheckboxListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                value: dia1,
                onChanged: (v) {
                  setState(() => dia1 = v!);
                },
                title: const Text('Día 1'),
                controlAffinity: ListTileControlAffinity.leading,
              ),

              CheckboxListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                value: dia2,
                onChanged: (v) {
                  setState(() => dia2 = v!);
                },
                title: const Text('Día 2'),
                controlAffinity: ListTileControlAffinity.leading,
              ),

              CheckboxListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                value: dia3,
                onChanged: (v) {
                  setState(() => dia3 = v!);
                },
                title: const Text('Día 3'),
                controlAffinity: ListTileControlAffinity.leading,
              ),

              const SizedBox(height: 18),

              /// Volvería
              _dropdown(
                titulo: 'Volvería a participar',
                value: volveria2,
                onChanged: (v) {
                  setState(() {
                    volveria2 = v;
                  });
                },
              ),

              const SizedBox(height: 18),

              CheckboxListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                value: acepta1,
                onChanged: (v) {
                  setState(() {
                    acepta1 = v!;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
                title: const Text(
                  'Autorizo el tratamiento de mis datos y acepto los Términos y Condiciones.',
                  style: TextStyle(fontSize: 12),
                ),
              ),

              CheckboxListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                value: acepta2,
                onChanged: (v) {
                  setState(() {
                    acepta2 = v!;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
                title: const Text(
                  'Autorizo el tratamiento de mis datos y acepto los Términos y Condiciones.',
                  style: TextStyle(fontSize: 12),
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      barrierColor: Colors.black54,
                      builder: (_) => const ValoracionSuccessDialog(),
                    );
                  },
                  child: const Text(
                    'Continuar',
                    style: TextStyle(color: Colors.white),
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

  Widget _dropdown({
    required String titulo,
    required String? value,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: const TextStyle(color: Colors.black, fontSize: 15),
            children: [
              TextSpan(text: titulo),
              const TextSpan(
                text: ' *',
                style: TextStyle(color: AppColors.requiredField),
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        DropdownButtonFormField<String>(
          value: value,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          hint: const Text('Seleccione'),
          items: opciones
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
