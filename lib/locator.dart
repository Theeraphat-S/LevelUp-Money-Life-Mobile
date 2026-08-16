import 'package:get_it/get_it.dart';
import 'package:mobile_app_standard/domain/datasource/app_datebase.dart';
import 'package:mobile_app_standard/domain/http_client/api_client.dart';
import 'package:mobile_app_standard/domain/http_client/ip.dart';
import 'package:mobile_app_standard/domain/http_client/websocket.dart';
import 'package:mobile_app_standard/domain/repositories/budget_repository.dart';
import 'package:mobile_app_standard/domain/repositories/gamification_repository.dart';
import 'package:mobile_app_standard/domain/repositories/todo_repo.dart';
import 'package:mobile_app_standard/domain/repositories/transaction_repository.dart';
import 'package:mobile_app_standard/domain/repositories/user_repository.dart';
import 'package:mobile_app_standard/domain/services/storage_service.dart';
import 'package:mobile_app_standard/feature/budget/bloc/budget_bloc.dart';
import 'package:mobile_app_standard/feature/dashboard/bloc/dashboard_bloc.dart';
import 'package:mobile_app_standard/feature/gamification/bloc/gamification_bloc.dart';
import 'package:mobile_app_standard/feature/home/bloc/websocket/websocket_bloc.dart';
import 'package:mobile_app_standard/feature/todo/bloc/todo_bloc.dart';
import 'package:mobile_app_standard/feature/transaction/bloc/transaction_bloc.dart';
import 'package:mobile_app_standard/shared/bloc/app/app_bloc.dart';
import 'package:mobile_app_standard/shared/bloc/language/language_bloc.dart';

final locator = GetIt.instance;

Future<void> initLocator() async {
  // 1. Register and Initialize Storage Service
  final storageService = StorageService();
  await storageService.init();
  locator.registerSingleton<StorageService>(storageService);

  // 2. Register Core Database
  locator.registerLazySingleton<AppDatabase>(() => AppDatabase());

  // 3. Register Http / API Clients
  locator.registerLazySingleton<ApiClient>(() => ApiClient());
  locator.registerLazySingleton<IpClient>(() => IpClient());
  locator.registerLazySingleton<WebSocketClient>(() => WebSocketClient());

  // 4. Register Repositories (Backed by StorageService)
  locator.registerLazySingleton<UserRepositoryInterface>(
      () => UserRepository(locator<StorageService>()));
  locator.registerLazySingleton<TransactionRepositoryInterface>(
      () => TransactionRepository(locator<StorageService>()));
  locator.registerLazySingleton<GamificationRepositoryInterface>(
      () => GamificationRepository(locator<StorageService>()));
  locator.registerLazySingleton<BudgetRepositoryInterface>(
      () => BudgetRepository(locator<StorageService>()));
  locator.registerLazySingleton<TodoRepositoryInterface>(
      () => TodoRepository(locator<AppDatabase>()));

  // 5. Register Blocs
  locator.registerFactory<AppGlobalBloc>(
      () => AppGlobalBloc(locator<StorageService>()));

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

  locator.registerLazySingleton<TodoBloc>(() => TodoBloc());
  locator.registerLazySingleton<WebsocketBloc>(() => WebsocketBloc());
  locator.registerLazySingleton<LanguageBloc>(() => LanguageBloc());
}
