import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/fonts.dart';
import '../../../core/constants/icons.dart';
import '../../../core/constants/images.dart';
import '../../../core/widgets/app_icons.dart';
import '../../eventos/data/evento.dart';
import '../../login/presentation/bloc/auth_cubit.dart';
import '../../login/presentation/bloc/auth_state.dart';
import '../../profile/data/ecard_mock_data.dart';
import '../data/credencial_mock_data.dart';
import '../data/credencial_repository.dart';

class CredencialModal extends StatefulWidget {
  /// Datos fijos (modo mock/tests) - se ignora si [evento] viene informado.
  final CredencialData? datos;

  /// Evento real: dispara el modo real (perfil autenticado + credencial de
  /// backend) en vez de los datos fijos de [datos].
  final Evento? evento;

  final CredencialRepository? credencialRepository;

  const CredencialModal({
    super.key,
    this.datos,
    this.evento,
    this.credencialRepository,
  });

  static CredencialData get datosPorDefecto => const CredencialData(
    nombre: EcardMockData.nombre,
    cargo: EcardMockData.cargo,
    empresa: EcardMockData.empresa,
    evento: CredencialMockData.evento,
    codigo:
        '${CredencialMockData.codigoEvento}-${EcardMockData.documento}',
  );

  static Future<void> mostrar(
    BuildContext context, {
    CredencialData? datos,
    Evento? evento,
    CredencialRepository? credencialRepository,
  }) {
    return showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Credencial digital',
      barrierColor: AppColors.modalOverlay,
      transitionDuration: const Duration(milliseconds: 260),
      pageBuilder: (_, _, _) => CredencialModal(
        datos: datos,
        evento: evento,
        credencialRepository: credencialRepository,
      ),
      transitionBuilder: (_, animation, _, child) {
        final curva = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(curva),
          child: child,
        );
      },
    );
  }

  @override
  State<CredencialModal> createState() => _CredencialModalState();
}

class _CredencialModalState extends State<CredencialModal> {
  late final CredencialRepository _repository =
      widget.credencialRepository ?? CredencialRepository();
  Future<CredencialData>? _futuro;

  @override
  void initState() {
    super.initState();
    final evento = widget.evento;
    if (evento != null) {
      _futuro = _cargar(evento);
    }
  }

  Future<CredencialData> _cargar(Evento evento) async {
    final estadoAuth = context.read<AuthCubit>().state;
    final perfil = estadoAuth is AuthAutenticado ? estadoAuth.perfil : null;
    final credencial = await _repository.obtener(evento.id);
    return CredencialData(
      nombre: perfil?.nombreCompleto ?? '',
      cargo: perfil?.cargo ?? '',
      empresa: perfil?.organizacion ?? '',
      evento: evento.nombre,
      codigo: credencial.codigoQr,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: SingleChildScrollView(
          child: Container(
          // 581 del diseño como mínimo: el nombre y el evento crecen en
          // renglones y el panel con ellos.
          constraints: const BoxConstraints(minHeight: 581),
          width: double.infinity,
          decoration: const BoxDecoration(
            color: AppColors.white,
            border: Border(
              top: BorderSide(color: AppColors.lightGray),
              left: BorderSide(color: AppColors.lightGray),
              right: BorderSide(color: AppColors.lightGray),
            ),
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            boxShadow: [
              BoxShadow(
                color: Color(0x1A000000),
                offset: Offset(-1, -1),
                blurRadius: 32,
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                top: 24.5,
                right: 23.5,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => Navigator.of(context).pop(),
                  child: const SizedBox(
                    width: 24,
                    height: 24,
                    child: Center(
                      child: AppIcon(
                        SvgIcon.x,
                        width: 9,
                        height: 9,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ),
                ),
              ),
              // Sin `Positioned`: es el contenido el que da el alto al panel.
              // 48 arriba y los 81 que sobraban abajo en el diseño.
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 48, 24, 81),
                child: _construirCuerpo(),
              ),
            ],
          ),
        ),
        ),
      ),
    );
  }

  Widget _construirCuerpo() {
    if (widget.evento == null) {
      return _Contenido(datos: widget.datos ?? CredencialModal.datosPorDefecto);
    }
    return FutureBuilder<CredencialData>(
      future: _futuro,
      builder: (context, snapshot) {
        return _Contenido(
          datos: snapshot.data,
          cargando: snapshot.connectionState != ConnectionState.done,
          error: snapshot.hasError,
        );
      },
    );
  }
}

