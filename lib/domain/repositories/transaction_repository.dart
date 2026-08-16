import 'package:mobile_app_standard/domain/models/transaction/category_item.dart';
import 'package:mobile_app_standard/domain/models/transaction/transaction_item.dart';
import 'package:mobile_app_standard/domain/services/storage_service.dart';

abstract class TransactionRepositoryInterface {
  Future<List<TransactionItem>> getTransactions({String? monthFilter});
  Future<List<CategoryItem>> getCategories();
  Future<TransactionItem> createTransaction(TransactionItem tx);
  Future<TransactionItem> updateTransaction(TransactionItem tx);
  Future<void> deleteTransaction(String id);
  Future<void> toggleCleared(String id);
  Future<void> bulkToggleCleared(bool cleared, {String? monthFilter});
  Future<Map<String, double>> getFinancialSummary({String? monthFilter});
}

class TransactionRepository implements TransactionRepositoryInterface {
  final StorageService storageService;

  TransactionRepository(this.storageService);

  @override
  Future<List<TransactionItem>> getTransactions({String? monthFilter}) async {
    final all = storageService.getTransactions();
    if (monthFilter == null || monthFilter.isEmpty) {
      return all;
    }
    return all.where((t) => t.formattedMonth == monthFilter).toList();
  }

  @override
  Future<List<CategoryItem>> getCategories() async {
    return CategoryItem.defaultCategories;
  }

  @override
  Future<TransactionItem> createTransaction(TransactionItem tx) async {
    final all = storageService.getTransactions();
    all.insert(0, tx);
    await storageService.saveTransactions(all);
    return tx;
  }

  @override
  Future<TransactionItem> updateTransaction(TransactionItem tx) async {
    final all = storageService.getTransactions();
    final idx = all.indexWhere((t) => t.id == tx.id);
    if (idx != -1) {
      all[idx] = tx;
      await storageService.saveTransactions(all);
    }
    return tx;
  }

  @override
  Future<void> deleteTransaction(String id) async {
    final all = storageService.getTransactions();
    all.removeWhere((t) => t.id == id);
    await storageService.saveTransactions(all);
  }

  @override
  Future<void> toggleCleared(String id) async {
    final all = storageService.getTransactions();
    final idx = all.indexWhere((t) => t.id == id);
    if (idx != -1) {
      all[idx] = all[idx].copyWith(cleared: !all[idx].cleared);
      await storageService.saveTransactions(all);
    }
  }

  @override
  Future<void> bulkToggleCleared(bool cleared, {String? monthFilter}) async {
    final all = storageService.getTransactions();
    final updated = all.map((t) {
      if (monthFilter == null || t.formattedMonth == monthFilter) {
        return t.copyWith(cleared: cleared);
      }
      return t;
    }).toList();
    await storageService.saveTransactions(updated);
  }

  @override
  Future<Map<String, double>> getFinancialSummary({String? monthFilter}) async {
    final txs = await getTransactions(monthFilter: monthFilter);
    double totalIncome = 0.0;
    double totalExpense = 0.0;

    for (final tx in txs) {
      if (tx.isIncome) {
        totalIncome += tx.absAmount;
      } else {
        totalExpense += tx.absAmount;
      }
    }

    final netSavings = totalIncome - totalExpense;
    return {
      'totalIncome': totalIncome,
      'totalExpense': totalExpense,
      'netSavings': netSavings,
      'totalBalance': netSavings,
    };
  }
}
