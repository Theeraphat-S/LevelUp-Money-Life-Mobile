// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'budget_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class BudgetLocalizationsEn extends BudgetLocalizations {
  BudgetLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get budget_title => 'Budget 50/30/20 Plan';

  @override
  String get monthly_income_base => 'Base Monthly Income';

  @override
  String get needs_bucket => 'Needs (50%)';

  @override
  String get needs_desc => 'Rent, food, utilities, health, transport';

  @override
  String get wants_bucket => 'Wants (30%)';

  @override
  String get wants_desc => 'Dining out, entertainment, shopping, leisure';

  @override
  String get savings_bucket => 'Savings & Debt (20%)';

  @override
  String get savings_desc => 'Emergency fund, investments, debt repayment';

  @override
  String get allocated => 'Allocated';

  @override
  String get remaining => 'Remaining';

  @override
  String get spent => 'Spent';

  @override
  String get over_budget => 'Over Budget!';

  @override
  String get adjust_budget => 'Adjust Budget Allocation';

  @override
  String get save_budget_plan => 'Save Budget Plan';

  @override
  String get total_must_be_100 => 'Total allocation must equal 100%';
}
