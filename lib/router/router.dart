import 'package:auto_route/auto_route.dart';
import 'package:levelup_money_life/feature/analytics/pages/analytics_page.dart';
import 'package:levelup_money_life/feature/budget/pages/budget_page.dart';
import 'package:levelup_money_life/feature/dashboard/pages/dashboard_page.dart';
import 'package:levelup_money_life/feature/gamification/pages/quest_page.dart';
import 'package:levelup_money_life/feature/main_shell/pages/main_shell_page.dart';
import 'package:levelup_money_life/feature/transaction/pages/transaction_page.dart';

part 'router.gr.dart'; // ไฟล์ที่สร้างโดย auto_route_generator

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: MainShellRoute.page,
          initial: true,
          children: [
            AutoRoute(page: DashboardRoute.page, initial: true),
            AutoRoute(page: TransactionRoute.page),
            AutoRoute(page: BudgetRoute.page),
            AutoRoute(page: AnalyticsRoute.page),
            AutoRoute(page: QuestRoute.page),
          ],
        ),
      ];
}

