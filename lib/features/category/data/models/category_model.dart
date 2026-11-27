import 'package:flutter/material.dart';
import 'package:msaref/features/category/domain/entities/category_entity.dart';

class CategoryModel extends CategoryEntity {
  const CategoryModel({
    required super.id,
    required super.name,
    required super.icon,
    required super.colorHex,
    super.isDefault,
  });

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'],
      name: map['name'],
      // نحفظ codePoint للأيقونة كـ int
      icon: IconData(
        // ignore: non_const_argument_for_const_parameter
        map['icon'] as int,
        fontFamily: 'MaterialIcons',
      ),
      colorHex: map['color_hex'],
      isDefault: map['is_default'] == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'icon': icon.codePoint,
      'color_hex': colorHex,
      'is_default': isDefault ? 1 : 0,
    };
  }

  factory CategoryModel.fromEntity(CategoryEntity entity) {
    return CategoryModel(
      id: entity.id,
      name: entity.name,
      icon: entity.icon,
      colorHex: entity.colorHex,
      isDefault: entity.isDefault,
    );
  }
}
