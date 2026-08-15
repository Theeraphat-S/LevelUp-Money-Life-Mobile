import 'package:auto_route/auto_route.dart';
import 'package:mobile_app_standard/feature/dashboard/pages/dashboard_page.dart';
import 'package:mobile_app_standard/feature/gamification/pages/quest_page.dart';
import 'package:mobile_app_standard/feature/home/pages/home_page.dart';
import 'package:mobile_app_standard/feature/todo/pages/todo_page.dart';
import 'package:mobile_app_standard/feature/transaction/pages/transaction_page.dart';

part 'router.gr.dart'; // ไฟล์ที่สร้างโดย auto_route_generator

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        CustomRoute(
          page: DashboardRoute.page,
          initial: true,
          transitionsBuilder: TransitionsBuilders.noTransition,
        ),
        CustomRoute(
          page: TransactionRoute.page,
          transitionsBuilder: TransitionsBuilders.slideRightWithFade,
        ),
        CustomRoute(
          page: QuestRoute.page,
          transitionsBuilder: TransitionsBuilders.slideRightWithFade,
        ),
        CustomRoute(
          page: HomeRoute.page,
          transitionsBuilder: TransitionsBuilders.noTransition,
        ),
        CustomRoute(
          page: TodoRoute.page,
          transitionsBuilder: TransitionsBuilders.noTransition,
        ),
      ];
}
