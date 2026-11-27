import 'package:dartz/dartz.dart';
import 'package:msaref/core/error/failures.dart';
import 'package:msaref/core/usecases/usecase.dart';
import 'package:msaref/features/category/domain/entities/category_entity.dart';
import 'package:msaref/features/category/domain/repositories/category_repository.dart';

class GetCategoriesUsecase extends UseCase {
  final CategoryRepository repo;
  GetCategoriesUsecase(this.repo);
  @override
  Future<Either<Failure, List<CategoryEntity>>> call(NoParams) {
    return repo.getCategories();
  }
}
