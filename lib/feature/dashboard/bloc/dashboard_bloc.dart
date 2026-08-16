import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app_standard/domain/repositories/budget_repository.dart';
import 'package:mobile_app_standard/domain/repositories/gamification_repository.dart';
import 'package:mobile_app_standard/domain/repositories/transaction_repository.dart';
import 'package:mobile_app_standard/domain/repositories/user_repository.dart';
import 'package:mobile_app_standard/feature/dashboard/bloc/dashboard_event.dart';
import 'package:mobile_app_standard/feature/dashboard/bloc/dashboard_state.dart';

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
      final summary = await transactionRepository.getFinancialSummary(
          monthFilter: event.monthFilter);
      final transactions = await transactionRepository.getTransactions(
          monthFilter: event.monthFilter);
      final quests = await gamificationRepository.getDailyQuests();

      emit(state.copyWith(
        status: DashboardStatus.success,
        userProfile: user,
        summary: summary,
        recentTransactions: transactions.take(5).toList(),
        activeQuests: quests,
      ));
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
