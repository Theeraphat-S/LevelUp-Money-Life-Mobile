import 'package:flutter/material.dart';
import 'package:levelup_money_life/i18n/i18n.dart';
import 'package:levelup_money_life/shared/tokens/p_colors.dart';

class BottomBarCustom extends StatelessWidget {
  final int activeIndex;
  final ValueChanged<int> onItemTapped;

  const BottomBarCustom({
    super.key,
    required this.activeIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;


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
                selectedIndex: activeIndex,
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
                selectedIndex: activeIndex,
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
                selectedIndex: activeIndex,
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
                selectedIndex: activeIndex,
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
                selectedIndex: activeIndex,
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
