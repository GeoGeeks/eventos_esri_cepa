/// Perfil del usuario autenticado, tal como lo devuelve
/// `GET /usuarios/mi-perfil` en `eventos_esri_cepa_api`.
class PerfilUsuario {
  const PerfilUsuario({
    required this.id,
    required this.tipoDocumento,
    required this.numeroDocumento,
    required this.nombres,
    required this.apellidos,
    required this.email,
    this.celular,
    this.organizacion,
    this.cargo,
    required this.activo,
    required this.createdAt,
    required this.updatedAt,
    this.genero,
  });

  final String id;
  final String tipoDocumento;
  final String numeroDocumento;
  final String nombres;
  final String apellidos;
  final String email;
  final String? celular;
  // Denormalizados desde eventosdb.RegistroEvento - pueden faltar si esa
  // inscripción no los trae, no todo asistente los diligencia.
  final String? organizacion;
  final String? cargo;
  final bool activo;
  final DateTime createdAt;
  final DateTime updatedAt;
  /// SOLO para un colaborador interno (viene de SuccessFactors) - un
  /// asistente externo no tiene esta fuente de dato, siempre null. Valor
  /// crudo del backend, sin normalizar - ver [saludo].
  final String? genero;

  /// "Nombres Apellidos" en formato título, como se muestra en Inicio/Perfil
  /// (ej. "Valentina Piragauta"). `nombres`/`apellidos` llegan tal cual los
  /// digitó el asistente al registrarse en `eventosdb.RegistroEvento` — en la
  /// práctica casi siempre en MAYÚSCULAS — así que se normalizan solo para
  /// mostrar, sin tocar los campos originales.
  String get nombreCompleto => _aTitulo('$nombres $apellidos');

  /// Iniciales para el avatar circular de Perfil (p.ej. "María López" → "ML").
  String get iniciales {
    final inicialNombre = nombres.isNotEmpty ? nombres[0].toUpperCase() : '';
    final inicialApellido =
        apellidos.isNotEmpty ? apellidos[0].toUpperCase() : '';
    return '$inicialNombre$inicialApellido';
  }

  /// "Bienvenido"/"Bienvenida" para el saludo de Inicio, según [genero].
  /// Compara solo la primera letra (sin distinguir mayúsculas) porque no hay
  /// confirmado todavía qué valores exactos manda SuccessFactors ('M'/'F'
  /// vs. 'Masculino'/'Femenino', etc.) - más seguro que comparar el string
  /// completo. Sin dato (asistente externo, o colaborador sin género
  /// diligenciado) cae al masculino genérico, el uso por defecto habitual en
  /// español ante la ausencia del dato - no hay una forma neutral de una
  /// sola palabra que calce con el resto de la copy de la app.
  String get saludo {
    final valor = genero?.trim().toLowerCase();
    if (valor != null && valor.startsWith('f')) return 'Bienvenida';
    return 'Bienvenido';
  }

  /// "Cargo · Organización" para el subtítulo de Inicio/Perfil - null si no
  /// hay ninguno de los dos dato, con el separador solo si hay ambos.
  String? get cargoYOrganizacion {
    final partes = [
      if (cargo != null && cargo!.isNotEmpty) cargo!,
      if (organizacion != null && organizacion!.isNotEmpty) organizacion!,
    ];
    return partes.isEmpty ? null : partes.join(' · ');
  }

  factory PerfilUsuario.fromJson(Map<String, dynamic> json) {
    return PerfilUsuario(
      id: json['id'] as String,
      tipoDocumento: json['tipoDocumento'] as String,
      numeroDocumento: json['numeroDocumento'] as String,
      nombres: json['nombres'] as String,
      apellidos: json['apellidos'] as String,
      email: json['email'] as String,
      celular: json['celular'] as String?,
      organizacion: json['organizacion'] as String?,
      cargo: json['cargo'] as String?,
      activo: json['activo'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      genero: json['genero'] as String?,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PerfilUsuario &&
        other.id == id &&
        other.tipoDocumento == tipoDocumento &&
        other.numeroDocumento == numeroDocumento &&
        other.nombres == nombres &&
        other.apellidos == apellidos &&
        other.email == email &&
        other.celular == celular &&
        other.organizacion == organizacion &&
        other.cargo == cargo &&
        other.activo == activo &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.genero == genero;
  }

  @override
  int get hashCode => Object.hash(
        id,
        tipoDocumento,
        numeroDocumento,
        nombres,
        apellidos,
        email,
        celular,
        organizacion,
        cargo,
        Object.hash(activo, createdAt, updatedAt, genero),
      );
}

/// Pasa `texto` a formato título por palabra (ej. "VALENTINA PIRAGAUTA" o
/// "valentina piragauta" → "Valentina Piragauta"). No es lingüísticamente
/// perfecto (no baja preposiciones tipo "de"/"del" como haría un formateador
/// de nombres completo), pero es la conversión esperada para los nombres
/// propios que llegan denormalizados de `eventosdb`.
String _aTitulo(String texto) {
  return texto
      .toLowerCase()
      .split(' ')
      .map(
        (palabra) => palabra.isEmpty
            ? palabra
            : palabra[0].toUpperCase() + palabra.substring(1),
      )
      .join(' ');
}
