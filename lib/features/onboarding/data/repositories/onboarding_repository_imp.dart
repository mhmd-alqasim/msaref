import 'package:dartz/dartz.dart';
import 'package:msaref/core/error/failures.dart';
import 'package:msaref/features/onboarding/data/datasources/onboarding_local_datasoures.dart';
import 'package:msaref/features/onboarding/domain/repositories/onboarding_repository.dart';

class OnboardingRepositoryImp extends OnboardingRepository {
  final OnboardingLocalDatasoures datasoures;
  OnboardingRepositoryImp(this.datasoures);

  @override
  Future<Either<Failure, bool>> isOnBoardingSeen() async {
    try {
      final resulte = datasoures.isOnBoardingSeen();
      return Right(resulte);
    } on CacheFailure catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> completeOnBoarding() async {
    try {
      await datasoures.completeOnBoarding();
      return const Right(unit);
    } on CacheFailure catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
}
