class AchievementItem {
  final String id;
  final String title;
  final String description;
  final String iconKey;
  final int expReward;
  final String badgeName;
  final bool isUnlocked;
  final DateTime? unlockedAt;

  AchievementItem({
    required this.id,
    required this.title,
    required this.description,
    required this.iconKey,
    required this.expReward,
    required this.badgeName,
    this.isUnlocked = false,
    this.unlockedAt,
  });

  factory AchievementItem.fromJson(Map<String, dynamic> json) {
    return AchievementItem(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      iconKey: json['iconKey'] as String? ?? 'star',
      expReward: json['expReward'] as int? ?? 100,
      badgeName: json['badgeName'] as String? ?? 'Badge',
      isUnlocked: json['isUnlocked'] as bool? ?? false,
      unlockedAt: json['unlockedAt'] != null
          ? DateTime.tryParse(json['unlockedAt'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'iconKey': iconKey,
      'expReward': expReward,
      'badgeName': badgeName,
      'isUnlocked': isUnlocked,
      'unlockedAt': unlockedAt?.toIso8601String(),
    };
  }
}
