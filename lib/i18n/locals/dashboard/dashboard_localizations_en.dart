// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'dashboard_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class DashboardLocalizationsEn extends DashboardLocalizations {
  DashboardLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get monthly_income => 'Monthly Income';

  @override
  String get monthly_expense => 'Monthly Expense';

  @override
  String get net_savings => 'NET SAVINGS';

  @override
  String get status_healthy => 'Healthy';

  @override
  String get status_overspent => 'Overspent';

  @override
  String day_streak(int days) {
    return '$days-Day Streak 🔥';
  }

  @override
  String total_xp_score(int xp) {
    return 'Total Score: $xp XP';
  }

  @override
  String get view_quests_achievements => 'View Quests & Badges →';

  @override
  String get add_expense => 'Add Expense';

  @override
  String get add_income => 'Add Income';

  @override
  String get scan_slip => 'Scan Slip';

  @override
  String get daily_quests => 'Daily Quests';

  @override
  String get view_all => 'View All';

  @override
  String get recent_transactions => 'Recent Transactions';

  @override
  String get no_transactions_month => 'No transactions in this month';

  @override
  String get slip_scan_tooltip => 'Scan Transfer Slip (+25 XP)';

  @override
  String get quick_add_tooltip => 'Quick Add Transaction';

  @override
  String get theme_toggle_tooltip => 'Toggle Light/Dark Theme';

  @override
  String get data_manager_tooltip => 'Data Manager (Backup/Restore)';

  @override
  String get language_toggle_tooltip => 'Change Language';
}
