/// Una pregunta frecuente. [enlace] marca una palabra de [respuesta] que
/// abre una URL (hoy solo "aquí" → política de privacidad).
class PreguntaFrecuente {
  const PreguntaFrecuente({
    required this.pregunta,
    required this.respuesta,
    this.enlace,
  });

  final String pregunta;
  final String respuesta;
  final EnlaceRespuesta? enlace;
}

/// Palabra de la respuesta que se muestra como enlace.
class EnlaceRespuesta {
  const EnlaceRespuesta({required this.texto, required this.url});

  /// Texto exacto dentro de la respuesta (su primera aparición es el enlace).
  final String texto;
  final String url;
}

class CategoriaPreguntas {
  const CategoriaPreguntas({required this.titulo, required this.preguntas});

  final String titulo;
  final List<PreguntaFrecuente> preguntas;
}

/// Contenido de "Preguntas frecuentes" (Perfil > Soporte), tal como lo
/// entregó la PO el 2026-09-24. Texto fijo en la app a propósito: no hay
/// backend para esto y cambia muy poco; si algún día se administra desde el
/// panel, este es el seam a reemplazar por un repositorio.
class PreguntasFrecuentesData {
  PreguntasFrecuentesData._();

  static const urlPrivacidad = 'https://www.esri.co/es-co/privacidad';

  static const categorias = [
    CategoriaPreguntas(
      titulo: 'Información general',
      preguntas: [
        PreguntaFrecuente(
          pregunta: '¿Cómo crear una cuenta?',
          respuesta:
              'No es necesario crear una cuenta. Una vez se registre en uno o más de nuestros eventos, podrá acceder a la aplicación utilizando su documento de identificación. Puede consultar nuestras políticas de privacidad aquí.',
          enlace: EnlaceRespuesta(texto: 'aquí', url: urlPrivacidad),
        ),
        PreguntaFrecuente(
          pregunta: '¿Cuáles son mis eventos reservados?',
          respuesta:
              'En esta sección encontrará todos los eventos en los que está registrado y que aún no han finalizado.',
        ),
        PreguntaFrecuente(
          pregunta: '¿Cómo actualizar mis datos personales?',
          respuesta:
              'Sus datos personales se actualizan automáticamente con la información suministrada en su registro más reciente a cualquiera de nuestros eventos.',
        ),
        PreguntaFrecuente(
          pregunta: '¿Cómo puedo contactar a soporte?',
          respuesta:
              'Si requiere ayuda, puede comunicarse con nuestro equipo de soporte ingresando a Perfil > Soporte > Contáctenos. Estaremos atentos para atender sus solicitudes e inquietudes.',
        ),
        PreguntaFrecuente(
          pregunta: '¿Cómo acceder a mis eventos pasados?',
          respuesta:
              'Ingrese a la sección Historial para consultar todos los eventos a los que ha asistido. Desde allí podrá descargar sus certificados de asistencia y acceder a las memorias o materiales disponibles de cada evento.',
        ),
      ],
    ),
    CategoriaPreguntas(
      titulo: 'Acerca de mis eventos',
      preguntas: [
        PreguntaFrecuente(
          pregunta: '¿Cómo adquirir mi credencial?',
          respuesta:
              'Su credencial se genera automáticamente una vez complete el registro al evento. Puede consultarla ingresando a Reservas > Seleccione el evento > Mi credencial o accediendo directamente al detalle del evento, donde la encontrará junto a la información de la fecha.',
        ),
        PreguntaFrecuente(
          pregunta: '¿Cómo usar mis favoritos?',
          respuesta:
              'Personalice su experiencia marcando como favoritos las charlas, laboratorios o actividades de su interés. De esta manera podrá planificar su agenda y aprovechar al máximo cada evento.',
        ),
        PreguntaFrecuente(
          pregunta: '¿Cómo recibir notificaciones del evento?',
          respuesta:
              'Para recibir notificaciones, asegúrese de habilitar los permisos de notificaciones al instalar la aplicación. También puede verificar y administrar estos permisos desde la configuración de su dispositivo.',
        ),
        PreguntaFrecuente(
          pregunta: '¿Cómo adquirir mi certificado de asistencia?',
          respuesta:
              'Una vez finalizado el evento, ingrese al detalle del evento y responda la encuesta "Valorar evento". Su opinión es muy importante para nosotros. Al completar la encuesta, podrá descargar su certificado de participación.',
        ),
        PreguntaFrecuente(
          pregunta: '¿Puedo compartir mi credencial con otros asistentes?',
          respuesta:
              'La credencial es personal y se utiliza para su identificación y registro durante el evento. Si desea compartir su información de contacto con otros asistentes, puede hacerlo desde Perfil > e-Card, donde encontrará su tarjeta digital para facilitar la interacción y el networking durante el evento.',
        ),
      ],
    ),
  ];
}
