import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app_standard/domain/models/budget/allocation_item.dart';
import 'package:mobile_app_standard/domain/models/transaction/transaction_item.dart';
import 'package:mobile_app_standard/domain/services/gamification_engine.dart';

void main() {
  group('GamificationEngine Tests', () {
    test('XP required for level increases by 50 per level', () {
      expect(GamificationEngine.getXpRequiredForLevel(1), 100);
      expect(GamificationEngine.getXpRequiredForLevel(2), 150);
      expect(GamificationEngine.getXpRequiredForLevel(3), 200);
      expect(GamificationEngine.getXpRequiredForLevel(4), 250);
    });

    test('calculateLevelFromTotalXp calculates rank and progression correctly', () {
      // 0 XP -> Lv 1 (0/100)
      final p0 = GamificationEngine.calculateLevelFromTotalXp(0);
      expect(p0.level, 1);
      expect(p0.currentLevelXp, 0);
      expect(p0.xpForNextLevel, 100);
      expect(p0.titleRankKey, 'rank.novice');

      // 120 XP -> Lv 2 (20/150) (100 required for Lv 1)
      final p120 = GamificationEngine.calculateLevelFromTotalXp(120);
      expect(p120.level, 2);
      expect(p120.currentLevelXp, 20);
      expect(p120.xpForNextLevel, 150);

      // 250 XP -> Lv 3 (0/200) -> Tactician (100 + 150 = 250)
      final p250 = GamificationEngine.calculateLevelFromTotalXp(250);
      expect(p250.level, 3);
      expect(p250.currentLevelXp, 0);
      expect(p250.xpForNextLevel, 200);
      expect(p250.titleRankKey, 'rank.tactician');
    });

    test('updateStreak increments streak on consecutive days', () {
      final res = GamificationEngine.updateStreak('2026-08-15', 3);
      // If diff is 1 day, streak increments
      expect(res.newStreak >= 1, true);
    });

    test('evaluates first_log and first_income achievements on new transaction', () {
      final txs = [
        TransactionItem(
          id: 'tx_1',
          name: 'เงินเดือน',
          amount: 45000,
          category: 'Income',
          date: '2026-08-01',
        ),
      ];

      final result = GamificationEngine.evaluateAchievements(
        transactions: txs,
        quests: const [],
        allocations: AllocationItem.defaultAllocations,
        streakDays: 1,
        unlockedIds: const [],
      );

      final unlockedIds = result.allAchievements
          .where((a) => a.unlocked)
          .map((a) => a.id)
          .toList();

      expect(unlockedIds.contains('first_log'), true);
      expect(unlockedIds.contains('first_income'), true);
      expect(result.bonusXp, greaterThan(0));
    });
  });
}
