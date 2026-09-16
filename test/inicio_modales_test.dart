import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:esri_eventos/core/widgets/formulario_web_modal.dart';
import 'package:esri_eventos/core/widgets/upcoming_event_card.dart';
import 'package:esri_eventos/features/eventos/data/evento.dart';
import 'package:esri_eventos/features/eventos/data/eventos_store.dart';
import 'package:esri_eventos/features/eventos/detalle_evento_modal.dart';
import 'package:esri_eventos/features/inicio/inicio.dart';
import 'package:esri_eventos/features/login/data/auth_repository.dart';
import 'package:esri_eventos/features/login/data/perfil_usuario.dart';
import 'package:esri_eventos/features/login/presentation/bloc/auth_cubit.dart';

import 'fuentes_de_prueba.dart';

/// Mismos dos eventos que ya asumía este archivo cuando los datos eran
/// mock (CUE 2026 reservado, Planeta Esri Bogotá "próximo") - ahora se
/// inyectan directo en `EventosStore` en vez de venir de
/// `proximosEventosMock` (retirado al conectar `EventosRepository`).
final _cueReservado = Evento(
  id: 'cue',
  nombre: 'CUE 2026',
  fechaInicio: DateTime(2026, 10, 2),
  fechaFinalizacion: DateTime(2026, 10, 2),
  horaInicio: DateTime(2026, 10, 2, 11),
);
// Fecha a futuro a propósito: EventosStore.cargar() excluye eventos ya
// pasados de "próximos" (ver ese archivo) - un fixture con fecha pasada acá
// contradiría esa regla, aunque este test la inyecte directo sin pasar por
// ese filtro.
final _planetaProximo = Evento(
  id: 'planeta',
  nombre: 'Planeta Esri Bogotá',
  fechaInicio: DateTime(2026, 12, 10),
  fechaFinalizacion: DateTime(2026, 12, 10),
  horaInicio: DateTime(2026, 12, 10, 8),
);

/// El _Header de Inicio lee AuthCubit del context - doble sin red, estos
/// tests son de navegación/modales, no ejercitan el login.
class _AuthRepositorySinRed implements AuthRepository {
  @override
  Future<PerfilUsuario> iniciarSesion(String numeroDocumento) =>
      Future.error(UnimplementedError());

  @override
  Future<PerfilUsuario?> restaurarSesion() async => null;

  @override
  Future<void> cerrarSesion() async {}
}

/// Monta Inicio y devuelve cuántas veces pidió ir a la pantalla Eventos.
Future<List<int>> _montarInicio(WidgetTester tester) async {
  tester.view.physicalSize = const Size(412, 917);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  final vecesQueNavego = [0];
  await tester.pumpWidget(
    BlocProvider(
      create: (_) => AuthCubit(repository: _AuthRepositorySinRed()),
      child: MaterialApp(
        home: InicioApp(onGoToEventos: () => vecesQueNavego[0]++),
      ),
    ),
  );
  await tester.pump();
  return vecesQueNavego;
}

/// El botón de una tarjeta de «Próximos eventos» (las reservadas también
/// tienen "Ver más", así que hay que acotar la búsqueda).
Finder _botonProximo(String texto) => find.descendant(
      of: find.byType(UpcomingEventCard),
      matching: find.text(texto),
    );

Future<void> _tocar(WidgetTester tester, Finder boton) async {
  await tester.ensureVisible(boton);
  await tester.pumpAndSettle();
  await tester.tap(boton);
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 400));
}

void main() {
  setUpAll(cargarFuentesReales);

  setUp(() {
    EventosStore.estado.value = EventosCargados(
      reservados: [_cueReservado],
      proximos: [_planetaProximo],
    );
  });

  tearDown(() {
    EventosStore.estado.value = const EventosSinCargar();
  });

  testWidgets('«Próximos eventos» solo destaca Planeta Esri Bogotá', (
    tester,
  ) async {
    await _montarInicio(tester);

    expect(find.byType(UpcomingEventCard), findsOneWidget);
    expect(_botonProximo('Ver más'), findsOneWidget);
    expect(find.text('Planeta Esri Bogotá'), findsOneWidget);
    expect(find.text('CUE 2026'), findsOneWidget); // solo el reservado
  });

  testWidgets('"Ver más" abre el detalle sobre Inicio, sin ir a Eventos', (
    tester,
  ) async {
    final vecesQueNavego = await _montarInicio(tester);

    await _tocar(tester, _botonProximo('Ver más'));

    expect(find.byType(DetalleEventoModal), findsOneWidget);
    // El modal se superpone: Inicio sigue montado detrás.
    expect(find.byType(InicioApp), findsOneWidget);
    expect(vecesQueNavego[0], 0);
  });

  testWidgets('"Registrarse" abre el formulario sobre Inicio, sin ir a Eventos',
      (tester) async {
    final vecesQueNavego = await _montarInicio(tester);

    await _tocar(tester, _botonProximo('Registrarse'));

    // El WebView no tiene implementación de plataforma en un test, así que su
    // excepción se descarta: lo que se comprueba aquí es el cableado.
    tester.takeException();
    expect(find.byType(FormularioWebModal), findsOneWidget);
    expect(find.text('Registro'), findsOneWidget);
    expect(find.byType(InicioApp), findsOneWidget);
    expect(vecesQueNavego[0], 0);
  });

  testWidgets('el chip "Ver todos" sí lleva a la pantalla Eventos', (
    tester,
  ) async {
    final vecesQueNavego = await _montarInicio(tester);

    await _tocar(tester, find.text('Ver todos'));

    expect(vecesQueNavego[0], 1);
  });
}
