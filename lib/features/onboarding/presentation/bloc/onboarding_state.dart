class OnboardingState {
  final int currentPage;

  const OnboardingState({
    required this.currentPage,
  });

  OnboardingState copyWith({
    int? currentPage,
  }) {
    return OnboardingState(
      currentPage: currentPage ?? this.currentPage,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OnboardingState &&
        other.currentPage == currentPage;
  }

  @override
  int get hashCode => currentPage.hashCode;

  @override
  String toString() {
    return 'OnboardingState(currentPage: $currentPage)';
  }
}
