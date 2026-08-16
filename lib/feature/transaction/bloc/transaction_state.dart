import 'package:equatable/equatable.dart';
import 'package:mobile_app_standard/domain/models/transaction/category_item.dart';
import 'package:mobile_app_standard/domain/models/transaction/transaction_item.dart';

enum TransactionStatus { initial, loading, success, failure }
enum TransactionSortField { date, amount, name, category }

class TransactionState extends Equatable {
  final TransactionStatus status;
  final List<TransactionItem> allTransactions;
  final List<TransactionItem> filteredTransactions;
  final List<CategoryItem> categories;
  final String? monthFilter;
  final String? categoryFilter;
  final bool? clearedFilter;
  final String searchQuery;
  final TransactionSortField sortField;
  final bool sortAscending;
  final int lastExpAwarded;
  final String? errorMessage;

  const TransactionState({
    this.status = TransactionStatus.initial,
    this.allTransactions = const [],
    this.filteredTransactions = const [],
    this.categories = const [],
    this.monthFilter,
    this.categoryFilter,
    this.clearedFilter,
    this.searchQuery = '',
    this.sortField = TransactionSortField.date,
    this.sortAscending = false,
    this.lastExpAwarded = 0,
    this.errorMessage,
  });

  TransactionState copyWith({
    TransactionStatus? status,
    List<TransactionItem>? allTransactions,
    List<TransactionItem>? filteredTransactions,
    List<CategoryItem>? categories,
    String? monthFilter,
    String? categoryFilter,
    bool? clearedFilter,
    bool clearCategoryFilter = false,
    bool clearClearedFilter = false,
    String? searchQuery,
    TransactionSortField? sortField,
    bool? sortAscending,
    int? lastExpAwarded,
    String? errorMessage,
  }) {
    return TransactionState(
      status: status ?? this.status,
      allTransactions: allTransactions ?? this.allTransactions,
      filteredTransactions: filteredTransactions ?? this.filteredTransactions,
      categories: categories ?? this.categories,
      monthFilter: monthFilter ?? this.monthFilter,
      categoryFilter: clearCategoryFilter
          ? null
          : (categoryFilter ?? this.categoryFilter),
      clearedFilter: clearClearedFilter
          ? null
          : (clearedFilter ?? this.clearedFilter),
      searchQuery: searchQuery ?? this.searchQuery,
      sortField: sortField ?? this.sortField,
      sortAscending: sortAscending ?? this.sortAscending,
      lastExpAwarded: lastExpAwarded ?? this.lastExpAwarded,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        allTransactions,
        filteredTransactions,
        categories,
        monthFilter,
        categoryFilter,
        clearedFilter,
        searchQuery,
        sortField,
        sortAscending,
        lastExpAwarded,
        errorMessage,
      ];
}
