import 'package:mobile_app_standard/domain/http_client/api_client.dart';
import 'package:mobile_app_standard/domain/models/budget/budget_item.dart';

abstract class BudgetRepositoryInterface {
  Future<List<BudgetItem>> getBudgets();
  Future<List<SavingsGoal>> getSavingsGoals();
  Future<void> addSavingsAmount(String goalId, double amount);
}

class BudgetRepository implements BudgetRepositoryInterface {
  final ApiClient apiClient;

  final List<BudgetItem> _budgets = [
    BudgetItem(
      id: 'b_1',
      categoryId: 'cat_food',
      categoryName: 'อาหาร & เครื่องดื่ม',
      categoryIcon: 'restaurant',
      monthlyLimit: 6000.0,
      spentAmount: 2450.0,
    ),
    BudgetItem(
      id: 'b_2',
      categoryId: 'cat_travel',
      categoryName: 'เดินทาง & คมนาคม',
      categoryIcon: 'directions_car',
      monthlyLimit: 2500.0,
      spentAmount: 1100.0,
    ),
    BudgetItem(
      id: 'b_3',
      categoryId: 'cat_shopping',
      categoryName: 'ช้อปปิ้ง & ไลฟ์สไตล์',
      categoryIcon: 'shopping_bag',
      monthlyLimit: 3000.0,
      spentAmount: 2890.0,
    ),
  ];

  final List<SavingsGoal> _savings = [
    SavingsGoal(
      id: 'sg_1',
      title: 'กองทุนฉุกเฉิน (Emergency Fund)',
      targetAmount: 30000.0,
      currentAmount: 18500.0,
      iconKey: 'shield',
      colorValue: 0xFF10B981,
    ),
    SavingsGoal(
      id: 'sg_2',
      title: 'ซื้อ MacBook Pro M4 สำหรับ Dev',
      targetAmount: 59900.0,
      currentAmount: 24000.0,
      iconKey: 'laptop_mac',
      colorValue: 0xFF3B82F6,
    ),
  ];

  BudgetRepository(this.apiClient);

  @override
  Future<List<BudgetItem>> getBudgets() async {
    try {
      final response = await apiClient.dio.get('/budgets');
      if (response.statusCode == 200 && response.data is List) {
        return (response.data as List)
            .map((e) => BudgetItem.fromJson(e))
            .toList();
      }
    } catch (_) {}
    return List.from(_budgets);
  }

  @override
  Future<List<SavingsGoal>> getSavingsGoals() async {
    try {
      final response = await apiClient.dio.get('/savings');
      if (response.statusCode == 200 && response.data is List) {
        return (response.data as List)
            .map((e) => SavingsGoal.fromJson(e))
            .toList();
      }
    } catch (_) {}
    return List.from(_savings);
  }

  @override
  Future<void> addSavingsAmount(String goalId, double amount) async {
    final index = _savings.indexWhere((s) => s.id == goalId);
    if (index != -1) {
      final current = _savings[index];
      _savings[index] = SavingsGoal(
        id: current.id,
        title: current.title,
        targetAmount: current.targetAmount,
        currentAmount: current.currentAmount + amount,
        iconKey: current.iconKey,
        colorValue: current.colorValue,
        targetDate: current.targetDate,
      );
      try {
        await apiClient.dio.post('/savings/$goalId/deposit', data: {'amount': amount});
      } catch (_) {}
    }
  }
}
