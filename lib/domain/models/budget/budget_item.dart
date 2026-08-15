class BudgetItem {
  final String id;
  final String categoryId;
  final String categoryName;
  final String categoryIcon;
  final double monthlyLimit;
  final double spentAmount;

  BudgetItem({
    required this.id,
    required this.categoryId,
    required this.categoryName,
    required this.categoryIcon,
    required this.monthlyLimit,
    this.spentAmount = 0.0,
  });

  double get percentUsed =>
      monthlyLimit > 0 ? (spentAmount / monthlyLimit).clamp(0.0, 1.5) : 0.0;

  bool get isExceeded => spentAmount > monthlyLimit;

  factory BudgetItem.fromJson(Map<String, dynamic> json) {
    return BudgetItem(
      id: json['id'] as String,
      categoryId: json['categoryId'] as String,
      categoryName: json['categoryName'] as String? ?? 'หมวดหมู่',
      categoryIcon: json['categoryIcon'] as String? ?? 'category',
      monthlyLimit: (json['monthlyLimit'] as num?)?.toDouble() ?? 5000.0,
      spentAmount: (json['spentAmount'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'categoryIcon': categoryIcon,
      'monthlyLimit': monthlyLimit,
      'spentAmount': spentAmount,
    };
  }
}

class SavingsGoal {
  final String id;
  final String title;
  final double targetAmount;
  final double currentAmount;
  final String iconKey;
  final int colorValue;
  final DateTime? targetDate;

  SavingsGoal({
    required this.id,
    required this.title,
    required this.targetAmount,
    this.currentAmount = 0.0,
    this.iconKey = 'savings',
    this.colorValue = 0xFF10B981,
    this.targetDate,
  });

  double get progressRatio =>
      targetAmount > 0 ? (currentAmount / targetAmount).clamp(0.0, 1.0) : 0.0;

  factory SavingsGoal.fromJson(Map<String, dynamic> json) {
    return SavingsGoal(
      id: json['id'] as String,
      title: json['title'] as String,
      targetAmount: (json['targetAmount'] as num?)?.toDouble() ?? 10000.0,
      currentAmount: (json['currentAmount'] as num?)?.toDouble() ?? 0.0,
      iconKey: json['iconKey'] as String? ?? 'savings',
      colorValue: json['colorValue'] as int? ?? 0xFF10B981,
      targetDate: json['targetDate'] != null
          ? DateTime.tryParse(json['targetDate'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'targetAmount': targetAmount,
      'currentAmount': currentAmount,
      'iconKey': iconKey,
      'colorValue': colorValue,
      'targetDate': targetDate?.toIso8601String(),
    };
  }
}
