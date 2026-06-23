import 'package:flutter/material.dart';

import '../../../../core/constants/images.dart';
import '../widgets/post_event_actions.dart';
import 'package:esri_eventos/features/historial/presentation/widgets/post_event_header.dart';
import '../widgets/post_event_info.dart';
import 'post_event_video_screen.dart'; // Al estar en la misma carpeta, va directo

class PostEventScreen extends StatelessWidget {
  const PostEventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final images = [
      Images.galeria1,
      Images.galeria2,
      Images.galeria3,
      Images.galeria4,
      Images.galeria5,
      Images.galeria1,
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: Column(
        children: [
          PostEventHeader(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  PostEventInfo(),
                  const SizedBox(height: 16),
                  PostEventActions(),
                  const SizedBox(height: 24),

                  const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 26,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Galería',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 26,
                    ),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: images.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemBuilder: (_, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const PostEventVideoScreen(),
                              ),
                            );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.asset(
                              images[index],
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}