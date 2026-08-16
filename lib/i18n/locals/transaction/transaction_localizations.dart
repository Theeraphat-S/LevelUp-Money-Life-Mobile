import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'transaction_localizations_en.dart';
import 'transaction_localizations_th.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of TransactionLocalizations
/// returned by `TransactionLocalizations.of(context)`.
///
/// Applications need to include `TransactionLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'transaction/transaction_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: TransactionLocalizations.localizationsDelegates,
///   supportedLocales: TransactionLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the TransactionLocalizations.supportedLocales
/// property.
abstract class TransactionLocalizations {
  TransactionLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static TransactionLocalizations? of(BuildContext context) {
    return Localizations.of<TransactionLocalizations>(context, TransactionLocalizations);
  }

  static const LocalizationsDelegate<TransactionLocalizations> delegate = _TransactionLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('th')
  ];

  /// Transactions Page Title
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get transactions_title;

  /// Total Income
  ///
  /// In en, this message translates to:
  /// **'Total Income'**
  String get total_income;

  /// Total Expense
  ///
  /// In en, this message translates to:
  /// **'Total Expense'**
  String get total_expense;

  /// Net Flow
  ///
  /// In en, this message translates to:
  /// **'Net Flow'**
  String get net_flow;

  /// Filter All
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filter_all;

  /// Filter Income
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get filter_income;

  /// Filter Expense
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get filter_expense;

  /// Search field placeholder
  ///
  /// In en, this message translates to:
  /// **'Search transaction name...'**
  String get search_placeholder;

  /// Empty list search message
  ///
  /// In en, this message translates to:
  /// **'No transactions found'**
  String get no_transactions_found;

  /// Quick add sheet title
  ///
  /// In en, this message translates to:
  /// **'Quick Record Transaction'**
  String get quick_add_title;

  /// Edit transaction sheet title
  ///
  /// In en, this message translates to:
  /// **'Edit Transaction'**
  String get edit_transaction_title;

  /// Transaction item name label
  ///
  /// In en, this message translates to:
  /// **'Item Name'**
  String get transaction_name;

  /// Transaction name placeholder
  ///
  /// In en, this message translates to:
  /// **'e.g. Lunch, Coffee, Salary'**
  String get transaction_name_hint;

  /// Amount label
  ///
  /// In en, this message translates to:
  /// **'Amount (THB)'**
  String get amount_thb;

  /// Category label
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// Date label
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// Notes label
  ///
  /// In en, this message translates to:
  /// **'Notes (Optional)'**
  String get notes;

  /// Notes placeholder
  ///
  /// In en, this message translates to:
  /// **'Add extra details...'**
  String get notes_hint;

  /// Save transaction button
  ///
  /// In en, this message translates to:
  /// **'Save Transaction (+15 XP)'**
  String get save_transaction;

  /// Saving state text
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get saving;

  /// Delete button
  ///
  /// In en, this message translates to:
  /// **'Delete Transaction'**
  String get delete_transaction;

  /// Delete dialog title
  ///
  /// In en, this message translates to:
  /// **'Delete Transaction?'**
  String get delete_confirm_title;

  /// Delete dialog message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this transaction record?'**
  String get delete_confirm_msg;

  /// Scan slip dialog title
  ///
  /// In en, this message translates to:
  /// **'Scan Transfer Slip'**
  String get scan_slip_title;

  /// Scan slip description
  ///
  /// In en, this message translates to:
  /// **'Extract details automatically & earn +25 XP!'**
  String get scan_slip_subtitle;

  /// Select slip button
  ///
  /// In en, this message translates to:
  /// **'Select Slip Image'**
  String get select_slip_image;

  /// Demo slip button
  ///
  /// In en, this message translates to:
  /// **'Use Demo Slip'**
  String get use_demo_slip;

  /// Slip success message
  ///
  /// In en, this message translates to:
  /// **'Slip scanned successfully!'**
  String get slip_analyzed_success;

  /// EXP reward dialog title
  ///
  /// In en, this message translates to:
  /// **'Mission Complete!'**
  String get exp_reward_title;

  /// EXP earned message
  ///
  /// In en, this message translates to:
  /// **'You earned +{xp} XP!'**
  String exp_reward_msg(int xp);
}

class _TransactionLocalizationsDelegate extends LocalizationsDelegate<TransactionLocalizations> {
  const _TransactionLocalizationsDelegate();

  @override
  Future<TransactionLocalizations> load(Locale locale) {
    return SynchronousFuture<TransactionLocalizations>(lookupTransactionLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'th'].contains(locale.languageCode);

  @override
  bool shouldReload(_TransactionLocalizationsDelegate old) => false;
}

TransactionLocalizations lookupTransactionLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return TransactionLocalizationsEn();
    case 'th': return TransactionLocalizationsTh();
  }

  throw FlutterError(
    'TransactionLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
