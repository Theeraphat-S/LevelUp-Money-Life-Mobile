import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app_standard/config/config.dart';
import 'package:mobile_app_standard/feature/budget/bloc/budget_bloc.dart';
import 'package:mobile_app_standard/feature/dashboard/bloc/dashboard_bloc.dart';
import 'package:mobile_app_standard/feature/dashboard/bloc/dashboard_event.dart';
import 'package:mobile_app_standard/feature/gamification/bloc/gamification_bloc.dart';
import 'package:mobile_app_standard/feature/gamification/bloc/gamification_event.dart';
import 'package:mobile_app_standard/feature/home/bloc/websocket/websocket_bloc.dart';
import 'package:mobile_app_standard/feature/todo/bloc/todo_bloc.dart';
import 'package:mobile_app_standard/feature/transaction/bloc/transaction_bloc.dart';
import 'package:mobile_app_standard/feature/transaction/bloc/transaction_event.dart';
import 'package:mobile_app_standard/i18n/i18n.dart';
import 'package:mobile_app_standard/locator.dart';
import 'package:mobile_app_standard/router/router.dart';
import 'package:mobile_app_standard/shared/bloc/app/app_bloc.dart';
import 'package:mobile_app_standard/shared/bloc/language/language_bloc.dart';
import 'package:mobile_app_standard/shared/bloc/language/language_state.dart';
import 'package:mobile_app_standard/shared/tokens/p_colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await loadEnv();
  await initLocator();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AppGlobalBloc>(
          create: (context) =>
              locator<AppGlobalBloc>()..add(const InitializeAppEvent()),
        ),
        BlocProvider<DashboardBloc>(
          create: (context) =>
              locator<DashboardBloc>()..add(const LoadDashboardData()),
        ),
        BlocProvider<TransactionBloc>(
          create: (context) =>
              locator<TransactionBloc>()..add(const LoadTransactionsEvent()),
        ),
        BlocProvider<BudgetBloc>(
          create: (context) =>
              locator<BudgetBloc>()..add(const LoadBudgetDataEvent()),
        ),
        BlocProvider<GamificationBloc>(
          create: (context) =>
              locator<GamificationBloc>()..add(const LoadGamificationDataEvent()),
        ),
        BlocProvider<TodoBloc>(create: (context) => locator<TodoBloc>()),
        BlocProvider<WebsocketBloc>(
          create: (context) => locator<WebsocketBloc>(),
        ),
        BlocProvider<LanguageBloc>(
          create: (context) => locator<LanguageBloc>(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppGlobalBloc, AppGlobalState>(
      builder: (context, appState) {
        return BlocBuilder<LanguageBloc, LanguageState>(
          builder: (context, languageState) {
            final lightTheme = ThemeData(
              useMaterial3: true,
              brightness: Brightness.light,
              scaffoldBackgroundColor: PColor.lightBase,
              primaryColor: PColor.primaryLight,
              colorScheme: const ColorScheme.light(
                primary: PColor.primaryLight,
                secondary: PColor.jadeLight,
                surface: PColor.lightSurface,
                onSurface: PColor.lightInk,
                error: PColor.roseLight,
              ),
              dividerColor: PColor.lightLine,
              cardColor: PColor.lightSurface,
              appBarTheme: const AppBarTheme(
                backgroundColor: PColor.lightSurface,
                foregroundColor: PColor.lightInk,
                elevation: 0,
              ),
            );

            final darkTheme = ThemeData(
              useMaterial3: true,
              brightness: Brightness.dark,
              scaffoldBackgroundColor: PColor.darkBase,
              primaryColor: PColor.primaryDark,
              colorScheme: const ColorScheme.dark(
                primary: PColor.primaryDark,
                secondary: PColor.jadeDark,
                surface: PColor.darkSurface,
                onSurface: PColor.darkInk,
                error: PColor.roseDark,
              ),
              dividerColor: PColor.darkLine,
              cardColor: PColor.darkSurface,
              appBarTheme: const AppBarTheme(
                backgroundColor: PColor.darkSurface,
                foregroundColor: PColor.darkInk,
                elevation: 0,
              ),
            );

            return MaterialApp.router(
              title: 'LevelUp Money Life',
              debugShowCheckedModeBanner: false,
              supportedLocales: I18n.all,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              locale: languageState.locale,
              theme: lightTheme,
              darkTheme: darkTheme,
              themeMode: appState.themeMode,
              routerConfig: _appRouter.config(),
            );
          },
        );
      },
    );
  }
}
