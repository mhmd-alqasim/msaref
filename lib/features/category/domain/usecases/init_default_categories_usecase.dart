import 'package:dartz/dartz.dart';
import 'package:msaref/core/error/failures.dart';
import 'package:msaref/core/usecases/usecase.dart';
import 'package:msaref/core/utils/default_categories.dart';
import 'package:msaref/features/category/domain/repositories/category_repository.dart';

//AI CODE *-*
class InitDefaultCategoriesUseCase extends UseCase<Unit, NoParams> {
  final CategoryRepository repository;
  InitDefaultCategoriesUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(NoParams params) async {
    final result = await repository.hasCategories();
    //AI CODE *-*

    return result.fold((failure) => Left(failure), (hasCategories) async {
      if (hasCategories) return const Right(unit);

      for (final category in defaultCategories) {
        await repository.addCategory(category);
      }
      return const Right(unit);
    });
  }
}
