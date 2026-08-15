import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app_standard/domain/models/transaction/category_item.dart';
import 'package:mobile_app_standard/domain/models/transaction/transaction_item.dart';
import 'package:mobile_app_standard/domain/models/transaction/wallet_item.dart';
import 'package:mobile_app_standard/feature/dashboard/bloc/dashboard_bloc.dart';
import 'package:mobile_app_standard/feature/dashboard/bloc/dashboard_event.dart';
import 'package:mobile_app_standard/feature/dashboard/bloc/dashboard_state.dart';
import 'package:mobile_app_standard/feature/dashboard/widgets/daily_quests_section.dart';
import 'package:mobile_app_standard/feature/dashboard/widgets/financial_overview_card.dart';
import 'package:mobile_app_standard/feature/dashboard/widgets/quick_actions_bar.dart';
import 'package:mobile_app_standard/feature/dashboard/widgets/recent_transactions_section.dart';
import 'package:mobile_app_standard/feature/dashboard/widgets/rpg_hud_card.dart';
import 'package:mobile_app_standard/feature/transaction/bloc/transaction_bloc.dart';
import 'package:mobile_app_standard/feature/transaction/bloc/transaction_event.dart';
import 'package:mobile_app_standard/feature/transaction/widgets/add_transaction_sheet.dart';
import 'package:mobile_app_standard/locator.dart';
import 'package:mobile_app_standard/router/router.dart';
import 'package:mobile_app_standard/shared/components/appbar/appbar_custom.dart';
import 'package:mobile_app_standard/shared/components/appbar/bottombar_custom.dart';

@RoutePage()
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _DashboardPageView();
  }
}

class _DashboardPageView extends StatelessWidget {
  const _DashboardPageView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBarCustom(
        title: 'LevelUp Money Life 🎮',
        automaticallyImplyLeading: false,
      ),
      bottomNavigationBar: BottomBarCustom(
        currentRouteName: DashboardRoute.name,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final txState = context.read<TransactionBloc>().state;
          AddTransactionSheet.show(
            context,
            initialType: TransactionType.expense,
            categories: txState.categories.isNotEmpty
                ? txState.categories
                : CategoryItem.defaultCategories,
            wallets: txState.wallets.isNotEmpty
                ? txState.wallets
                : WalletItem.defaultWallets,
          );
        },
        backgroundColor: const Color(0xFF3B82F6),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
      ),
      body: BlocConsumer<DashboardBloc, DashboardState>(
        listener: (context, state) {
          if (state.notificationMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.notificationMessage!),
                backgroundColor: const Color(0xFF10B981),
                duration: const Duration(seconds: 3),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.status == DashboardStatus.loading &&
              state.userProfile == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final user = state.userProfile;

          return RefreshIndicator(
            onRefresh: () async {
              context.read<DashboardBloc>().add(const LoadDashboardData());
              context
                  .read<TransactionBloc>()
                  .add(const LoadTransactionsEvent());
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. RPG HUD Card (Level, EXP, Streak, HP)
                  if (user != null)
                    RpgHudCard(
                      user: user,
                      onCheckIn: () {
                        context
                            .read<DashboardBloc>()
                            .add(const CheckInDailyEvent());
                      },
                    ),
                  const SizedBox(height: 16),

                  // 2. Financial Overview Card (Balance, Income, Expense)
                  FinancialOverviewCard(summary: state.summary),
                  const SizedBox(height: 20),

                  // 3. Quick Action Buttons
                  QuickActionsBar(
                    onAddExpense: () {
                      final txState = context.read<TransactionBloc>().state;
                      AddTransactionSheet.show(
                        context,
                        initialType: TransactionType.expense,
                        categories: txState.categories.isNotEmpty
                            ? txState.categories
                            : CategoryItem.defaultCategories,
                        wallets: txState.wallets.isNotEmpty
                            ? txState.wallets
                            : WalletItem.defaultWallets,
                      );
                    },
                    onAddIncome: () {
                      final txState = context.read<TransactionBloc>().state;
                      AddTransactionSheet.show(
                        context,
                        initialType: TransactionType.income,
                        categories: txState.categories.isNotEmpty
                            ? txState.categories
                            : CategoryItem.defaultCategories,
                        wallets: txState.wallets.isNotEmpty
                            ? txState.wallets
                            : WalletItem.defaultWallets,
                      );
                    },
                    onOpenQuests: () {
                      context.router.push(const QuestRoute());
                    },
                    onOpenHistory: () {
                      context.router.push(const TransactionRoute());
                    },
                  ),
                  const SizedBox(height: 24),

                  // 4. Daily Quests Section
                  DailyQuestsSection(
                    quests: state.activeQuests,
                    onClaim: (questId) {
                      context
                          .read<DashboardBloc>()
                          .add(ClaimQuestRewardEvent(questId));
                    },
                    onViewAll: () {
                      context.router.push(const QuestRoute());
                    },
                  ),
                  const SizedBox(height: 20),

                  // 5. Recent Transactions Section
                  RecentTransactionsSection(
                    transactions: state.recentTransactions,
                    onViewAll: () {
                      context.router.push(const TransactionRoute());
                    },
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
