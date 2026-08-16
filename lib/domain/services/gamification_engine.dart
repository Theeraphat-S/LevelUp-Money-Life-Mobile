import 'package:intl/intl.dart';
import 'package:mobile_app_standard/domain/models/budget/allocation_item.dart';
import 'package:mobile_app_standard/domain/models/gamification/achievement.dart';
import 'package:mobile_app_standard/domain/models/gamification/quest.dart';
import 'package:mobile_app_standard/domain/models/transaction/transaction_item.dart';

class LevelProgression {
  final int level;
  final int currentLevelXp;
  final int xpForNextLevel;
  final double progressPercent;
  final String titleRankKey;
  final String titleRankTh;
  final String titleRankEn;

  const LevelProgression({
    required this.level,
    required this.currentLevelXp,
    required this.xpForNextLevel,
    required this.progressPercent,
    required this.titleRankKey,
    required this.titleRankTh,
    required this.titleRankEn,
  });
}

class AchievementEvaluationResult {
  final List<AchievementItem> newlyUnlocked;
  final List<AchievementItem> allAchievements;
  final int bonusXp;

  const AchievementEvaluationResult({
    required this.newlyUnlocked,
    required this.allAchievements,
    required this.bonusXp,
  });
}

class GamificationEngine {
  /// Calculates XP required to advance from Level L to Level L+1.
  /// Level 1: 100 XP, Level 2: 150 XP, Level 3: 200 XP...
  static int getXpRequiredForLevel(int level) {
    return 100 + (level - 1) * 50;
  }

  /// Derives full level and progression stats from total lifetime XP.
  static LevelProgression calculateLevelFromTotalXp(int totalXp) {
    int level = 1;
    int remainingXp = totalXp < 0 ? 0 : totalXp;

    while (true) {
      final required = getXpRequiredForLevel(level);
      if (remainingXp >= required) {
        remainingXp -= required;
        level += 1;
      } else {
        break;
      }
    }

    final xpForNextLevel = getXpRequiredForLevel(level);
    final progressPercent =
        ((remainingXp / xpForNextLevel) * 100.0).clamp(0.0, 100.0);

    String titleRankKey = 'rank.novice';
    String titleRankTh = 'Novice';
    String titleRankEn = 'Novice';

    if (level >= 20) {
      titleRankKey = 'rank.maestro';
      titleRankTh = 'Maestro';
      titleRankEn = 'Maestro';
    } else if (level >= 15) {
      titleRankKey = 'rank.sovereign';
      titleRankTh = 'Sovereign';
      titleRankEn = 'Sovereign';
    } else if (level >= 10) {
      titleRankKey = 'rank.guardian';
      titleRankTh = 'Guardian';
      titleRankEn = 'Guardian';
    } else if (level >= 6) {
      titleRankKey = 'rank.strategist';
      titleRankTh = 'Strategist';
      titleRankEn = 'Strategist';
    } else if (level >= 3) {
      titleRankKey = 'rank.tactician';
      titleRankTh = 'Tactician';
      titleRankEn = 'Tactician';
    }

    return LevelProgression(
      level: level,
      currentLevelXp: remainingXp,
      xpForNextLevel: xpForNextLevel,
      progressPercent: progressPercent,
      titleRankKey: titleRankKey,
      titleRankTh: titleRankTh,
      titleRankEn: titleRankEn,
    );
  }

  /// Calculates updated streak days comparing last active date with current date.
  static ({int newStreak, String today}) updateStreak(
      String? lastActiveDate, int currentStreak) {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    if (lastActiveDate == null || lastActiveDate.isEmpty) {
      return (newStreak: 1, today: today);
    }
    if (lastActiveDate == today) {
      return (newStreak: currentStreak < 1 ? 1 : currentStreak, today: today);
    }

    try {
      final lastDate = DateTime.parse(lastActiveDate);
      final curDate = DateTime.parse(today);
      final diffDays = curDate.difference(lastDate).inDays;

      if (diffDays == 1) {
        return (newStreak: currentStreak + 1, today: today);
      } else {
        return (newStreak: 1, today: today);
      }
    } catch (_) {
      return (newStreak: 1, today: today);
    }
  }

  /// Evaluates all achievements against current data state and awards bonus XP.
  static AchievementEvaluationResult evaluateAchievements({
    required List<TransactionItem> transactions,
    required List<QuestItem> quests,
    required List<AllocationItem> allocations,
    required int streakDays,
    required List<String> unlockedIds,
  }) {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final newlyUnlocked = <AchievementItem>[];
    int bonusXp = 0;

    final totalLogs = transactions.length;
    final hasIncome = transactions.any((t) => t.isIncome || t.amount > 0);
    final allQuestsDone = quests.length >= 3 && quests.every((q) => q.done);
    final totalAllocPercent = allocations.fold<int>(0, (sum, a) => sum + a.percent);
    final isBudgetBalanced = totalAllocPercent == 100;
    final savingsAlloc = allocations.firstWhere(
      (a) => a.id == 'savings' || a.label.toLowerCase().contains('saving'),
      orElse: () => const AllocationItem(
        id: 'savings',
        label: 'Savings',
        percent: 0,
        color: '#4D8E75',
      ),
    );
    final hasGoodSavings = savingsAlloc.percent >= 20;
    final allCleared =
        transactions.isNotEmpty && transactions.every((t) => t.cleared);

    final allAchievements = AchievementItem.initialAchievements.map((ach) {
      final isAlreadyUnlocked = unlockedIds.contains(ach.id);
      bool shouldUnlock = isAlreadyUnlocked;
      int progress = 0;

      switch (ach.id) {
        case 'first_log':
          progress = totalLogs > 0 ? 1 : 0;
          shouldUnlock = totalLogs > 0;
          break;
        case 'first_income':
          progress = hasIncome ? 1 : 0;
          shouldUnlock = hasIncome;
          break;
        case 'streak_3':
          progress = streakDays > 3 ? 3 : streakDays;
          shouldUnlock = streakDays >= 3;
          break;
        case 'streak_7':
          progress = streakDays > 7 ? 7 : streakDays;
          shouldUnlock = streakDays >= 7;
          break;
        case 'quest_master':
          progress = allQuestsDone ? 1 : 0;
          shouldUnlock = allQuestsDone;
          break;
        case 'balanced_budget':
          progress = isBudgetBalanced ? 1 : 0;
          shouldUnlock = isBudgetBalanced;
          break;
        case 'savings_champion':
          progress = hasGoodSavings ? 1 : 0;
          shouldUnlock = hasGoodSavings;
          break;
        case 'ten_logs':
          progress = totalLogs > 10 ? 10 : totalLogs;
          shouldUnlock = totalLogs >= 10;
          break;
        case 'cleared_all':
          progress = allCleared ? 1 : 0;
          shouldUnlock = allCleared;
          break;
      }

      if (!isAlreadyUnlocked && shouldUnlock) {
        final unlockedItem = ach.copyWith(
          unlocked: true,
          unlockedAt: today,
          progress: ach.target ?? 1,
        );
        newlyUnlocked.add(unlockedItem);
        bonusXp += ach.xpReward;
        return unlockedItem;
      }

      return ach.copyWith(
        unlocked: isAlreadyUnlocked,
        progress: progress,
      );
    }).toList();

    return AchievementEvaluationResult(
      newlyUnlocked: newlyUnlocked,
      allAchievements: allAchievements,
      bonusXp: bonusXp,
    );
  }
}
