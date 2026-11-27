import 'package:dartz/dartz.dart';
import 'package:msaref/core/error/failures.dart';
import 'package:msaref/core/usecases/usecase.dart';
import 'package:msaref/features/category/domain/repositories/category_repository.dart';

class DeleteCategoryUseCase extends UseCase<Unit, String> {
  final CategoryRepository repository;
  DeleteCategoryUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(String id) {
    return repository.deleteCategory(id);
  }
}
