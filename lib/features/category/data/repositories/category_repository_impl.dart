import 'package:dartz/dartz.dart';
import 'package:msaref/core/error/exceptions.dart';
import 'package:msaref/core/error/failures.dart';
import 'package:msaref/features/category/data/datasources/category_local_datasource.dart';
import 'package:msaref/features/category/data/models/category_model.dart';
import 'package:msaref/features/category/domain/entities/category_entity.dart';
import 'package:msaref/features/category/domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryLocalDataSource dataSource;
  CategoryRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories() async {
    try {
      final categories = await dataSource.getCategories();
      return Right(categories);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> addCategory(CategoryEntity category) async {
    try {
      final model = CategoryModel.fromEntity(category);
      await dataSource.addCategory(model);
      return const Right(unit);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteCategory(String id) async {
    try {
      await dataSource.deleteCategory(id);
      return const Right(unit);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> hasCategories() async {
    try {
      final result = await dataSource.hasCategories();
      return Right(result);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
}
