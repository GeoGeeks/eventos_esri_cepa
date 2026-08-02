import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/fonts.dart';
import '../../core/constants/icons.dart';
import '../../core/constants/images.dart';
import '../../core/widgets/upcoming_event_card.dart';
import '../invitados/invitados.dart';

class _ReservedEvent {
  final String title, date, location, image, mode;
  const _ReservedEvent({
    required this.title,
    required this.date,
    required this.location,
    required this.image,
    required this.mode,
  });

  bool get isPresencial => mode == 'Presencial';
}

const _events = [
  _ReservedEvent(
    title: 'CUE 2026',
    date: 'Oct 02 - 11:00 a.m.',
    location: 'Calle 32 # 54-34',
    image: Images.esriEventos,
    mode: 'Presencial',
  ),
  _ReservedEvent(
    title: 'Planeta Esri',
    date: 'Oct 02 - 11:00 a.m.',
    location: 'Calle 32 # 54-34',
    image: Images.planetaEsri,
    mode: 'Presencial',
  ),
];

class ReservasScreen extends StatefulWidget {
  const ReservasScreen({super.key});

  @override
  State<ReservasScreen> createState() => _ReservasScreenState();
}

class _ReservasScreenState extends State<ReservasScreen> {
  String _query = '';
  bool _showFilter = false;
  bool _virtualSelected = false;
  bool _presencialSelected = false;

  String _normalizeText(String text) {
    const withDiacritics =
        'ÀÁÂÃÄÅàáâãäåÒÓÔÕÖØòóôõöøÈÉÊËèéêëðÇçÐÌÍÎÏìíîïÙÚÛÜùúûüÑñŠšŸÿý';
    const withoutDiacritics =
        'AAAAAAaaaaaaOOOOOOooooooEEEEeeeedCcDIIIIiiiiUUUUuuuuNnSsYyy';

    String str = text.toLowerCase();
    for (int i = 0; i < withDiacritics.length; i++) {
      str = str.replaceAll(withDiacritics[i], withoutDiacritics[i]);
    }
    return str;
  }

  List<_ReservedEvent> get _filtered {
    final cleanQuery = _normalizeText(_query);

    return _events.where((e) {
      final matchesSearch =
          cleanQuery.isEmpty || _normalizeText(e.title).contains(cleanQuery);

      bool matchesFilter = true;
      if (_virtualSelected && !_presencialSelected) {
        matchesFilter = !e.isPresencial;
      } else if (!_virtualSelected && _presencialSelected) {
        matchesFilter = e.isPresencial;
      }

      return matchesSearch && matchesFilter;
    }).toList();
  }

  void _abrirInvitados() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const InvitadosScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final eventos = _filtered;
    final screenWidth = MediaQuery.of(context).size.width;
    final rightPadding = math.max(0.0, (screenWidth - 360) / 2);

