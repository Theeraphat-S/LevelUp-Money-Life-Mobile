import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'budget_localizations_en.dart';
import 'budget_localizations_th.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of BudgetLocalizations
/// returned by `BudgetLocalizations.of(context)`.
///
/// Applications need to include `BudgetLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'budget/budget_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: BudgetLocalizations.localizationsDelegates,
///   supportedLocales: BudgetLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the BudgetLocalizations.supportedLocales
/// property.
abstract class BudgetLocalizations {
  BudgetLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static BudgetLocalizations? of(BuildContext context) {
    return Localizations.of<BudgetLocalizations>(context, BudgetLocalizations);
  }

  static const LocalizationsDelegate<BudgetLocalizations> delegate = _BudgetLocalizationsDelegate();

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

  /// Budget Plan Title
  ///
  /// In en, this message translates to:
  /// **'Budget 50/30/20 Plan'**
  String get budget_title;

  /// Base Monthly Income Label
  ///
  /// In en, this message translates to:
  /// **'Base Monthly Income'**
  String get monthly_income_base;

  /// Needs bucket
  ///
  /// In en, this message translates to:
  /// **'Needs (50%)'**
  String get needs_bucket;

  /// Needs description
  ///
  /// In en, this message translates to:
  /// **'Rent, food, utilities, health, transport'**
  String get needs_desc;

  /// Wants bucket
  ///
  /// In en, this message translates to:
  /// **'Wants (30%)'**
  String get wants_bucket;

  /// Wants description
  ///
  /// In en, this message translates to:
  /// **'Dining out, entertainment, shopping, leisure'**
  String get wants_desc;

  /// Savings bucket
  ///
  /// In en, this message translates to:
  /// **'Savings & Debt (20%)'**
  String get savings_bucket;

  /// Savings description
  ///
  /// In en, this message translates to:
  /// **'Emergency fund, investments, debt repayment'**
  String get savings_desc;

  /// Allocated
  ///
  /// In en, this message translates to:
  /// **'Allocated'**
  String get allocated;

  /// Remaining
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get remaining;

  /// Spent
  ///
  /// In en, this message translates to:
  /// **'Spent'**
  String get spent;

  /// Over budget alert
  ///
  /// In en, this message translates to:
  /// **'Over Budget!'**
  String get over_budget;

  /// Adjust budget button
  ///
  /// In en, this message translates to:
  /// **'Adjust Budget Allocation'**
  String get adjust_budget;

  /// Save budget button
  ///
  /// In en, this message translates to:
  /// **'Save Budget Plan'**
  String get save_budget_plan;

  /// Validation error message
  ///
  /// In en, this message translates to:
  /// **'Total allocation must equal 100%'**
  String get total_must_be_100;
}

class _BudgetLocalizationsDelegate extends LocalizationsDelegate<BudgetLocalizations> {
  const _BudgetLocalizationsDelegate();

  @override
  Future<BudgetLocalizations> load(Locale locale) {
    return SynchronousFuture<BudgetLocalizations>(lookupBudgetLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'th'].contains(locale.languageCode);

  @override
  bool shouldReload(_BudgetLocalizationsDelegate old) => false;
}

BudgetLocalizations lookupBudgetLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return BudgetLocalizationsEn();
    case 'th': return BudgetLocalizationsTh();
  }

  throw FlutterError(
    'BudgetLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
