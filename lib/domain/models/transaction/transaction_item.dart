import 'package:mobile_app_standard/domain/models/transaction/category_item.dart';

enum TransactionType { expense, income, transfer }

class TransactionItem {
  final String id;
  final String title;
  final double amount;
  final TransactionType type;
  final String categoryId;
  final String categoryName;
  final String categoryIcon;
  final int categoryColor;
  final String walletId;
  final String walletName;
  final DateTime date;
  final String? note;
  final int expGained;

  TransactionItem({
    required this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.categoryId,
    required this.categoryName,
    required this.categoryIcon,
    required this.categoryColor,
    required this.walletId,
    required this.walletName,
    required this.date,
    this.note,
    this.expGained = 15,
  });

  factory TransactionItem.fromJson(Map<String, dynamic> json) {
    return TransactionItem(
      id: json['id'] as String,
      title: json['title'] as String,
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      type: TransactionType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => TransactionType.expense,
      ),
      categoryId: json['categoryId'] as String? ?? 'cat_food',
      categoryName: json['categoryName'] as String? ?? 'ทั่วไป',
      categoryIcon: json['categoryIcon'] as String? ?? 'restaurant',
      categoryColor: json['categoryColor'] as int? ?? 0xFFEF4444,
      walletId: json['walletId'] as String? ?? 'wallet_cash',
      walletName: json['walletName'] as String? ?? 'เงินสด',
      date: json['date'] != null
          ? DateTime.tryParse(json['date'].toString()) ?? DateTime.now()
          : DateTime.now(),
      note: json['note'] as String?,
      expGained: json['expGained'] as int? ?? 15,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'type': type.name,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'categoryIcon': categoryIcon,
      'categoryColor': categoryColor,
      'walletId': walletId,
      'walletName': walletName,
      'date': date.toIso8601String(),
      'note': note,
      'expGained': expGained,
    };
  }
}
