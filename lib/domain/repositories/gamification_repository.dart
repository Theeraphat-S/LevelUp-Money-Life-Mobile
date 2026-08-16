import 'package:mobile_app_standard/domain/models/gamification/quest.dart';
import 'package:mobile_app_standard/domain/services/gamification_engine.dart';
import 'package:mobile_app_standard/domain/services/storage_service.dart';

abstract class GamificationRepositoryInterface {
  Future<List<QuestItem>> getDailyQuests();
  Future<QuestItem> toggleQuest(String questId);
  Future<QuestItem> claimQuestReward(String questId);
  Future<AchievementEvaluationResult> evaluateAchievements();
}

class GamificationRepository implements GamificationRepositoryInterface {
  final StorageService storageService;

  GamificationRepository(this.storageService);

  @override
  Future<List<QuestItem>> getDailyQuests() async {
    return storageService.getQuests();
  }

  @override
  Future<QuestItem> toggleQuest(String questId) async {
    final quests = storageService.getQuests();
    final idx = quests.indexWhere((q) => q.id == questId);
    if (idx != -1) {
      final old = quests[idx];
      final newDone = !old.done;
      final updated = old.copyWith(done: newDone);
      quests[idx] = updated;
      await storageService.saveQuests(quests);

      // Add/remove XP
      final currentXp = storageService.getTotalXp();
      final adjustedXp =
          newDone ? currentXp + old.xp : (currentXp - old.xp).clamp(0, 9999999);
      await storageService.saveTotalXp(adjustedXp);

      return updated;
    }
    throw Exception('Quest not found: $questId');
  }

  @override
  Future<QuestItem> claimQuestReward(String questId) async {
    final quests = storageService.getQuests();
    final idx = quests.indexWhere((q) => q.id == questId);
    if (idx != -1) {
      final old = quests[idx];
      if (!old.done) {
        final updated = old.copyWith(done: true);
        quests[idx] = updated;
        await storageService.saveQuests(quests);

        final currentXp = storageService.getTotalXp();
        await storageService.saveTotalXp(currentXp + old.xp);
        return updated;
      }
      return old;
    }
    throw Exception('Quest not found: $questId');
  }

  @override
  Future<AchievementEvaluationResult> evaluateAchievements() async {
    final transactions = storageService.getTransactions();
    final quests = storageService.getQuests();
    final allocations = storageService.getAllocations();
    final streakDays = storageService.getStreakDays();
    final unlockedIds = storageService.getUnlockedAchievementIds();

    final result = GamificationEngine.evaluateAchievements(
      transactions: transactions,
      quests: quests,
      allocations: allocations,
      streakDays: streakDays,
      unlockedIds: unlockedIds,
    );

    if (result.newlyUnlocked.isNotEmpty) {
      final updatedIds = List<String>.from(unlockedIds);
      for (final ach in result.newlyUnlocked) {
        if (!updatedIds.contains(ach.id)) {
          updatedIds.add(ach.id);
        }
      }
      await storageService.saveUnlockedAchievementIds(updatedIds);

      if (result.bonusXp > 0) {
        final currentXp = storageService.getTotalXp();
        await storageService.saveTotalXp(currentXp + result.bonusXp);
      }
    }

    return result;
  }
}
