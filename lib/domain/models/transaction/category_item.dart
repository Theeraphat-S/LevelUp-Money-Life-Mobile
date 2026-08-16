import 'package:flutter/material.dart';

enum BudgetBucket { needs, wants, savings }

class CategoryItem {
  final String id;
  final String name;
  final String iconName;
  final int colorValue;
  final bool isIncome;
  final BudgetBucket? bucket;

  const CategoryItem({
    required this.id,
    required this.name,
    required this.iconName,
    required this.colorValue,
    this.isIncome = false,
    this.bucket,
  });

  Color get color => Color(colorValue);

  factory CategoryItem.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as String? ?? 'Food';
    return defaultCategories.firstWhere(
      (c) => c.id.toLowerCase() == id.toLowerCase() || c.name.toLowerCase() == id.toLowerCase(),
      orElse: () => CategoryItem(
        id: id,
        name: json['name'] as String? ?? id,
        iconName: json['iconName'] as String? ?? 'restaurant',
        colorValue: json['colorValue'] as int? ?? 0xFFC99A4B,
        isIncome: json['isIncome'] as bool? ?? false,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'iconName': iconName,
      'colorValue': colorValue,
      'isIncome': isIncome,
      'bucket': bucket?.name,
    };
  }

  static const List<CategoryItem> defaultCategories = [
    CategoryItem(
      id: 'Income',
      name: 'Income',
      iconName: 'trending_up',
      colorValue: 0xFF4D8E75, // Soft Jade
      isIncome: true,
    ),
    CategoryItem(
      id: 'Food',
      name: 'Food',
      iconName: 'restaurant',
      colorValue: 0xFFC99A4B, // Muted Amber
      bucket: BudgetBucket.needs,
    ),
    CategoryItem(
      id: 'Transport',
      name: 'Transport',
      iconName: 'directions_car',
      colorValue: 0xFF1C5954, // Deep Teal
      bucket: BudgetBucket.needs,
    ),
    CategoryItem(
      id: 'Home',
      name: 'Home',
      iconName: 'home',
      colorValue: 0xFF879B62, // Moss
      bucket: BudgetBucket.needs,
    ),
    CategoryItem(
      id: 'Health',
      name: 'Health',
      iconName: 'favorite',
      colorValue: 0xFF879B62, // Moss
      bucket: BudgetBucket.needs,
    ),
    CategoryItem(
      id: 'Learning',
      name: 'Learning',
      iconName: 'school',
      colorValue: 0xFF1C5954, // Deep Teal
      bucket: BudgetBucket.wants,
    ),
    CategoryItem(
      id: 'Fun',
      name: 'Fun',
      iconName: 'sports_esports',
      colorValue: 0xFFC99A4B, // Muted Amber
      bucket: BudgetBucket.wants,
    ),
    CategoryItem(
      id: 'Debt',
      name: 'Debt',
      iconName: 'receipt_long',
      colorValue: 0xFFB96D69, // Clay Rose
      bucket: BudgetBucket.savings,
    ),
    CategoryItem(
      id: 'Savings',
      name: 'Savings',
      iconName: 'account_balance_wallet',
      colorValue: 0xFF4D8E75, // Soft Jade
      bucket: BudgetBucket.savings,
    ),
  ];

  static CategoryItem fromCategoryId(String categoryId) {
    return defaultCategories.firstWhere(
      (c) =>
          c.id.toLowerCase() == categoryId.toLowerCase() ||
          c.name.toLowerCase() == categoryId.toLowerCase(),
      orElse: () => defaultCategories[1], // default Food
    );
  }

  String getLocalizedName(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    return getLocalizedCategoryName(id, locale);
  }

  static String getLocalizedCategoryName(String categoryId, String langCode) {
    if (langCode == 'th') {
      return getCategoryThaiName(categoryId);
    }
    switch (categoryId) {
      case 'Income':
        return 'Income';
      case 'Food':
        return 'Food & Dining';
      case 'Transport':
        return 'Transportation';
      case 'Home':
        return 'Housing & Bills';
      case 'Health':
        return 'Health & Medical';
      case 'Learning':
        return 'Education & Skills';
      case 'Fun':
        return 'Entertainment & Travel';
      case 'Debt':
        return 'Debt & Loan Payments';
      case 'Savings':
        return 'Savings & Investments';
      default:
        return categoryId;
    }
  }

  static String getCategoryThaiName(String categoryId) {
    switch (categoryId) {
      case 'Income':
        return 'รายรับ';
      case 'Food':
        return 'อาหาร & เครื่องดื่ม';
      case 'Transport':
        return 'เดินทาง & คมนาคม';
      case 'Home':
        return 'ที่อยู่อาศัย & บิล';
      case 'Health':
        return 'สุขภาพ & ยา';
      case 'Learning':
        return 'การศึกษา & พัฒนาตนเอง';
      case 'Fun':
        return 'ความบันเทิง & ท่องเที่ยว';
      case 'Debt':
        return 'หนี้สิน & ผ่อนชำระ';
      case 'Savings':
        return 'เงินออม & ลงทุน';
      default:
        return categoryId;
    }
  }
}

