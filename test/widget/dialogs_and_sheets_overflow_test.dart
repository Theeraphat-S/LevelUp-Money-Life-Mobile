import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app_standard/domain/datasource/app_datebase.dart';
import 'package:mobile_app_standard/domain/repositories/budget_repository.dart';
import 'package:mobile_app_standard/domain/repositories/gamification_repository.dart';
import 'package:mobile_app_standard/domain/repositories/transaction_repository.dart';
import 'package:mobile_app_standard/domain/repositories/user_repository.dart';
import 'package:mobile_app_standard/feature/budget/bloc/budget_bloc.dart';
import 'package:mobile_app_standard/feature/dashboard/bloc/dashboard_bloc.dart';
import 'package:mobile_app_standard/feature/gamification/bloc/gamification_bloc.dart';
import 'package:mobile_app_standard/feature/transaction/bloc/transaction_bloc.dart';
import 'package:mobile_app_standard/feature/transaction/widgets/quick_add_sheet.dart';
import 'package:mobile_app_standard/feature/transaction/widgets/slip_scan_sheet.dart';
import 'package:mobile_app_standard/locator.dart';
import 'package:mobile_app_standard/shared/bloc/app/app_bloc.dart';
import 'package:mobile_app_standard/shared/components/data_manager_dialog.dart';

void main() {
  late AppDatabase db;
  late TransactionRepository transactionRepo;
  late GamificationRepository gamificationRepo;
  late UserRepository userRepo;
  late BudgetRepository budgetRepo;
  late AppGlobalBloc appGlobalBloc;
  late GamificationBloc gamificationBloc;
  late TransactionBloc transactionBloc;
  late DashboardBloc dashboardBloc;
  late BudgetBloc budgetBloc;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    await db.initDatabase();
    if (!locator.isRegistered<AppDatabase>()) {
      locator.registerSingleton<AppDatabase>(db);
    }

    transactionRepo = TransactionRepository(db);
    gamificationRepo = GamificationRepository(db);
    userRepo = UserRepository(db);
    budgetRepo = BudgetRepository(db);

    appGlobalBloc = AppGlobalBloc(db);
    gamificationBloc = GamificationBloc(
      gamificationRepository: gamificationRepo,
      userRepository: userRepo,
    );
    transactionBloc = TransactionBloc(
      transactionRepository: transactionRepo,
      userRepository: userRepo,
      gamificationRepository: gamificationRepo,
    );
    dashboardBloc = DashboardBloc(
      userRepository: userRepo,
      transactionRepository: transactionRepo,
      gamificationRepository: gamificationRepo,
      budgetRepository: budgetRepo,
    );
    budgetBloc = BudgetBloc(
      budgetRepository: budgetRepo,
      transactionRepository: transactionRepo,
      gamificationRepository: gamificationRepo,
    );
  });

  tearDown(() async {
    await budgetBloc.close();
    await dashboardBloc.close();
    await transactionBloc.close();
    await gamificationBloc.close();
    await appGlobalBloc.close();
    await db.close();
    await locator.reset();
  });

  Widget buildTestableWidget({
    required Widget child,
    required double width,
    double height = 800,
  }) {
    return MaterialApp(
      home: MediaQuery(
        data: MediaQueryData(
          size: Size(width, height),
          padding: const EdgeInsets.only(top: 24),
        ),
        child: MultiBlocProvider(
          providers: [
            BlocProvider<AppGlobalBloc>.value(value: appGlobalBloc),
            BlocProvider<GamificationBloc>.value(value: gamificationBloc),
            BlocProvider<TransactionBloc>.value(value: transactionBloc),
            BlocProvider<DashboardBloc>.value(value: dashboardBloc),
            BlocProvider<BudgetBloc>.value(value: budgetBloc),
          ],
          child: Scaffold(
            body: Center(child: child),
          ),
        ),
      ),
    );
  }

  group('Sheets and Dialogs Layout & Overflow Tests', () {
    testWidgets('SlipScanSheet renders without overflow on compact 320dp width',
        (tester) async {
      tester.view.physicalSize = const Size(320, 700);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        buildTestableWidget(
          child: const SlipScanSheet(),
          width: 320,
          height: 700,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(SlipScanSheet), findsOneWidget);
      expect(find.text('สแกนสลิปโอนเงิน (OCR)'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('QuickAddSheet renders without overflow on compact 320dp width',
        (tester) async {
      tester.view.physicalSize = const Size(320, 700);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        buildTestableWidget(
          child: const QuickAddSheet(),
          width: 320,
          height: 700,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(QuickAddSheet), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('DataManagerDialog renders without overflow on compact 320dp width',
        (tester) async {
      tester.view.physicalSize = const Size(320, 700);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        buildTestableWidget(
          child: const DataManagerDialog(),
          width: 320,
          height: 700,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(DataManagerDialog), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