/// El encabezado ("Credencial digital" + subtítulo) es fijo, sea cual sea
/// el estado de [datos] - solo la parte que depende del backend (nombre,
/// QR, evento) se reemplaza por un loader/error mientras carga o falla en
/// modo real (ver `_CredencialModalState._construirCuerpo`).
class _Contenido extends StatelessWidget {
  final CredencialData? datos;
  final bool cargando;
  final bool error;

  const _Contenido({this.datos, this.cargando = false, this.error = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          height: 32,
          child: Text(
            'Credencial digital',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: Fonts.medium,
              fontSize: Fonts.text3h,
              fontWeight: Fonts.wMedium,
              height: 32 / 26,
              letterSpacing: 0,
              color: AppColors.textTitle,
            ),
          ),
        ),
        const SizedBox(height: 4),
        const SizedBox(
          height: 20,
          child: Text(
            'Utilice este código para acceder al evento',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: Fonts.regular,
              fontSize: Fonts.text0h,
              fontWeight: Fonts.wRegular,
              height: 20 / 16,
              letterSpacing: 0,
              color: AppColors.textMuted,
            ),
          ),
        ),
        const SizedBox(height: 61.5),
        if (cargando)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (error || datos == null)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: Text(
              'No se pudo cargar la credencial. Intente de nuevo.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: Fonts.regular,
                fontSize: Fonts.text0h,
                fontWeight: Fonts.wRegular,
                color: AppColors.textMuted,
              ),
            ),
          )
        else
          ..._detalleCredencial(datos!),
      ],
    );
  }

  List<Widget> _detalleCredencial(CredencialData datos) {
    return [
      Text(
        datos.nombre,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontFamily: Fonts.demi,
          fontSize: Fonts.text3h,
          fontWeight: Fonts.wDemi,
          height: 32 / 26,
          letterSpacing: 0,
          color: AppColors.primary,
        ),
      ),
      const SizedBox(height: 2.5),
      Text(
        datos.subtitulo,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontFamily: Fonts.regular,
          fontSize: Fonts.text0h,
          fontWeight: Fonts.wRegular,
          height: 20 / 16,
          letterSpacing: 0,
          color: AppColors.modalSubtitle,
        ),
      ),
      const SizedBox(height: 20),
      Center(
        child: QrImageView(
          data: datos.codigo,
          version: QrVersions.auto,
          size: 232,
          gapless: false,
          backgroundColor: AppColors.white,
          errorCorrectionLevel: QrErrorCorrectLevel.H,
          eyeStyle: const QrEyeStyle(
            eyeShape: QrEyeShape.square,
            color: AppColors.primary,
          ),
          dataModuleStyle: const QrDataModuleStyle(
            dataModuleShape: QrDataModuleShape.square,
            color: AppColors.primary,
          ),
          embeddedImage: const AssetImage(Images.logoqr),
          embeddedImageStyle: const QrEmbeddedImageStyle(size: Size(40, 40)),
        ),
      ),
      const SizedBox(height: 8),
      Text(
        datos.evento,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontFamily: Fonts.medium,
          fontSize: Fonts.text0h,
          fontWeight: Fonts.wMedium,
          height: 20 / 16,
          letterSpacing: 0,
          color: AppColors.textMuted,
        ),
      ),
    ];
  }
}
