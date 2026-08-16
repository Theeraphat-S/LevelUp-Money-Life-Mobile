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
    on<ToggleQuestEvent>(_onToggleQuest);
    on<ClaimQuestEvent>(_onClaimQuest);
  }

  Future<void> _onLoadData(
    LoadGamificationDataEvent event,
    Emitter<GamificationState> emit,
  ) async {
    emit(state.copyWith(status: GamificationStatus.loading));
    try {
      final evalResult = await gamificationRepository.evaluateAchievements();
      final user = await userRepository.getUserProfile();
      final quests = await gamificationRepository.getDailyQuests();

      emit(state.copyWith(
        status: GamificationStatus.success,
        userProfile: user,
        dailyQuests: quests,
        achievements: evalResult.allAchievements,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: GamificationStatus.failure,
        errorMessage: 'ไม่สามารถโหลดข้อมูลเควสได้: $e',
      ));
    }
  }

  Future<void> _onToggleQuest(
    ToggleQuestEvent event,
    Emitter<GamificationState> emit,
  ) async {
    try {
      final updated = await gamificationRepository.toggleQuest(event.questId);
      final evalResult = await gamificationRepository.evaluateAchievements();
      final user = await userRepository.getUserProfile();
      final quests = await gamificationRepository.getDailyQuests();

      emit(state.copyWith(
        userProfile: user,
        dailyQuests: quests,
        achievements: evalResult.allAchievements,
        message: updated.done
            ? 'ทำเควสสำเร็จ! +${updated.xp} XP'
            : 'ยกเลิกสถานะเควสเรียบร้อย',
      ));
    } catch (e) {
      emit(state.copyWith(errorMessage: 'เกิดข้อผิดพลาด: $e'));
    }
  }

  Future<void> _onClaimQuest(
    ClaimQuestEvent event,
    Emitter<GamificationState> emit,
  ) async {
    try {
      final claimed =
          await gamificationRepository.claimQuestReward(event.questId);
      final evalResult = await gamificationRepository.evaluateAchievements();
      final user = await userRepository.getUserProfile();
      final quests = await gamificationRepository.getDailyQuests();

      emit(state.copyWith(
        userProfile: user,
        dailyQuests: quests,
        achievements: evalResult.allAchievements,
        message: 'ปลดล็อกสำเร็จ! ได้รับ +${claimed.xp} XP',
      ));
    } catch (e) {
      emit(state.copyWith(errorMessage: 'เกิดข้อผิดพลาดในการรับรางวัล: $e'));
    }
  }
}
