class Images {
  Images._();

  // background_inicio.svg y esri_blanco.svg no son vectores: son un PNG
  // embebido en base64 dentro de una cáscara SVG, y flutter_svg ignora los
  // elementos <image>, así que no dibujaba nada. Se apunta al PNG extraído
  // de esos mismos archivos (mismos píxeles). Los .svg se conservan en disco.
  static const String backgroundInicio =
    'assets/images/login/background_inicio.png';

static const String logoApp =
    'assets/images/login/logo_app.svg';

static const String esriBlanco =
    'assets/images/login/esri_blanco.png';

  static const String esriEventos = 'assets/images/cards/esri_eventos.png';

  static const String planetaEsri = 'assets/images/cards/comunidad_esri.png';

  static const String headerInicio = 'assets/images/inicio/header_inicio.png';

  static const String iconHeader = 'assets/images/inicio/icon_header.png';

  static const String onboarding1 = 'assets/images/onboarding/onboarding_1.png';

  static const String onboarding2 = 'assets/images/onboarding/onboarding_2.png';

  static const String onboarding3 = 'assets/images/onboarding/onboarding_3.png';

  static const String onboarding4 = 'assets/images/onboarding/onboarding_4.png';

  static const String profile1 = 'assets/images/profile/profile_1.png';

  static const String headerInvitados = 'assets/images/invitados/invitados.png';

  static const String logoCue = 'assets/images/invitados/cue.png';
  
  static const String fotoInvitado = 'assets/images/invitados/foto_invitados.png';

  static const String experienciaComunidad = 'assets/images/experiencias/comunidad.png';
  
  static const String experienciaGeoIA     = 'assets/images/experiencias/geo.png';

  static const String qrEcard = 'assets/images/profile/qre_card.png';


static const String galeria1 =
    'assets/images/post_evento/galeria_1.png';

static const String galeria2 =
    'assets/images/post_evento/galeria_2.png';

static const String galeria3 =
    'assets/images/post_evento/galeria_3.png';

static const String galeria4 =
    'assets/images/post_evento/galeria_4.png';

static const String galeria5 =
    'assets/images/post_evento/galeria_5.png';

static const String videoCover =
    'assets/images/post_evento/video_cover.png';

static const String logoqr =
    'assets/images/post_evento/logo_qr.png';

static const String notificaciones = 'assets/images/notificaciones/notificaciones.png';
}
