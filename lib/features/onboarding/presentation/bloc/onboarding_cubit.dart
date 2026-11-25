import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:msaref/core/usecases/usecase.dart';
import 'package:msaref/features/onboarding/domain/usecases/check_onboarding_usecase.dart';
import 'package:msaref/features/onboarding/domain/usecases/complete_onboarding_usecase.dart';
import 'package:msaref/features/onboarding/presentation/bloc/onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  final CheckOnboardingUseCase _checkOnboarding;
  final CompleteOnboardingUseCase _completeOnboarding;

  OnboardingCubit({
    required this._checkOnboarding,
    required this._completeOnboarding,
  }) : super(OnboardingInitial());

  Future checkOnboaring() async {
    final result = await _checkOnboarding(const NoParams());
    result.fold(
      (_) => emit(ISOnboarding()),
      (isComplete) =>
          isComplete ? emit(OnboardingCompleted()) : emit(ISOnboarding()),
    );
  }

  Future<void> completeOnboarding() async {
    final result = await _completeOnboarding(const NoParams());
    result.fold(
      (_) => emit(const ISOnboarding()),
      (_) => emit(const OnboardingCompleted()),
    );
  }
}
