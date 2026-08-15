enum QuestType { daily, weekly, achievement }
enum QuestCategory { expense, income, saving, streak, budget }

class QuestItem {
  final String id;
  final String title;
  final String description;
  final int expReward;
  final int coinReward;
  final QuestType type;
  final QuestCategory category;
  final int currentProgress;
  final int targetProgress;
  final bool isCompleted;
  final bool isClaimed;

  QuestItem({
    required this.id,
    required this.title,
    required this.description,
    required this.expReward,
    required this.coinReward,
    this.type = QuestType.daily,
    this.category = QuestCategory.expense,
    required this.currentProgress,
    required this.targetProgress,
    this.isCompleted = false,
    this.isClaimed = false,
  });

  double get progressRatio => targetProgress > 0
      ? (currentProgress / targetProgress).clamp(0.0, 1.0)
      : 0.0;

  QuestItem copyWith({
    String? id,
    String? title,
    String? description,
    int? expReward,
    int? coinReward,
    QuestType? type,
    QuestCategory? category,
    int? currentProgress,
    int? targetProgress,
    bool? isCompleted,
    bool? isClaimed,
  }) {
    return QuestItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      expReward: expReward ?? this.expReward,
      coinReward: coinReward ?? this.coinReward,
      type: type ?? this.type,
      category: category ?? this.category,
      currentProgress: currentProgress ?? this.currentProgress,
      targetProgress: targetProgress ?? this.targetProgress,
      isCompleted: isCompleted ?? this.isCompleted,
      isClaimed: isClaimed ?? this.isClaimed,
    );
  }

  factory QuestItem.fromJson(Map<String, dynamic> json) {
    return QuestItem(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      expReward: json['expReward'] as int? ?? 25,
      coinReward: json['coinReward'] as int? ?? 10,
      type: QuestType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => QuestType.daily,
      ),
      category: QuestCategory.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => QuestCategory.expense,
      ),
      currentProgress: json['currentProgress'] as int? ?? 0,
      targetProgress: json['targetProgress'] as int? ?? 1,
      isCompleted: json['isCompleted'] as bool? ?? false,
      isClaimed: json['isClaimed'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'expReward': expReward,
      'coinReward': coinReward,
      'type': type.name,
      'category': category.name,
      'currentProgress': currentProgress,
      'targetProgress': targetProgress,
      'isCompleted': isCompleted,
      'isClaimed': isClaimed,
    };
  }
}
