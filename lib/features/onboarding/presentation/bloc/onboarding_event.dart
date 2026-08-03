abstract class OnboardingEvent {
  const OnboardingEvent();
}

class OnboardingPageChanged extends OnboardingEvent {
  final int page;

  const OnboardingPageChanged(this.page);
}
