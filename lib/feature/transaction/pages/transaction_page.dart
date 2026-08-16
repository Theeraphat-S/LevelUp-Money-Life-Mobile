import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app_standard/domain/models/transaction/category_item.dart';
import 'package:mobile_app_standard/domain/models/transaction/transaction_item.dart';
import 'package:mobile_app_standard/feature/dashboard/bloc/dashboard_bloc.dart';
import 'package:mobile_app_standard/feature/dashboard/bloc/dashboard_event.dart';
import 'package:mobile_app_standard/feature/gamification/bloc/gamification_bloc.dart';
import 'package:mobile_app_standard/feature/gamification/bloc/gamification_event.dart';
import 'package:mobile_app_standard/feature/transaction/bloc/transaction_bloc.dart';
import 'package:mobile_app_standard/feature/transaction/bloc/transaction_event.dart';
import 'package:mobile_app_standard/feature/transaction/bloc/transaction_state.dart';
import 'package:mobile_app_standard/feature/transaction/widgets/quick_add_sheet.dart';
import 'package:mobile_app_standard/router/router.dart';
import 'package:mobile_app_standard/shared/components/appbar/bottombar_custom.dart';
import 'package:mobile_app_standard/shared/components/header_command_deck.dart';
import 'package:mobile_app_standard/shared/tokens/p_colors.dart';

@RoutePage()
class TransactionPage extends StatelessWidget {
  const TransactionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _TransactionPageView();
  }
}

class _TransactionPageView extends StatefulWidget {
  const _TransactionPageView();

  @override
  State<_TransactionPageView> createState() => _TransactionPageViewState();
}

