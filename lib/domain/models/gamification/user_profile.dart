class UserProfile {
  final String id;
  final String name;
  final String title;
  final String avatarUrl;
  final int level;
  final int currentExp;
  final int maxExp;
  final int goldCoins;
  final int streakDays;
  final DateTime lastCheckIn;
  final int healthPoint; // 0 - 100
  final int manaPoint; // 0 - 100

  UserProfile({
    required this.id,
    required this.name,
    required this.title,
    required this.avatarUrl,
    required this.level,
    required this.currentExp,
    required this.maxExp,
    required this.goldCoins,
    required this.streakDays,
    required this.lastCheckIn,
    this.healthPoint = 100,
    this.manaPoint = 100,
  });

  double get expProgress => maxExp > 0 ? (currentExp / maxExp).clamp(0.0, 1.0) : 0.0;
  double get hpProgress => (healthPoint / 100.0).clamp(0.0, 1.0);

  UserProfile copyWith({
    String? id,
    String? name,
    String? title,
    String? avatarUrl,
    int? level,
    int? currentExp,
    int? maxExp,
    int? goldCoins,
    int? streakDays,
    DateTime? lastCheckIn,
    int? healthPoint,
    int? manaPoint,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      title: title ?? this.title,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      level: level ?? this.level,
      currentExp: currentExp ?? this.currentExp,
      maxExp: maxExp ?? this.maxExp,
      goldCoins: goldCoins ?? this.goldCoins,
      streakDays: streakDays ?? this.streakDays,
      lastCheckIn: lastCheckIn ?? this.lastCheckIn,
      healthPoint: healthPoint ?? this.healthPoint,
      manaPoint: manaPoint ?? this.manaPoint,
    );
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String? ?? 'user_1',
      name: json['name'] as String? ?? 'Adventurer',
      title: json['title'] as String? ?? 'Novice Saver',
      avatarUrl: json['avatarUrl'] as String? ?? '',
      level: json['level'] as int? ?? 1,
      currentExp: json['currentExp'] as int? ?? 50,
      maxExp: json['maxExp'] as int? ?? 100,
      goldCoins: json['goldCoins'] as int? ?? 120,
      streakDays: json['streakDays'] as int? ?? 1,
      lastCheckIn: json['lastCheckIn'] != null
          ? DateTime.tryParse(json['lastCheckIn'].toString()) ?? DateTime.now()
          : DateTime.now(),
      healthPoint: json['healthPoint'] as int? ?? 100,
      manaPoint: json['manaPoint'] as int? ?? 100,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'title': title,
      'avatarUrl': avatarUrl,
      'level': level,
      'currentExp': currentExp,
      'maxExp': maxExp,
      'goldCoins': goldCoins,
      'streakDays': streakDays,
      'lastCheckIn': lastCheckIn.toIso8601String(),
      'healthPoint': healthPoint,
      'manaPoint': manaPoint,
    };
  }
}
