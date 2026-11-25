import 'package:dartz/dartz.dart';
import 'package:msaref/core/error/failures.dart';
import 'package:msaref/core/usecases/usecase.dart';
import 'package:msaref/features/onboarding/domain/repositories/onboarding_repository.dart';

class CompleteOnboardingUseCase extends UseCase<Unit, NoParams> {
  final OnboardingRepository repository;
  CompleteOnboardingUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(NoParams params) {
    return repository.completeOnBoarding();
  }
}