class _TransactionPageViewState extends State<_TransactionPageView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currencyFormat = NumberFormat('#,##0.00', 'en_US');
    final borderColor = PColor.line(context);

    return Scaffold(
      backgroundColor: PColor.base(context),
      appBar: HeaderCommandDeck(
        onOpenQuests: () => context.router.push(const QuestRoute()),
      ),
      bottomNavigationBar: BottomBarCustom(
        currentRouteName: TransactionRoute.name,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => QuickAddSheet.show(context),
        backgroundColor: PColor.primary(context),
        foregroundColor: isDark ? PColor.darkBase : Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text('บันทึกรายการ',
            style: TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: BlocBuilder<TransactionBloc, TransactionState>(
        builder: (context, state) {
          final transactions = state.filteredTransactions;

          return Column(
            children: [
              // 1. Search & Filter Bar Section
              Container(
                color: PColor.surface(context),
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Column(
                  children: [
                    // Search Field
                    TextField(
                      controller: _searchController,
                      onChanged: (val) {
                        context.read<TransactionBloc>().add(
                            SetTransactionFilterEvent(search: val));
                      },
                      style: TextStyle(fontSize: 13, color: PColor.ink(context)),
                      decoration: InputDecoration(
                        hintText: 'ค้นหาชื่อรายการ, หมวดหมู่, หรือโน้ต...',
                        prefixIcon: Icon(Icons.search_rounded,
                            size: 18, color: PColor.inkSoft(context)),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear_rounded, size: 16),
                                onPressed: () {
                                  _searchController.clear();
                                  context.read<TransactionBloc>().add(
                                      const SetTransactionFilterEvent(
                                          search: ''));
                                },
                              )
                            : null,
                        filled: true,
                        fillColor: PColor.surfaceSubtle(context),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: borderColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: borderColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: PColor.primary(context), width: 1.5),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Category Filter Horizontal Scroll
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildCategoryPill(
                            label: 'ทั้งหมด',
                            isSelected: state.categoryFilter == null,
                            onTap: () => context.read<TransactionBloc>().add(
                                const SetTransactionFilterEvent(
                                    clearCategory: true)),
                          ),
                          ...CategoryItem.defaultCategories.map((cat) {
                            return _buildCategoryPill(
                              label: CategoryItem.getCategoryThaiName(cat.id),
                              color: cat.color,
                              isSelected: state.categoryFilter == cat.id,
                              onTap: () => context.read<TransactionBloc>().add(
                                  SetTransactionFilterEvent(
                                      category: cat.id)),
                            );
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, thickness: 1),

              // 2. Secondary Filter & Bulk Actions Strip
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: PColor.surfaceSubtle(context),
                child: Row(
                  children: [
                    // Cleared Toggle Pill
                    _buildSmallFilterButton(
                      context: context,
                      label: state.clearedFilter == null
                          ? 'สถานะ: ทั้งหมด'
                          : state.clearedFilter == true
                              ? 'สถานะ: เคลียร์แล้ว ✓'
                              : 'สถานะ: ยังไม่เคลียร์ ⌛',
                      onTap: () {
                        if (state.clearedFilter == null) {
                          context.read<TransactionBloc>().add(
                              const SetTransactionFilterEvent(cleared: true));
                        } else if (state.clearedFilter == true) {
                          context.read<TransactionBloc>().add(
                              const SetTransactionFilterEvent(cleared: false));
                        } else {
                          context.read<TransactionBloc>().add(
                              const SetTransactionFilterEvent(
                                  clearCleared: true));
                        }
                      },
                    ),
                    const SizedBox(width: 8),

                    // Sort Order Button
                    _buildSmallFilterButton(
                      context: context,
                      icon: state.sortAscending
                          ? Icons.arrow_upward_rounded
                          : Icons.arrow_downward_rounded,
                      label: state.sortField == TransactionSortField.date
                          ? 'วันที่'
                          : state.sortField == TransactionSortField.amount
                              ? 'จำนวนเงิน'
                              : 'ชื่อ',
                      onTap: () {
                        // Cycle sort fields
                        if (state.sortField == TransactionSortField.date) {
                          context.read<TransactionBloc>().add(
                              const SetTransactionFilterEvent(
                                  sortField: TransactionSortField.amount));
                        } else if (state.sortField ==
                            TransactionSortField.amount) {
                          context.read<TransactionBloc>().add(
                              const SetTransactionFilterEvent(
                                  sortField: TransactionSortField.name));
                        } else {
                          context.read<TransactionBloc>().add(
                              SetTransactionFilterEvent(
                                  sortField: TransactionSortField.date,
                                  sortAscending: !state.sortAscending));
                        }
                      },
                    ),
                    const Spacer(),

                    // Bulk Clear Menu
                    PopupMenuButton<String>(
                      tooltip: 'การจัดการหลายรายการ',
                      icon: Icon(Icons.more_horiz_rounded,
                          size: 18, color: PColor.ink(context)),
                      color: PColor.surface(context),
                      onSelected: (val) {
                        if (val == 'clear_all') {
                          context
                              .read<TransactionBloc>()
                              .add(const BulkToggleTransactionClearedEvent(true));
                        } else if (val == 'unclear_all') {
                          context.read<TransactionBloc>().add(
                              const BulkToggleTransactionClearedEvent(false));
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'clear_all',
                          child: Text('ทำเครื่องหมายเคลียร์ทั้งหมด'),
                        ),
                        const PopupMenuItem(
                          value: 'unclear_all',
                          child: Text('ยกเลิกการเคลียร์ทั้งหมด'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // 3. Transactions Ledger List
              Expanded(
                child: transactions.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.receipt_long_outlined,
                                size: 56, color: PColor.line(context)),
                            const SizedBox(height: 12),
                            Text(
                              'ไม่พบรายการธุรกรรมตามเงื่อนไขที่เลือก',
                              style: TextStyle(
                                  fontSize: 13,
                                  color: PColor.inkSoft(context)),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        itemCount: transactions.length,
                        itemBuilder: (context, index) {
                          final tx = transactions[index];
                          return _buildTransactionCard(
                              context, tx, currencyFormat);
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCategoryPill({
    required String label,
    Color? color,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 6.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: isSelected
                ? PColor.primary(context)
                : PColor.surfaceSubtle(context),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected
                  ? PColor.primary(context)
                  : PColor.line(context),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (color != null) ...[
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 5),
              ],
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected
                      ? Colors.white
                      : PColor.ink(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSmallFilterButton({
    required BuildContext context,
    IconData? icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: PColor.surface(context),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: PColor.line(context)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 14, color: PColor.inkSoft(context)),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: PColor.ink(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionCard(
    BuildContext context,
    TransactionItem tx,
    NumberFormat currencyFormat,
  ) {
    final catItem = tx.categoryItem;

    return Dismissible(
      key: Key(tx.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 8),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: PColor.rose(context),
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Icon(Icons.delete_outline_rounded, color: Colors.white),
      ),
      onDismissed: (_) {
        context
            .read<TransactionBloc>()
            .add(DeleteTransactionItemEvent(tx.id));
        context.read<DashboardBloc>().add(const LoadDashboardData());
        context
            .read<GamificationBloc>()
            .add(const LoadGamificationDataEvent());
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: PColor.surface(context),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: PColor.line(context)),
        ),
        child: ListTile(
          onTap: () => QuickAddSheet.show(context, initialTransaction: tx),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: catItem.color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              tx.isIncome
                  ? Icons.arrow_upward_rounded
                  : Icons.arrow_downward_rounded,
              color: catItem.color,
              size: 18,
            ),
          ),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  tx.name,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: PColor.ink(context),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              InkWell(
                onTap: () {
                  context
                      .read<TransactionBloc>()
                      .add(ToggleTransactionClearedEvent(tx.id));
                  context
                      .read<DashboardBloc>()
                      .add(const LoadDashboardData());
                },
                borderRadius: BorderRadius.circular(6),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: tx.cleared
                        ? PColor.jadeSoft(context)
                        : PColor.amberSoft(context),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    tx.cleared ? 'Cleared ✓' : 'Pending',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: tx.cleared
                          ? PColor.jadeInk(context)
                          : PColor.amberInk(context),
                    ),
                  ),
                ),
              ),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 2),
              Text(
                '${CategoryItem.getCategoryThaiName(tx.category)} • ${tx.date}',
                style: TextStyle(
                  fontSize: 11,
                  color: PColor.inkSoft(context),
                ),
              ),
              if (tx.notes != null && tx.notes!.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  '📝 ${tx.notes}',
                  style: TextStyle(
                    fontSize: 10,
                    color: PColor.inkFaint(context),
                    fontStyle: FontStyle.italic,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
          trailing: Text(
            '${tx.isIncome ? '+' : '-'}฿${currencyFormat.format(tx.absAmount)}',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: tx.isIncome
                  ? PColor.jadeInk(context)
                  : PColor.roseInk(context),
            ),
          ),
        ),
      ),
    );
  }
}
