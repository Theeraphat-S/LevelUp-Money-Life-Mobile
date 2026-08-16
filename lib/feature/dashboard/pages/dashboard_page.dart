import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app_standard/domain/models/transaction/category_item.dart';
import 'package:mobile_app_standard/domain/models/transaction/transaction_item.dart';
import 'package:mobile_app_standard/feature/dashboard/bloc/dashboard_bloc.dart';
import 'package:mobile_app_standard/feature/dashboard/bloc/dashboard_event.dart';
import 'package:mobile_app_standard/feature/dashboard/bloc/dashboard_state.dart';
import 'package:mobile_app_standard/feature/gamification/bloc/gamification_bloc.dart';
import 'package:mobile_app_standard/feature/gamification/bloc/gamification_event.dart';
import 'package:mobile_app_standard/feature/transaction/bloc/transaction_bloc.dart';
import 'package:mobile_app_standard/feature/transaction/bloc/transaction_event.dart';
import 'package:mobile_app_standard/feature/transaction/widgets/quick_add_sheet.dart';
import 'package:mobile_app_standard/feature/transaction/widgets/slip_scan_sheet.dart';
import 'package:mobile_app_standard/i18n/i18n.dart';
import 'package:mobile_app_standard/router/router.dart';
import 'package:mobile_app_standard/shared/bloc/app/app_bloc.dart';
import 'package:mobile_app_standard/shared/components/appbar/bottombar_custom.dart';
import 'package:mobile_app_standard/shared/components/bento_card.dart';
import 'package:mobile_app_standard/shared/components/header_command_deck.dart';
import 'package:mobile_app_standard/shared/components/metric_tile.dart';
import 'package:mobile_app_standard/shared/components/xp_progress_bar.dart';
import 'package:mobile_app_standard/shared/tokens/p_colors.dart';

