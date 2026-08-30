import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:levelup_money_life/router/router.dart';
import 'package:levelup_money_life/shared/components/appbar/bottombar_custom.dart';
import 'package:levelup_money_life/shared/components/header_command_deck.dart';

@RoutePage()
class MainShellPage extends StatelessWidget {
  const MainShellPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
      routes: const [
        DashboardRoute(),
        TransactionRoute(),
        BudgetRoute(),
        AnalyticsRoute(),
        QuestRoute(),
      ],
      appBarBuilder: (context, tabsRouter) => HeaderCommandDeck(
        onOpenQuests: () => tabsRouter.setActiveIndex(4),
      ),
      bottomNavigationBuilder: (context, tabsRouter) => BottomBarCustom(
        activeIndex: tabsRouter.activeIndex,
        onItemTapped: tabsRouter.setActiveIndex,
      ),
    );
  }
}