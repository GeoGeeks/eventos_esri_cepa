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
    image: 'assets/images/onboarding_1.png',
    title: 'Eventos Esri',
    description:
        'Consulte próximos eventos de Esri y acceda a toda la información desde un solo lugar.',
  ),
  OnboardingModel(
    image: 'assets/images/onboarding_2.png',
    title: 'Credencial digital',
    description:
        'Acceda a su credencial digital para ingresar de manera rápida y segura a sus eventos.',
  ),
  OnboardingModel(
    image: 'assets/images/onboarding_3.png',
    title: 'Agenda personalizada',
    description:
        'Visualice horarios, sesiones y actividades programadas para cada evento.',
  ),
  OnboardingModel(
    image: 'assets/images/onboarding_4.png',
    title: 'Información del evento',
    description:
        'Encuentre ubicación, detalles importantes y contenido relacionado con cada evento.',
  ),
];