import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:levelup_money_life/feature/budget/bloc/budget_bloc.dart';
import 'package:levelup_money_life/feature/dashboard/bloc/dashboard_bloc.dart';
import 'package:levelup_money_life/feature/dashboard/bloc/dashboard_event.dart';
import 'package:levelup_money_life/feature/gamification/bloc/gamification_bloc.dart';
import 'package:levelup_money_life/feature/gamification/bloc/gamification_state.dart';
import 'package:levelup_money_life/feature/transaction/bloc/transaction_bloc.dart';
import 'package:levelup_money_life/feature/transaction/bloc/transaction_event.dart';
import 'package:levelup_money_life/shared/bloc/app/app_bloc.dart';
import 'package:levelup_money_life/shared/components/settings_sheet.dart';
import 'package:levelup_money_life/shared/tokens/p_colors.dart';

class HeaderCommandDeck extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onOpenQuests;

  const HeaderCommandDeck({super.key, this.onOpenQuests});

  @override
  Size get preferredSize => const Size.fromHeight(60.0);

  void _changeMonth(BuildContext context, String currentMonth, int offset) {
    try {
      final parts = currentMonth.split('-');
      int year = int.parse(parts[0]);
      int month = int.parse(parts[1]);

      month += offset;
      if (month > 12) {
        month = 1;
        year += 1;
      } else if (month < 1) {
        month = 12;
        year -= 1;
      }

      final newMonthStr = '$year-${month.toString().padLeft(2, '0')}';
      context.read<AppGlobalBloc>().add(ChangeActiveMonthEvent(newMonthStr));
      context.read<DashboardBloc>().add(LoadDashboardData(monthFilter: newMonthStr));
      context.read<TransactionBloc>().add(LoadTransactionsEvent(monthFilter: newMonthStr));
      context.read<BudgetBloc>().add(LoadBudgetDataEvent(monthFilter: newMonthStr));
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final surfaceColor = PColor.surface(context);
    final borderColor = PColor.line(context);

    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        border: Border(
          bottom: BorderSide(color: borderColor, width: 1.0),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
          child: Row(
            children: [
              // Brand Icon & Name
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: PColor.primarySoft(context),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Icon(
                  Icons.shield_outlined,
                  color: PColor.primary(context),
                  size: 15,
                ),
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  'LevelUp Money Life',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                    color: PColor.ink(context),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 6),

              // Center-Right: Compact Month Selector Pill
              BlocBuilder<AppGlobalBloc, AppGlobalState>(
                builder: (context, appState) {
                  final activeMonth = appState.activeMonth;

                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                    decoration: BoxDecoration(
                      color: PColor.surfaceSubtle(context),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: borderColor, width: 1),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          onTap: () => _changeMonth(context, activeMonth, -1),
                          borderRadius: BorderRadius.circular(6),
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Icon(
                              Icons.chevron_left_rounded,
                              size: 16,
                              color: PColor.ink(context),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Text(
                            activeMonth,
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: PColor.ink(context),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () => _changeMonth(context, activeMonth, 1),
                          borderRadius: BorderRadius.circular(6),
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Icon(
                              Icons.chevron_right_rounded,
                              size: 16,
                              color: PColor.ink(context),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(width: 6),

              // Top-Right: Profile Avatar Button with Level Badge (Opens SettingsSheet)
              BlocBuilder<GamificationBloc, GamificationState>(
                builder: (context, gState) {
                  final user = gState.userProfile;
                  final level = user?.level ?? 1;

                  return Tooltip(
                    message: 'การตั้งค่า & โปรไฟล์',
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => SettingsSheet.show(context),
                        borderRadius: BorderRadius.circular(20),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: PColor.surfaceSubtle(context),
                                border: Border.all(color: borderColor, width: 1.5),
                              ),
                              child: Icon(
                                Icons.person_rounded,
                                size: 18,
                                color: PColor.primary(context),
                              ),
                            ),
                            Positioned(
                              right: -4,
                              bottom: -2,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                decoration: BoxDecoration(
                                  color: PColor.primary(context),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: surfaceColor, width: 1),
                                ),
                                child: Text(
                                  'Lv.$level',
                                  style: const TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

