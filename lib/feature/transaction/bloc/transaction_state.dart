import 'package:equatable/equatable.dart';
import 'package:mobile_app_standard/domain/dto/transaction_dto.dart';
import 'package:mobile_app_standard/domain/models/transaction/category_item.dart';
import 'package:mobile_app_standard/domain/models/transaction/transaction_item.dart';
import 'package:mobile_app_standard/domain/models/transaction/wallet_item.dart';

enum TransactionStatus { initial, loading, success, failure }

class TransactionState extends Equatable {
  final TransactionStatus status;
  final List<TransactionItem> allTransactions;
  final List<TransactionItem> filteredTransactions;
  final List<CategoryItem> categories;
  final List<WalletItem> wallets;
  final TransactionType? currentFilter;
  final TransactionResponse? lastCreatedResponse;
  final String? errorMessage;

  const TransactionState({
    this.status = TransactionStatus.initial,
    this.allTransactions = const [],
    this.filteredTransactions = const [],
    this.categories = const [],
    this.wallets = const [],
    this.currentFilter,
    this.lastCreatedResponse,
    this.errorMessage,
  });

  TransactionState copyWith({
    TransactionStatus? status,
    List<TransactionItem>? allTransactions,
    List<TransactionItem>? filteredTransactions,
    List<CategoryItem>? categories,
    List<WalletItem>? wallets,
    TransactionType? currentFilter,
    TransactionResponse? lastCreatedResponse,
    String? errorMessage,
    bool clearLastCreated = false,
  }) {
    return TransactionState(
      status: status ?? this.status,
      allTransactions: allTransactions ?? this.allTransactions,
      filteredTransactions: filteredTransactions ?? this.filteredTransactions,
      categories: categories ?? this.categories,
      wallets: wallets ?? this.wallets,
      currentFilter: currentFilter ?? this.currentFilter,
      lastCreatedResponse: clearLastCreated
          ? null
          : (lastCreatedResponse ?? this.lastCreatedResponse),
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        allTransactions,
        filteredTransactions,
        categories,
        wallets,
        currentFilter,
        lastCreatedResponse,
        errorMessage,
      ];
}
