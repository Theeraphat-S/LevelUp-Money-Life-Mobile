class AchievementItem {
  final String id;
  final String titleKey;
  final String descKey;
  final String titleTh;
  final String descTh;
  final String titleEn;
  final String descEn;
  final String iconName;
  final int xpReward;
  final bool unlocked;
  final String? unlockedAt;
  final int progress;
  final int? target;

  const AchievementItem({
    required this.id,
    required this.titleKey,
    required this.descKey,
    required this.titleTh,
    required this.descTh,
    required this.titleEn,
    required this.descEn,
    required this.iconName,
    required this.xpReward,
    this.unlocked = false,
    this.unlockedAt,
    this.progress = 0,
    this.target,
  });

  bool get isUnlocked => unlocked;
  String get title => titleTh;
  String get description => descTh;
  String get badgeName => id;

  AchievementItem copyWith({
    String? id,
    String? titleKey,
    String? descKey,
    String? titleTh,
    String? descTh,
    String? titleEn,
    String? descEn,
    String? iconName,
    int? xpReward,
    bool? unlocked,
    String? unlockedAt,
    int? progress,
    int? target,
  }) {
    return AchievementItem(
      id: id ?? this.id,
      titleKey: titleKey ?? this.titleKey,
      descKey: descKey ?? this.descKey,
      titleTh: titleTh ?? this.titleTh,
      descTh: descTh ?? this.descTh,
      titleEn: titleEn ?? this.titleEn,
      descEn: descEn ?? this.descEn,
      iconName: iconName ?? this.iconName,
      xpReward: xpReward ?? this.xpReward,
      unlocked: unlocked ?? this.unlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      progress: progress ?? this.progress,
      target: target ?? this.target,
    );
  }

  factory AchievementItem.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as String;
    final template = initialAchievements.firstWhere(
      (a) => a.id == id,
      orElse: () => initialAchievements.first,
    );

    return template.copyWith(
      unlocked: json['unlocked'] as bool? ?? false,
      unlockedAt: json['unlockedAt'] as String?,
      progress: json['progress'] as int? ?? 0,
      target: json['target'] as int? ?? template.target,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titleKey': titleKey,
      'descKey': descKey,
      'iconName': iconName,
      'xpReward': xpReward,
      'unlocked': unlocked,
      if (unlockedAt != null) 'unlockedAt': unlockedAt,
      'progress': progress,
      if (target != null) 'target': target,
    };
  }

  static const List<AchievementItem> initialAchievements = [
    AchievementItem(
      id: 'first_log',
      titleKey: 'achievements.first_log.title',
      descKey: 'achievements.first_log.desc',
      titleTh: 'ก้าวแรกสู่วินัยการเงิน',
      descTh: 'บันทึกรายการรายรับหรือรายจ่ายรายการแรก',
      titleEn: 'First Financial Step',
      descEn: 'Log your very first income or expense',
      iconName: 'edit_note',
      xpReward: 25,
    ),
    AchievementItem(
      id: 'first_income',
      titleKey: 'achievements.first_income.title',
      descKey: 'achievements.first_income.desc',
      titleTh: 'กระแสเงินสดแรก',
      descTh: 'บันทึกรายการรายรับสำเร็จ',
      titleEn: 'First Inflow',
      descEn: 'Log your first income transaction',
      iconName: 'monetization_on',
      xpReward: 30,
    ),
    AchievementItem(
      id: 'streak_3',
      titleKey: 'achievements.streak_3.title',
      descKey: 'achievements.streak_3.desc',
      titleTh: 'สตรีค 3 วันติด',
      descTh: 'บันทึกรายการต่อเนื่อง 3 วันติดต่อกัน',
      titleEn: '3-Day Streak',
      descEn: 'Maintain a 3-day continuous activity streak',
      iconName: 'local_fire_department',
      xpReward: 50,
      target: 3,
    ),
    AchievementItem(
      id: 'streak_7',
      titleKey: 'achievements.streak_7.title',
      descKey: 'achievements.streak_7.desc',
      titleTh: 'หนึ่งสัปดาห์ไม่ขาดสาย',
      descTh: 'บันทึกรายการต่อเนื่องครบ 7 วัน',
      titleEn: '7-Day Champion',
      descEn: 'Keep the habit alive with a 7-day streak',
      iconName: 'whatshot',
      xpReward: 100,
      target: 7,
    ),
    AchievementItem(
      id: 'quest_master',
      titleKey: 'achievements.quest_master.title',
      descKey: 'achievements.quest_master.desc',
      titleTh: 'ผู้พิชิตเควสประจำวัน',
      descTh: 'ทำเควสประจำวันครบทั้งหมด 3 ข้อ',
      titleEn: 'Quest Master',
      descEn: 'Complete all 3 daily quests in a single day',
      iconName: 'check_circle',
      xpReward: 40,
    ),
    AchievementItem(
      id: 'balanced_budget',
      titleKey: 'achievements.balanced_budget.title',
      descKey: 'achievements.balanced_budget.desc',
      titleTh: 'งบประมาณสมดุล 100%',
      descTh: 'จัดสรรสัดส่วนงบประมาณ 50/30/20 รวมกันได้ 100% พอดี',
      titleEn: 'Balanced Budget',
      descEn: 'Configure 50/30/20 budget allocations to equal 100%',
      iconName: 'balance',
      xpReward: 35,
    ),
    AchievementItem(
      id: 'savings_champion',
      titleKey: 'achievements.savings_champion.title',
      descKey: 'achievements.savings_champion.desc',
      titleTh: 'ยอดนักออม',
      descTh: 'ตั้งสัดส่วนเงินออม (Savings) ตั้งแต่ 20% ขึ้นไป',
      titleEn: 'Savings Champion',
      descEn: 'Allocate 20% or more to your savings budget',
      iconName: 'savings',
      xpReward: 50,
    ),
    AchievementItem(
      id: 'ten_logs',
      titleKey: 'achievements.ten_logs.title',
      descKey: 'achievements.ten_logs.desc',
      titleTh: 'เซียนบันทึก 10 รายการ',
      descTh: 'บันทึกรายการธุรกรรมครบ 10 รายการ',
      titleEn: 'Deca Logger',
      descEn: 'Log at least 10 transactions',
      iconName: 'checklist',
      xpReward: 60,
      target: 10,
    ),
    AchievementItem(
      id: 'cleared_all',
      titleKey: 'achievements.cleared_all.title',
      descKey: 'achievements.cleared_all.desc',
      titleTh: 'ตรวจสอบครบทุกยอด',
      descTh: 'ทำเครื่องหมาย Cleared ครบทุกรายการในบัญชี',
      titleEn: 'All Reconciled',
      descEn: 'Mark every transaction as cleared',
      iconName: 'verified',
      xpReward: 45,
    ),
  ];
}
