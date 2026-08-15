import 'package:flutter/material.dart';

enum CategoryType { expense, income }

class CategoryItem {
  final String id;
  final String name;
  final String iconName;
  final int colorValue;
  final CategoryType type;

  const CategoryItem({
    required this.id,
    required this.name,
    required this.iconName,
    required this.colorValue,
    this.type = CategoryType.expense,
  });

  Color get color => Color(colorValue);

  factory CategoryItem.fromJson(Map<String, dynamic> json) {
    return CategoryItem(
      id: json['id'] as String,
      name: json['name'] as String,
      iconName: json['iconName'] as String? ?? 'category',
      colorValue: json['colorValue'] as int? ?? 0xFF3B82F6,
      type: json['type'] == 'income' ? CategoryType.income : CategoryType.expense,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'iconName': iconName,
      'colorValue': colorValue,
      'type': type.name,
    };
  }

  static List<CategoryItem> get defaultCategories => const [
        CategoryItem(
          id: 'cat_food',
          name: 'อาหาร & เครื่องดื่ม',
          iconName: 'restaurant',
          colorValue: 0xFFEF4444, // Red
          type: CategoryType.expense,
        ),
        CategoryItem(
          id: 'cat_travel',
          name: 'เดินทาง & คมนาคม',
          iconName: 'directions_car',
          colorValue: 0xFFF59E0B, // Amber
          type: CategoryType.expense,
        ),
        CategoryItem(
          id: 'cat_shopping',
          name: 'ช้อปปิ้ง & ไลฟ์สไตล์',
          iconName: 'shopping_bag',
          colorValue: 0xFFEC4899, // Pink
          type: CategoryType.expense,
        ),
        CategoryItem(
          id: 'cat_bills',
          name: 'บิล & ค่าน้ำค่าไฟ',
          iconName: 'receipt_long',
          colorValue: 0xFF8B5CF6, // Purple
          type: CategoryType.expense,
        ),
        CategoryItem(
          id: 'cat_entertainment',
          name: 'ความบันเทิง & เกม',
          iconName: 'sports_esports',
          colorValue: 0xFF06B6D4, // Cyan
          type: CategoryType.expense,
        ),
        CategoryItem(
          id: 'cat_health',
          name: 'สุขภาพ & ยารักษาโรค',
          iconName: 'favorite',
          colorValue: 0xFF10B981, // Emerald
          type: CategoryType.expense,
        ),
        CategoryItem(
          id: 'cat_salary',
          name: 'เงินเดือน & โบนัส',
          iconName: 'account_balance_wallet',
          colorValue: 0xFF10B981, // Emerald
          type: CategoryType.income,
        ),
        CategoryItem(
          id: 'cat_freelance',
          name: 'ฟรีแลนซ์ & ธุรกิจ',
          iconName: 'work',
          colorValue: 0xFF3B82F6, // Blue
          type: CategoryType.income,
        ),
        CategoryItem(
          id: 'cat_investment',
          name: 'การลงทุน & ดอกเบี้ย',
          iconName: 'trending_up',
          colorValue: 0xFFF59E0B, // Amber
          type: CategoryType.income,
        ),
      ];
}
