import 'package:drift/drift.dart';
import 'package:mobile_app_standard/domain/datasource/app_datebase.dart';
import 'package:mobile_app_standard/domain/models/transaction/category_item.dart';
import 'package:mobile_app_standard/domain/models/transaction/transaction_item.dart';

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
  final AppDatabase db;

  TransactionRepository(this.db);

  @override
  Future<List<TransactionItem>> getTransactions({String? monthFilter}) async {
    final query = db.select(db.transactions)
      ..orderBy([(t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)]);

    if (monthFilter != null && monthFilter.isNotEmpty) {
      query.where((t) => t.date.like('$monthFilter%'));
    }

    final rows = await query.get();
    return rows
        .map((r) => TransactionItem(
              id: r.id,
              name: r.name,
              amount: r.amount,
              date: r.date,
              category: r.category,
              cleared: r.cleared,
              notes: r.notes,
              expGained: r.expGained,
            ))
        .toList();
  }

  @override
  Future<List<CategoryItem>> getCategories() async {
    return CategoryItem.defaultCategories;
  }

  @override
  Future<TransactionItem> createTransaction(TransactionItem tx) async {
    await db.into(db.transactions).insert(
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
    return tx;
  }

  @override
  Future<TransactionItem> updateTransaction(TransactionItem tx) async {
    await (db.update(db.transactions)..where((t) => t.id.equals(tx.id))).write(
      TransactionsCompanion(
        name: Value(tx.name),
        amount: Value(tx.amount),
        date: Value(tx.date),
        category: Value(tx.category),
        cleared: Value(tx.cleared),
        notes: Value(tx.notes),
        expGained: Value(tx.expGained),
      ),
    );
    return tx;
  }

  @override
  Future<void> deleteTransaction(String id) async {
    await (db.delete(db.transactions)..where((t) => t.id.equals(id))).go();
  }

  @override
  Future<void> toggleCleared(String id) async {
    final tx = await (db.select(db.transactions)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    if (tx != null) {
      await (db.update(db.transactions)..where((t) => t.id.equals(id))).write(
        TransactionsCompanion(cleared: Value(!tx.cleared)),
      );
    }
  }

  @override
  Future<void> bulkToggleCleared(bool cleared, {String? monthFilter}) async {
    final updateQuery = db.update(db.transactions);
    if (monthFilter != null && monthFilter.isNotEmpty) {
      updateQuery.where((t) => t.date.like('$monthFilter%'));
    }
    await updateQuery.write(TransactionsCompanion(cleared: Value(cleared)));
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
