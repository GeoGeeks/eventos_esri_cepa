import 'package:flutter/material.dart';

class PostEventActions extends StatelessWidget {
  const PostEventActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 26,
      ),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 44,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFF091F44),
                ),
                child: const Text(
                  'Valorar evento',
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: SizedBox(
              height: 44,
              child: OutlinedButton(
                onPressed: () {},
                child: const Text(
                  'Certificado',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}