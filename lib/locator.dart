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
import 'package:mobile_app_standard/feature/dashboard/bloc/dashboard_bloc.dart';
import 'package:mobile_app_standard/feature/gamification/bloc/gamification_bloc.dart';
import 'package:mobile_app_standard/feature/home/bloc/websocket/websocket_bloc.dart';
import 'package:mobile_app_standard/feature/todo/bloc/todo_bloc.dart';
import 'package:mobile_app_standard/feature/transaction/bloc/transaction_bloc.dart';
import 'package:mobile_app_standard/shared/bloc/language/language_bloc.dart';

final locator = GetIt.instance;

Future<void> initLocator() async {
  // Register Core Database
  locator.registerLazySingleton<AppDatabase>(() => AppDatabase());

  // Register Http / API Clients
  locator.registerLazySingleton<ApiClient>(() => ApiClient());
  locator.registerLazySingleton<IpClient>(() => IpClient());
  locator.registerLazySingleton<WebSocketClient>(() => WebSocketClient());

  // Register Repositories
  locator.registerLazySingleton<UserRepositoryInterface>(
      () => UserRepository(locator<ApiClient>()));
  locator.registerLazySingleton<TransactionRepositoryInterface>(
      () => TransactionRepository(locator<ApiClient>()));
  locator.registerLazySingleton<GamificationRepositoryInterface>(
      () => GamificationRepository(locator<ApiClient>()));
  locator.registerLazySingleton<BudgetRepositoryInterface>(
      () => BudgetRepository(locator<ApiClient>()));
  locator.registerLazySingleton<TodoRepositoryInterface>(
      () => TodoRepository(locator<AppDatabase>()));

  // Register Blocs
  locator.registerFactory<DashboardBloc>(() => DashboardBloc(
        userRepository: locator<UserRepositoryInterface>(),
        transactionRepository: locator<TransactionRepositoryInterface>(),
        gamificationRepository: locator<GamificationRepositoryInterface>(),
        budgetRepository: locator<BudgetRepositoryInterface>(),
      ));

  locator.registerFactory<TransactionBloc>(() => TransactionBloc(
        transactionRepository: locator<TransactionRepositoryInterface>(),
        userRepository: locator<UserRepositoryInterface>(),
      ));

  locator.registerFactory<GamificationBloc>(() => GamificationBloc(
        gamificationRepository: locator<GamificationRepositoryInterface>(),
        userRepository: locator<UserRepositoryInterface>(),
      ));

  locator.registerLazySingleton<TodoBloc>(() => TodoBloc());
  locator.registerLazySingleton<WebsocketBloc>(() => WebsocketBloc());
  locator.registerLazySingleton<LanguageBloc>(() => LanguageBloc());
}
