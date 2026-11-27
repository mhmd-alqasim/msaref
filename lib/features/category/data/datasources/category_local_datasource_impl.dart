import 'package:msaref/core/database/database_helper.dart';
import 'package:msaref/core/error/exceptions.dart';
import 'package:msaref/features/category/data/datasources/category_local_datasource.dart';
import 'package:msaref/features/category/data/models/category_model.dart';

const String _categoriesTable = 'categories';

class CategoryLocalDataSourceImpl implements CategoryLocalDataSource {
  final DatabaseHelper databaseHelper;
  CategoryLocalDataSourceImpl(this.databaseHelper);

  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      final maps = await databaseHelper.query(_categoriesTable);
      return maps.map((map) => CategoryModel.fromMap(map)).toList();
    } catch (e) {
      throw CacheException(message: 'فشل في جلب الفئات: $e');
    }
  }

  @override
  Future<void> addCategory(CategoryModel category) async {
    try {
      await databaseHelper.insert(_categoriesTable, category.toMap());
    } catch (e) {
      throw CacheException(message: 'فشل في إضافة الفئة: $e');
    }
  }

  @override
  Future<void> deleteCategory(String id) async {
    try {
      await databaseHelper.delete(
        _categoriesTable,
        where: 'id = ? AND is_default = 0', // لا نحذف الافتراضية
        whereArgs: [id],
      );
    } catch (e) {
      throw CacheException(message: 'فشل في حذف الفئة: $e');
    }
  }

  @override
  Future<bool> hasCategories() async {
    try {
      final maps = await databaseHelper.query(_categoriesTable);
      return maps.isNotEmpty;
    } catch (e) {
      throw CacheException(message: 'فشل في التحقق: $e');
    }
  }
}
