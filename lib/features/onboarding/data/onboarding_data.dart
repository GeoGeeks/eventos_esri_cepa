import '../../../core/constants/images.dart';

class OnboardingModel {
  final String image;
  final String title;
  final String description;

  const OnboardingModel({
    required this.image,
    required this.title,
    required this.description,
  });
}

const List<OnboardingModel> onboardingItems = [
  OnboardingModel(
    image: Images.onboarding1,
    title: 'Eventos Esri',
    description:
        'Consulte próximos eventos de Esri y acceda a toda la información desde un solo lugar.',
  ),

  OnboardingModel(
    image: Images.onboarding2,
    title: 'Credencial digital',
    description:
        'Acceda a su credencial digital para ingresar de manera rápida y segura a sus eventos.',
  ),

  OnboardingModel(
    image: Images.onboarding3,
    title: 'Agenda personalizada',
    description:
        'Visualice horarios, sesiones y actividades programadas para cada evento.',
  ),

  OnboardingModel(
    image: Images.onboarding4,
    title: 'Información del evento',
    description:
        'Encuentre ubicación, detalles importantes y contenido relacionado con cada evento.',
  ),
];