    return GestureDetector(
      onTap: () {
        if (_showFilter) {
          setState(() => _showFilter = false);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    width: 360,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 36, bottom: 80),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            width: 360,
                            child: Text(
                              'Eventos Reservados',
                              style: TextStyle(
                                fontFamily: Fonts.medium,
                                fontSize: Fonts.text3h,
                                fontWeight: Fonts.wMedium,
                                height: 32 / 26,
                                color: AppColors.textTitle,
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          const SizedBox(
                            width: 360,
                            child: Text(
                              'Encuentre la información sobre los eventos en '
                              'los que se ha registrado.',
                              style: TextStyle(
                                fontFamily: Fonts.regular,
                                fontSize: Fonts.text0h,
                                fontWeight: Fonts.wRegular,
                                height: 20 / 16,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ),

                          const SizedBox(height: 26),

                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 32,
                                  child: TextField(
                                    onChanged: (v) =>
                                        setState(() => _query = v),
                                    style: const TextStyle(
                                      fontFamily: Fonts.regular,
                                      fontSize: Fonts.text0h,
                                      fontWeight: Fonts.wRegular,
                                      color: AppColors.textTitle,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: 'Buscar',
                                      hintStyle: const TextStyle(
                                        fontFamily: Fonts.regular,
                                        fontSize: Fonts.text0h,
                                        fontWeight: Fonts.wRegular,
                                        color: AppColors.textSubtle,
                                      ),
                                      prefixIcon: const Padding(
                                        padding: EdgeInsets.only(
                                          left: 13,
                                          right: 8,
                                        ),
                                        child: _SearchIcon(),
                                      ),
                                      prefixIconConstraints:
                                          const BoxConstraints(
                                        minWidth: 37,
                                        minHeight: 16,
                                      ),
                                      contentPadding: const EdgeInsets.only(
                                        top: 6,
                                        bottom: 6,
                                        right: 12,
                                      ),
                                      filled: true,
                                      fillColor: AppColors.white,
                                      isDense: true,
                                      border: const OutlineInputBorder(
                                        borderRadius: BorderRadius.zero,
                                        borderSide: BorderSide(
                                          color: AppColors.textSubtle,
                                          width: 1,
                                        ),
                                      ),
                                      enabledBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.zero,
                                        borderSide: BorderSide(
                                          color: AppColors.textSubtle,
                                          width: 1,
                                        ),
                                      ),
                                      focusedBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.zero,
                                        borderSide: BorderSide(
                                          color: AppColors.primary,
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              _SplitFilterButton(
                                onTap: () => setState(
                                  () => _showFilter = !_showFilter,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          if (eventos.isEmpty)
                            const Padding(
                              padding: EdgeInsets.only(top: 40),
                              child: Center(
                                child: Text(
                                  'No se encontraron eventos',
                                  style: TextStyle(
                                    fontFamily: Fonts.regular,
                                    fontSize: 14,
                                    fontWeight: Fonts.wRegular,
                                    color: AppColors.textSubtle,
                                  ),
                                ),
                              ),
                            )
                          else
                            for (var i = 0; i < eventos.length; i++)
                              Padding(
                                padding: EdgeInsets.only(
                                  bottom: i == eventos.length - 1 ? 0 : 24,
                                ),
                                child: SizedBox(
                                  width: 360,
                                  height: 122,
                                  child: UpcomingEventCard(
                                    title: eventos[i].title,
                                    date: eventos[i].date,
                                    location: eventos[i].location,
                                    image: eventos[i].image,
                                    mode: eventos[i].mode,
                                    secondaryLabel: 'Mi credencial',
                                    actionsGap: 11,
                                    viewMoreWidth: 75,
                                    secondaryWidth: 110,
                                    onViewMore: _abrirInvitados,
                                    onRegister: () {},
                                  ),
                                ),
                              ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              if (_showFilter)
                Positioned(
                  top: 184,
                  right: rightPadding,
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      width: 259,
                      height: 132,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: AppColors.lightGray,
                          width: 1,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.25),
                            offset: Offset(0, 4),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            width: 219,
                            height: 16,
                            child: Text(
                              'Modalidad',
                              style: TextStyle(
                                fontFamily: Fonts.regular,
                                fontSize: 14,
                                fontWeight: Fonts.wRegular,
                                height: 16 / 14,
                                color: AppColors.modalSubtitle,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: 219,
                            height: 1,
                            color: AppColors.lightGray,
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: 219,
                            height: 64,
                            child: Column(
                              children: [
                                _FilterOptionItem(
                                  label: 'Virtual',
                                  isSelected: _virtualSelected,
                                  onTap: () {
                                    setState(() {
                                      _virtualSelected = !_virtualSelected;
                                      if (_virtualSelected) {
                                        _presencialSelected = false;
                                      }
                                    });
                                  },
                                ),
                                _FilterOptionItem(
                                  label: 'Presencial',
                                  isSelected: _presencialSelected,
                                  onTap: () {
                                    setState(() {
                                      _presencialSelected =
                                          !_presencialSelected;
                                      if (_presencialSelected) {
                                        _virtualSelected = false;
                                      }
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchIcon extends StatelessWidget {
  const _SearchIcon();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 16,
      height: 16,
      child: SvgPicture.asset(
        SvgIcon.search,
        width: 16,
        height: 16,
        colorFilter: const ColorFilter.mode(
          AppColors.textSubtle,
          BlendMode.srcIn,
        ),
        placeholderBuilder: (_) => const Icon(
          Icons.search,
          size: 16,
          color: AppColors.textSubtle,
        ),
      ),
    );
  }
}

class _FilterOptionItem extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterOptionItem({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 219,
        height: 32,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Row(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.white,
                  border: Border.all(
                    color:
                        isSelected ? AppColors.primary : AppColors.textSubtle,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: isSelected
                    ? const Icon(
                        Icons.check,
                        size: 12,
                        color: AppColors.white,
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: const TextStyle(
                  fontFamily: Fonts.regular,
                  fontSize: 14,
                  fontWeight: Fonts.wRegular,
                  color: AppColors.textTitle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SplitFilterButton extends StatelessWidget {
  final VoidCallback onTap;
  const _SplitFilterButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 65,
      height: 32,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: onTap,
            child: Container(
              width: 32,
              height: 32,
              padding: const EdgeInsets.all(8),
              color: AppColors.primary,
              alignment: Alignment.center,
              child: SvgPicture.asset(
                SvgIcon.filtro,
                width: 16,
                height: 16,
                colorFilter: const ColorFilter.mode(
                  AppColors.white,
                  BlendMode.srcIn,
                ),
                placeholderBuilder: (_) => const Icon(
                  Icons.filter_alt_outlined,
                  color: AppColors.white,
                  size: 16,
                ),
              ),
            ),
          ),
          Container(
            width: 1,
            height: 32,
            color: AppColors.primary,
            alignment: Alignment.center,
            child: Container(
              width: 1,
              height: 24,
              color: AppColors.white,
            ),
          ),
          InkWell(
            onTap: onTap,
            child: Container(
              width: 32,
              height: 32,
              color: AppColors.primary,
              alignment: Alignment.center,
              child: SizedBox(
                width: 8,
                height: 5.414,
                child: SvgPicture.asset(
                  SvgIcon.arrow,
                  width: 8,
                  height: 5.414,
                  fit: BoxFit.contain,
                  colorFilter: const ColorFilter.mode(
                    AppColors.white,
                    BlendMode.srcIn,
                  ),
                  placeholderBuilder: (_) => const Icon(
                    Icons.keyboard_arrow_down,
                    color: AppColors.white,
                    size: 12,
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
