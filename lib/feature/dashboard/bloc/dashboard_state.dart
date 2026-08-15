import 'package:equatable/equatable.dart';
import 'package:mobile_app_standard/domain/models/budget/budget_item.dart';
import 'package:mobile_app_standard/domain/models/gamification/quest.dart';
import 'package:mobile_app_standard/domain/models/gamification/user_profile.dart';
import 'package:mobile_app_standard/domain/models/transaction/transaction_item.dart';

enum DashboardStatus { initial, loading, success, failure }

class DashboardState extends Equatable {
  final DashboardStatus status;
  final UserProfile? userProfile;
  final Map<String, double> summary;
  final List<TransactionItem> recentTransactions;
  final List<QuestItem> activeQuests;
  final List<BudgetItem> budgets;
  final String? errorMessage;
  final String? notificationMessage;

  const DashboardState({
    this.status = DashboardStatus.initial,
    this.userProfile,
    this.summary = const {
      'totalBalance': 0.0,
      'totalIncome': 0.0,
      'totalExpense': 0.0,
      'netSavings': 0.0,
    },
    this.recentTransactions = const [],
    this.activeQuests = const [],
    this.budgets = const [],
    this.errorMessage,
    this.notificationMessage,
  });

  DashboardState copyWith({
    DashboardStatus? status,
    UserProfile? userProfile,
    Map<String, double>? summary,
    List<TransactionItem>? recentTransactions,
    List<QuestItem>? activeQuests,
    List<BudgetItem>? budgets,
    String? errorMessage,
    String? notificationMessage,
  }) {
    return DashboardState(
      status: status ?? this.status,
      userProfile: userProfile ?? this.userProfile,
      summary: summary ?? this.summary,
      recentTransactions: recentTransactions ?? this.recentTransactions,
      activeQuests: activeQuests ?? this.activeQuests,
      budgets: budgets ?? this.budgets,
      errorMessage: errorMessage,
      notificationMessage: notificationMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        userProfile,
        summary,
        recentTransactions,
        activeQuests,
        budgets,
        errorMessage,
        notificationMessage,
      ];
}
