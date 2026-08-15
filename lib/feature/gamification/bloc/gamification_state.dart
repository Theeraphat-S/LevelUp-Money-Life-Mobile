import 'package:equatable/equatable.dart';
import 'package:mobile_app_standard/domain/models/gamification/achievement.dart';
import 'package:mobile_app_standard/domain/models/gamification/quest.dart';
import 'package:mobile_app_standard/domain/models/gamification/user_profile.dart';

enum GamificationStatus { initial, loading, success, failure }

class GamificationState extends Equatable {
  final GamificationStatus status;
  final UserProfile? userProfile;
  final List<QuestItem> dailyQuests;
  final List<AchievementItem> achievements;
  final String? message;
  final String? errorMessage;

  const GamificationState({
    this.status = GamificationStatus.initial,
    this.userProfile,
    this.dailyQuests = const [],
    this.achievements = const [],
    this.message,
    this.errorMessage,
  });

  GamificationState copyWith({
    GamificationStatus? status,
    UserProfile? userProfile,
    List<QuestItem>? dailyQuests,
    List<AchievementItem>? achievements,
    String? message,
    String? errorMessage,
  }) {
    return GamificationState(
      status: status ?? this.status,
      userProfile: userProfile ?? this.userProfile,
      dailyQuests: dailyQuests ?? this.dailyQuests,
      achievements: achievements ?? this.achievements,
      message: message,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        userProfile,
        dailyQuests,
        achievements,
        message,
        errorMessage,
      ];
}
