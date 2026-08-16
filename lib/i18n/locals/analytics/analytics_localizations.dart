import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'analytics_localizations_en.dart';
import 'analytics_localizations_th.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AnalyticsLocalizations
/// returned by `AnalyticsLocalizations.of(context)`.
///
/// Applications need to include `AnalyticsLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'analytics/analytics_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AnalyticsLocalizations.localizationsDelegates,
///   supportedLocales: AnalyticsLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the AnalyticsLocalizations.supportedLocales
/// property.
abstract class AnalyticsLocalizations {
  AnalyticsLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AnalyticsLocalizations? of(BuildContext context) {
    return Localizations.of<AnalyticsLocalizations>(context, AnalyticsLocalizations);
  }

  static const LocalizationsDelegate<AnalyticsLocalizations> delegate = _AnalyticsLocalizationsDelegate();

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

  /// Analytics Page Title
  ///
  /// In en, this message translates to:
  /// **'Spending Analytics'**
  String get analytics_title;

  /// Expense by Category
  ///
  /// In en, this message translates to:
  /// **'Expense by Category'**
  String get expense_by_category;

  /// Income vs Expense
  ///
  /// In en, this message translates to:
  /// **'Income vs Expense'**
  String get income_vs_expense;

  /// Savings Rate
  ///
  /// In en, this message translates to:
  /// **'Net Savings Rate'**
  String get savings_rate;

  /// Financial Health Score
  ///
  /// In en, this message translates to:
  /// **'Financial Health Score'**
  String get financial_health;

  /// Empty analytics data message
  ///
  /// In en, this message translates to:
  /// **'No spending records found for this month'**
  String get no_data_month;

  /// Top spending header
  ///
  /// In en, this message translates to:
  /// **'Top Expense Breakdown'**
  String get top_spending;

  /// Health grade
  ///
  /// In en, this message translates to:
  /// **'Excellent Financial Discipline 🌟'**
  String get health_grade_excellent;

  /// Health grade
  ///
  /// In en, this message translates to:
  /// **'Good Budget Balance 👍'**
  String get health_grade_good;

  /// Health grade
  ///
  /// In en, this message translates to:
  /// **'High Spending Warning ⚠️'**
  String get health_grade_warning;
}

class _AnalyticsLocalizationsDelegate extends LocalizationsDelegate<AnalyticsLocalizations> {
  const _AnalyticsLocalizationsDelegate();

  @override
  Future<AnalyticsLocalizations> load(Locale locale) {
    return SynchronousFuture<AnalyticsLocalizations>(lookupAnalyticsLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'th'].contains(locale.languageCode);

  @override
  bool shouldReload(_AnalyticsLocalizationsDelegate old) => false;
}

AnalyticsLocalizations lookupAnalyticsLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AnalyticsLocalizationsEn();
    case 'th': return AnalyticsLocalizationsTh();
  }

  throw FlutterError(
    'AnalyticsLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
