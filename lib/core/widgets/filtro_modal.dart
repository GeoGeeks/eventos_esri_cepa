import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import 'filtro_chip.dart';
import 'filtro_panel.dart';

class FiltroModal extends StatefulWidget {
  const FiltroModal({super.key});

  @override
  State<FiltroModal> createState() => _FiltroModalState();
}

class _FiltroModalState extends State<FiltroModal> {
  final List<String> categorias = [
    'Lugar',
    'Actividad',
    'Temática',
    'Nivel',
    'Producto',
  ];

  List<String> seleccionados = [
    'Lugar',
    'Actividad',
    'Temática',
  ];

  void toggleFiltro(String filtro) {
    setState(() {
      if (seleccionados.contains(filtro)) {
        seleccionados.remove(filtro);
      } else {
        seleccionados.add(filtro);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.72,
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      child: Column(
        children: [
          /// BOTÓN CERRAR
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.close,
                color: AppColors.textSubtle,
                size: 18,
              ),
            ),
          ),

          Expanded(
            child: Row(
              children: [
                /// PANEL IZQUIERDO
                Container(
                  width: 110,
                  color: AppColors.lightGray,
                  child: ListView(
                    padding: const EdgeInsets.all(12),
                    children: categorias.map((categoria) {
                      return FiltroChip(
                        title: categoria,
                        selected: seleccionados.contains(categoria),
                        onTap: () => toggleFiltro(categoria),
                      );
                    }).toList(),
                  ),
                ),

                /// PANEL DERECHO
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          color: AppColors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: ListView(
                            children: seleccionados
                                .map(
                                  (filtro) => Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: 24,
                                    ),
                                    child: FiltroPanel(
                                      titulo: filtro,
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ),

                      /// BOTONES INFERIORES
                      Container(
                        width: double.infinity,
                        color: AppColors.white,
                        padding: const EdgeInsets.fromLTRB(
                          16,
                          12,
                          16,
                          24,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              height: 36,
                              child: OutlinedButton(
                                onPressed: () {
                                  setState(() {
                                    seleccionados.clear();
                                  });
                                },
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: AppColors.white,
                                  side: const BorderSide(
                                    color: AppColors.primary,
                                  ),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero,
                                  ),
                                ),
                                child: const Text(
                                  'Limpiar filtros',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(width: 8),

                            SizedBox(
                              height: 36,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: AppColors.white,
                                  elevation: 0,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero,
                                  ),
                                ),
                                child: const Text(
                                  'Aplicar',
                                ),
                              ),
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
        ],
      ),
    );
  }
}