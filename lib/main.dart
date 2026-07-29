import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/constants/fonts.dart';
import 'features/login/login_screen.dart';
import 'features/onboarding/presentation/bloc/onboarding_bloc.dart';

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
          fontFamily: Fonts.regular,
        ),
        // El flujo arranca en Iniciar Sesión; al ingresar pasa a Onboarding 1.
        home: const LoginScreen(),
      ),
    );
  }
}