import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app_standard/domain/datasource/app_datebase.dart';
import 'package:mobile_app_standard/domain/repositories/gamification_repository.dart';
import 'package:mobile_app_standard/domain/repositories/transaction_repository.dart';
import 'package:mobile_app_standard/domain/repositories/user_repository.dart';
import 'package:mobile_app_standard/feature/analytics/pages/analytics_page.dart';
import 'package:mobile_app_standard/feature/gamification/bloc/gamification_bloc.dart';
import 'package:mobile_app_standard/feature/gamification/bloc/gamification_event.dart';
import 'package:mobile_app_standard/feature/transaction/bloc/transaction_bloc.dart';
import 'package:mobile_app_standard/feature/transaction/bloc/transaction_event.dart';
import 'package:mobile_app_standard/shared/bloc/app/app_bloc.dart';

void main() {
  late AppDatabase db;
  late TransactionRepository transactionRepo;
  late GamificationRepository gamificationRepo;
  late UserRepository userRepo;
  late AppGlobalBloc appGlobalBloc;
  late GamificationBloc gamificationBloc;
  late TransactionBloc transactionBloc;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    await db.initDatabase();
    transactionRepo = TransactionRepository(db);
    gamificationRepo = GamificationRepository(db);
    userRepo = UserRepository(db);

    appGlobalBloc = AppGlobalBloc(db);
    gamificationBloc = GamificationBloc(
      gamificationRepository: gamificationRepo,
      userRepository: userRepo,
    );
    gamificationBloc.add(const LoadGamificationDataEvent());

    transactionBloc = TransactionBloc(
      transactionRepository: transactionRepo,
      userRepository: userRepo,
      gamificationRepository: gamificationRepo,
    );
    transactionBloc.add(const LoadTransactionsEvent());
  });

  tearDown(() async {
    await transactionBloc.close();
    await gamificationBloc.close();
    await appGlobalBloc.close();
    await db.close();
  });

  Widget buildTestableAnalyticsPage(
      {required double width, double height = 800}) {
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
          ],
          child: const AnalyticsPage(),
        ),
      ),
    );
  }

  group('AnalyticsPage Layout & Overflow Tests', () {
    testWidgets('Renders without overflow on standard 360dp width screen',
        (tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(buildTestableAnalyticsPage(width: 360));
      await tester.pumpAndSettle();

      expect(find.byType(AnalyticsPage), findsOneWidget);
      expect(find.textContaining('เปรียบเทียบกระแสเงินสด'), findsOneWidget);
      expect(find.textContaining('สัดส่วนการใช้จ่ายตามหมวดหมู่'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Renders without overflow on compact 320dp width screen',
        (tester) async {
      tester.view.physicalSize = const Size(320, 600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(buildTestableAnalyticsPage(width: 320));
      await tester.pumpAndSettle();

      expect(find.byType(AnalyticsPage), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
