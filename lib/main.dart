import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'features/onboarding/presentation/screens/onboarding_screen.dart';

void main() {
  runApp(const EsriEventosApp());
}

class EsriEventosApp extends StatelessWidget {
  const EsriEventosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => OnboardingBloc(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Esri Eventos',
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: 'AvenirNext',
        ),
        home: const OnboardingScreen(),
      ),
    );
  }
}