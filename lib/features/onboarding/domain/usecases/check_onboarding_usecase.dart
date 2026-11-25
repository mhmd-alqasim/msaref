import 'package:dartz/dartz.dart';
import 'package:msaref/core/error/failures.dart';
import 'package:msaref/core/usecases/usecase.dart';
import 'package:msaref/features/onboarding/domain/repositories/onboarding_repository.dart';

class CheckOnboardingUseCase extends UseCase<bool, NoParams> {
  final OnboardingRepository repository;
  CheckOnboardingUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) {
    return repository.isOnBoardingSeen();
  }
}
