import 'package:dartz/dartz.dart';
import 'package:msaref/core/error/failures.dart';
import 'package:msaref/core/usecases/usecase.dart';
import 'package:msaref/features/category/domain/entities/category_entity.dart';
import 'package:msaref/features/category/domain/repositories/category_repository.dart';

class AddCategoryUseCase extends UseCase<Unit, CategoryEntity> {
  final CategoryRepository repository;
  AddCategoryUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(CategoryEntity params) {
    return repository.addCategory(params);
  }
}
