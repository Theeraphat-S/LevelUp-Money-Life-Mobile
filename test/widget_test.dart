import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app_standard/domain/models/budget/allocation_item.dart';
import 'package:mobile_app_standard/domain/models/transaction/category_item.dart';
import 'package:mobile_app_standard/domain/models/transaction/transaction_item.dart';

void main() {
  group('LevelUp Money Life Domain Tests', () {
    test('TransactionItem signed amounts and categories', () {
      final expense = TransactionItem(
        id: 'tx_1',
        name: 'กาแฟ',
        amount: -65.0,
        category: 'Food',
        date: '2026-08-16',
      );

      expect(expense.isIncome, false);
      expect(expense.absAmount, 65.0);
      expect(expense.categoryItem.bucket, BudgetBucket.needs);

      final income = TransactionItem(
        id: 'tx_2',
        name: 'เงินเดือน',
        amount: 50000.0,
        category: 'Income',
        date: '2026-08-01',
      );

      expect(income.isIncome, true);
      expect(income.absAmount, 50000.0);
    });

    test('AllocationItem calculates budget amounts accurately', () {
      const monthlyIncome = 48000.0;
      final allocations = AllocationItem.defaultAllocations;

      final needs = allocations.firstWhere((a) => a.id == 'needs');
      final wants = allocations.firstWhere((a) => a.id == 'wants');
      final savings = allocations.firstWhere((a) => a.id == 'savings');

      expect(needs.getBudgetAmount(monthlyIncome), 24000.0);
      expect(wants.getBudgetAmount(monthlyIncome), 14400.0);
      expect(savings.getBudgetAmount(monthlyIncome), 9600.0);
      expect(needs.percent + wants.percent + savings.percent, 100);
    });
  });
}
