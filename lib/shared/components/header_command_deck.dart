import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app_standard/feature/dashboard/bloc/dashboard_bloc.dart';
import 'package:mobile_app_standard/feature/dashboard/bloc/dashboard_event.dart';
import 'package:mobile_app_standard/feature/gamification/bloc/gamification_bloc.dart';
import 'package:mobile_app_standard/feature/gamification/bloc/gamification_state.dart';
import 'package:mobile_app_standard/feature/transaction/bloc/transaction_bloc.dart';
import 'package:mobile_app_standard/feature/transaction/bloc/transaction_event.dart';
import 'package:mobile_app_standard/feature/transaction/widgets/quick_add_sheet.dart';
import 'package:mobile_app_standard/feature/transaction/widgets/slip_scan_sheet.dart';
import 'package:mobile_app_standard/shared/bloc/app/app_bloc.dart';
import 'package:mobile_app_standard/shared/components/data_manager_dialog.dart';
import 'package:mobile_app_standard/shared/components/gamification_badges.dart';
import 'package:mobile_app_standard/shared/tokens/p_colors.dart';

class HeaderCommandDeck extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onOpenQuests;

  const HeaderCommandDeck({super.key, this.onOpenQuests});

  @override
  Size get preferredSize => const Size.fromHeight(108.0);

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
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top Row: Logo/Title + Theme, Language & Modals
              Row(
                children: [
                  // App Title with Brand icon
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: PColor.primarySoft(context),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.shield_outlined,
                      color: PColor.primary(context),
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'LevelUp Money Life',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3,
                      color: PColor.ink(context),
                    ),
                  ),
                  const Spacer(),

                  // Quick Action: Scan Slip
                  _buildHeaderIconButton(
                    context: context,
                    icon: Icons.document_scanner_outlined,
                    tooltip: 'สแกนสลิปโอนเงิน (+25 XP)',
                    onTap: () => SlipScanSheet.show(context),
                  ),
                  const SizedBox(width: 4),

                  // Quick Action: Quick Add
                  _buildHeaderIconButton(
                    context: context,
                    icon: Icons.add_circle_outline_rounded,
                    tooltip: 'เพิ่มรายการด่วน',
                    isPrimary: true,
                    onTap: () => QuickAddSheet.show(context),
                  ),
                  const SizedBox(width: 4),

                  // Theme Toggle
                  _buildHeaderIconButton(
                    context: context,
                    icon: isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                    tooltip: 'สลับ Light/Dark Mode',
                    onTap: () {
                      final newMode = isDark ? ThemeMode.light : ThemeMode.dark;
                      context.read<AppGlobalBloc>().add(ChangeThemeModeEvent(newMode));
                    },
                  ),
                  const SizedBox(width: 4),

                  // Data Manager (Backup / Export / Import)
                  _buildHeaderIconButton(
                    context: context,
                    icon: Icons.folder_open_outlined,
                    tooltip: 'สำรอง/กู้คืนข้อมูล (JSON)',
                    onTap: () => DataManagerDialog.show(context),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Bottom Row: Active Month Picker + Badges (Level / Streak)
              BlocBuilder<AppGlobalBloc, AppGlobalState>(
                builder: (context, appState) {
                  final activeMonth = appState.activeMonth;

                  return Row(
                    children: [
                      // Month Selector Pill
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        decoration: BoxDecoration(
                          color: PColor.surfaceSubtle(context),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: borderColor, width: 1),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              onTap: () => _changeMonth(context, activeMonth, -1),
                              borderRadius: BorderRadius.circular(6),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Icon(
                                  Icons.chevron_left_rounded,
                                  size: 18,
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
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: PColor.ink(context),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () => _changeMonth(context, activeMonth, 1),
                              borderRadius: BorderRadius.circular(6),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Icon(
                                  Icons.chevron_right_rounded,
                                  size: 18,
                                  color: PColor.ink(context),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),

                      // Gamification State Badges
                      BlocBuilder<GamificationBloc, GamificationState>(
                        builder: (context, gState) {
                          final user = gState.userProfile;
                          if (user == null) {
                            return const SizedBox.shrink();
                          }

                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              LevelRankBadge(
                                level: user.level,
                                rankTitle: user.rankTitle,
                                onTap: onOpenQuests,
                              ),
                              const SizedBox(width: 6),
                              StreakBadge(
                                streakDays: user.streakDays,
                                onTap: onOpenQuests,
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderIconButton({
    required BuildContext context,
    required IconData icon,
    required String tooltip,
    required VoidCallback onTap,
    bool isPrimary = false,
  }) {
    final primaryColor = PColor.primary(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Tooltip(
      message: tooltip,
      child: Material(
        color: isPrimary
            ? primaryColor
            : PColor.surfaceSubtle(context),
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isPrimary ? primaryColor : PColor.line(context),
                width: 1,
              ),
            ),
            child: Icon(
              icon,
              size: 16,
              color: isPrimary
                  ? (isDark ? PColor.darkBase : Colors.white)
                  : PColor.ink(context),
            ),
          ),
        ),
      ),
    );
  }
}
