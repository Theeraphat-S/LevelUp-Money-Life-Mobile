import 'package:mobile_app_standard/domain/http_client/api_client.dart';
import 'package:mobile_app_standard/domain/models/gamification/achievement.dart';
import 'package:mobile_app_standard/domain/models/gamification/quest.dart';

abstract class GamificationRepositoryInterface {
  Future<List<QuestItem>> getDailyQuests();
  Future<List<AchievementItem>> getAchievements();
  Future<QuestItem> claimQuestReward(String questId);
}

class GamificationRepository implements GamificationRepositoryInterface {
  final ApiClient apiClient;

  final List<QuestItem> _quests = [
    QuestItem(
      id: 'quest_1',
      title: 'บันทึกรายจ่ายวันนี้ (Daily Log)',
      description: 'บันทึกรายการใช้จ่ายอย่างน้อย 1 รายการเพื่อรักษาวินัย',
      expReward: 30,
      coinReward: 15,
      type: QuestType.daily,
      category: QuestCategory.expense,
      currentProgress: 1,
      targetProgress: 1,
      isCompleted: true,
      isClaimed: false,
    ),
    QuestItem(
      id: 'quest_2',
      title: 'คุมงบอาหารมื้อเย็น (Food Master)',
      description: 'ทานอาหารไม่เกินงบประมาณ 150 บาทในมื้อเย็น',
      expReward: 50,
      coinReward: 25,
      type: QuestType.daily,
      category: QuestCategory.budget,
      currentProgress: 0,
      targetProgress: 1,
      isCompleted: false,
      isClaimed: false,
    ),
    QuestItem(
      id: 'quest_3',
      title: 'สะสมเช็คอินต่อเนื่อง 3 วัน (Streak Hero)',
      description: 'เปิดแอปและเช็คอินเพื่อรับพลังงานไฟต่อเนื่อง',
      expReward: 100,
      coinReward: 50,
      type: QuestType.weekly,
      category: QuestCategory.streak,
      currentProgress: 3,
      targetProgress: 3,
      isCompleted: true,
      isClaimed: true,
    ),
  ];

  final List<AchievementItem> _achievements = [
    AchievementItem(
      id: 'ach_1',
      title: 'ก้าวแรกสู่อิสรภาพ (First Step)',
      description: 'บันทึกรายการรายรับ-รายจ่ายครั้งแรก',
      iconKey: 'flag',
      expReward: 50,
      badgeName: 'First Transaction Badge',
      isUnlocked: true,
      unlockedAt: DateTime.now().subtract(const Duration(days: 4)),
    ),
    AchievementItem(
      id: 'ach_2',
      title: 'นักออมผู้มุ่งมั่น (Master Saver)',
      description: 'มีเงินออมรวมในกระปุกเกิน 10,000 บาท',
      iconKey: 'savings',
      expReward: 200,
      badgeName: '10K Saver Badge',
      isUnlocked: false,
    ),
    AchievementItem(
      id: 'ach_3',
      title: 'ผู้คุมกฎแห่งงบประมาณ (Budget Titan)',
      description: 'ไม่ใช้เงินเกินงบประมาณต่อเนื่องครบ 30 วัน',
      iconKey: 'shield',
      expReward: 500,
      badgeName: 'Diamond Budget Badge',
      isUnlocked: false,
    ),
  ];

  GamificationRepository(this.apiClient);

  @override
  Future<List<QuestItem>> getDailyQuests() async {
    try {
      final response = await apiClient.dio.get('/gamification/quests');
      if (response.statusCode == 200 && response.data is List) {
        return (response.data as List)
            .map((e) => QuestItem.fromJson(e))
            .toList();
      }
    } catch (_) {}
    return List.from(_quests);
  }

  @override
  Future<List<AchievementItem>> getAchievements() async {
    try {
      final response = await apiClient.dio.get('/gamification/achievements');
      if (response.statusCode == 200 && response.data is List) {
        return (response.data as List)
            .map((e) => AchievementItem.fromJson(e))
            .toList();
      }
    } catch (_) {}
    return List.from(_achievements);
  }

  @override
  Future<QuestItem> claimQuestReward(String questId) async {
    final index = _quests.indexWhere((q) => q.id == questId);
    if (index != -1) {
      _quests[index] = _quests[index].copyWith(isClaimed: true);
      try {
        await apiClient.dio.post('/gamification/quests/$questId/claim');
      } catch (_) {}
      return _quests[index];
    }
    throw Exception('Quest not found');
  }
}
