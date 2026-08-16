import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mobile_app_standard/i18n/i18n.dart';
import 'package:mobile_app_standard/router/router.dart';
import 'package:mobile_app_standard/shared/tokens/p_colors.dart';

class BottomBarCustom extends HookWidget {
  final String currentRouteName;

  const BottomBarCustom({super.key, required this.currentRouteName});

  int _getIndexFromRoute(String routeName) {
    if (routeName == DashboardRoute.name) return 0;
    if (routeName == TransactionRoute.name) return 1;
    if (routeName == BudgetRoute.name) return 2;
    if (routeName == AnalyticsRoute.name) return 3;
    if (routeName == QuestRoute.name) return 4;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedIndex = useState(_getIndexFromRoute(currentRouteName));

    useEffect(() {
      selectedIndex.value = _getIndexFromRoute(currentRouteName);
      return null;
    }, [currentRouteName]);

    void onItemTapped(int index) {
      if (index == 0 && currentRouteName != DashboardRoute.name) {
        context.router.push(const DashboardRoute());
      } else if (index == 1 && currentRouteName != TransactionRoute.name) {
        context.router.push(const TransactionRoute());
      } else if (index == 2 && currentRouteName != BudgetRoute.name) {
        context.router.push(const BudgetRoute());
      } else if (index == 3 && currentRouteName != AnalyticsRoute.name) {
        context.router.push(const AnalyticsRoute());
      } else if (index == 4 && currentRouteName != QuestRoute.name) {
        context.router.push(const QuestRoute());
      }
      selectedIndex.value = index;
    }

    final surfaceColor = PColor.surface(context);
    final activeColor = PColor.primary(context);
    final inactiveColor = PColor.inkSoft(context);
    final borderColor = PColor.line(context);

    final i18n = AppLocalizations(context).appbar;

    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        border: Border(
          top: BorderSide(color: borderColor, width: 1.0),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black38 : const Color(0x0A142D2B),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context: context,
                index: 0,
                selectedIndex: selectedIndex.value,
                icon: Icons.dashboard_outlined,
                activeIcon: Icons.dashboard_rounded,
                label: i18n.nav_overview,
                activeColor: activeColor,
                inactiveColor: inactiveColor,
                onTap: () => onItemTapped(0),
              ),
              _buildNavItem(
                context: context,
                index: 1,
                selectedIndex: selectedIndex.value,
                icon: Icons.receipt_long_outlined,
                activeIcon: Icons.receipt_long_rounded,
                label: i18n.nav_transactions,
                activeColor: activeColor,
                inactiveColor: inactiveColor,
                onTap: () => onItemTapped(1),
              ),
              _buildNavItem(
                context: context,
                index: 2,
                selectedIndex: selectedIndex.value,
                icon: Icons.pie_chart_outline_rounded,
                activeIcon: Icons.pie_chart_rounded,
                label: i18n.nav_budget,
                activeColor: activeColor,
                inactiveColor: inactiveColor,
                onTap: () => onItemTapped(2),
              ),
              _buildNavItem(
                context: context,
                index: 3,
                selectedIndex: selectedIndex.value,
                icon: Icons.analytics_outlined,
                activeIcon: Icons.analytics_rounded,
                label: i18n.nav_analytics,
                activeColor: activeColor,
                inactiveColor: inactiveColor,
                onTap: () => onItemTapped(3),
              ),
              _buildNavItem(
                context: context,
                index: 4,
                selectedIndex: selectedIndex.value,
                icon: Icons.military_tech_outlined,
                activeIcon: Icons.military_tech_rounded,
                label: i18n.nav_quests,
                activeColor: activeColor,
                inactiveColor: inactiveColor,
                onTap: () => onItemTapped(4),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required int index,
    required int selectedIndex,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required Color activeColor,
    required Color inactiveColor,
    required VoidCallback onTap,
  }) {
    final isSelected = index == selectedIndex;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isSelected ? activeIcon : icon,
                size: 20,
                color: isSelected ? activeColor : inactiveColor,
              ),
              const SizedBox(height: 3),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? activeColor : inactiveColor,
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
