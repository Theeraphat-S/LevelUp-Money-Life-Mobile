import 'package:drift/drift.dart';
import 'package:mobile_app_standard/domain/datasource/app_datebase.dart';
import 'package:mobile_app_standard/domain/models/budget/allocation_item.dart';
import 'package:mobile_app_standard/domain/models/gamification/quest.dart';
import 'package:mobile_app_standard/domain/models/transaction/transaction_item.dart';
import 'package:mobile_app_standard/domain/services/gamification_engine.dart';

abstract class GamificationRepositoryInterface {
  Future<List<QuestItem>> getDailyQuests();
  Future<QuestItem> toggleQuest(String questId);
  Future<QuestItem> claimQuestReward(String questId);
  Future<AchievementEvaluationResult> evaluateAchievements();
}

class GamificationRepository implements GamificationRepositoryInterface {
  final AppDatabase db;

  GamificationRepository(this.db);

  @override
  Future<List<QuestItem>> getDailyQuests() async {
    final rows = await db.select(db.quests).get();
    if (rows.isEmpty) {
      return QuestItem.defaultQuests;
    }
    return rows
        .map((r) => QuestItem(
              id: r.id,
              title: r.title,
              date: r.date,
              xp: r.xp,
              done: r.done,
              category: r.category,
            ))
        .toList();
  }

  @override
  Future<QuestItem> toggleQuest(String questId) async {
    final questRow = await (db.select(db.quests)
          ..where((q) => q.id.equals(questId)))
        .getSingleOrNull();

    if (questRow == null) {
      throw Exception('Quest not found: $questId');
    }

    final newDone = !questRow.done;

    await db.transaction(() async {
      await (db.update(db.quests)..where((q) => q.id.equals(questId))).write(
        QuestsCompanion(done: Value(newDone)),
      );

      final user = await (db.select(db.userProfiles)
            ..where((u) => u.id.equals('user_main')))
          .getSingleOrNull();

      final currentXp = user?.totalXp ?? 180;
      final adjustedXp = newDone
          ? currentXp + questRow.xp
          : (currentXp - questRow.xp).clamp(0, 9999999);

      await (db.update(db.userProfiles)..where((u) => u.id.equals('user_main')))
          .write(UserProfilesCompanion(totalXp: Value(adjustedXp)));
    });

    return QuestItem(
      id: questRow.id,
      title: questRow.title,
      date: questRow.date,
      xp: questRow.xp,
      done: newDone,
      category: questRow.category,
    );
  }

  @override
  Future<QuestItem> claimQuestReward(String questId) async {
    final questRow = await (db.select(db.quests)
          ..where((q) => q.id.equals(questId)))
        .getSingleOrNull();

    if (questRow == null) {
      throw Exception('Quest not found: $questId');
    }

    if (!questRow.done) {
      await db.transaction(() async {
        await (db.update(db.quests)..where((q) => q.id.equals(questId))).write(
          const QuestsCompanion(done: Value(true)),
        );

        final user = await (db.select(db.userProfiles)
              ..where((u) => u.id.equals('user_main')))
            .getSingleOrNull();

        final currentXp = user?.totalXp ?? 180;
        await (db.update(db.userProfiles)..where((u) => u.id.equals('user_main')))
            .write(UserProfilesCompanion(totalXp: Value(currentXp + questRow.xp)));
      });

      return QuestItem(
        id: questRow.id,
        title: questRow.title,
        date: questRow.date,
        xp: questRow.xp,
        done: true,
        category: questRow.category,
      );
    }

    return QuestItem(
      id: questRow.id,
      title: questRow.title,
      date: questRow.date,
      xp: questRow.xp,
      done: questRow.done,
      category: questRow.category,
    );
  }

  @override
  Future<AchievementEvaluationResult> evaluateAchievements() async {
    final txRows = await db.select(db.transactions).get();
    final questRows = await db.select(db.quests).get();
    final allocRows = await db.select(db.allocations).get();
    final user = await (db.select(db.userProfiles)
          ..where((u) => u.id.equals('user_main')))
        .getSingleOrNull();
    final unlockedRows = await db.select(db.unlockedAchievements).get();

    final transactions = txRows
        .map((r) => TransactionItem(
              id: r.id,
              name: r.name,
              amount: r.amount,
              date: r.date,
              category: r.category,
              cleared: r.cleared,
              notes: r.notes,
              expGained: r.expGained,
            ))
        .toList();

    final quests = questRows
        .map((r) => QuestItem(
              id: r.id,
              title: r.title,
              date: r.date,
              xp: r.xp,
              done: r.done,
              category: r.category,
            ))
        .toList();

    final allocations = allocRows
        .map((r) => AllocationItem(
              id: r.id,
              label: r.label,
              percent: r.percent,
              color: r.color,
            ))
        .toList();

    final streakDays = user?.streakDays ?? 1;
    final unlockedIds = unlockedRows.map((r) => r.id).toList();

    final result = GamificationEngine.evaluateAchievements(
      transactions: transactions,
      quests: quests,
      allocations: allocations,
      streakDays: streakDays,
      unlockedIds: unlockedIds,
    );

    if (result.newlyUnlocked.isNotEmpty) {
      await db.transaction(() async {
        final nowStr = user?.lastActiveDate ?? '';
        for (final ach in result.newlyUnlocked) {
          await db.into(db.unlockedAchievements).insert(
                UnlockedAchievementsCompanion.insert(
                  id: ach.id,
                  unlockedAt: nowStr,
                ),
                mode: InsertMode.insertOrReplace,
              );
        }

        if (result.bonusXp > 0) {
          final currentXp = user?.totalXp ?? 180;
          await (db.update(db.userProfiles)
                ..where((u) => u.id.equals('user_main')))
              .write(UserProfilesCompanion(
                  totalXp: Value(currentXp + result.bonusXp)));
        }
      });
    }

    return result;
  }
}
