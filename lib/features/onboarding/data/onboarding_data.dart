import '../../../core/constants/images.dart';

class OnboardingModel {
  final String image;
  final String title;
  final String description;

  final double imageWidth;
  final double imageHeight;

  /// Distancia desde la parte superior
  final double imageTop;

  /// Desplazamiento horizontal de la imagen
  final double imageOffsetX;

  const OnboardingModel({
    required this.image,
    required this.title,
    required this.description,
    required this.imageWidth,
    required this.imageHeight,
    required this.imageTop,
    required this.imageOffsetX,
  });
}

const List<OnboardingModel> onboardingItems = [
  OnboardingModel(
    image: Images.onboarding1,
    title: 'Eventos Esri',
    description:
        'Consulte próximos eventos de Esri y acceda a toda la información desde un solo lugar.',
    imageWidth: 295,
    imageHeight: 376,
    imageTop: 169,
    imageOffsetX: 1.5,
  ),

  OnboardingModel(
    image: Images.onboarding2,
    title: 'Credencial digital',
    description:
        'Acceda a su e-card y presente su credencial para ingresar a los eventos registrados.',
    imageWidth: 295,
    imageHeight: 376,
    imageTop: 171,
    imageOffsetX: -10.5,
  ),

  OnboardingModel(
    image: Images.onboarding3,
    title: 'Soporte y alertas',
    description:
        'Reciba notificaciones en tiempo real sobre cambios y novedades de sus eventos.',
    imageWidth: 295,
    imageHeight: 377,
    imageTop: 169,
    imageOffsetX: 0,
  ),

  OnboardingModel(
    image: Images.onboarding4,
    title: 'Información del evento',
    description:
        'Consulte detalles del evento como agenda, ubicación y contenido relacionado.',
    imageWidth: 339,
    imageHeight: 432,
    imageTop: 145,
    imageOffsetX: 0,
  ),
];