@RoutePage()
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PColor.base(context),
      appBar: HeaderCommandDeck(
        onOpenQuests: () => context.router.push(const QuestRoute()),
      ),
      bottomNavigationBar: const BottomBarCustom(
        currentRouteName: DashboardRoute.name,
      ),
      body: BlocConsumer<DashboardBloc, DashboardState>(
        listener: (context, state) {
          if (state.notificationMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.notificationMessage!),
                backgroundColor: PColor.jadeLight,
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

          final summary = state.summary;
          final totalIncome = summary['totalIncome'] ?? 0.0;
          final totalExpense = summary['totalExpense'] ?? 0.0;
          final netSavings = summary['netSavings'] ?? 0.0;
          final user = state.userProfile;
          final currencyFormat = NumberFormat('#,##0.00', 'en_US');
          final i18n = AppLocalizations(context).dashboard;
          final currentLang = Localizations.localeOf(context).languageCode;

          return RefreshIndicator(
            onRefresh: () async {
              final activeMonth = context.read<AppGlobalBloc>().state.activeMonth;
              context
                  .read<DashboardBloc>()
                  .add(LoadDashboardData(monthFilter: activeMonth));
              context
                  .read<TransactionBloc>()
                  .add(LoadTransactionsEvent(monthFilter: activeMonth));
              context
                  .read<GamificationBloc>()
                  .add(const LoadGamificationDataEvent());
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Metric Tiles Row
                  Row(
                    children: [
                      Expanded(
                        child: MetricTile(
                          icon: const Icon(Icons.arrow_upward_rounded),
                          label: i18n.monthly_income,
                          value: '฿${currencyFormat.format(totalIncome)}',
                          tone: MetricTone.jade,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: MetricTile(
                          icon: const Icon(Icons.arrow_downward_rounded),
                          label: i18n.monthly_expense,
                          value: '฿${currencyFormat.format(totalExpense)}',
                          tone: MetricTone.rose,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // 2. Net Savings / Flow Bento Card
                  BentoCard(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              i18n.net_savings,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                                color: PColor.inkSoft(context),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${netSavings >= 0 ? '+' : ''}฿${currencyFormat.format(netSavings)}',
                              style: TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: netSavings >= 0
                                    ? PColor.jadeInk(context)
                                    : PColor.roseInk(context),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: netSavings >= 0
                                ? PColor.jadeSoft(context)
                                : PColor.roseSoft(context),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            netSavings >= 0 ? i18n.status_healthy : i18n.status_overspent,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: netSavings >= 0
                                  ? PColor.jadeInk(context)
                                  : PColor.roseInk(context),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // 3. Gamification Progression Bento Card
                  if (user != null)
                    BentoCard(
                      header: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.military_tech_rounded,
                                  size: 16, color: PColor.jade(context)),
                              const SizedBox(width: 6),
                              Text(
                                'Lv.${user.level} · ${currentLang == 'en' ? user.rankTitleEn : user.rankTitle}',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: PColor.ink(context),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            i18n.day_streak(user.streakDays),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: PColor.amberInk(context),
                            ),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          XPProgressBar(
                            currentXp: user.currentExp,
                            xpForNextLevel: user.maxExp,
                            progressPercent: user.expProgress * 100.0,
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                i18n.total_xp_score(user.totalXp),
                                style: TextStyle(
                                  fontSize: 11,
                                  fontFamily: 'monospace',
                                  color: PColor.inkSoft(context),
                                ),
                              ),
                              InkWell(
                                onTap: () =>
                                    context.router.push(const QuestRoute()),
                                child: Text(
                                  i18n.view_quests_achievements,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: PColor.primary(context),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 14),

                  // 4. Quick Action Deck
                  Row(
                    children: [
                      Expanded(
                        child: _buildActionButton(
                          context: context,
                          icon: Icons.add_rounded,
                          label: i18n.add_expense,
                          toneColor: PColor.rose(context),
                          onTap: () => QuickAddSheet.show(context,
                              initialType: TransactionType.expense),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildActionButton(
                          context: context,
                          icon: Icons.add_rounded,
                          label: i18n.add_income,
                          toneColor: PColor.jade(context),
                          onTap: () => QuickAddSheet.show(context,
                              initialType: TransactionType.income),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildActionButton(
                          context: context,
                          icon: Icons.document_scanner_outlined,
                          label: i18n.scan_slip,
                          toneColor: PColor.primary(context),
                          onTap: () => SlipScanSheet.show(context),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // 5. Daily Quests Snapshot
                  BentoCard(
                    header: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.checklist_rounded,
                                size: 16, color: PColor.primary(context)),
                            const SizedBox(width: 6),
                            Text(
                              i18n.daily_quests,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: PColor.ink(context),
                              ),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () =>
                              context.router.push(const QuestRoute()),
                          child: Text(
                            i18n.view_all,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: PColor.primary(context),
                            ),
                          ),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: state.activeQuests.take(3).map((quest) {
                        return Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                  color: PColor.lineSubtle(context), width: 1),
                            ),
                          ),
                          child: ListTile(
                            dense: true,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 0),
                            leading: Checkbox(
                              value: quest.done,
                              activeColor: PColor.primary(context),
                              onChanged: (_) {
                                context
                                    .read<GamificationBloc>()
                                    .add(ToggleQuestEvent(quest.id));
                                context.read<DashboardBloc>().add(
                                    const LoadDashboardData());
                              },
                            ),
                            title: Text(
                              quest.getLocalizedTitle(context),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: quest.done
                                    ? PColor.inkFaint(context)
                                    : PColor.ink(context),
                                decoration: quest.done
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: PColor.jadeSoft(context),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '+${quest.xp} XP',
                                style: TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: PColor.jadeInk(context),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 6. Recent Transactions
                  BentoCard(
                    header: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.receipt_long_outlined,
                                size: 16, color: PColor.primary(context)),
                            const SizedBox(width: 6),
                            Text(
                              i18n.recent_transactions,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: PColor.ink(context),
                              ),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () =>
                              context.router.push(const TransactionRoute()),
                          child: Text(
                            i18n.view_all,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: PColor.primary(context),
                            ),
                          ),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.zero,
                    child: state.recentTransactions.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Center(
                              child: Text(
                                i18n.no_transactions_month,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: PColor.inkFaint(context),
                                ),
                              ),
                            ),
                          )
                        : Column(
                            children: state.recentTransactions.map((tx) {
                              final localizedCategory =
                                  CategoryItem.getLocalizedCategoryName(
                                      tx.category, currentLang);
                              return Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        color: PColor.lineSubtle(context),
                                        width: 1),
                                  ),
                                ),
                                child: ListTile(
                                  dense: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 2),
                                  leading: Container(
                                    padding: const EdgeInsets.all(7),
                                    decoration: BoxDecoration(
                                      color: tx.isIncome
                                          ? PColor.jadeSoft(context)
                                          : PColor.roseSoft(context),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      tx.isIncome
                                          ? Icons.arrow_upward_rounded
                                          : Icons.arrow_downward_rounded,
                                      size: 16,
                                      color: tx.isIncome
                                          ? PColor.amountIconJade(context)
                                          : PColor.amountIconRose(context),
                                    ),
                                  ),
                                  title: Text(
                                    tx.name,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: PColor.ink(context),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  subtitle: Text(
                                    '$localizedCategory • ${tx.date}',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: PColor.inkSoft(context),
                                    ),
                                  ),
                                  trailing: Text(
                                    '${tx.isIncome ? '+' : '-'}฿${currencyFormat.format(tx.absAmount)}',
                                    style: TextStyle(
                                      fontFamily: 'monospace',
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: tx.isIncome
                                          ? PColor.jadeInk(context)
                                          : PColor.roseInk(context),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color toneColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: PColor.surface(context),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: PColor.line(context)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: toneColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: toneColor, size: 16),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: PColor.ink(context),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
