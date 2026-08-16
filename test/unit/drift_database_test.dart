import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app_standard/domain/datasource/app_datebase.dart';
import 'package:mobile_app_standard/domain/models/transaction/transaction_item.dart';
import 'package:mobile_app_standard/domain/repositories/budget_repository.dart';
import 'package:mobile_app_standard/domain/repositories/gamification_repository.dart';
import 'package:mobile_app_standard/domain/repositories/transaction_repository.dart';
import 'package:mobile_app_standard/domain/repositories/user_repository.dart';

void main() {
  late AppDatabase db;
  late TransactionRepository transactionRepo;
  late BudgetRepository budgetRepo;
  late GamificationRepository gamificationRepo;
  late UserRepository userRepo;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    await db.initDatabase();
    transactionRepo = TransactionRepository(db);
    budgetRepo = BudgetRepository(db);
    gamificationRepo = GamificationRepository(db);
    userRepo = UserRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('Drift SQLite Local Database Tests', () {
    test('Initial seeding populates default transactions, budget, quests and user profile', () async {
      final txs = await transactionRepo.getTransactions();
      expect(txs.length, greaterThanOrEqualTo(8));

      final allocs = await budgetRepo.getAllocations();
      expect(allocs.length, 3);
      expect(allocs.map((a) => a.id).toList(), ['needs', 'wants', 'savings']);

      final income = await budgetRepo.getMonthlyIncome();
      expect(income, 48000.0);

      final quests = await gamificationRepo.getDailyQuests();
      expect(quests.length, greaterThanOrEqualTo(3));

      final user = await userRepo.getUserProfile();
      expect(user.id, 'user_main');
      expect(user.totalXp, 180);
    });

    test('Transaction CRUD operations work offline in SQLite', () async {
      final newTx = TransactionItem(
        id: 'test_tx_1',
        name: 'กาแฟอเมซอน',
        amount: -65.0,
        date: '2026-08-16',
        category: 'Food',
        notes: 'Cold brew',
      );

      await transactionRepo.createTransaction(newTx);
      var txs = await transactionRepo.getTransactions(monthFilter: '2026-08');
      expect(txs.any((t) => t.id == 'test_tx_1'), true);

      // Toggle cleared
      await transactionRepo.toggleCleared('test_tx_1');
      var updated = (await transactionRepo.getTransactions())
          .firstWhere((t) => t.id == 'test_tx_1');
      expect(updated.cleared, false);

      // Update
      await transactionRepo.updateTransaction(newTx.copyWith(name: 'ชาเขียวมัทฉะ'));
      updated = (await transactionRepo.getTransactions())
          .firstWhere((t) => t.id == 'test_tx_1');
      expect(updated.name, 'ชาเขียวมัทฉะ');

      // Delete
      await transactionRepo.deleteTransaction('test_tx_1');
      txs = await transactionRepo.getTransactions();
      expect(txs.any((t) => t.id == 'test_tx_1'), false);
    });

    test('Financial summary calculation handles income and expenses properly', () async {
      final summary = await transactionRepo.getFinancialSummary();
      expect(summary.containsKey('totalIncome'), true);
      expect(summary.containsKey('totalExpense'), true);
      expect(summary.containsKey('netSavings'), true);
      expect(summary['totalIncome']!, greaterThan(0));
    });

    test('Budget 50/30/20 bucket calculations execute accurately', () async {
      final txs = await transactionRepo.getTransactions();
      final income = await budgetRepo.getMonthlyIncome();
      final allocs = await budgetRepo.getAllocations();

      final summaries = await budgetRepo.calculateBucketSummaries(
        transactions: txs,
        monthlyIncome: income,
        allocations: allocs,
      );

      expect(summaries.length, 3);
      final needs = summaries.firstWhere((s) => s.id == 'needs');
      expect(needs.budgetAmount, (income * 50) / 100);
      expect(needs.percent, 50);
    });

    test('Gamification quest toggle and claim adds XP to UserProfile in SQLite', () async {
      final quests = await gamificationRepo.getDailyQuests();
      final firstQuest = quests.first;

      final initialUser = await userRepo.getUserProfile();
      final initialXp = initialUser.totalXp;

      // Toggle quest
      await gamificationRepo.toggleQuest(firstQuest.id);
      final userAfterToggle = await userRepo.getUserProfile();

      // XP should be modified
      expect(userAfterToggle.totalXp, isNot(initialXp));
    });

    test('Backup export JSON, import JSON, and reset database work seamlessly', () async {
      final backup = await db.exportBackupJson();
      expect(backup['version'], 1);
      expect(backup['transactions'], isA<List>());
      expect(backup['allocations'], isA<List>());
      expect(backup['quests'], isA<List>());
      expect(backup['gamification'], isA<Map>());

      // Test Reset
      await db.resetAllData();
      final postResetTxs = await transactionRepo.getTransactions();
      expect(postResetTxs.length, greaterThanOrEqualTo(8));

      // Test Import
      final success = await db.importBackupJson(backup);
      expect(success, true);
    });
  });
}
