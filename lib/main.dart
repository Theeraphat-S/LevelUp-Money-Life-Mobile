import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app_standard/config/config.dart';
import 'package:mobile_app_standard/feature/dashboard/bloc/dashboard_bloc.dart';
import 'package:mobile_app_standard/feature/dashboard/bloc/dashboard_event.dart';
import 'package:mobile_app_standard/feature/gamification/bloc/gamification_bloc.dart';
import 'package:mobile_app_standard/feature/home/bloc/websocket/websocket_bloc.dart';
import 'package:mobile_app_standard/feature/todo/bloc/todo_bloc.dart';
import 'package:mobile_app_standard/feature/transaction/bloc/transaction_bloc.dart';
import 'package:mobile_app_standard/feature/transaction/bloc/transaction_event.dart';
import 'package:mobile_app_standard/i18n/i18n.dart';
import 'package:mobile_app_standard/locator.dart';
import 'package:mobile_app_standard/router/router.dart';
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
        BlocProvider<DashboardBloc>(
          create: (context) =>
              locator<DashboardBloc>()..add(const LoadDashboardData()),
        ),
        BlocProvider<TransactionBloc>(
          create: (context) =>
              locator<TransactionBloc>()..add(const LoadTransactionsEvent()),
        ),
        BlocProvider<GamificationBloc>(
          create: (context) => locator<GamificationBloc>(),
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
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, languageState) {
        if (Platform.isIOS) {
          return CupertinoApp.router(
            title: 'LevelUp Money Life',
            supportedLocales: I18n.all,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            locale: languageState.locale,
            theme: CupertinoThemeData(primaryColor: PColor.primaryColor),
            routerConfig: _appRouter.config(),
          );
        }
        return MaterialApp.router(
          title: 'LevelUp Money Life',
          supportedLocales: I18n.all,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          locale: languageState.locale,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF3B82F6),
              primary: const Color(0xFF3B82F6),
            ),
            scaffoldBackgroundColor: const Color(0xFFF8FAFC),
            useMaterial3: true,
          ),
          routerConfig: _appRouter.config(),
        );
      },
    );
  }
}
