/// Abreviatura corta del mes para las tarjetas de evento.
///
/// Las cuatro pantallas que usan `EventCard` / `UpcomingEventCard` —Inicio,
/// Eventos, Reservados e Historial— le pasan la fecha **ya compuesta**
/// (`'Septiembre 10 - 08:00 a.m.'`), y cada mock la escribe a su manera: unos
/// con el mes completo y otros ya abreviado. Figma la dibuja siempre corta
/// —«Ago», «Sept», «Oct»—, de 3 a 4 letras y **sin punto**, así que la
/// abreviatura la aplican las propias tarjetas y no los datos: da igual cómo
/// venga escrita la cadena, la card la muestra igual.
class FormatoFecha {
  const FormatoFecha._();

  /// Abreviatura por las tres primeras letras del mes. «Septiembre» es la
  /// única de cuatro, como en el diseño.
  static const Map<String, String> _abreviaturas = {
    'ene': 'Ene',
    'feb': 'Feb',
    'mar': 'Mar',
    'abr': 'Abr',
    'may': 'May',
    'jun': 'Jun',
    'jul': 'Jul',
    'ago': 'Ago',
    'sep': 'Sept',
    'set': 'Sept', // «setiembre», grafía también válida
    'oct': 'Oct',
    'nov': 'Nov',
    'dic': 'Dic',
  };

  /// Acepta el mes entero o ya abreviado, con punto o sin él. El lookahead
  /// evita morder palabras que empiecen igual («mayores», «marca»): detrás del
  /// mes sólo puede venir un espacio, un signo o el final de la cadena.
  static final RegExp _mes = RegExp(
    r'\b('
    r'ene(?:ro)?|feb(?:rero)?|mar(?:zo)?|abr(?:il)?|may(?:o)?|jun(?:io)?|'
    r'jul(?:io)?|ago(?:sto)?|sept?(?:iembre)?|set(?:iembre)?|oct(?:ubre)?|'
    r'nov(?:iembre)?|dic(?:iembre)?'
    r')(?![a-záéíóúñ])\.?',
    caseSensitive: false,
    unicode: true,
  );

  /// Devuelve `texto` con todos sus meses en abreviatura corta y sin punto.
  /// El resto de la cadena —día, hora, separadores— no se toca.
  static String mesCorto(String texto) => texto.replaceAllMapped(
    _mes,
    (m) => _abreviaturas[m.group(1)!.toLowerCase().substring(0, 3)]!,
  );
}
