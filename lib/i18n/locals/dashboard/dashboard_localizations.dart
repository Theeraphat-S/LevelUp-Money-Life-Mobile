import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'dashboard_localizations_en.dart';
import 'dashboard_localizations_th.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of DashboardLocalizations
/// returned by `DashboardLocalizations.of(context)`.
///
/// Applications need to include `DashboardLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'dashboard/dashboard_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: DashboardLocalizations.localizationsDelegates,
///   supportedLocales: DashboardLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the DashboardLocalizations.supportedLocales
/// property.
abstract class DashboardLocalizations {
  DashboardLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static DashboardLocalizations? of(BuildContext context) {
    return Localizations.of<DashboardLocalizations>(context, DashboardLocalizations);
  }

  static const LocalizationsDelegate<DashboardLocalizations> delegate = _DashboardLocalizationsDelegate();

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

  /// Monthly Income
  ///
  /// In en, this message translates to:
  /// **'Monthly Income'**
  String get monthly_income;

  /// Monthly Expense
  ///
  /// In en, this message translates to:
  /// **'Monthly Expense'**
  String get monthly_expense;

  /// Net Savings
  ///
  /// In en, this message translates to:
  /// **'NET SAVINGS'**
  String get net_savings;

  /// Healthy Flow Status
  ///
  /// In en, this message translates to:
  /// **'Healthy'**
  String get status_healthy;

  /// Overspent Flow Status
  ///
  /// In en, this message translates to:
  /// **'Overspent'**
  String get status_overspent;

  /// Day streak label
  ///
  /// In en, this message translates to:
  /// **'{days}-Day Streak 🔥'**
  String day_streak(int days);

  /// Total XP Score
  ///
  /// In en, this message translates to:
  /// **'Total Score: {xp} XP'**
  String total_xp_score(int xp);

  /// View quests link
  ///
  /// In en, this message translates to:
  /// **'View Quests & Badges →'**
  String get view_quests_achievements;

  /// Add Expense button
  ///
  /// In en, this message translates to:
  /// **'Add Expense'**
  String get add_expense;

  /// Add Income button
  ///
  /// In en, this message translates to:
  /// **'Add Income'**
  String get add_income;

  /// Scan Slip button
  ///
  /// In en, this message translates to:
  /// **'Scan Slip'**
  String get scan_slip;

  /// Daily Quests Header
  ///
  /// In en, this message translates to:
  /// **'Daily Quests'**
  String get daily_quests;

  /// View All link
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get view_all;

  /// Recent Transactions Header
  ///
  /// In en, this message translates to:
  /// **'Recent Transactions'**
  String get recent_transactions;

  /// Empty transactions message
  ///
  /// In en, this message translates to:
  /// **'No transactions in this month'**
  String get no_transactions_month;

  /// Scan slip tooltip
  ///
  /// In en, this message translates to:
  /// **'Scan Transfer Slip (+25 XP)'**
  String get slip_scan_tooltip;

  /// Quick add tooltip
  ///
  /// In en, this message translates to:
  /// **'Quick Add Transaction'**
  String get quick_add_tooltip;

  /// Theme toggle tooltip
  ///
  /// In en, this message translates to:
  /// **'Toggle Light/Dark Theme'**
  String get theme_toggle_tooltip;

  /// Data manager tooltip
  ///
  /// In en, this message translates to:
  /// **'Data Manager (Backup/Restore)'**
  String get data_manager_tooltip;

  /// Language toggle tooltip
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get language_toggle_tooltip;
}

class _DashboardLocalizationsDelegate extends LocalizationsDelegate<DashboardLocalizations> {
  const _DashboardLocalizationsDelegate();

  @override
  Future<DashboardLocalizations> load(Locale locale) {
    return SynchronousFuture<DashboardLocalizations>(lookupDashboardLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'th'].contains(locale.languageCode);

  @override
  bool shouldReload(_DashboardLocalizationsDelegate old) => false;
}

DashboardLocalizations lookupDashboardLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return DashboardLocalizationsEn();
    case 'th': return DashboardLocalizationsTh();
  }

  throw FlutterError(
    'DashboardLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
