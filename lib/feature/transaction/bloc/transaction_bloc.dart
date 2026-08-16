import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app_standard/domain/models/transaction/transaction_item.dart';
import 'package:mobile_app_standard/domain/repositories/gamification_repository.dart';
import 'package:mobile_app_standard/domain/repositories/transaction_repository.dart';
import 'package:mobile_app_standard/domain/repositories/user_repository.dart';
import 'package:mobile_app_standard/feature/transaction/bloc/transaction_event.dart';
import 'package:mobile_app_standard/feature/transaction/bloc/transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final TransactionRepositoryInterface transactionRepository;
  final UserRepositoryInterface userRepository;
  final GamificationRepositoryInterface gamificationRepository;

  TransactionBloc({
    required this.transactionRepository,
    required this.userRepository,
    required this.gamificationRepository,
  }) : super(const TransactionState()) {
    on<LoadTransactionsEvent>(_onLoadTransactions);
    on<AddTransactionItemEvent>(_onAddTransaction);
    on<UpdateTransactionItemEvent>(_onUpdateTransaction);
    on<DeleteTransactionItemEvent>(_onDeleteTransaction);
    on<ToggleTransactionClearedEvent>(_onToggleCleared);
    on<BulkToggleTransactionClearedEvent>(_onBulkToggleCleared);
    on<SetTransactionFilterEvent>(_onSetFilters);
  }

  Future<void> _onLoadTransactions(
    LoadTransactionsEvent event,
    Emitter<TransactionState> emit,
  ) async {
    emit(state.copyWith(status: TransactionStatus.loading));
    try {
      final month = event.monthFilter ?? state.monthFilter;
      final transactions =
          await transactionRepository.getTransactions(monthFilter: month);
      final categories = await transactionRepository.getCategories();

      final filtered = _applyFiltersAndSort(
        transactions,
        categoryFilter: state.categoryFilter,
        clearedFilter: state.clearedFilter,
        search: state.searchQuery,
        sortField: state.sortField,
        sortAscending: state.sortAscending,
      );

      emit(state.copyWith(
        status: TransactionStatus.success,
        allTransactions: transactions,
        filteredTransactions: filtered,
        categories: categories,
        monthFilter: month,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: TransactionStatus.failure,
        errorMessage: 'เกิดข้อผิดพลาดในการโหลดรายการ: $e',
      ));
    }
  }

  Future<void> _onAddTransaction(
    AddTransactionItemEvent event,
    Emitter<TransactionState> emit,
  ) async {
    try {
      final tx = event.transaction;
      await transactionRepository.createTransaction(tx);

      // Calculate EXP to award
      int expAwarded = tx.isIncome ? 30 : 15;
      if (tx.notes != null && tx.notes!.isNotEmpty) {
        expAwarded += 5; // writing note bonus
      }
      if (event.bonusExp > 0) {
        expAwarded += event.bonusExp; // slip scan bonus
      }

      await userRepository.addExp(expAwarded);
      await gamificationRepository.evaluateAchievements();

      add(LoadTransactionsEvent(monthFilter: state.monthFilter));
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'ไม่สามารถบันทึกรายการได้: $e',
      ));
    }
  }

  Future<void> _onUpdateTransaction(
    UpdateTransactionItemEvent event,
    Emitter<TransactionState> emit,
  ) async {
    try {
      await transactionRepository.updateTransaction(event.transaction);
      await gamificationRepository.evaluateAchievements();
      add(LoadTransactionsEvent(monthFilter: state.monthFilter));
    } catch (e) {
      emit(state.copyWith(errorMessage: 'ไม่สามารถแก้ไขรายการได้: $e'));
    }
  }

  Future<void> _onDeleteTransaction(
    DeleteTransactionItemEvent event,
    Emitter<TransactionState> emit,
  ) async {
    try {
      await transactionRepository.deleteTransaction(event.id);
      add(LoadTransactionsEvent(monthFilter: state.monthFilter));
    } catch (e) {
      emit(state.copyWith(errorMessage: 'ไม่สามารถลบรายการได้: $e'));
    }
  }

  Future<void> _onToggleCleared(
    ToggleTransactionClearedEvent event,
    Emitter<TransactionState> emit,
  ) async {
    try {
      await transactionRepository.toggleCleared(event.id);
      await gamificationRepository.evaluateAchievements();
      add(LoadTransactionsEvent(monthFilter: state.monthFilter));
    } catch (e) {
      emit(state.copyWith(errorMessage: 'เกิดข้อผิดพลาด: $e'));
    }
  }

  Future<void> _onBulkToggleCleared(
    BulkToggleTransactionClearedEvent event,
    Emitter<TransactionState> emit,
  ) async {
    try {
      await transactionRepository.bulkToggleCleared(event.cleared,
          monthFilter: state.monthFilter);
      await gamificationRepository.evaluateAchievements();
      add(LoadTransactionsEvent(monthFilter: state.monthFilter));
    } catch (e) {
      emit(state.copyWith(errorMessage: 'เกิดข้อผิดพลาด: $e'));
    }
  }

  void _onSetFilters(
    SetTransactionFilterEvent event,
    Emitter<TransactionState> emit,
  ) {
    final newCategory = event.clearCategory
        ? null
        : (event.category ?? state.categoryFilter);
    final newCleared = event.clearCleared
        ? null
        : (event.cleared ?? state.clearedFilter);
    final newSearch = event.search ?? state.searchQuery;
    final newSortField = event.sortField ?? state.sortField;
    final newSortAscending = event.sortAscending ?? state.sortAscending;

    final filtered = _applyFiltersAndSort(
      state.allTransactions,
      categoryFilter: newCategory,
      clearedFilter: newCleared,
      search: newSearch,
      sortField: newSortField,
      sortAscending: newSortAscending,
    );

    emit(state.copyWith(
      filteredTransactions: filtered,
      categoryFilter: newCategory,
      clearedFilter: newCleared,
      clearCategoryFilter: event.clearCategory,
      clearClearedFilter: event.clearCleared,
      searchQuery: newSearch,
      sortField: newSortField,
      sortAscending: newSortAscending,
    ));
  }

  List<TransactionItem> _applyFiltersAndSort(
    List<TransactionItem> items, {
    String? categoryFilter,
    bool? clearedFilter,
    String? search,
    TransactionSortField sortField = TransactionSortField.date,
    bool sortAscending = false,
  }) {
    var result = List<TransactionItem>.from(items);

    if (categoryFilter != null && categoryFilter.isNotEmpty) {
      result = result
          .where((t) =>
              t.category.toLowerCase() == categoryFilter.toLowerCase())
          .toList();
    }

    if (clearedFilter != null) {
      result = result.where((t) => t.cleared == clearedFilter).toList();
    }

    if (search != null && search.trim().isNotEmpty) {
      final q = search.trim().toLowerCase();
      result = result.where((t) {
        final nameMatch = t.name.toLowerCase().contains(q);
        final notesMatch = t.notes?.toLowerCase().contains(q) ?? false;
        final catMatch = t.category.toLowerCase().contains(q);
        return nameMatch || notesMatch || catMatch;
      }).toList();
    }

    result.sort((a, b) {
      int cmp = 0;
      switch (sortField) {
        case TransactionSortField.date:
          cmp = a.date.compareTo(b.date);
          break;
        case TransactionSortField.amount:
          cmp = a.amount.compareTo(b.amount);
          break;
        case TransactionSortField.name:
          cmp = a.name.toLowerCase().compareTo(b.name.toLowerCase());
          break;
        case TransactionSortField.category:
          cmp = a.category.toLowerCase().compareTo(b.category.toLowerCase());
          break;
      }
      return sortAscending ? cmp : -cmp;
    });

    return result;
  }
}
