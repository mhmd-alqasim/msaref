import 'package:msaref/features/category/domain/entities/category_entity.dart';

abstract class CategoryState {
  const CategoryState();
}

class CategoryInitial extends CategoryState {
  const CategoryInitial();
}

class CategoryLoadingState extends CategoryState {
  const CategoryLoadingState();
}

class CategoryLoadedState extends CategoryState {
  final List<CategoryEntity> categories;
  const CategoryLoadedState({required this.categories});
}

class CategoryErrorState extends CategoryState {
  final String message;
  const CategoryErrorState(this.message);
}

class CategoryActionSuccessState extends CategoryState {
  final String message;
  const CategoryActionSuccessState(this.message);
}
