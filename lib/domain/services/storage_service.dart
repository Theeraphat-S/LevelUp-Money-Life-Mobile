import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app_standard/domain/datasource/hive_config.dart';
import 'package:mobile_app_standard/domain/models/budget/allocation_item.dart';
import 'package:mobile_app_standard/domain/models/gamification/quest.dart';
import 'package:mobile_app_standard/domain/models/transaction/transaction_item.dart';
import 'package:mobile_app_standard/domain/services/gamification_engine.dart';

class StorageService {
  static const String boxName = 'levelup_money_life_box';
  Box? _box;

  Future<void> init() async {
    await HiveConfig.init();
    _box = await HiveConfig.openBox(boxName);
    await _seedInitialDataIfNeeded();
  }

  Box get box {
    if (_box == null) {
      throw StateError('StorageService not initialized. Call init() first.');
    }
    return _box!;
  }

  Future<void> _seedInitialDataIfNeeded() async {
    if (!box.containsKey('transactions')) {
      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final currentMonth = today.substring(0, 7);

      final sampleTransactions = [
        TransactionItem(
          id: 't1',
          name: 'Monthly Salary',
          amount: 48000,
          date: '$currentMonth-01',
          category: 'Income',
          cleared: true,
          notes: 'Direct bank deposit',
        ),
        TransactionItem(
          id: 't2',
          name: 'Condo Rent & Maintenance',
          amount: -12500,
          date: '$currentMonth-02',
          category: 'Home',
          cleared: true,
          notes: 'Auto-debit',
        ),
        TransactionItem(
          id: 't3',
          name: 'Groceries — Tops Market',
          amount: -1420,
          date: '$currentMonth-04',
          category: 'Food',
          cleared: true,
          notes: 'Weekly pantry restock',
        ),
        TransactionItem(
          id: 't4',
          name: 'BTS Rabbit Card Top-up',
          amount: -500,
          date: '$currentMonth-05',
          category: 'Transport',
          cleared: true,
        ),
        TransactionItem(
          id: 't5',
          name: 'Data Science Specialization',
          amount: -1200,
          date: '$currentMonth-07',
          category: 'Learning',
          cleared: true,
          notes: 'Online certificate',
        ),
        TransactionItem(
          id: 't6',
          name: 'Dinner & Cafe — Thonglor',
          amount: -680,
          date: '$currentMonth-09',
          category: 'Fun',
          cleared: false,
        ),
        TransactionItem(
          id: 't7',
          name: 'Emergency Fund Allocation',
          amount: -5000,
          date: '$currentMonth-10',
          category: 'Savings',
          cleared: true,
          notes: 'High yield savings',
        ),
        TransactionItem(
          id: 't8',
          name: 'Fitness Membership',
          amount: -1500,
          date: '$currentMonth-12',
          category: 'Health',
          cleared: true,
        ),
      ];

      await saveTransactions(sampleTransactions);
      await saveAllocations(AllocationItem.defaultAllocations);
      await saveMonthlyIncome(48000.0);
      await saveQuests(QuestItem.defaultQuests);
      await saveTotalXp(180);
      await saveStreakDays(1);
      await saveLastActiveDate(today);
      await saveUnlockedAchievementIds([]);
      await saveActiveMonth(currentMonth);
      await saveThemeMode('system');
    }
  }

