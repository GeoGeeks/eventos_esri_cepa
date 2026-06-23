import 'package:flutter/material.dart';

import '../../../../core/constants/images.dart';
import '../widgets/post_event_actions.dart';
import 'package:esri_eventos/features/historial/presentation/widgets/post_event_header.dart';
import '../widgets/post_event_info.dart';

class PostEventVideoScreen extends StatelessWidget {
  const PostEventVideoScreen({super.key});

  @override
  Widget build(BuildContext context) {
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

                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 26,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset(
                            Images.videoCover,
                            width: double.infinity,
                            height: 240,
                            fit: BoxFit.cover,
                          ),
                          Container(
                            width: 64,
                            height: 64,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.play_arrow,
                              size: 40,
                              color: Color(0xFF091F44),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 26,
                    ),
                    child: Text(
                      'Es un evento presencial gratuito donde podrá conocer historias, soluciones e innovaciones en el campo de la tecnología y los SIG.',
                      style: TextStyle(
                        color: Color(0xFF666666),
                        height: 1.5,
                      ),
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