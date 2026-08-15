import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mobile_app_standard/router/router.dart';
import 'package:mobile_app_standard/shared/tokens/p_colors.dart';

class BottomBarCustom extends HookWidget {
  final String currentRouteName;

  const BottomBarCustom({super.key, required this.currentRouteName});

  int _getIndexFromRoute(String routeName) {
    if (routeName == DashboardRoute.name) return 0;
    if (routeName == TransactionRoute.name) return 1;
    if (routeName == QuestRoute.name) return 2;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
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
      } else if (index == 2 && currentRouteName != QuestRoute.name) {
        context.router.push(const QuestRoute());
      }
      selectedIndex.value = index;
    }

    if (Platform.isIOS) {
      return CupertinoTabBar(
        currentIndex: selectedIndex.value,
        onTap: onItemTapped,
        activeColor: PColor.primaryColor,
        inactiveColor: Colors.grey.shade600,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.gamecontroller_fill),
            label: 'หน้าหลัก',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.list_bullet),
            label: 'ธุรกรรม',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.flag_fill),
            label: 'เควส & EXP',
          ),
        ],
      );
    }

    return BottomNavigationBar(
      currentIndex: selectedIndex.value,
      onTap: onItemTapped,
      selectedItemColor: PColor.primaryColor,
      unselectedItemColor: Colors.grey.shade600,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard_rounded),
          label: 'หน้าหลัก',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.receipt_long_rounded),
          label: 'ธุรกรรม',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.military_tech_rounded),
          label: 'เควส & EXP',
        ),
      ],
    );
  }
}
