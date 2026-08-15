import 'package:flutter/material.dart';

enum WalletType { cash, bank, creditCard, eWallet }

class WalletItem {
  final String id;
  final String name;
  final WalletType type;
  final double balance;
  final int colorValue;
  final String? accountNumber;

  const WalletItem({
    required this.id,
    required this.name,
    required this.type,
    required this.balance,
    required this.colorValue,
    this.accountNumber,
  });

  Color get color => Color(colorValue);

  WalletItem copyWith({
    String? id,
    String? name,
    WalletType? type,
    double? balance,
    int? colorValue,
    String? accountNumber,
  }) {
    return WalletItem(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      balance: balance ?? this.balance,
      colorValue: colorValue ?? this.colorValue,
      accountNumber: accountNumber ?? this.accountNumber,
    );
  }

  factory WalletItem.fromJson(Map<String, dynamic> json) {
    return WalletItem(
      id: json['id'] as String,
      name: json['name'] as String,
      type: WalletType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => WalletType.cash,
      ),
      balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
      colorValue: json['colorValue'] as int? ?? 0xFF3B82F6,
      accountNumber: json['accountNumber'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.name,
      'balance': balance,
      'colorValue': colorValue,
      'accountNumber': accountNumber,
    };
  }

  static List<WalletItem> get defaultWallets => const [
        WalletItem(
          id: 'wallet_cash',
          name: 'เงินสด (Cash)',
          type: WalletType.cash,
          balance: 2500.0,
          colorValue: 0xFF10B981,
        ),
        WalletItem(
          id: 'wallet_kbank',
          name: 'ธนาคารกสิกรไทย (KBank)',
          type: WalletType.bank,
          balance: 18450.0,
          colorValue: 0xFF059669,
          accountNumber: 'xxx-x-x1234-x',
        ),
        WalletItem(
          id: 'wallet_scb',
          name: 'ธนาคารไทยพาณิชย์ (SCB)',
          type: WalletType.bank,
          balance: 8200.0,
          colorValue: 0xFF7C3AED,
          accountNumber: 'xxx-x-x5678-x',
        ),
      ];
}
