import 'package:flutter/material.dart';

class ECardScreen extends StatelessWidget {
  const ECardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('E-Card'),
      ),
      body: const Center(
        child: Text(
          'E-Card de Maria Lopez',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}