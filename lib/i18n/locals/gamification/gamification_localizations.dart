import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'gamification_localizations_en.dart';
import 'gamification_localizations_th.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of GamificationLocalizations
/// returned by `GamificationLocalizations.of(context)`.
///
/// Applications need to include `GamificationLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gamification/gamification_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: GamificationLocalizations.localizationsDelegates,
///   supportedLocales: GamificationLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the GamificationLocalizations.supportedLocales
/// property.
abstract class GamificationLocalizations {
  GamificationLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static GamificationLocalizations? of(BuildContext context) {
    return Localizations.of<GamificationLocalizations>(context, GamificationLocalizations);
  }

  static const LocalizationsDelegate<GamificationLocalizations> delegate = _GamificationLocalizationsDelegate();

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

  /// Quests Page Title
  ///
  /// In en, this message translates to:
  /// **'Quests & Badges'**
  String get quests_title;

  /// Hero profile card title
  ///
  /// In en, this message translates to:
  /// **'Finance Hero Profile'**
  String get hero_profile;

  /// Level and rank title
  ///
  /// In en, this message translates to:
  /// **'Lv.{level} · {rank}'**
  String level_display(int level, String rank);

  /// EXP progress text
  ///
  /// In en, this message translates to:
  /// **'EXP: {current} / {max}'**
  String exp_progress(int current, int max);

  /// Daily quests tab
  ///
  /// In en, this message translates to:
  /// **'Daily Quests'**
  String get tab_daily_quests;

  /// Achievements tab
  ///
  /// In en, this message translates to:
  /// **'Badges & Ranks'**
  String get tab_achievements;

  /// Level up title
  ///
  /// In en, this message translates to:
  /// **'LEVEL UP!'**
  String get level_up_title;

  /// Level up congratulation message
  ///
  /// In en, this message translates to:
  /// **'Congratulations! You reached Level {level}!'**
  String level_up_congrats(int level);

  /// New rank announcement
  ///
  /// In en, this message translates to:
  /// **'New Rank: {rank}'**
  String new_rank_unlocked(String rank);

  /// Awesome button
  ///
  /// In en, this message translates to:
  /// **'Awesome!'**
  String get awesome_btn;

  /// Streak label
  ///
  /// In en, this message translates to:
  /// **'{days}-Day Activity Streak 🔥'**
  String streak_label(int days);

  /// Unlocked status
  ///
  /// In en, this message translates to:
  /// **'Unlocked'**
  String get unlocked_badge;

  /// Locked status
  ///
  /// In en, this message translates to:
  /// **'Locked'**
  String get locked_badge;

  /// Default quest 1
  ///
  /// In en, this message translates to:
  /// **'Record all daily expenses for today'**
  String get quest_q1;

  /// Default quest 2
  ///
  /// In en, this message translates to:
  /// **'Review your 50/30/20 budget allocation'**
  String get quest_q2;

  /// Default quest 3
  ///
  /// In en, this message translates to:
  /// **'Transfer savings to emergency reserve fund'**
  String get quest_q3;
}

class _GamificationLocalizationsDelegate extends LocalizationsDelegate<GamificationLocalizations> {
  const _GamificationLocalizationsDelegate();

  @override
  Future<GamificationLocalizations> load(Locale locale) {
    return SynchronousFuture<GamificationLocalizations>(lookupGamificationLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'th'].contains(locale.languageCode);

  @override
  bool shouldReload(_GamificationLocalizationsDelegate old) => false;
}

GamificationLocalizations lookupGamificationLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return GamificationLocalizationsEn();
    case 'th': return GamificationLocalizationsTh();
  }

  throw FlutterError(
    'GamificationLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
