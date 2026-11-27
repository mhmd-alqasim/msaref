import 'package:dartz/dartz.dart';
import 'package:msaref/core/error/failures.dart';
import 'package:msaref/features/category/domain/entities/category_entity.dart';

abstract class CategoryRepository {
  Future<Either<Failure, List<CategoryEntity>>> getCategories();
  Future<Either<Failure, Unit>> addCategory(CategoryEntity category);
  Future<Either<Failure, Unit>> deleteCategory(String id);
  Future<Either<Failure, bool>> hasCategories(); //check for found category
}
