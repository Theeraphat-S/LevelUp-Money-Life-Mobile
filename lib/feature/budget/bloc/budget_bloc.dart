import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app_standard/domain/models/budget/allocation_item.dart';
import 'package:mobile_app_standard/domain/repositories/budget_repository.dart';
import 'package:mobile_app_standard/domain/repositories/gamification_repository.dart';
import 'package:mobile_app_standard/domain/repositories/transaction_repository.dart';

// State
enum BudgetStatus { initial, loading, success, failure }

class BudgetState extends Equatable {
  final BudgetStatus status;
  final double monthlyIncome;
  final List<AllocationItem> allocations;
  final List<BucketSpendingSummary> summaries;
  final String? errorMessage;

  const BudgetState({
    this.status = BudgetStatus.initial,
    this.monthlyIncome = 48000.0,
    this.allocations = const [],
    this.summaries = const [],
    this.errorMessage,
  });

  int get totalAllocatedPercent =>
      allocations.fold<int>(0, (sum, a) => sum + a.percent);

  bool get isBalanced => totalAllocatedPercent == 100;

  BudgetState copyWith({
    BudgetStatus? status,
    double? monthlyIncome,
    List<AllocationItem>? allocations,
    List<BucketSpendingSummary>? summaries,
    String? errorMessage,
  }) {
    return BudgetState(
      status: status ?? this.status,
      monthlyIncome: monthlyIncome ?? this.monthlyIncome,
      allocations: allocations ?? this.allocations,
      summaries: summaries ?? this.summaries,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        monthlyIncome,
        allocations,
        summaries,
        errorMessage,
      ];
}

// Events
abstract class BudgetEvent extends Equatable {
  const BudgetEvent();
  @override
  List<Object?> get props => [];
}

class LoadBudgetDataEvent extends BudgetEvent {
  final String? monthFilter;
  const LoadBudgetDataEvent({this.monthFilter});
  @override
  List<Object?> get props => [monthFilter];
}

class UpdateAllocationsEvent extends BudgetEvent {
  final List<AllocationItem> allocations;
  const UpdateAllocationsEvent(this.allocations);
  @override
  List<Object?> get props => [allocations];
}

class UpdateMonthlyIncomeEvent extends BudgetEvent {
  final double income;
  const UpdateMonthlyIncomeEvent(this.income);
  @override
  List<Object?> get props => [income];
}

// Bloc
class BudgetBloc extends Bloc<BudgetEvent, BudgetState> {
  final BudgetRepositoryInterface budgetRepository;
  final TransactionRepositoryInterface transactionRepository;
  final GamificationRepositoryInterface gamificationRepository;

  BudgetBloc({
    required this.budgetRepository,
    required this.transactionRepository,
    required this.gamificationRepository,
  }) : super(const BudgetState()) {
    on<LoadBudgetDataEvent>(_onLoadBudgetData);
    on<UpdateAllocationsEvent>(_onUpdateAllocations);
    on<UpdateMonthlyIncomeEvent>(_onUpdateMonthlyIncome);
  }

  Future<void> _onLoadBudgetData(
    LoadBudgetDataEvent event,
    Emitter<BudgetState> emit,
  ) async {
    emit(state.copyWith(status: BudgetStatus.loading));
    try {
      final income = await budgetRepository.getMonthlyIncome();
      final allocations = await budgetRepository.getAllocations();
      final transactions = await transactionRepository.getTransactions(
          monthFilter: event.monthFilter);

      final summaries = await budgetRepository.calculateBucketSummaries(
        transactions: transactions,
        monthlyIncome: income,
        allocations: allocations,
      );

      emit(state.copyWith(
        status: BudgetStatus.success,
        monthlyIncome: income,
        allocations: allocations,
        summaries: summaries,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: BudgetStatus.failure,
        errorMessage: 'ไม่สามารถโหลดข้อมูลงบประมาณได้: $e',
      ));
    }
  }

  Future<void> _onUpdateAllocations(
    UpdateAllocationsEvent event,
    Emitter<BudgetState> emit,
  ) async {
    try {
      await budgetRepository.saveAllocations(event.allocations);
      await gamificationRepository.evaluateAchievements();
      add(const LoadBudgetDataEvent());
    } catch (e) {
      emit(state.copyWith(errorMessage: 'เกิดข้อผิดพลาดในการบันทึกสัดส่วนงบ: $e'));
    }
  }

  Future<void> _onUpdateMonthlyIncome(
    UpdateMonthlyIncomeEvent event,
    Emitter<BudgetState> emit,
  ) async {
    try {
      await budgetRepository.saveMonthlyIncome(event.income);
      add(const LoadBudgetDataEvent());
    } catch (e) {
      emit(state.copyWith(errorMessage: 'เกิดข้อผิดพลาดในการบันทึกรายได้: $e'));
    }
  }
}
