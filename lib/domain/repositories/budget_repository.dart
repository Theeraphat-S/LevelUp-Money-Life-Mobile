import 'package:mobile_app_standard/domain/models/budget/allocation_item.dart';
import 'package:mobile_app_standard/domain/models/transaction/category_item.dart';
import 'package:mobile_app_standard/domain/models/transaction/transaction_item.dart';
import 'package:mobile_app_standard/domain/services/storage_service.dart';

class BucketSpendingSummary {
  final String id;
  final String label;
  final int percent;
  final double budgetAmount;
  final double spentAmount;
  final double remainingAmount;
  final double progressPercent;
  final String color;

  const BucketSpendingSummary({
    required this.id,
    required this.label,
    required this.percent,
    required this.budgetAmount,
    required this.spentAmount,
    required this.remainingAmount,
    required this.progressPercent,
    required this.color,
  });
}

abstract class BudgetRepositoryInterface {
  Future<List<AllocationItem>> getAllocations();
  Future<void> saveAllocations(List<AllocationItem> allocations);
  Future<double> getMonthlyIncome();
  Future<void> saveMonthlyIncome(double income);
  Future<List<BucketSpendingSummary>> calculateBucketSummaries({
    required List<TransactionItem> transactions,
    required double monthlyIncome,
    required List<AllocationItem> allocations,
  });
}

class BudgetRepository implements BudgetRepositoryInterface {
  final StorageService storageService;

  BudgetRepository(this.storageService);

  @override
  Future<List<AllocationItem>> getAllocations() async {
    return storageService.getAllocations();
  }

  @override
  Future<void> saveAllocations(List<AllocationItem> allocations) async {
    await storageService.saveAllocations(allocations);
  }

  @override
  Future<double> getMonthlyIncome() async {
    return storageService.getMonthlyIncome();
  }

  @override
  Future<void> saveMonthlyIncome(double income) async {
    await storageService.saveMonthlyIncome(income);
  }

  @override
  Future<List<BucketSpendingSummary>> calculateBucketSummaries({
    required List<TransactionItem> transactions,
    required double monthlyIncome,
    required List<AllocationItem> allocations,
  }) async {
    // Group expense transactions by bucket
    double needsSpent = 0.0;
    double wantsSpent = 0.0;
    double savingsSpent = 0.0;

    for (final tx in transactions) {
      if (tx.isIncome) continue;
      final cat = tx.categoryItem;
      final absAmt = tx.absAmount;

      if (cat.bucket == BudgetBucket.needs) {
        needsSpent += absAmt;
      } else if (cat.bucket == BudgetBucket.wants) {
        wantsSpent += absAmt;
      } else if (cat.bucket == BudgetBucket.savings) {
        savingsSpent += absAmt;
      } else {
        needsSpent += absAmt;
      }
    }

    return allocations.map((alloc) {
      final budgetAmount = (monthlyIncome * alloc.percent) / 100.0;
      double spent = 0.0;
      if (alloc.id == 'needs') {
        spent = needsSpent;
      } else if (alloc.id == 'wants') {
        spent = wantsSpent;
      } else if (alloc.id == 'savings') {
        spent = savingsSpent;
      }

      final remaining = budgetAmount - spent;
      final progress = budgetAmount > 0
          ? ((spent / budgetAmount) * 100.0).clamp(0.0, 100.0)
          : 0.0;

      return BucketSpendingSummary(
        id: alloc.id,
        label: alloc.label,
        percent: alloc.percent,
        budgetAmount: budgetAmount,
        spentAmount: spent,
        remainingAmount: remaining,
        progressPercent: progress,
        color: alloc.color,
      );
    }).toList();
  }
}
