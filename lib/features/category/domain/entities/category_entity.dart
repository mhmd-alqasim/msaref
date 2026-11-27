import 'package:flutter/widgets.dart';

class CategoryEntity {
  final String id;
  final String name;
  final IconData icon;
  final String colorHex;
  final bool isDefault;
  const CategoryEntity({
    required this.id,
    required this.name,
    required this.icon,
    required this.colorHex,
    this.isDefault = false,
  });
  //colorHex --->Color
  Color get color => Color(int.parse(colorHex.replaceAll('#', '0xff')));
}
