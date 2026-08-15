import 'package:mobile_app_standard/domain/models/transaction/transaction_item.dart';

class CreateTransactionRequest {
  final String title;
  final double amount;
  final TransactionType type;
  final String categoryId;
  final String walletId;
  final DateTime date;
  final String? note;

  CreateTransactionRequest({
    required this.title,
    required this.amount,
    required this.type,
    required this.categoryId,
    required this.walletId,
    required this.date,
    this.note,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'amount': amount,
      'type': type.name,
      'categoryId': categoryId,
      'walletId': walletId,
      'date': date.toIso8601String(),
      'note': note,
    };
  }
}

class TransactionResponse {
  final TransactionItem transaction;
  final int expAwarded;
  final bool isLevelUp;
  final int newLevel;

  TransactionResponse({
    required this.transaction,
    required this.expAwarded,
    this.isLevelUp = false,
    this.newLevel = 1,
  });

  factory TransactionResponse.fromJson(Map<String, dynamic> json) {
    return TransactionResponse(
      transaction: TransactionItem.fromJson(json['transaction']),
      expAwarded: json['expAwarded'] as int? ?? 15,
      isLevelUp: json['isLevelUp'] as bool? ?? false,
      newLevel: json['newLevel'] as int? ?? 1,
    );
  }
}
