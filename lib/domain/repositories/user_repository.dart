import 'package:mobile_app_standard/domain/models/gamification/user_profile.dart';
import 'package:mobile_app_standard/domain/services/gamification_engine.dart';
import 'package:mobile_app_standard/domain/services/storage_service.dart';

abstract class UserRepositoryInterface {
  Future<UserProfile> getUserProfile();
  Future<UserProfile> addExp(int expToAdd, {int coinsToAdd = 0});
  Future<UserProfile> checkInDaily();
  Future<UserProfile> updateUnlockedAchievements(List<String> achievementIds);
}

class UserRepository implements UserRepositoryInterface {
  final StorageService storageService;

  UserRepository(this.storageService);

  @override
  Future<UserProfile> getUserProfile() async {
    final totalXp = storageService.getTotalXp();
    final streakDays = storageService.getStreakDays();
    final lastActiveDate = storageService.getLastActiveDate();
    final unlockedIds = storageService.getUnlockedAchievementIds();

    return UserProfile(
      totalXp: totalXp,
      streakDays: streakDays,
      lastActiveDate: lastActiveDate,
      unlockedAchievementIds: unlockedIds,
    );
  }

  @override
  Future<UserProfile> addExp(int expToAdd, {int coinsToAdd = 0}) async {
    final currentXp = storageService.getTotalXp();
    final newXp = currentXp + expToAdd;
    await storageService.saveTotalXp(newXp);

    // Also update activity streak date
    final lastDate = storageService.getLastActiveDate();
    final streak = storageService.getStreakDays();
    final streakResult = GamificationEngine.updateStreak(lastDate, streak);
    await storageService.saveStreakDays(streakResult.newStreak);
    await storageService.saveLastActiveDate(streakResult.today);

    return getUserProfile();
  }

  @override
  Future<UserProfile> checkInDaily() async {
    final lastDate = storageService.getLastActiveDate();
    final streak = storageService.getStreakDays();
    final streakResult = GamificationEngine.updateStreak(lastDate, streak);

    await storageService.saveStreakDays(streakResult.newStreak);
    await storageService.saveLastActiveDate(streakResult.today);

    return addExp(20);
  }

  @override
  Future<UserProfile> updateUnlockedAchievements(
      List<String> achievementIds) async {
    await storageService.saveUnlockedAchievementIds(achievementIds);
    return getUserProfile();
  }
}
