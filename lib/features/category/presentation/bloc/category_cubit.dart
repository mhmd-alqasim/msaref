import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:msaref/core/usecases/usecase.dart';
import 'package:msaref/core/utils/app_string.dart';
import 'package:msaref/features/category/domain/entities/category_entity.dart';
import 'package:msaref/features/category/domain/usecases/add_category_usecase.dart';
import 'package:msaref/features/category/domain/usecases/delete_category_usecase.dart';
import 'package:msaref/features/category/domain/usecases/get_categories_usecase.dart';
import 'package:msaref/features/category/presentation/bloc/category_state.dart';
import 'package:uuid/uuid.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final GetCategoriesUsecase _getCategories;
  final AddCategoryUseCase _addCategory;
  final DeleteCategoryUseCase _deleteCategory;
  CategoryCubit({
    required this._getCategories,
    required this._addCategory,
    required this._deleteCategory,
  }) : super(const CategoryInitial());

  Future loadCategory() async {
    emit(const CategoryLoadingState());
    final result = await _getCategories(NoParams());
    result.fold(
      (failure) => emit(CategoryErrorState(failure.message)),
      (categories) => emit(CategoryLoadedState(categories: categories)),
    );
  }

  Future<void> addCategory({
    required String name,
    required IconData icon,
    required String color,
  }) async {
    emit(CategoryLoadingState());
    final category = CategoryEntity(
      colorHex: color,
      id: Uuid().v4(),
      name: name,
      icon: icon,
    );
    final result = await _addCategory(category);
    result.fold((failure) => emit(CategoryErrorState(failure.message)), (
      _,
    ) async {
      emit(const CategoryActionSuccessState(AppStrings.addcategory));
      await loadCategory();
    });
  }

  Future<void> deleteWallet(String id) async {
    emit(const CategoryLoadingState());
    final result = await _deleteCategory(id);
    result.fold((failure) => emit(CategoryErrorState(failure.message)), (
      _,
    ) async {
      emit(const CategoryActionSuccessState(AppStrings.deleteCate));
      await loadCategory();
    });
  }
}
