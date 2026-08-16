import 'package:drift/drift.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app_standard/domain/datasource/app_datebase.dart';
import 'package:mobile_app_standard/domain/models/gamification/user_profile.dart';
import 'package:mobile_app_standard/domain/services/gamification_engine.dart';

abstract class UserRepositoryInterface {
  Future<UserProfile> getUserProfile();
  Future<UserProfile> addExp(int expToAdd, {int coinsToAdd = 0});
  Future<UserProfile> checkInDaily();
  Future<UserProfile> updateUnlockedAchievements(List<String> achievementIds);
}

class UserRepository implements UserRepositoryInterface {
  final AppDatabase db;

  UserRepository(this.db);

  @override
  Future<UserProfile> getUserProfile() async {
    final user = await (db.select(db.userProfiles)
          ..where((u) => u.id.equals('user_main')))
        .getSingleOrNull();

    final unlockedRows = await db.select(db.unlockedAchievements).get();
    final unlockedIds = unlockedRows.map((r) => r.id).toList();

    return UserProfile(
      id: user?.id ?? 'user_main',
      name: user?.name ?? 'Finance Commander',
      totalXp: user?.totalXp ?? 180,
      streakDays: user?.streakDays ?? 1,
      lastActiveDate: user?.lastActiveDate ??
          DateFormat('yyyy-MM-dd').format(DateTime.now()),
      unlockedAchievementIds: unlockedIds,
    );
  }

  @override
  Future<UserProfile> addExp(int expToAdd, {int coinsToAdd = 0}) async {
    await db.transaction(() async {
      final user = await (db.select(db.userProfiles)
            ..where((u) => u.id.equals('user_main')))
          .getSingleOrNull();

      final currentXp = user?.totalXp ?? 180;
      final newXp = currentXp + expToAdd;

      final lastDate = user?.lastActiveDate ??
          DateFormat('yyyy-MM-dd').format(DateTime.now());
      final streak = user?.streakDays ?? 1;
      final streakResult = GamificationEngine.updateStreak(lastDate, streak);

      await (db.update(db.userProfiles)..where((u) => u.id.equals('user_main')))
          .write(
        UserProfilesCompanion(
          totalXp: Value(newXp),
          streakDays: Value(streakResult.newStreak),
          lastActiveDate: Value(streakResult.today),
        ),
      );
    });

    return getUserProfile();
  }

  @override
  Future<UserProfile> checkInDaily() async {
    await db.transaction(() async {
      final user = await (db.select(db.userProfiles)
            ..where((u) => u.id.equals('user_main')))
          .getSingleOrNull();

      final lastDate = user?.lastActiveDate ??
          DateFormat('yyyy-MM-dd').format(DateTime.now());
      final streak = user?.streakDays ?? 1;
      final streakResult = GamificationEngine.updateStreak(lastDate, streak);

      final currentXp = user?.totalXp ?? 180;
      final newXp = currentXp + 20;

      await (db.update(db.userProfiles)..where((u) => u.id.equals('user_main')))
          .write(
        UserProfilesCompanion(
          totalXp: Value(newXp),
          streakDays: Value(streakResult.newStreak),
          lastActiveDate: Value(streakResult.today),
        ),
      );
    });

    return getUserProfile();
  }

  @override
  Future<UserProfile> updateUnlockedAchievements(
      List<String> achievementIds) async {
    await db.transaction(() async {
      final user = await (db.select(db.userProfiles)
            ..where((u) => u.id.equals('user_main')))
          .getSingleOrNull();
      final today = user?.lastActiveDate ??
          DateFormat('yyyy-MM-dd').format(DateTime.now());

      for (final id in achievementIds) {
        await db.into(db.unlockedAchievements).insert(
              UnlockedAchievementsCompanion.insert(
                id: id,
                unlockedAt: today,
              ),
              mode: InsertMode.insertOrReplace,
            );
      }
    });

    return getUserProfile();
  }
}
