/// Stand o Experiencia de un evento, tal como lo devuelve
/// `eventos_esri_cepa_api` (`GET /eventos/:idEvento/expositores`) - ver la
/// entidad `Expositor` de ese repo. Una sola tabla/tipo discriminada por
/// [tipo] ('stand' | 'experiencia'), no dos clases separadas - mismo
/// criterio que ya usaba el mock de `InvitadosScreen`
/// (`ExperienciaEvento` sirve para las dos pestañas).
class Expositor {
  const Expositor({
    required this.id,
    required this.idEvento,
    required this.tipo,
    required this.nombre,
    required this.descripcion,
    this.nombreContacto,
    required this.emailContacto,
    this.imagenUrl,
    this.dia,
    this.ubicacion,
    this.horarioDia1,
    this.horarioDia2,
    this.categoria,
  });

  final String id;
  final String idEvento;

  /// 'stand' | 'experiencia'.
  final String tipo;
  final String nombre;
  final String descripcion;
  final String? nombreContacto;
  final String emailContacto;
  final String? imagenUrl;
  final String? dia;
  final String? ubicacion;
  final String? horarioDia1;
  final String? horarioDia2;

  /// Solo aplica cuando `tipo == 'stand'` (ej. "Partner Member"). El panel
  /// nunca la asigna a una Experiencia.
  final String? categoria;

  /// "Jueves · 2:00 p.m. a 5:00 p.m." (+ " / 8:00 a.m. a 12:00 p.m." si hay
  /// un segundo horario) - lo que `TarjetaExperiencia` espera como `fecha`
  /// ya compuesto. `horarioDia1`/`horarioDia2` ya vienen formateados por el
  /// admin, no son horas ISO - no hay nada que parsear.
  String get fechaFormateada {
    final base = [
      if (dia != null && dia!.isNotEmpty) dia!,
      if (horarioDia1 != null && horarioDia1!.isNotEmpty) horarioDia1!,
    ].join(' · ');
    if (horarioDia2 == null || horarioDia2!.isEmpty) return base;
    return base.isEmpty ? horarioDia2! : '$base / $horarioDia2';
  }

  factory Expositor.fromJson(Map<String, dynamic> json) {
    return Expositor(
      id: json['id'] as String,
      idEvento: json['idEvento'] as String,
      tipo: json['tipo'] as String,
      nombre: json['nombre'] as String,
      descripcion: json['descripcion'] as String,
      nombreContacto: json['nombreContacto'] as String?,
      emailContacto: json['emailContacto'] as String,
      imagenUrl: json['imagenUrl'] as String?,
      dia: json['dia'] as String?,
      ubicacion: json['ubicacion'] as String?,
      horarioDia1: json['horarioDia1'] as String?,
      horarioDia2: json['horarioDia2'] as String?,
      categoria: json['categoria'] as String?,
    );
  }
}
