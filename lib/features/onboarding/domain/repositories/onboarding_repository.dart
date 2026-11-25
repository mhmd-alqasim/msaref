import 'package:dartz/dartz.dart';
import 'package:msaref/core/error/failures.dart';

abstract class OnboardingRepository {
  Future<Either<Failure, bool>> isOnBoardingSeen();
  Future<Either<Failure, Unit>> completeOnBoarding();
}
