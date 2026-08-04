class CredencialData {
  final String nombre;
  final String cargo;
  final String empresa;
  final String evento;
  final String codigo;

  const CredencialData({
    required this.nombre,
    required this.cargo,
    required this.empresa,
    required this.evento,
    required this.codigo,
  });

  String get subtitulo {
    if (cargo.isEmpty) return empresa;
    if (empresa.isEmpty) return cargo;
    return '$cargo - $empresa';
  }
}

class CredencialMockData {
  CredencialMockData._();

  static const String evento = 'Conferencia de Usuarios Esri 2026';
  static const String codigoEvento = 'CUE-2026';
}
