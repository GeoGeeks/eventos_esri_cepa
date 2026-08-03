import 'package:flutter/material.dart';

import '../../features/agenda/data/filtro_data.dart';
import '../constants/app_colors.dart';
import '../constants/fonts.dart';
import '../constants/icons.dart';
import 'app_icons.dart';
import 'filtro_chip.dart';
import 'filtro_panel.dart';

class FiltroModal extends StatefulWidget {
  final List<GrupoFiltro> grupos;
  final Map<String, Set<String>> seleccion;

  const FiltroModal({
    super.key,
    this.grupos = FiltroData.grupos,
    this.seleccion = const {},
  });

  @override
  State<FiltroModal> createState() => _FiltroModalState();
}

class _FiltroModalState extends State<FiltroModal> {
  late final Map<String, Set<String>> _seleccion = {
    for (final grupo in widget.grupos)
      grupo.etiqueta: {...?widget.seleccion[grupo.etiqueta]},
  };

  final ScrollController _scroll = ScrollController();
  int _indiceActivo = 0;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_alSacudir);
  }

  @override
  void dispose() {
    _scroll.removeListener(_alSacudir);
    _scroll.dispose();
    super.dispose();
  }

  double _altoGrupo(GrupoFiltro grupo) =>
      20 + 17 + grupo.opciones.length * 20 + (grupo.opciones.length - 1) * 10;

  double _desplazamiento(int indice) {
    var total = 0.0;
    for (var i = 0; i < indice; i++) {
      total += _altoGrupo(widget.grupos[i]) + 19;
    }
    return total;
  }

  void _alSacudir() {
    var indice = 0;
    for (var i = 0; i < widget.grupos.length; i++) {
      if (_scroll.offset >= _desplazamiento(i) - 20) indice = i;
    }
    if (indice != _indiceActivo) setState(() => _indiceActivo = indice);
  }

  void _irAGrupo(int indice) {
    setState(() => _indiceActivo = indice);
    if (!_scroll.hasClients) return;
    _scroll.animateTo(
      _desplazamiento(indice).clamp(0, _scroll.position.maxScrollExtent),
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOut,
    );
  }

  void _alternarOpcion(String etiqueta, String opcion) {
    setState(() {
      final actuales = _seleccion[etiqueta]!;
      if (!actuales.remove(opcion)) actuales.add(opcion);
    });
  }

  void _limpiar() {
    setState(() {
      for (final grupo in _seleccion.values) {
        grupo.clear();
      }
    });
  }

  void _aplicar() {
    Navigator.pop(context, {
      for (final entrada in _seleccion.entries)
        if (entrada.value.isNotEmpty) entrada.key: entrada.value,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 618,
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
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: 116,
                child: Container(
                  color: AppColors.lightGray,
                  padding: const EdgeInsets.only(left: 26, top: 23),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var i = 0; i < widget.grupos.length; i++) ...[
                        if (i > 0) const SizedBox(height: 8),
                        FiltroChip(
                          title: widget.grupos[i].etiqueta,
                          selected: i == _indiceActivo,
                          onTap: () => _irAGrupo(i),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    const SizedBox(height: 28),
                    Expanded(
                      child: ListView(
                        controller: _scroll,
                        padding: const EdgeInsets.only(left: 12, right: 26),
                        children: [
                          for (var i = 0; i < widget.grupos.length; i++) ...[
                            if (i > 0) const SizedBox(height: 19),
                            FiltroPanel(
                              titulo: widget.grupos[i].titulo,
                              opciones: widget.grupos[i].opciones,
                              seleccionadas:
                                  _seleccion[widget.grupos[i].etiqueta]!,
                              onOpcion: (opcion) => _alternarOpcion(
                                widget.grupos[i].etiqueta,
                                opcion,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 26, bottom: 50),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          _BotonFiltro(
                            ancho: 115,
                            etiqueta: 'Limpiar filtros',
                            relleno: false,
                            onTap: _limpiar,
                          ),
                          const SizedBox(width: 8),
                          _BotonFiltro(
                            ancho: 70,
                            etiqueta: 'Aplicar',
                            relleno: true,
                            onTap: _aplicar,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 14,
            right: 26,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => Navigator.pop(context),
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
        ],
      ),
    );
  }
}

class _BotonFiltro extends StatelessWidget {
  final double ancho;
  final String etiqueta;
  final bool relleno;
  final VoidCallback onTap;

  const _BotonFiltro({
    required this.ancho,
    required this.etiqueta,
    required this.relleno,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: ancho,
        height: 32,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: relleno ? AppColors.primary : AppColors.white,
          border: Border.all(color: AppColors.primary),
        ),
        child: Text(
          etiqueta,
          style: TextStyle(
            fontFamily: Fonts.regular,
            fontSize: Fonts.textSm,
            fontWeight: Fonts.wRegular,
            height: 20 / 14,
            letterSpacing: 0,
            color: relleno ? AppColors.white : AppColors.primary,
          ),
        ),
      ),
    );
  }
}
