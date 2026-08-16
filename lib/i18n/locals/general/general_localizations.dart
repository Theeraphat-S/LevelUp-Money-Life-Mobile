import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'general_localizations_en.dart';
import 'general_localizations_th.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of GeneralLocalizations
/// returned by `GeneralLocalizations.of(context)`.
///
/// Applications need to include `GeneralLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'general/general_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: GeneralLocalizations.localizationsDelegates,
///   supportedLocales: GeneralLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the GeneralLocalizations.supportedLocales
/// property.
abstract class GeneralLocalizations {
  GeneralLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static GeneralLocalizations? of(BuildContext context) {
    return Localizations.of<GeneralLocalizations>(context, GeneralLocalizations);
  }

  static const LocalizationsDelegate<GeneralLocalizations> delegate = _GeneralLocalizationsDelegate();

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

  /// Cancel
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// OK
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// Yes
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// Add
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// Close
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Save
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Edit
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// Delete
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Confirm
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// Status
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// Language
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Thai
  ///
  /// In en, this message translates to:
  /// **'Thai'**
  String get thai;

  /// English
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// Light Mode
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get theme_light;

  /// Dark Mode
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get theme_dark;

  /// System Theme
  ///
  /// In en, this message translates to:
  /// **'System Theme'**
  String get theme_system;

  /// Data Manager
  ///
  /// In en, this message translates to:
  /// **'Data Manager'**
  String get data_manager;

  /// Backup Data
  ///
  /// In en, this message translates to:
  /// **'Backup Data (JSON)'**
  String get backup_data;

  /// Restore Data
  ///
  /// In en, this message translates to:
  /// **'Restore Data (JSON)'**
  String get restore_data;

  /// Reset All Data
  ///
  /// In en, this message translates to:
  /// **'Reset All Data'**
  String get reset_data;

  /// Reset confirmation
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to reset all data to default?'**
  String get reset_confirm;

  /// Data restored successfully
  ///
  /// In en, this message translates to:
  /// **'Data restored successfully!'**
  String get data_restored_success;

  /// Failed to restore data
  ///
  /// In en, this message translates to:
  /// **'Failed to restore data. Invalid JSON.'**
  String get data_restore_failed;

  /// Copied to clipboard
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get copied_to_clipboard;
}

class _GeneralLocalizationsDelegate extends LocalizationsDelegate<GeneralLocalizations> {
  const _GeneralLocalizationsDelegate();

  @override
  Future<GeneralLocalizations> load(Locale locale) {
    return SynchronousFuture<GeneralLocalizations>(lookupGeneralLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'th'].contains(locale.languageCode);

  @override
  bool shouldReload(_GeneralLocalizationsDelegate old) => false;
}

GeneralLocalizations lookupGeneralLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return GeneralLocalizationsEn();
    case 'th': return GeneralLocalizationsTh();
  }

  throw FlutterError(
    'GeneralLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
