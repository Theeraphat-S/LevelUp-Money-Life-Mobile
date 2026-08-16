import 'package:intl/intl.dart';
import 'package:mobile_app_standard/domain/models/transaction/category_item.dart';

enum TransactionType { expense, income }

class TransactionItem {
  final String id;
  final String name;
  final double amount; // signed amount: positive for income, negative for expense
  final String date; // "YYYY-MM-DD"
  final String category;
  final bool cleared;
  final String? notes;
  final int expGained;

  TransactionItem({
    required this.id,
    required this.name,
    required this.amount,
    required this.date,
    required this.category,
    this.cleared = true,
    this.notes,
    this.expGained = 15,
  });

  bool get isIncome => amount > 0 || category == 'Income';
  bool get isExpense => !isIncome;
  double get absAmount => amount.abs();
  String get title => name;
  String? get note => notes;

  TransactionType get type =>
      isIncome ? TransactionType.income : TransactionType.expense;

  CategoryItem get categoryItem => CategoryItem.fromCategoryId(category);

  DateTime get parsedDate {
    try {
      return DateTime.parse(date);
    } catch (_) {
      return DateTime.now();
    }
  }

  String get formattedMonth {
    if (date.length >= 7) {
      return date.substring(0, 7);
    }
    return DateFormat('yyyy-MM').format(DateTime.now());
  }

  TransactionItem copyWith({
    String? id,
    String? name,
    double? amount,
    String? date,
    String? category,
    bool? cleared,
    String? notes,
    int? expGained,
  }) {
    return TransactionItem(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      category: category ?? this.category,
      cleared: cleared ?? this.cleared,
      notes: notes ?? this.notes,
      expGained: expGained ?? this.expGained,
    );
  }

  factory TransactionItem.fromJson(Map<String, dynamic> json) {
    final rawAmount = (json['amount'] as num?)?.toDouble() ?? 0.0;
    final cat = json['category'] as String? ??
        json['categoryName'] as String? ??
        'Food';
    final name = json['name'] as String? ?? json['title'] as String? ?? 'รายการ';

    String dateStr = json['date'] as String? ??
        DateFormat('yyyy-MM-dd').format(DateTime.now());
    if (dateStr.length > 10) {
      dateStr = dateStr.substring(0, 10);
    }

    return TransactionItem(
      id: json['id'] as String? ??
          'tx_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      amount: rawAmount,
      date: dateStr,
      category: cat,
      cleared: json['cleared'] as bool? ?? true,
      notes: json['notes'] as String? ?? json['note'] as String?,
      expGained: json['expGained'] as int? ?? 15,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'date': date,
      'category': category,
      'cleared': cleared,
      if (notes != null && notes!.isNotEmpty) 'notes': notes,
    };
  }
}
