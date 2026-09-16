import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:esri_eventos/features/login/presentation/bloc/auth_cubit.dart';
import 'package:esri_eventos/features/onboarding/data/onboarding_storage.dart';
import 'package:esri_eventos/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:esri_eventos/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:esri_eventos/navigation/menu.dart';

import 'fuentes_de_prueba.dart';

/// Doble de [OnboardingStorage] en memoria - registra si `marcarVisto()` se
/// llegó a llamar, sin tocar el canal de plataforma real.
class _FakeOnboardingStorage implements OnboardingStorage {
  bool marcarVistoLlamado = false;

  @override
  Future<bool> yaVisto() async => false;

  @override
  Future<void> marcarVisto() async => marcarVistoLlamado = true;
}

Future<void> _montarOnboarding(
  WidgetTester tester,
  _FakeOnboardingStorage storage,
) async {
  tester.view.physicalSize = const Size(412, 917);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  // Los providers van AFUERA de `MaterialApp`, no dentro de `home` - `Menu`
  // se llega navegando a una ruta NUEVA (`Navigator.pushReplacement`), y un
  // provider puesto solo alrededor de `home` queda fuera del scope de esa
  // ruta nueva (las rutas del Navigator son "hermanas", no descendientes
  // unas de otras) - de ahí salía un `ProviderNotFoundException` al
  // construir `Menu`.
  await tester.pumpWidget(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => OnboardingBloc()),
        // Requerido por Menu.initState() al llegar ahí (lee el estado de
        // sesión para decidir esColaborador) - no se usa para loguearse en
        // este test, solo para que el árbol de widgets no reviente.
        BlocProvider(create: (_) => AuthCubit()),
      ],
      child: MaterialApp(
        home: OnboardingScreen(onboardingStorage: storage),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(cargarFuentesReales);

  testWidgets(
    '"Omitir" marca el onboarding como visto y navega a Menu',
    (WidgetTester tester) async {
      final storage = _FakeOnboardingStorage();
      await _montarOnboarding(tester, storage);

      await tester.tap(find.text('Omitir'));
      // Sin `pumpAndSettle`: `Menu` dispara una llamada de red real
      // (`EventosStore.cargar`, sin seam de inyección) que se queda
      // "cargando" en este entorno de test - un `CircularProgressIndicator`
      // (animación indefinida) hace que `pumpAndSettle` nunca se considere
      // asentado. Un solo `pump(duration)` grande avanza el reloj virtual de
      // una vez, de sobra para la cadena de await/microtasks
      // (`marcarVisto()` → Navigator.pushReplacement) y para que la
      // transición de salida de `MaterialPageRoute` (300ms) termine y
      // remueva `OnboardingScreen` del árbol.
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(storage.marcarVistoLlamado, isTrue);
      expect(find.byType(Menu), findsOneWidget);
      expect(find.byType(OnboardingScreen), findsNothing);
    },
  );
}
