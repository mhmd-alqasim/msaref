import 'package:flutter/material.dart';
import 'package:msaref/features/category/domain/entities/category_entity.dart';
import 'package:uuid/uuid.dart';

final List<CategoryEntity> defaultCategories = [
  CategoryEntity(
    id: const Uuid().v4(),
    name: 'طعام',
    icon: Icons.fastfood,
    colorHex: '#FF5733',
    isDefault: true,
  ),
  CategoryEntity(
    id: const Uuid().v4(),
    name: 'تسوق',
    icon: Icons.shopping_cart,
    colorHex: '#3498DB',
    isDefault: true,
  ),
  CategoryEntity(
    id: const Uuid().v4(),
    name: 'منزل',
    icon: Icons.home,
    colorHex: '#2ECC71',
    isDefault: true,
  ),
  CategoryEntity(
    id: const Uuid().v4(),
    name: 'مواصلات',
    icon: Icons.directions_car,
    colorHex: '#9B59B6',
    isDefault: true,
  ),
  CategoryEntity(
    id: const Uuid().v4(),
    name: 'ترفيه',
    icon: Icons.movie,
    colorHex: '#F39C12',
    isDefault: true,
  ),
  CategoryEntity(
    id: const Uuid().v4(),
    name: 'صحة',
    icon: Icons.medical_services,
    colorHex: '#E74C3C',
    isDefault: true,
  ),
  CategoryEntity(
    id: const Uuid().v4(),
    name: 'تعليم',
    icon: Icons.school,
    colorHex: '#1ABC9C',
    isDefault: true,
  ),
  CategoryEntity(
    id: const Uuid().v4(),
    name: 'راتب',
    icon: Icons.attach_money,
    colorHex: '#27AE60',
    isDefault: true,
  ),
];
