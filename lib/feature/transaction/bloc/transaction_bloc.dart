import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app_standard/domain/models/transaction/transaction_item.dart';
import 'package:mobile_app_standard/domain/repositories/transaction_repository.dart';
import 'package:mobile_app_standard/domain/repositories/user_repository.dart';
import 'package:mobile_app_standard/feature/transaction/bloc/transaction_event.dart';
import 'package:mobile_app_standard/feature/transaction/bloc/transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final TransactionRepositoryInterface transactionRepository;
  final UserRepositoryInterface userRepository;

  TransactionBloc({
    required this.transactionRepository,
    required this.userRepository,
  }) : super(const TransactionState()) {
    on<LoadTransactionsEvent>(_onLoadTransactions);
    on<CreateTransactionEvent>(_onCreateTransaction);
    on<DeleteTransactionEvent>(_onDeleteTransaction);
    on<FilterTransactionsByTypeEvent>(_onFilterTransactions);
  }

  Future<void> _onLoadTransactions(
    LoadTransactionsEvent event,
    Emitter<TransactionState> emit,
  ) async {
    emit(state.copyWith(status: TransactionStatus.loading));
    try {
      final transactions = await transactionRepository.getTransactions();
      final categories = await transactionRepository.getCategories();
      final wallets = await transactionRepository.getWallets();

      emit(state.copyWith(
        status: TransactionStatus.success,
        allTransactions: transactions,
        filteredTransactions: _applyFilter(transactions, state.currentFilter),
        categories: categories,
        wallets: wallets,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: TransactionStatus.failure,
        errorMessage: 'เกิดข้อผิดพลาดในการโหลดรายการ: $e',
      ));
    }
  }

  Future<void> _onCreateTransaction(
    CreateTransactionEvent event,
    Emitter<TransactionState> emit,
  ) async {
    emit(state.copyWith(status: TransactionStatus.loading));
    try {
      final response =
          await transactionRepository.createTransaction(event.request);
      
      // Award EXP to User Profile
      await userRepository.addExp(response.expAwarded);

      final updatedTransactions =
          await transactionRepository.getTransactions();
      final updatedWallets = await transactionRepository.getWallets();

      emit(state.copyWith(
        status: TransactionStatus.success,
        allTransactions: updatedTransactions,
        filteredTransactions:
            _applyFilter(updatedTransactions, state.currentFilter),
        wallets: updatedWallets,
        lastCreatedResponse: response,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: TransactionStatus.failure,
        errorMessage: 'ไม่สามารถบันทึกรายการได้: $e',
      ));
    }
  }

  Future<void> _onDeleteTransaction(
    DeleteTransactionEvent event,
    Emitter<TransactionState> emit,
  ) async {
    try {
      await transactionRepository.deleteTransaction(event.transactionId);
      final updatedList = state.allTransactions
          .where((t) => t.id != event.transactionId)
          .toList();

      emit(state.copyWith(
        allTransactions: updatedList,
        filteredTransactions: _applyFilter(updatedList, state.currentFilter),
      ));
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'ลบรายการไม่สำเร็จ: $e',
      ));
    }
  }

  void _onFilterTransactions(
    FilterTransactionsByTypeEvent event,
    Emitter<TransactionState> emit,
  ) {
    emit(state.copyWith(
      currentFilter: event.filterType,
      filteredTransactions:
          _applyFilter(state.allTransactions, event.filterType),
    ));
  }

  List<TransactionItem> _applyFilter(
    List<TransactionItem> items,
    TransactionType? filter,
  ) {
    if (filter == null) return items;
    return items.where((i) => i.type == filter).toList();
  }
}
