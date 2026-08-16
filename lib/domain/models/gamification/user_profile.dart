import 'package:mobile_app_standard/domain/services/gamification_engine.dart';

class UserProfile {
  final String id;
  final String name;
  final int totalXp;
  final int streakDays;
  final String lastActiveDate;
  final List<String> unlockedAchievementIds;

  UserProfile({
    this.id = 'user_main',
    this.name = 'Finance Commander',
    required this.totalXp,
    required this.streakDays,
    required this.lastActiveDate,
    this.unlockedAchievementIds = const [],
  });

  LevelProgression get progression =>
      GamificationEngine.calculateLevelFromTotalXp(totalXp);

  int get level => progression.level;
  int get currentExp => progression.currentLevelXp;
  int get maxExp => progression.xpForNextLevel;
  double get expProgress => progression.progressPercent / 100.0;
  String get titleRankKey => progression.titleRankKey;
  String get rankTitle => progression.titleRankTh;
  String get rankTitleEn => progression.titleRankEn;
  int get goldCoins => totalXp ~/ 2;

  UserProfile copyWith({
    String? id,
    String? name,
    int? totalXp,
    int? streakDays,
    String? lastActiveDate,
    List<String>? unlockedAchievementIds,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      totalXp: totalXp ?? this.totalXp,
      streakDays: streakDays ?? this.streakDays,
      lastActiveDate: lastActiveDate ?? this.lastActiveDate,
      unlockedAchievementIds:
          unlockedAchievementIds ?? this.unlockedAchievementIds,
    );
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String? ?? 'user_main',
      name: json['name'] as String? ?? 'Finance Commander',
      totalXp: json['totalXp'] as int? ?? 180,
      streakDays: json['streakDays'] as int? ?? 1,
      lastActiveDate: json['lastActiveDate'] as String? ?? '',
      unlockedAchievementIds: (json['unlockedAchievementIds'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'totalXp': totalXp,
      'streakDays': streakDays,
      'lastActiveDate': lastActiveDate,
      'unlockedAchievementIds': unlockedAchievementIds,
      'level': level,
      'currentLevelXp': currentExp,
      'xpForNextLevel': maxExp,
      'titleRankKey': titleRankKey,
    };
  }
}
