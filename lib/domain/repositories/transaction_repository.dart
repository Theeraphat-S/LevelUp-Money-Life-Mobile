import 'package:mobile_app_standard/domain/dto/transaction_dto.dart';
import 'package:mobile_app_standard/domain/http_client/api_client.dart';
import 'package:mobile_app_standard/domain/models/transaction/category_item.dart';
import 'package:mobile_app_standard/domain/models/transaction/transaction_item.dart';
import 'package:mobile_app_standard/domain/models/transaction/wallet_item.dart';

abstract class TransactionRepositoryInterface {
  Future<List<TransactionItem>> getTransactions();
  Future<List<CategoryItem>> getCategories();
  Future<List<WalletItem>> getWallets();
  Future<TransactionResponse> createTransaction(CreateTransactionRequest request);
  Future<void> deleteTransaction(String id);
  Future<Map<String, double>> getFinancialSummary();
}

class TransactionRepository implements TransactionRepositoryInterface {
  final ApiClient apiClient;

  // Local in-memory list for fast reactive response & fallback
  final List<TransactionItem> _transactions = [
    TransactionItem(
      id: 'tx_1',
      title: 'ข้าวกลางวัน ข้าวมันไก่',
      amount: 65.0,
      type: TransactionType.expense,
      categoryId: 'cat_food',
      categoryName: 'อาหาร & เครื่องดื่ม',
      categoryIcon: 'restaurant',
      categoryColor: 0xFFEF4444,
      walletId: 'wallet_cash',
      walletName: 'เงินสด (Cash)',
      date: DateTime.now().subtract(const Duration(hours: 2)),
      note: 'มื้อเที่ยงที่ตึกออฟฟิศ',
      expGained: 15,
    ),
    TransactionItem(
      id: 'tx_2',
      title: 'ค่ารถไฟฟ้า BTS',
      amount: 45.0,
      type: TransactionType.expense,
      categoryId: 'cat_travel',
      categoryName: 'เดินทาง & คมนาคม',
      categoryIcon: 'directions_car',
      categoryColor: 0xFFF59E0B,
      walletId: 'wallet_kbank',
      walletName: 'ธนาคารกสิกรไทย',
      date: DateTime.now().subtract(const Duration(hours: 5)),
      note: 'เดินทางไปทำงาน',
      expGained: 15,
    ),
    TransactionItem(
      id: 'tx_3',
      title: 'รับเงินโปรเจกต์พิเศษ Freelance',
      amount: 4500.0,
      type: TransactionType.income,
      categoryId: 'cat_freelance',
      categoryName: 'ฟรีแลนซ์ & ธุรกิจ',
      categoryIcon: 'work',
      categoryColor: 0xFF3B82F6,
      walletId: 'wallet_scb',
      walletName: 'ธนาคารไทยพาณิชย์',
      date: DateTime.now().subtract(const Duration(days: 1)),
      note: 'งานออกแบบ UI Mobile App',
      expGained: 50,
    ),
  ];

  final List<WalletItem> _wallets = List.from(WalletItem.defaultWallets);
  final List<CategoryItem> _categories = List.from(CategoryItem.defaultCategories);

  TransactionRepository(this.apiClient);

  @override
  Future<List<TransactionItem>> getTransactions() async {
    try {
      final response = await apiClient.dio.get('/transactions');
      if (response.statusCode == 200 && response.data is List) {
        final items = (response.data as List)
            .map((e) => TransactionItem.fromJson(e))
            .toList();
        return items;
      }
    } catch (_) {}
    return List.from(_transactions);
  }

  @override
  Future<List<CategoryItem>> getCategories() async {
    try {
      final response = await apiClient.dio.get('/categories');
      if (response.statusCode == 200 && response.data is List) {
        return (response.data as List)
            .map((e) => CategoryItem.fromJson(e))
            .toList();
      }
    } catch (_) {}
    return _categories;
  }

  @override
  Future<List<WalletItem>> getWallets() async {
    try {
      final response = await apiClient.dio.get('/wallets');
      if (response.statusCode == 200 && response.data is List) {
        return (response.data as List)
            .map((e) => WalletItem.fromJson(e))
            .toList();
      }
    } catch (_) {}
    return _wallets;
  }

  @override
  Future<TransactionResponse> createTransaction(
      CreateTransactionRequest request) async {
    // Find category & wallet metadata
    final cat = _categories.firstWhere(
      (c) => c.id == request.categoryId,
      orElse: () => _categories.first,
    );
    final wallet = _wallets.firstWhere(
      (w) => w.id == request.walletId,
      orElse: () => _wallets.first,
    );

    // Calculate EXP reward based on transaction
    int expAwarded = 15;
    if (request.type == TransactionType.income) {
      expAwarded = 30;
    } else if (request.note != null && request.note!.isNotEmpty) {
      expAwarded += 5; // Bonus for writing details
    }

    final newTx = TransactionItem(
      id: 'tx_${DateTime.now().millisecondsSinceEpoch}',
      title: request.title,
      amount: request.amount,
      type: request.type,
      categoryId: cat.id,
      categoryName: cat.name,
      categoryIcon: cat.iconName,
      categoryColor: cat.colorValue,
      walletId: wallet.id,
      walletName: wallet.name,
      date: request.date,
      note: request.note,
      expGained: expAwarded,
    );

    _transactions.insert(0, newTx);

    // Update wallet balance
    final walletIndex = _wallets.indexWhere((w) => w.id == wallet.id);
    if (walletIndex != -1) {
      final currentBalance = _wallets[walletIndex].balance;
      final newBalance = request.type == TransactionType.income
          ? currentBalance + request.amount
          : currentBalance - request.amount;
      _wallets[walletIndex] =
          _wallets[walletIndex].copyWith(balance: newBalance);
    }

    try {
      final response = await apiClient.dio.post(
        '/transactions',
        data: request.toJson(),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        return TransactionResponse.fromJson(response.data);
      }
    } catch (_) {}

    return TransactionResponse(
      transaction: newTx,
      expAwarded: expAwarded,
      isLevelUp: false,
    );
  }

  @override
  Future<void> deleteTransaction(String id) async {
    _transactions.removeWhere((tx) => tx.id == id);
    try {
      await apiClient.dio.delete('/transactions/$id');
    } catch (_) {}
  }

  @override
  Future<Map<String, double>> getFinancialSummary() async {
    double totalIncome = 0.0;
    double totalExpense = 0.0;
    double totalBalance = 0.0;

    for (final wallet in _wallets) {
      totalBalance += wallet.balance;
    }

    for (final tx in _transactions) {
      if (tx.type == TransactionType.income) {
        totalIncome += tx.amount;
      } else if (tx.type == TransactionType.expense) {
        totalExpense += tx.amount;
      }
    }

    return {
      'totalBalance': totalBalance,
      'totalIncome': totalIncome,
      'totalExpense': totalExpense,
      'netSavings': totalIncome - totalExpense,
    };
  }
}
