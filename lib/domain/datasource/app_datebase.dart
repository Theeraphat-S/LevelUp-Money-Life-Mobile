import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app_standard/domain/datasource/hive_config.dart';
import 'package:mobile_app_standard/domain/datasource/tables.dart';
import 'package:mobile_app_standard/domain/models/budget/allocation_item.dart';
import 'package:mobile_app_standard/domain/models/gamification/quest.dart';
import 'package:mobile_app_standard/domain/models/todo_table.dart';
import 'package:mobile_app_standard/domain/models/transaction/transaction_item.dart';
import 'package:mobile_app_standard/domain/services/gamification_engine.dart';

part 'app_datebase.g.dart';

@DriftDatabase(tables: [
  TodoItems,
  Transactions,
  Allocations,
  Quests,
  UserProfiles,
  UnlockedAchievements,
  AppSettings,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        beforeOpen: (details) async {
          // You can enable foreign keys if needed:
          // await customStatement('PRAGMA foreign_keys = ON');
        },
        onCreate: (Migrator m) async {
          await m.createAll();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          if (from < 2) {
            await m.addColumn(todoItems, todoItems.priority);
          }
          if (from < 3) {
            await m.createTable(transactions);
            await m.createTable(allocations);
            await m.createTable(quests);
            await m.createTable(userProfiles);
            await m.createTable(unlockedAchievements);
            await m.createTable(appSettings);
          }
        },
      );

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'db',
    );
  }

  // ==========================================
  // INITIALIZATION & MIGRATION / SEEDING
  // ==========================================

  Future<void> initDatabase() async {
    // Check if initial seeding or migration from Hive is needed
    final hasAllocations = (await select(allocations).get()).isNotEmpty;
    final hasUser = (await select(userProfiles).get()).isNotEmpty;

    if (!hasAllocations && !hasUser) {
      await _migrateFromHiveOrSeedDefaults();
    }
  }

  Future<void> _migrateFromHiveOrSeedDefaults() async {
    bool migratedFromHive = false;
    try {
      await HiveConfig.init();
      final box = await HiveConfig.openBox('levelup_money_life_box');
      if (box.isNotEmpty && box.containsKey('transactions')) {
        // Read from Hive
        final rawTx = box.get('transactions');
        List<TransactionItem> hiveTxs = [];
        if (rawTx != null) {
          final List list = rawTx is String ? jsonDecode(rawTx) : rawTx;
          hiveTxs = list
              .map((e) => TransactionItem.fromJson(Map<String, dynamic>.from(e)))
              .toList();
        }

        final rawAlloc = box.get('allocations');
        List<AllocationItem> hiveAllocs = AllocationItem.defaultAllocations;
        if (rawAlloc != null) {
          final List list = rawAlloc is String ? jsonDecode(rawAlloc) : rawAlloc;
          hiveAllocs = list
              .map((e) => AllocationItem.fromJson(Map<String, dynamic>.from(e)))
              .toList();
        }

        final double monthlyIncome =
            (box.get('monthlyIncome') as num?)?.toDouble() ?? 48000.0;

        final rawQuests = box.get('quests');
        List<QuestItem> hiveQuests = QuestItem.defaultQuests;
        if (rawQuests != null) {
          final List list = rawQuests is String ? jsonDecode(rawQuests) : rawQuests;
          hiveQuests = list
              .map((e) => QuestItem.fromJson(Map<String, dynamic>.from(e)))
              .toList();
        }

        final int totalXp = (box.get('totalXp') as num?)?.toInt() ?? 180;
        final int streakDays = (box.get('streakDays') as num?)?.toInt() ?? 1;
        final String lastActiveDate = box.get('lastActiveDate') as String? ??
            DateFormat('yyyy-MM-dd').format(DateTime.now());

        final rawUnlocked = box.get('unlockedAchievementIds');
        List<String> unlockedIds = [];
        if (rawUnlocked != null) {
          final List list =
              rawUnlocked is String ? jsonDecode(rawUnlocked) : rawUnlocked;
          unlockedIds = list.map((e) => e.toString()).toList();
        }

        final String activeMonth = box.get('activeMonth') as String? ??
            DateFormat('yyyy-MM').format(DateTime.now());
        final String themeMode = box.get('themeMode') as String? ?? 'system';

        // Insert into Drift in transaction
        await transaction(() async {
          // 1. Transactions
          for (final tx in hiveTxs) {
            await into(transactions).insert(
              TransactionsCompanion.insert(
                id: tx.id,
                name: tx.name,
                amount: tx.amount,
                date: tx.date,
                category: tx.category,
                cleared: Value(tx.cleared),
                notes: Value(tx.notes),
                expGained: Value(tx.expGained),
              ),
              mode: InsertMode.insertOrReplace,
            );
          }

          // 2. Allocations
          for (final a in hiveAllocs) {
            await into(allocations).insert(
              AllocationsCompanion.insert(
                id: a.id,
                label: a.label,
                percent: a.percent,
                color: a.color,
              ),
              mode: InsertMode.insertOrReplace,
            );
          }

          // 3. Quests
          for (final q in hiveQuests) {
            await into(quests).insert(
              QuestsCompanion.insert(
                id: q.id,
                title: q.title,
                date: q.date,
                xp: q.xp,
                done: Value(q.done),
                category: q.category,
              ),
              mode: InsertMode.insertOrReplace,
            );
          }

          // 4. User Profile
          await into(userProfiles).insert(
            UserProfilesCompanion.insert(
              id: const Value('user_main'),
              name: const Value('Finance Commander'),
              totalXp: Value(totalXp),
              streakDays: Value(streakDays),
              lastActiveDate: lastActiveDate,
            ),
            mode: InsertMode.insertOrReplace,
          );

          // 5. Unlocked achievements
          for (final achId in unlockedIds) {
            await into(unlockedAchievements).insert(
              UnlockedAchievementsCompanion.insert(
                id: achId,
                unlockedAt: lastActiveDate,
              ),
              mode: InsertMode.insertOrReplace,
            );
          }

          // 6. Settings
          await into(appSettings).insert(
            AppSettingsCompanion.insert(
              key: 'monthlyIncome',
              value: monthlyIncome.toString(),
            ),
            mode: InsertMode.insertOrReplace,
          );
          await into(appSettings).insert(
            AppSettingsCompanion.insert(
              key: 'activeMonth',
              value: activeMonth,
            ),
            mode: InsertMode.insertOrReplace,
          );
          await into(appSettings).insert(
            AppSettingsCompanion.insert(
              key: 'themeMode',
              value: themeMode,
            ),
            mode: InsertMode.insertOrReplace,
          );
        });

        migratedFromHive = true;
      }
    } catch (_) {
      migratedFromHive = false;
    }

    if (!migratedFromHive) {
      await _seedDefaultData();
    }
  }

  Future<void> _seedDefaultData() async {
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

    await transaction(() async {
      // 1. Transactions
      for (final tx in sampleTransactions) {
        await into(transactions).insert(
          TransactionsCompanion.insert(
            id: tx.id,
            name: tx.name,
            amount: tx.amount,
            date: tx.date,
            category: tx.category,
            cleared: Value(tx.cleared),
            notes: Value(tx.notes),
            expGained: Value(tx.expGained),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }

      // 2. Allocations
      for (final a in AllocationItem.defaultAllocations) {
        await into(allocations).insert(
          AllocationsCompanion.insert(
            id: a.id,
            label: a.label,
            percent: a.percent,
            color: a.color,
          ),
          mode: InsertMode.insertOrReplace,
        );
      }

      // 3. Quests
      for (final q in QuestItem.defaultQuests) {
        await into(quests).insert(
          QuestsCompanion.insert(
            id: q.id,
            title: q.title,
            date: q.date,
            xp: q.xp,
            done: Value(q.done),
            category: q.category,
          ),
          mode: InsertMode.insertOrReplace,
        );
      }

      // 4. User Profile
      await into(userProfiles).insert(
        UserProfilesCompanion.insert(
          id: const Value('user_main'),
          name: const Value('Finance Commander'),
          totalXp: const Value(180),
          streakDays: const Value(1),
          lastActiveDate: today,
        ),
        mode: InsertMode.insertOrReplace,
      );

      // 5. Settings
      await into(appSettings).insert(
        AppSettingsCompanion.insert(
          key: 'monthlyIncome',
          value: '48000.0',
        ),
        mode: InsertMode.insertOrReplace,
      );
      await into(appSettings).insert(
        AppSettingsCompanion.insert(
          key: 'activeMonth',
          value: currentMonth,
        ),
        mode: InsertMode.insertOrReplace,
      );
      await into(appSettings).insert(
        AppSettingsCompanion.insert(
          key: 'themeMode',
          value: 'system',
        ),
        mode: InsertMode.insertOrReplace,
      );
    });
  }

  // ==========================================
  // BACKUP EXPORT & IMPORT & RESET
  // ==========================================

  Future<Map<String, dynamic>> exportBackupJson() async {
    final allTxs = await select(transactions).get();
    final allAllocs = await select(allocations).get();
    final allQuests = await select(quests).get();
    final user = await (select(userProfiles)
          ..where((u) => u.id.equals('user_main')))
        .getSingleOrNull();
    final achievements = await select(unlockedAchievements).get();

    final incomeSetting = await (select(appSettings)
          ..where((s) => s.key.equals('monthlyIncome')))
        .getSingleOrNull();
    final monthSetting = await (select(appSettings)
          ..where((s) => s.key.equals('activeMonth')))
        .getSingleOrNull();
    final themeSetting = await (select(appSettings)
          ..where((s) => s.key.equals('themeMode')))
        .getSingleOrNull();

    final totalXp = user?.totalXp ?? 180;
    final streakDays = user?.streakDays ?? 1;
    final lastActiveDate = user?.lastActiveDate ??
        DateFormat('yyyy-MM-dd').format(DateTime.now());
    final progression =
        GamificationEngine.calculateLevelFromTotalXp(totalXp);

    return {
      'version': 1,
      'exportedAt': DateTime.now().toIso8601String(),
      'themeMode': themeSetting?.value ?? 'system',
      'activeMonth': monthSetting?.value ??
          DateFormat('yyyy-MM').format(DateTime.now()),
      'monthlyIncome': double.tryParse(incomeSetting?.value ?? '48000') ?? 48000.0,
      'transactions': allTxs
          .map((t) => {
                'id': t.id,
                'name': t.name,
                'amount': t.amount,
                'date': t.date,
                'category': t.category,
                'cleared': t.cleared,
                if (t.notes != null) 'notes': t.notes,
                'expGained': t.expGained,
              })
          .toList(),
      'allocations': allAllocs
          .map((a) => {
                'id': a.id,
                'label': a.label,
                'percent': a.percent,
                'color': a.color,
              })
          .toList(),
      'quests': allQuests
          .map((q) => {
                'id': q.id,
                'title': q.title,
                'date': q.date,
                'xp': q.xp,
                'done': q.done,
                'category': q.category,
              })
          .toList(),
      'gamification': {
        'level': progression.level,
        'currentLevelXp': progression.currentLevelXp,
        'xpForNextLevel': progression.xpForNextLevel,
        'totalXp': totalXp,
        'streakDays': streakDays,
        'lastActiveDate': lastActiveDate,
        'titleRankKey': progression.titleRankKey,
        'unlockedAchievementIds': achievements.map((a) => a.id).toList(),
      },
    };
  }

  Future<bool> importBackupJson(Map<String, dynamic> json) async {
    try {
      await transaction(() async {
        // 1. Transactions
        if (json['transactions'] is List) {
          await delete(transactions).go();
          for (final e in (json['transactions'] as List)) {
            final txMap = Map<String, dynamic>.from(e);
            final tx = TransactionItem.fromJson(txMap);
            await into(transactions).insert(
              TransactionsCompanion.insert(
                id: tx.id,
                name: tx.name,
                amount: tx.amount,
                date: tx.date,
                category: tx.category,
                cleared: Value(tx.cleared),
                notes: Value(tx.notes),
                expGained: Value(tx.expGained),
              ),
              mode: InsertMode.insertOrReplace,
            );
          }
        }

        // 2. Allocations
        if (json['allocations'] is List) {
          await delete(allocations).go();
          for (final e in (json['allocations'] as List)) {
            final aMap = Map<String, dynamic>.from(e);
            final a = AllocationItem.fromJson(aMap);
            await into(allocations).insert(
              AllocationsCompanion.insert(
                id: a.id,
                label: a.label,
                percent: a.percent,
                color: a.color,
              ),
              mode: InsertMode.insertOrReplace,
            );
          }
        }

        // 3. Monthly income
        if (json['monthlyIncome'] != null) {
          await into(appSettings).insert(
            AppSettingsCompanion.insert(
              key: 'monthlyIncome',
              value: json['monthlyIncome'].toString(),
            ),
            mode: InsertMode.insertOrReplace,
          );
        }

        // 4. Quests
        if (json['quests'] is List) {
          await delete(quests).go();
          for (final e in (json['quests'] as List)) {
            final qMap = Map<String, dynamic>.from(e);
            final q = QuestItem.fromJson(qMap);
            await into(quests).insert(
              QuestsCompanion.insert(
                id: q.id,
                title: q.title,
                date: q.date,
                xp: q.xp,
                done: Value(q.done),
                category: q.category,
              ),
              mode: InsertMode.insertOrReplace,
            );
          }
        }

        // 5. Gamification
        if (json['gamification'] is Map) {
          final g = Map<String, dynamic>.from(json['gamification']);
          final totalXp = (g['totalXp'] as num?)?.toInt() ?? 180;
          final streakDays = (g['streakDays'] as num?)?.toInt() ?? 1;
          final lastActiveDate = g['lastActiveDate']?.toString() ??
              DateFormat('yyyy-MM-dd').format(DateTime.now());

          await into(userProfiles).insert(
            UserProfilesCompanion.insert(
              id: const Value('user_main'),
              name: const Value('Finance Commander'),
              totalXp: Value(totalXp),
              streakDays: Value(streakDays),
              lastActiveDate: lastActiveDate,
            ),
            mode: InsertMode.insertOrReplace,
          );

          if (g['unlockedAchievementIds'] is List) {
            await delete(unlockedAchievements).go();
            for (final id in (g['unlockedAchievementIds'] as List)) {
              await into(unlockedAchievements).insert(
                UnlockedAchievementsCompanion.insert(
                  id: id.toString(),
                  unlockedAt: lastActiveDate,
                ),
                mode: InsertMode.insertOrReplace,
              );
            }
          }
        }

        // 6. Settings (Theme & Month)
        if (json['themeMode'] != null) {
          await into(appSettings).insert(
            AppSettingsCompanion.insert(
              key: 'themeMode',
              value: json['themeMode'].toString(),
            ),
            mode: InsertMode.insertOrReplace,
          );
        }

        if (json['activeMonth'] != null) {
          await into(appSettings).insert(
            AppSettingsCompanion.insert(
              key: 'activeMonth',
              value: json['activeMonth'].toString(),
            ),
            mode: InsertMode.insertOrReplace,
          );
        }
      });
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> resetAllData() async {
    await transaction(() async {
      await delete(transactions).go();
      await delete(allocations).go();
      await delete(quests).go();
      await delete(userProfiles).go();
      await delete(unlockedAchievements).go();
      await delete(appSettings).go();
    });
    await _seedDefaultData();
  }
}
