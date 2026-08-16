// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'transaction_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class TransactionLocalizationsEn extends TransactionLocalizations {
  TransactionLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get transactions_title => 'Transactions';

  @override
  String get total_income => 'Total Income';

  @override
  String get total_expense => 'Total Expense';

  @override
  String get net_flow => 'Net Flow';

  @override
  String get filter_all => 'All';

  @override
  String get filter_income => 'Income';

  @override
  String get filter_expense => 'Expense';

  @override
  String get search_placeholder => 'Search transaction name...';

  @override
  String get no_transactions_found => 'No transactions found';

  @override
  String get quick_add_title => 'Quick Record Transaction';

  @override
  String get edit_transaction_title => 'Edit Transaction';

  @override
  String get transaction_name => 'Item Name';

  @override
  String get transaction_name_hint => 'e.g. Lunch, Coffee, Salary';

  @override
  String get amount_thb => 'Amount (THB)';

  @override
  String get category => 'Category';

  @override
  String get date => 'Date';

  @override
  String get notes => 'Notes (Optional)';

  @override
  String get notes_hint => 'Add extra details...';

  @override
  String get save_transaction => 'Save Transaction (+15 XP)';

  @override
  String get saving => 'Saving...';

  @override
  String get delete_transaction => 'Delete Transaction';

  @override
  String get delete_confirm_title => 'Delete Transaction?';

  @override
  String get delete_confirm_msg => 'Are you sure you want to delete this transaction record?';

  @override
  String get scan_slip_title => 'Scan Transfer Slip';

  @override
  String get scan_slip_subtitle => 'Extract details automatically & earn +25 XP!';

  @override
  String get select_slip_image => 'Select Slip Image';

  @override
  String get use_demo_slip => 'Use Demo Slip';

  @override
  String get slip_analyzed_success => 'Slip scanned successfully!';

  @override
  String get exp_reward_title => 'Mission Complete!';

  @override
  String exp_reward_msg(int xp) {
    return 'You earned +$xp XP!';
  }
}
