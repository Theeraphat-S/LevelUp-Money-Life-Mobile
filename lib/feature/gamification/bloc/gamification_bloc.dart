import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app_standard/domain/repositories/gamification_repository.dart';
import 'package:mobile_app_standard/domain/repositories/user_repository.dart';
import 'package:mobile_app_standard/feature/gamification/bloc/gamification_event.dart';
import 'package:mobile_app_standard/feature/gamification/bloc/gamification_state.dart';

class GamificationBloc extends Bloc<GamificationEvent, GamificationState> {
  final GamificationRepositoryInterface gamificationRepository;
  final UserRepositoryInterface userRepository;

  GamificationBloc({
    required this.gamificationRepository,
    required this.userRepository,
  }) : super(const GamificationState()) {
    on<LoadGamificationDataEvent>(_onLoadData);
    on<ClaimQuestEvent>(_onClaimQuest);
  }

  Future<void> _onLoadData(
    LoadGamificationDataEvent event,
    Emitter<GamificationState> emit,
  ) async {
    emit(state.copyWith(status: GamificationStatus.loading));
    try {
      final user = await userRepository.getUserProfile();
      final quests = await gamificationRepository.getDailyQuests();
      final achievements = await gamificationRepository.getAchievements();

      emit(state.copyWith(
        status: GamificationStatus.success,
        userProfile: user,
        dailyQuests: quests,
        achievements: achievements,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: GamificationStatus.failure,
        errorMessage: 'ไม่สามารถโหลดข้อมูลเควสได้: $e',
      ));
    }
  }

  Future<void> _onClaimQuest(
    ClaimQuestEvent event,
    Emitter<GamificationState> emit,
  ) async {
    try {
      final claimed =
          await gamificationRepository.claimQuestReward(event.questId);
      final updatedUser = await userRepository.addExp(
        claimed.expReward,
        coinsToAdd: claimed.coinReward,
      );

      final updatedQuests = state.dailyQuests.map((q) {
        return q.id == event.questId ? claimed : q;
      }).toList();

      emit(state.copyWith(
        userProfile: updatedUser,
        dailyQuests: updatedQuests,
        message:
            '✨ ปลดล็อกสำเร็จ! ได้รับ +${claimed.expReward} EXP และ +${claimed.coinReward} Coins',
      ));
    } catch (e) {
      emit(state.copyWith(errorMessage: 'เกิดข้อผิดพลาดในการรับรางวัล: $e'));
    }
  }
}
