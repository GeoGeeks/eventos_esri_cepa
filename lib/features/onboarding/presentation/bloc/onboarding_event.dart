abstract class OnboardingEvent {}

class OnboardingPageChanged extends OnboardingEvent {
  final int page;

  OnboardingPageChanged(this.page);
}