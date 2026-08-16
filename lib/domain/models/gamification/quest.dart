import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class QuestItem {
  final String id;
  final String title;
  final String date; // "YYYY-MM-DD"
  final int xp;
  final bool done;
  final String category; // "daily" | "habit" | "milestone"

  QuestItem({
    required this.id,
    required this.title,
    required this.date,
    required this.xp,
    this.done = false,
    this.category = 'daily',
  });

  bool get isCompleted => done;
  bool get isClaimed => done;
  int get expReward => xp;
  int get coinReward => xp ~/ 2;
  String getLocalizedTitle(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    if (lang == 'en') {
      if (id == 'q1') return 'Record all daily expenses for today';
      if (id == 'q2') return 'Review your 50/30/20 budget allocation';
      if (id == 'q3') return 'Transfer savings to emergency reserve fund';
    }
    return title;
  }

  String get description => category == 'daily'
      ? 'Daily Quest'
      : category == 'habit'
          ? 'Habit Quest'
          : 'Milestone';

  QuestItem copyWith({
    String? id,
    String? title,
    String? date,
    int? xp,
    bool? done,
    String? category,
  }) {
    return QuestItem(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      xp: xp ?? this.xp,
      done: done ?? this.done,
      category: category ?? this.category,
    );
  }

  factory QuestItem.fromJson(Map<String, dynamic> json) {
    return QuestItem(
      id: json['id'] as String? ?? 'q_${DateTime.now().millisecondsSinceEpoch}',
      title: json['title'] as String? ?? 'Daily Quest',
      date: json['date'] as String? ??
          DateFormat('yyyy-MM-dd').format(DateTime.now()),
      xp: json['xp'] as int? ?? json['expReward'] as int? ?? 15,
      done: json['done'] as bool? ?? json['isCompleted'] as bool? ?? false,
      category: json['category'] as String? ?? 'daily',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'date': date,
      'xp': xp,
      'done': done,
      'category': category,
    };
  }

  static List<QuestItem> get defaultQuests {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    return [
      QuestItem(
        id: 'q1',
        title: 'บันทึกรายจ่ายประจำวันทุกรายการวันนี้',
        date: today,
        xp: 15,
        done: false,
        category: 'daily',
      ),
      QuestItem(
        id: 'q2',
        title: 'ตรวจสอบสัดส่วนการจัดสรรงบประมาณ 50/30/20',
        date: today,
        xp: 20,
        done: true,
        category: 'daily',
      ),
      QuestItem(
        id: 'q3',
        title: 'โอนเงินเก็บเข้าบัญชีเงินออมสำรองฉุกเฉิน',
        date: today,
        xp: 25,
        done: false,
        category: 'daily',
      ),
    ];
  }
}
