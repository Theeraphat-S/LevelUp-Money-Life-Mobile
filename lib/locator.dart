import 'package:get_it/get_it.dart';
import 'package:levelup_money_life/domain/datasource/app_database.dart';
import 'package:levelup_money_life/domain/datasource/hive_config.dart';
import 'package:levelup_money_life/domain/repositories/budget_repository.dart';
import 'package:levelup_money_life/domain/repositories/gamification_repository.dart';
import 'package:levelup_money_life/domain/repositories/transaction_repository.dart';
import 'package:levelup_money_life/domain/repositories/user_repository.dart';
import 'package:levelup_money_life/domain/services/quick_template_service.dart';
import 'package:levelup_money_life/feature/budget/bloc/budget_bloc.dart';
import 'package:levelup_money_life/feature/dashboard/bloc/dashboard_bloc.dart';
import 'package:levelup_money_life/feature/gamification/bloc/gamification_bloc.dart';
import 'package:levelup_money_life/feature/transaction/bloc/transaction_bloc.dart';
import 'package:levelup_money_life/shared/bloc/app/app_bloc.dart';
import 'package:levelup_money_life/shared/bloc/language/language_bloc.dart';

final locator = GetIt.instance;

Future<void> initLocator() async {
  // 1. Initialize and Register Core Local Database (Drift SQLite) and Hive Storage
  await HiveConfig.init();
  await QuickTemplateService.init();

  final db = AppDatabase();
  await db.initDatabase();
  locator.registerSingleton<AppDatabase>(db);

  // 2. Register Repositories (Backed by Drift SQLite)
  locator.registerLazySingleton<UserRepositoryInterface>(
      () => UserRepository(locator<AppDatabase>()));
  locator.registerLazySingleton<TransactionRepositoryInterface>(
      () => TransactionRepository(locator<AppDatabase>()));
  locator.registerLazySingleton<GamificationRepositoryInterface>(
      () => GamificationRepository(locator<AppDatabase>()));
  locator.registerLazySingleton<BudgetRepositoryInterface>(
      () => BudgetRepository(locator<AppDatabase>()));

  // 3. Register Blocs
  locator.registerFactory<AppGlobalBloc>(
      () => AppGlobalBloc(locator<AppDatabase>()));

  locator.registerFactory<DashboardBloc>(() => DashboardBloc(
        userRepository: locator<UserRepositoryInterface>(),
        transactionRepository: locator<TransactionRepositoryInterface>(),
        gamificationRepository: locator<GamificationRepositoryInterface>(),
        budgetRepository: locator<BudgetRepositoryInterface>(),
      ));

  locator.registerFactory<TransactionBloc>(() => TransactionBloc(
        transactionRepository: locator<TransactionRepositoryInterface>(),
        userRepository: locator<UserRepositoryInterface>(),
        gamificationRepository: locator<GamificationRepositoryInterface>(),
      ));

  locator.registerFactory<BudgetBloc>(() => BudgetBloc(
        budgetRepository: locator<BudgetRepositoryInterface>(),
        transactionRepository: locator<TransactionRepositoryInterface>(),
        gamificationRepository: locator<GamificationRepositoryInterface>(),
      ));

  locator.registerFactory<GamificationBloc>(() => GamificationBloc(
        gamificationRepository: locator<GamificationRepositoryInterface>(),
        userRepository: locator<UserRepositoryInterface>(),
      ));

  locator.registerLazySingleton<LanguageBloc>(
      () => LanguageBloc(locator<AppDatabase>()));
}

