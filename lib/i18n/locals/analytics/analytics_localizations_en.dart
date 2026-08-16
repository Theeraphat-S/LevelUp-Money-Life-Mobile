// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'analytics_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AnalyticsLocalizationsEn extends AnalyticsLocalizations {
  AnalyticsLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get analytics_title => 'Spending Analytics';

  @override
  String get expense_by_category => 'Expense by Category';

  @override
  String get income_vs_expense => 'Income vs Expense';

  @override
  String get savings_rate => 'Net Savings Rate';

  @override
  String get financial_health => 'Financial Health Score';

  @override
  String get no_data_month => 'No spending records found for this month';

  @override
  String get top_spending => 'Top Expense Breakdown';

  @override
  String get health_grade_excellent => 'Excellent Financial Discipline 🌟';

  @override
  String get health_grade_good => 'Good Budget Balance 👍';

  @override
  String get health_grade_warning => 'High Spending Warning ⚠️';
}
