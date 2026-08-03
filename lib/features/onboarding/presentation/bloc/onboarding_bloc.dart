import 'package:flutter_bloc/flutter_bloc.dart';

import 'onboarding_event.dart';
import 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc()
      : super(
          const OnboardingState(
            currentPage: 0,
          ),
        ) {
    on<OnboardingPageChanged>(_onPageChanged);
  }

  void _onPageChanged(
    OnboardingPageChanged event,
    Emitter<OnboardingState> emit,
  ) {
    emit(
      state.copyWith(
        currentPage: event.page,
      ),
    );
  }
}
