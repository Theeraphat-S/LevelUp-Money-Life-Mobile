import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mobile_app_standard/i18n/locals/analytics/analytics_localizations.dart';
import 'package:mobile_app_standard/i18n/locals/appbar/appbar_localizations.dart';
import 'package:mobile_app_standard/i18n/locals/budget/budget_localizations.dart';
import 'package:mobile_app_standard/i18n/locals/dashboard/dashboard_localizations.dart';
import 'package:mobile_app_standard/i18n/locals/gamification/gamification_localizations.dart';
import 'package:mobile_app_standard/i18n/locals/general/general_localizations.dart';
import 'package:mobile_app_standard/i18n/locals/home_page/home_page_localizations.dart';
import 'package:mobile_app_standard/i18n/locals/todo_page/todo_page_localizations.dart';
import 'package:mobile_app_standard/i18n/locals/transaction/transaction_localizations.dart';

class I18n {
  static final all = [
    const Locale('en'),
    const Locale('th'),
  ];
}

class AppLocalizations {
  final BuildContext context;

  static List<LocalizationsDelegate<dynamic>> get localizationsDelegates => [
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        AnalyticsLocalizations.delegate,
        AppbarLocalizations.delegate,
        BudgetLocalizations.delegate,
        DashboardLocalizations.delegate,
        GamificationLocalizations.delegate,
        GeneralLocalizations.delegate,
        HomePageLocalizations.delegate,
        TodoPageLocalizations.delegate,
        TransactionLocalizations.delegate,
      ];

  static List<Locale> get supportedLocales => I18n.all;

  AppLocalizations(this.context);

  // Get AnalyticsLocalizations
  AnalyticsLocalizations get analytics => AnalyticsLocalizations.of(context)!;

  // Get AppbarLocalizations
  AppbarLocalizations get appbar => AppbarLocalizations.of(context)!;

  // Get BudgetLocalizations
  BudgetLocalizations get budget => BudgetLocalizations.of(context)!;

  // Get DashboardLocalizations
  DashboardLocalizations get dashboard => DashboardLocalizations.of(context)!;

  // Get GamificationLocalizations
  GamificationLocalizations get gamification => GamificationLocalizations.of(context)!;

  // Get GeneralLocalizations
  GeneralLocalizations get general => GeneralLocalizations.of(context)!;

  // Get HomePageLocalizations
  HomePageLocalizations get homePage => HomePageLocalizations.of(context)!;

  // Get TodoPageLocalizations
  TodoPageLocalizations get todoPage => TodoPageLocalizations.of(context)!;

  // Get TransactionLocalizations
  TransactionLocalizations get transaction => TransactionLocalizations.of(context)!;

}

