import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:levelup_money_life/domain/models/transaction/transaction_item.dart';
import 'package:levelup_money_life/domain/repositories/budget_repository.dart';
import 'package:levelup_money_life/domain/repositories/gamification_repository.dart';
import 'package:levelup_money_life/domain/repositories/transaction_repository.dart';
import 'package:levelup_money_life/domain/repositories/user_repository.dart';
import 'package:levelup_money_life/feature/dashboard/bloc/dashboard_event.dart';
import 'package:levelup_money_life/feature/dashboard/bloc/dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final UserRepositoryInterface userRepository;
  final TransactionRepositoryInterface transactionRepository;
  final GamificationRepositoryInterface gamificationRepository;
  final BudgetRepositoryInterface budgetRepository;

  DashboardBloc({
    required this.userRepository,
    required this.transactionRepository,
    required this.gamificationRepository,
    required this.budgetRepository,
  }) : super(const DashboardState()) {
    on<LoadDashboardData>(_onLoadDashboardData);
    on<CheckInDailyEvent>(_onCheckInDaily);
    on<ClaimQuestRewardEvent>(_onClaimQuestReward);
  }

  Future<void> _onLoadDashboardData(
    LoadDashboardData event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(status: DashboardStatus.loading));
    try {
      final user = await userRepository.getUserProfile();
      final quests = await gamificationRepository.getDailyQuests();

      await emit.forEach<List<TransactionItem>>(
        transactionRepository.watchTransactions(monthFilter: event.monthFilter),
        onData: (transactions) {
          double totalIncome = 0.0;
          double totalExpense = 0.0;
          for (final tx in transactions) {
            if (tx.isIncome) {
              totalIncome += tx.absAmount;
            } else {
              totalExpense += tx.absAmount;
            }
          }
          final netSavings = totalIncome - totalExpense;
          final summary = {
            'totalIncome': totalIncome,
            'totalExpense': totalExpense,
            'netSavings': netSavings,
            'totalBalance': netSavings,
          };

          return state.copyWith(
            status: DashboardStatus.success,
            userProfile: user,
            summary: summary,
            recentTransactions: transactions.take(5).toList(),
            activeQuests: quests,
          );
        },
        onError: (e, stack) => state.copyWith(
          status: DashboardStatus.failure,
          errorMessage: 'ไม่สามารถโหลดข้อมูลได้: $e',
        ),
      );
    } catch (e) {
      emit(state.copyWith(
        status: DashboardStatus.failure,
        errorMessage: 'ไม่สามารถโหลดข้อมูลได้: $e',
      ));
    }
  }

  Future<void> _onCheckInDaily(
    CheckInDailyEvent event,
    Emitter<DashboardState> emit,
  ) async {
    try {
      final updatedUser = await userRepository.checkInDaily();
      emit(state.copyWith(
        userProfile: updatedUser,
        notificationMessage: 'เช็คอินสำเร็จ! ได้รับ +20 EXP',
      ));
    } catch (e) {
      emit(state.copyWith(errorMessage: 'เกิดข้อผิดพลาดในการเช็คอิน: $e'));
    }
  }

  Future<void> _onClaimQuestReward(
    ClaimQuestRewardEvent event,
    Emitter<DashboardState> emit,
  ) async {
    try {
      final claimedQuest =
          await gamificationRepository.claimQuestReward(event.questId);
      final updatedUser = await userRepository.getUserProfile();
      final quests = await gamificationRepository.getDailyQuests();

      emit(state.copyWith(
        userProfile: updatedUser,
        activeQuests: quests,
        notificationMessage:
            'รับรางวัลภารกิจสำเร็จ! +${claimedQuest.xp} EXP',
      ));
    } catch (e) {
      emit(state.copyWith(errorMessage: 'ไม่สามารถรับรางวัลได้: $e'));
    }
  }
}