  // Transactions
  List<TransactionItem> getTransactions() {
    final raw = box.get('transactions');
    if (raw == null) return [];
    try {
      final List list = raw is String ? jsonDecode(raw) : raw;
      return list
          .map((e) => TransactionItem.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveTransactions(List<TransactionItem> transactions) async {
    final jsonList = transactions.map((t) => t.toJson()).toList();
    await box.put('transactions', jsonEncode(jsonList));
  }

  // Allocations
  List<AllocationItem> getAllocations() {
    final raw = box.get('allocations');
    if (raw == null) return AllocationItem.defaultAllocations;
    try {
      final List list = raw is String ? jsonDecode(raw) : raw;
      return list
          .map((e) => AllocationItem.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } catch (_) {
      return AllocationItem.defaultAllocations;
    }
  }

  Future<void> saveAllocations(List<AllocationItem> allocations) async {
    final jsonList = allocations.map((a) => a.toJson()).toList();
    await box.put('allocations', jsonEncode(jsonList));
  }

  // Monthly Income
  double getMonthlyIncome() {
    return (box.get('monthlyIncome') as num?)?.toDouble() ?? 48000.0;
  }

  Future<void> saveMonthlyIncome(double income) async {
    await box.put('monthlyIncome', income);
  }

  // Quests
  List<QuestItem> getQuests() {
    final raw = box.get('quests');
    if (raw == null) return QuestItem.defaultQuests;
    try {
      final List list = raw is String ? jsonDecode(raw) : raw;
      return list
          .map((e) => QuestItem.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } catch (_) {
      return QuestItem.defaultQuests;
    }
  }

  Future<void> saveQuests(List<QuestItem> quests) async {
    final jsonList = quests.map((q) => q.toJson()).toList();
    await box.put('quests', jsonEncode(jsonList));
  }

  // Gamification XP, Streak, Achievements
  int getTotalXp() => (box.get('totalXp') as num?)?.toInt() ?? 180;
  Future<void> saveTotalXp(int xp) async => await box.put('totalXp', xp);

  int getStreakDays() => (box.get('streakDays') as num?)?.toInt() ?? 1;
  Future<void> saveStreakDays(int days) async =>
      await box.put('streakDays', days);

  String getLastActiveDate() =>
      box.get('lastActiveDate') as String? ??
      DateFormat('yyyy-MM-dd').format(DateTime.now());
  Future<void> saveLastActiveDate(String date) async =>
      await box.put('lastActiveDate', date);

  List<String> getUnlockedAchievementIds() {
    final raw = box.get('unlockedAchievementIds');
    if (raw == null) return [];
    try {
      final List list = raw is String ? jsonDecode(raw) : raw;
      return list.map((e) => e.toString()).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveUnlockedAchievementIds(List<String> ids) async {
    await box.put('unlockedAchievementIds', jsonEncode(ids));
  }

  // Active Month & Theme
  String getActiveMonth() {
    return box.get('activeMonth') as String? ??
        DateFormat('yyyy-MM').format(DateTime.now());
  }

  Future<void> saveActiveMonth(String month) async =>
      await box.put('activeMonth', month);

  String getThemeMode() => box.get('themeMode') as String? ?? 'system';
  Future<void> saveThemeMode(String mode) async =>
      await box.put('themeMode', mode);

  // Backup Data JSON Export & Import matching web
  Map<String, dynamic> exportBackupJson() {
    final totalXp = getTotalXp();
    final streakDays = getStreakDays();
    final lastActiveDate = getLastActiveDate();
    final unlockedIds = getUnlockedAchievementIds();
    final progression =
        GamificationEngine.calculateLevelFromTotalXp(totalXp);

    return {
      'version': 1,
      'exportedAt': DateTime.now().toIso8601String(),
      'themeMode': getThemeMode(),
      'activeMonth': getActiveMonth(),
      'monthlyIncome': getMonthlyIncome(),
      'transactions': getTransactions().map((t) => t.toJson()).toList(),
      'allocations': getAllocations().map((a) => a.toJson()).toList(),
      'quests': getQuests().map((q) => q.toJson()).toList(),
      'gamification': {
        'level': progression.level,
        'currentLevelXp': progression.currentLevelXp,
        'xpForNextLevel': progression.xpForNextLevel,
        'totalXp': totalXp,
        'streakDays': streakDays,
        'lastActiveDate': lastActiveDate,
        'titleRankKey': progression.titleRankKey,
        'unlockedAchievementIds': unlockedIds,
      },
    };
  }

  Future<bool> importBackupJson(Map<String, dynamic> json) async {
    try {
      if (json['transactions'] is List) {
        final txList = (json['transactions'] as List)
            .map((e) => TransactionItem.fromJson(Map<String, dynamic>.from(e)))
            .toList();
        await saveTransactions(txList);
      }

      if (json['allocations'] is List) {
        final allocList = (json['allocations'] as List)
            .map((e) => AllocationItem.fromJson(Map<String, dynamic>.from(e)))
            .toList();
        await saveAllocations(allocList);
      }

      if (json['monthlyIncome'] != null) {
        await saveMonthlyIncome(
            (json['monthlyIncome'] as num).toDouble());
      }

      if (json['quests'] is List) {
        final questList = (json['quests'] as List)
            .map((e) => QuestItem.fromJson(Map<String, dynamic>.from(e)))
            .toList();
        await saveQuests(questList);
      }

      if (json['gamification'] is Map) {
        final g = Map<String, dynamic>.from(json['gamification']);
        if (g['totalXp'] != null) {
          await saveTotalXp((g['totalXp'] as num).toInt());
        }
        if (g['streakDays'] != null) {
          await saveStreakDays((g['streakDays'] as num).toInt());
        }
        if (g['lastActiveDate'] != null) {
          await saveLastActiveDate(g['lastActiveDate'].toString());
        }
        if (g['unlockedAchievementIds'] is List) {
          final ids = (g['unlockedAchievementIds'] as List)
              .map((e) => e.toString())
              .toList();
          await saveUnlockedAchievementIds(ids);
        }
      }

      if (json['themeMode'] != null) {
        await saveThemeMode(json['themeMode'].toString());
      }

      if (json['activeMonth'] != null) {
        await saveActiveMonth(json['activeMonth'].toString());
      }

      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> resetAllData() async {
    await box.clear();
    await _seedInitialDataIfNeeded();
  }
}
