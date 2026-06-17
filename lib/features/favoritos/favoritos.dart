import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/fonts.dart';

class FavoritosScreen extends StatefulWidget {
  const FavoritosScreen({super.key});

  @override
  State<FavoritosScreen> createState() => _FavoritosScreenState();
}

class _FavoritosScreenState extends State<FavoritosScreen> {
  final List<bool> expanded = [false, false, true];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.primary,
            child: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
              size: 16,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Favoritos del evento',
          style: TextStyle(
            fontFamily: Fonts.avenir,
            color: Color(0xFF141414),
            fontSize: Fonts.titleLarge,
            fontWeight: FontWeight.w500,
            height: 32 / 26,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 8),

            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.search,
                          size: 18,
                          color: AppColors.textSubtle,
                        ),
                        hintText: 'Buscar',
                        hintStyle: TextStyle(
                          color: AppColors.textSubtle,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 40,
                  height: 40,
                  color: AppColors.primary,
                  child: const Icon(
                    Icons.filter_alt_outlined,
                    color: Colors.white,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Expanded(
              child: ListView.builder(
                itemCount: expanded.length,
                itemBuilder: (_, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _FavoritoCard(
                      expanded: expanded[index],
                      onTap: () {
                        setState(() {
                          expanded[index] = !expanded[index];
                        });
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FavoritoCard extends StatelessWidget {
  final bool expanded;
  final VoidCallback onTap;

  const _FavoritoCard({required this.expanded, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: Text(
                  'Encuestas avanzadas incorporando Inteligencia Artificial en ArcGIS Survey123',
                  style: TextStyle(
                    fontFamily: Fonts.avenir,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textTitle,
                    height: 1.1,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '10:00 · 11:00',
                style: TextStyle(color: Colors.grey.shade400, fontSize: 11),
              ),
              IconButton(
                onPressed: onTap,
                icon: Icon(
                  expanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: AppColors.textSubtle,
                ),
              ),
            ],
          ),

          const SizedBox(height: 4),

          const Row(
            children: [
              Icon(Icons.person_outline, size: 14, color: AppColors.textSubtle),
              SizedBox(width: 4),
              Text(
                'Julian Gutiérrez',
                style: TextStyle(color: AppColors.textSubtle, fontSize: 13),
              ),
            ],
          ),

          const SizedBox(height: 2),

          const Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 14,
                color: AppColors.textSubtle,
              ),
              SizedBox(width: 4),
              Text(
                'Auditorio 103',
                style: TextStyle(color: AppColors.textSubtle, fontSize: 13),
              ),
            ],
          ),

          const SizedBox(height: 2),

          const Row(
            children: [
              Icon(Icons.people_outline, size: 14, color: AppColors.textSubtle),
              SizedBox(width: 4),
              Text(
                'Aforo 30 personas',
                style: TextStyle(color: AppColors.textSubtle, fontSize: 13),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              _chip('Avanzado'),
              const SizedBox(width: 6),
              _chip('Tecnología'),
              const SizedBox(width: 6),
              _chip('GeoIA'),
              const Spacer(),
              const Text(
                'Valorar',
                style: TextStyle(color: AppColors.primary, fontSize: 13),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              const Spacer(),
              Icon(Icons.star, color: AppColors.primary),
            ],
          ),

          if (expanded) ...[
            const SizedBox(height: 12),

            const Text(
              'Integre modelos de Deep Learning para la detección de objetos en formularios de Survey123, conozca cómo la IA apoya los flujos de recolección de información.',
              style: TextStyle(color: AppColors.textSubtle, fontSize: 13),
            ),

            const SizedBox(height: 12),

            const Text(
              'Objetivos',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 8),

            const Text(
              '1. Integre modelos de Deep Learning para la detección de objetos.\n\n'
              '2. Conozca cómo la IA apoya los flujos de recolección.\n\n'
              '3. Aprenda a incorporar modelos en Survey123.',
              style: TextStyle(color: AppColors.textSubtle, fontSize: 13),
            ),
          ],
        ],
      ),
    );
  }

  static Widget _chip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.chipBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 11, color: AppColors.primary),
      ),
    );
  }
}
