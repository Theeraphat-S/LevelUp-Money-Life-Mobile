import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app_standard/domain/models/transaction/category_item.dart';
import 'package:mobile_app_standard/feature/transaction/bloc/transaction_bloc.dart';
import 'package:mobile_app_standard/feature/transaction/bloc/transaction_event.dart';
import 'package:mobile_app_standard/feature/transaction/bloc/transaction_state.dart';
import 'package:mobile_app_standard/router/router.dart';
import 'package:mobile_app_standard/shared/components/appbar/bottombar_custom.dart';
import 'package:mobile_app_standard/shared/components/bento_card.dart';
import 'package:mobile_app_standard/shared/components/header_command_deck.dart';
import 'package:mobile_app_standard/shared/tokens/p_colors.dart';

@RoutePage()
class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat('#,##0.00', 'en_US');

    return Scaffold(
      backgroundColor: PColor.base(context),
      appBar: HeaderCommandDeck(
        onOpenQuests: () => context.router.push(const QuestRoute()),
      ),
      bottomNavigationBar: BottomBarCustom(
        currentRouteName: AnalyticsRoute.name,
      ),
      body: BlocBuilder<TransactionBloc, TransactionState>(
        builder: (context, state) {
          final transactions = state.allTransactions;

          double totalIncome = 0.0;
          double totalExpense = 0.0;
          final Map<String, double> categorySpending = {};

          for (final tx in transactions) {
            if (tx.isIncome) {
              totalIncome += tx.absAmount;
            } else {
              totalExpense += tx.absAmount;
              categorySpending[tx.category] =
                  (categorySpending[tx.category] ?? 0.0) + tx.absAmount;
            }
          }

          final sortedCategories = categorySpending.entries.toList()
            ..sort((a, b) => b.value.compareTo(a.value));

          return RefreshIndicator(
            onRefresh: () async {
              context
                  .read<TransactionBloc>()
                  .add(const LoadTransactionsEvent());
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Inflow vs Outflow Bento Card
                  BentoCard(
                    header: Row(
                      children: [
                        Icon(Icons.compare_arrows_rounded,
                            size: 16, color: PColor.primary(context)),
                        const SizedBox(width: 6),
                        Text(
                          'เปรียบเทียบกระแสเงินสด (Cash Flow)',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: PColor.ink(context),
                          ),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('รายรับรวม',
                                    style: TextStyle(
                                        fontSize: 11,
                                        color: PColor.inkSoft(context))),
                                const SizedBox(height: 2),
                                Text(
                                  '+฿${currencyFormat.format(totalIncome)}',
                                  style: TextStyle(
                                    fontFamily: 'monospace',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: PColor.jadeInk(context),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('รายจ่ายรวม',
                                    style: TextStyle(
                                        fontSize: 11,
                                        color: PColor.inkSoft(context))),
                                const SizedBox(height: 2),
                                Text(
                                  '-฿${currencyFormat.format(totalExpense)}',
                                  style: TextStyle(
                                    fontFamily: 'monospace',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: PColor.roseInk(context),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),

                        // Ratio Bar
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Container(
                            height: 10,
                            color: PColor.line(context),
                            child: Row(
                              children: [
                                if (totalIncome + totalExpense > 0) ...[
                                  Expanded(
                                    flex: (totalIncome * 100).round(),
                                    child: Container(color: PColor.jade(context)),
                                  ),
                                  Expanded(
                                    flex: (totalExpense * 100).round(),
                                    child: Container(color: PColor.rose(context)),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 2. Category Spending Breakdown
                  BentoCard(
                    header: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.donut_large_rounded,
                                size: 16, color: PColor.primary(context)),
                            const SizedBox(width: 6),
                            Text(
                              'สัดส่วนการใช้จ่ายตามหมวดหมู่',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: PColor.ink(context),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'รวม ฿${currencyFormat.format(totalExpense)}',
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: PColor.inkSoft(context),
                          ),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: sortedCategories.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Center(
                              child: Text(
                                'ยังไม่มีข้อมูลรายจ่ายในเดือนนี้',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: PColor.inkFaint(context)),
                              ),
                            ),
                          )
                        : Column(
                            children: sortedCategories.map((entry) {
                              final cat = CategoryItem.fromCategoryId(entry.key);
                              final pct = totalExpense > 0
                                  ? (entry.value / totalExpense) * 100.0
                                  : 0.0;

                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 8,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            color: cat.color,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            CategoryItem.getCategoryThaiName(cat.id),
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              color: PColor.ink(context),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          '${pct.toStringAsFixed(1)}%',
                                          style: TextStyle(
                                            fontFamily: 'monospace',
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700,
                                            color: PColor.inkSoft(context),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          '฿${currencyFormat.format(entry.value)}',
                                          style: TextStyle(
                                            fontFamily: 'monospace',
                                            fontSize: 12,
                                            fontWeight: FontWeight.w800,
                                            color: PColor.roseInk(context),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(3),
                                      child: LinearProgressIndicator(
                                        value: (pct / 100.0).clamp(0.0, 1.0),
                                        minHeight: 6,
                                        backgroundColor: PColor.lineSubtle(context),
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                            cat.color),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
